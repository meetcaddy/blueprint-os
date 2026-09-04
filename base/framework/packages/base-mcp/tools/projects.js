/**
 * BASE Projects — Hierarchy-aware CRUD for projects.json
 * Supports Initiative > Project > Task with auto-ID by type
 */

import { readFileSync, writeFileSync, existsSync } from 'fs';
import { join } from 'path';
import { validateSurface } from './validate.js';
import { todayStr } from './dates.js'; // LOCAL calendar day, never UTC (see dates.js)

function debugLog(...args) {
    console.error('[BASE:projects]', new Date().toISOString(), ...args);
}

// ============================================================
// HELPERS
// ============================================================

const TYPE_PREFIX = { initiative: 'INI', project: 'PRJ', task: 'TSK' };

function getProjectsPath(workspacePath) {
    return join(workspacePath, '.base', 'data', 'projects.json');
}

function readProjects(workspacePath) {
    const filepath = getProjectsPath(workspacePath);
    if (!existsSync(filepath)) {
        return { version: 1, workspace: '', last_modified: null, categories: [], items: [], archived: [] };
    }
    try {
        return JSON.parse(readFileSync(filepath, 'utf-8'));
    } catch (error) {
        debugLog('Error reading projects.json:', error.message);
        return { version: 1, workspace: '', last_modified: null, categories: [], items: [], archived: [] };
    }
}

function writeProjects(workspacePath, data) {
    const filepath = getProjectsPath(workspacePath);
    data.last_modified = new Date().toISOString();
    validateSurface('projects', data);
    writeFileSync(filepath, JSON.stringify(data, null, 2), 'utf-8');
}

// ---- per-machine id band (cross-machine collision guard) --------------------------
// Every allocator here computed max(id)+1 from THIS machine's store, so two records
// created the same day on two machines got the SAME id by construction — one id came
// to name two different projects. Fix: each machine allocates only inside
// its own reserved band. Config resolution, in order:
//     ~/.machine-bands.json     (SHARED — same file CARL's allocator reads, so the two
//                                systems cannot drift into different bands)
//     ~/.base-gbl/machine.json  (BASE-local legacy fallback)
// Shape: { "id_range_start": 0, "id_range_size": 500 }  (desktop 000-499, laptop 500-999)
// Absent or invalid => legacy max(id)+1, byte-identical to before.
function baseIdRange() {
    const home = process.env.HOME;
    if (!home) return null;
    for (const rel of ['.machine-bands.json', '.base-gbl/machine.json']) {
        try {
            const p = join(home, rel);
            if (!existsSync(p)) continue;
            const c = JSON.parse(readFileSync(p, 'utf-8'));
            const start = Number(c.id_range_start);
            const size = Number(c.id_range_size);
            if (!Number.isInteger(start) || !Number.isInteger(size) || size <= 0 || start < 0) continue;
            return { start, size };
        } catch (e) { /* fall through to the next candidate, then to legacy */ }
    }
    return null;
}

function generateProjectId(type, items, archived) {
    // Scan ARCHIVED records too. archiveProject() moves an item from `items` into `archived`
    // (see the push at the archive tool), so scanning `items` alone hands the freed number to
    // the NEXT project — colliding with a record that still exists in the archive.
    // Observed for real: a live project id that also appeared under archived.
    const prefix = TYPE_PREFIX[type];
    if (!prefix) throw new Error(`Invalid type: ${type}. Valid: initiative, project, task`);

    const range = baseIdRange();
    let max = range ? range.start - 1 : 0;
    for (const item of [...(items || []), ...(archived || [])]) {
        const match = (item.id || '').match(new RegExp(`^${prefix}-(\\d+)$`));
        if (match) {
            const num = parseInt(match[1], 10);
            if (range && (num < range.start || num >= range.start + range.size)) continue; // other machine's band
            if (num > max) max = num;
        }
    }
    const next = max + 1;
    if (range && next >= range.start + range.size) {
        throw new Error(`BASE id range exhausted for ${prefix} (band ${range.start}-${range.start + range.size - 1}). Widen id_range_size in ~/.machine-bands.json.`);
    }
    return `${prefix}-${String(next).padStart(3, '0')}`;
}

function formatTimestamp() {
    return new Date().toISOString();
}

// ============================================================
// TOOL DEFINITIONS
// ============================================================

export const TOOLS = [
    {
        name: "base_list_projects",
        description: "List/filter project items. Supports filtering by type (initiative/project/task), status, priority, parent_id, and category.",
        inputSchema: {
            type: "object",
            properties: {
                type: { type: "string", enum: ["initiative", "project", "task"], description: "Filter by hierarchy level" },
                status: { type: "string", description: "Filter by status (backlog, todo, in_progress, blocked, in_review, completed, deferred, archived)" },
                priority: { type: "string", description: "Filter by priority (urgent, high, medium, low, ongoing)" },
                parent_id: { type: "string", description: "Filter by parent item ID" },
                category: { type: "string", description: "Filter by category" }
            },
            required: []
        }
    },
    {
        name: "base_get_project",
        description: "Get a single project item by ID. Returns the full item object.",
        inputSchema: {
            type: "object",
            properties: {
                id: { type: "string", description: "Item ID (e.g., 'PRJ-001', 'INI-002', 'TSK-005')" }
            },
            required: ["id"]
        }
    },
    {
        name: "base_add_project",
        description: "Add a new initiative, project, or task. Auto-generates ID by type (INI-NNN, PRJ-NNN, TSK-NNN). Sets created_at and updated_at.",
        inputSchema: {
            type: "object",
            properties: {
                type: { type: "string", enum: ["initiative", "project", "task"], description: "Hierarchy level" },
                title: { type: "string", description: "Item title" },
                parent_id: { type: "string", description: "Parent item ID (null for top-level initiatives)" },
                status: { type: "string", enum: ["backlog", "todo", "in_progress", "blocked", "in_review", "completed", "deferred"], description: "Initial status (default: todo)" },
                priority: { type: "string", enum: ["urgent", "high", "medium", "low", "ongoing"], description: "Priority level (default: medium)" },
                category: { type: "string", description: "Category from workspace categories list" },
                assignees: { type: "array", items: { type: "string" }, description: "Entity IDs to assign" },
                description: { type: "string", description: "Extended description" },
                location: { type: "string", description: "Workspace-relative path" },
                due_date: { type: "string", description: "ISO date deadline" },
                tags: { type: "array", items: { type: "string" }, description: "Free-form tags" }
            },
            required: ["type", "title"]
        }
    },
    {
        name: "base_update_project",
        description: "Update an existing item's fields by ID. Shallow merge — only specified fields updated, others preserved.",
        inputSchema: {
            type: "object",
            properties: {
                id: { type: "string", description: "Item ID to update" },
                data: { type: "object", description: "Fields to update (shallow merge)" }
            },
            required: ["id", "data"]
        }
    },
    {
        name: "base_archive_project",
        description: "Archive an item by ID — moves from items[] to archived[] with outcome and timestamp.",
        inputSchema: {
            type: "object",
            properties: {
                id: { type: "string", description: "Item ID to archive" },
                outcome: { type: "string", description: "What happened (shipped, killed, absorbed, etc.)" }
            },
            required: ["id", "outcome"]
        }
    },
    {
        name: "base_search_projects",
        description: "Search project items by keyword. Case-insensitive substring match across title, description, notes, and tags.",
        inputSchema: {
            type: "object",
            properties: {
                query: { type: "string", description: "Search query (case-insensitive)" }
            },
            required: ["query"]
        }
    }
];

// ============================================================
// TOOL HANDLERS
// ============================================================

function handleListProjects(args, workspacePath) {
    const data = readProjects(workspacePath);
    let items = data.items;

    if (args.type) items = items.filter(i => i.type === args.type);
    if (args.status) items = items.filter(i => i.status === args.status);
    if (args.priority) items = items.filter(i => i.priority === args.priority);
    if (args.parent_id) items = items.filter(i => i.parent_id === args.parent_id);
    if (args.category) items = items.filter(i => i.category === args.category);

    return { items, count: items.length, total: data.items.length };
}

function handleGetProject(args, workspacePath) {
    const { id } = args;
    if (!id) throw new Error('Missing required parameter: id');

    const data = readProjects(workspacePath);
    const item = data.items.find(i => i.id === id);
    if (!item) {
        throw new Error(`Item "${id}" not found. Available IDs: ${data.items.map(i => i.id).slice(0, 20).join(', ')}${data.items.length > 20 ? '...' : ''}`);
    }
    return item;
}

function handleAddProject(args, workspacePath) {
    const { type, title } = args;
    if (!type) throw new Error('Missing required parameter: type');
    if (!title) throw new Error('Missing required parameter: title');

    const data = readProjects(workspacePath);
    const now = formatTimestamp();
    const id = generateProjectId(type, data.items, data.archived);

    const newItem = {
        id,
        title,
        type,
        parent_id: args.parent_id || null,
        status: args.status || 'todo',
        priority: args.priority || 'medium',
        category: args.category || null,
        assignees: args.assignees || [],
        start_date: null,
        due_date: args.due_date || null,
        created_at: now,
        updated_at: now,
        location: args.location || null,
        blocked_by: null,
        next: null,
        notes: [],
        tags: args.tags || [],
        paul: null,
        relations: [],
        description: args.description || null
    };

    data.items.push(newItem);
    writeProjects(workspacePath, data);

    debugLog(`Added ${type} ${id}: ${title}`);
    return newItem;
}

function handleUpdateProject(args, workspacePath) {
    const { id, data: updateData } = args;
    if (!id) throw new Error('Missing required parameter: id');
    if (!updateData) throw new Error('Missing required parameter: data');

    const data = readProjects(workspacePath);
    const index = data.items.findIndex(i => i.id === id);
    if (index === -1) {
        throw new Error(`Item "${id}" not found`);
    }

    data.items[index] = {
        ...data.items[index],
        ...updateData,
        id, // Prevent ID overwrite
        updated_at: formatTimestamp()
    };

    writeProjects(workspacePath, data);

    debugLog(`Updated ${id}`);
    return data.items[index];
}

function handleArchiveProject(args, workspacePath) {
    const { id, outcome } = args;
    if (!id) throw new Error('Missing required parameter: id');
    if (!outcome) throw new Error('Missing required parameter: outcome');

    const data = readProjects(workspacePath);
    const index = data.items.findIndex(i => i.id === id);
    if (index === -1) {
        throw new Error(`Item "${id}" not found`);
    }

    const [item] = data.items.splice(index, 1);
    const now = formatTimestamp();

    if (!data.archived) data.archived = [];
    data.archived.push({
        id: item.id,
        title: item.title,
        outcome,
        // LOCAL calendar day. Was now.split('T')[0] — the UTC day sliced out of a
        // UTC instant, the same UTC-day bug spelled in two steps (and why a grep for
        // the literal toISOString().split() expression missed this site). It had
        // already written wrong days into archived[] before the fix.
        date: todayStr(),
        // archived_at stays the full UTC INSTANT — correct, timezone-agnostic, not a
        // calendar day. Do not "fix" this one.
        archived_at: now
    });

    writeProjects(workspacePath, data);

    debugLog(`Archived ${id}: ${outcome}`);
    return { id, title: item.title, outcome, archived_at: now };
}

function handleSearchProjects(args, workspacePath) {
    const { query } = args;
    if (!query) throw new Error('Missing required parameter: query');

    const data = readProjects(workspacePath);
    const queryLower = query.toLowerCase();
    const results = [];

    for (const item of data.items) {
        const searchFields = [
            item.title,
            item.description,
            ...(item.tags || []),
            ...(item.notes || []).map(n => n.text)
        ].filter(Boolean).join(' ').toLowerCase();

        if (searchFields.includes(queryLower)) {
            results.push({
                id: item.id,
                title: item.title,
                type: item.type,
                status: item.status,
                priority: item.priority
            });
        }
    }

    return { results, count: results.length, query };
}

// ============================================================
// HANDLER DISPATCH
// ============================================================

export function handleTool(name, args, workspacePath) {
    switch (name) {
        case 'base_list_projects':
            return handleListProjects(args, workspacePath);
        case 'base_get_project':
            return handleGetProject(args, workspacePath);
        case 'base_add_project':
            return handleAddProject(args, workspacePath);
        case 'base_update_project':
            return handleUpdateProject(args, workspacePath);
        case 'base_archive_project':
            return handleArchiveProject(args, workspacePath);
        case 'base_search_projects':
            return handleSearchProjects(args, workspacePath);
        default:
            return null;
    }
}
