<purpose>
Graduate a completed ideation from projects/{name}/ into a type-appropriate destination directory ({type→folder} routing) with its own git repo, type-aware README, and workspace tracking updates.
</purpose>

<user-story>
As a builder with a completed PLANNING.md, I want to graduate my project into the correct workspace folder for its type (apps/ for applications, workflows/ for workflows, etc.) with git and a synthesized README, so that I can start building or operating it without manual setup or wrong-folder cleanup.
</user-story>

<when-to-use>
- Ideation is complete and PLANNING.md exists in projects/{name}/
- Ready to move from planning to building (or operating, for non-app types)
- Want a clean project directory at the right workspace location with a synthesized brief
</when-to-use>

<context>
@seed.md
@checklists/planning-quality.md (quality gate — loaded before graduation)
</context>

<steps>

<step name="validate_input" priority="first">
## Validate Project

Check `$ARGUMENTS` for a project name.

**If no argument provided:**
Scan `projects/` for directories containing PLANNING.md. List them:

> "Available projects ready for graduation:"
> - {name} ({type from PLANNING.md})
> - {name} ({type})
>
> "Which one? Or provide a name."

Wait for response.

**If argument provided:**
1. Confirm `projects/{name}/PLANNING.md` exists — if not: "No PLANNING.md found at `projects/{name}/`. Run `/seed` to create one first."
2. The destination check happens AFTER type determination (see step `determine_destination`). If the resolved destination already exists, that step will report "already graduated."
</step>

<step name="quality_check">
## Quality Gate

Read `projects/{name}/PLANNING.md` and extract:
- **Type** metadata field (application, workflow, client, utility, campaign)
- Overall content depth

Reference `checklists/planning-quality.md` to assess whether the PLANNING.md is rich enough for a clean graduation and potential headless PAUL init.

<if condition="Type metadata is missing">
Infer type from content, or ask: "I can't find a Type field in this PLANNING.md. What type of project is this? (application, workflow, client, utility, campaign)"

Wait for response.
</if>

<if condition="PLANNING.md appears too thin">
Warn the user:

> "This PLANNING.md looks light — it may not have enough detail for a strong README or future PAUL init. Want to go back to `/seed` to flesh it out, or graduate as-is?"

Wait for response. If user wants to proceed, continue. If not, exit with suggestion to run `/seed`.
</if>
</step>

<step name="determine_destination">
## Determine Destination Folder

Normalize the extracted Type field:
1. Strip common prefixes ("Claude Code ", "Project: ", etc.)
2. Lowercase
3. Match against canonical types: application, workflow, client, utility, campaign

Map normalized type to destination root:

| Normalized Type | Destination Root |
|-----------------|------------------|
| application, app | `apps/` |
| workflow | `workflows/` |
| client | `websites/` |
| utility, tool | `apps/` (small utilities still live in apps/ unless user overrides) |
| campaign, content | `campaigns/` at the workspace root (create it if missing) |
| anything else | `apps/` (fallback default) |

Set `$DESTINATION_ROOT` to the mapped folder.

**Confirm with user before proceeding:**

> "Type: **{normalized type}** → graduating to `{destination_root}{name}/`. Proceed?"

Wait for confirmation. If user wants a different destination, accept their override (any path under the workspace root is valid).

**Now check if destination already exists:**
- If `{destination_root}{name}/` exists: stop with "`{destination_root}{name}/` already exists. This project may have been graduated previously."

If destination root folder doesn't exist (e.g., `campaigns/` not yet created), create it on the fly.
</step>

<step name="create_project_directory">
## Create Project Directory

1. Create the destination directory:
   ```bash
   mkdir -p {destination_root}{name}
   ```

2. Initialize git repo:
   ```bash
   cd {destination_root}{name}
   git init -b main
   ```

   Note: for projects under a parent that's already a git repo (e.g., a project folder inside a workspace repo that is already git-tracked), do NOT initialize a nested git repo. Detect this by checking if any parent directory has a `.git/` folder. If yes, skip `git init` — the project will be tracked by the parent repo.
</step>

<step name="synthesize_readme">
## Synthesize README

Read `projects/{name}/PLANNING.md` fully. Generate `{destination_root}{name}/README.md` by **synthesizing** (not copying) a clean project brief.

**Common sections (all types):**
- Title and one-line description
- Type, Skill Loadout, Quality Gates metadata
- Overview — concise summary of what and why
- Design Decisions — resolved decisions (numbered)
- Implementation Phases — phase breakdown (or "N/A" for small projects)
- Open Questions — unresolved items
- References

**Type-specific sections to add:**

| Type | Additional Sections |
|------|-------------------|
| Application | Stack, Deploy, Data Model, API Surface, Architecture, UI/UX |
| Workflow | Scope Definition, Integration Map, Interaction Design, Output Artifacts |
| Client | Client name, Business Context, Conversion Strategy, Timeline, Tech Approach |
| Utility | Location, Interface (invocation/input/output), Done Criteria |
| Campaign | Goal, Deliverables List, Timeline, Success Metrics |

**Synthesis guidelines:**
- Remove brainstorming artifacts, iteration history, abandoned ideas
- Keep all resolved design decisions
- Keep technical architecture details
- Keep implementation phases
- Preserve tables and structured data (information-dense)
- Preserve Type and Skill Loadout metadata — PAUL uses this for configuration
- The README should be comprehensive enough to run `/paul:init` against (for app/workflow/utility types)

Present the generated README to the user:

> "Here's the README I synthesized from your PLANNING.md. Take a look — anything to adjust?"

Wait for response.

<if condition="user requests changes">
Apply edits and re-present until approved.
</if>
</step>

<step name="finalize">
## Finalize Graduation

1. **Write README.md** to `{destination_root}{name}/README.md`

2. **Initial commit (only if a fresh git repo was initialized in step `create_project_directory`):**
   ```bash
   cd {destination_root}{name}
   git add README.md
   git commit -m "Initial commit: project brief from graduation"
   ```

   If the project lives inside a parent repo (no fresh git init was done), skip the commit — the parent repo will pick up the new files on its next commit cycle.

3. **Update ACTIVE.md (graceful skip if missing)** — find the project entry and update:
   - Location: `{destination_root}{name}/`
   - Status: `Graduated — ready for /paul:init`
   - If no entry exists, ask user which section to add it under
   - **If `ACTIVE.md` does not exist at workspace root, skip this step silently** — not all workspaces use ACTIVE.md as their tracking surface (BASE state may be used instead).

4. **Note graduation in PLANNING.md** — append to `projects/{name}/PLANNING.md`:
   ```
   ---
   **Graduated:** {today's date}
   **Location:** `{destination_root}{name}/`
   **README:** `{destination_root}{name}/README.md`
   ```

5. **Report:**
   ```
   Graduated: projects/{name}/ → {destination_root}{name}/
   README: {destination_root}{name}/README.md
   Git: {Initialized with initial commit | Tracked by parent repo}

   Next steps:
   - `/paul:init` in {destination_root}{name}/ to start a managed build (app/workflow/utility types)
   - `/seed launch {name}` does graduate + PAUL init in one step
   - For non-buildable workflows (folder-based capture systems, runbooks, etc.), the README is the deliverable — no PAUL init needed
   ```
</step>

</steps>

<output>
- `{destination_root}{name}/` — new project directory at the type-appropriate workspace location with git repo (or tracked by parent repo)
- `{destination_root}{name}/README.md` — type-aware synthesized project brief
- Updated `ACTIVE.md` entry (if ACTIVE.md exists; skipped silently otherwise)
- Graduation note appended to `projects/{name}/PLANNING.md`
</output>

<acceptance-criteria>
- [ ] Input validated: PLANNING.md exists in projects/{name}/
- [ ] Quality gate checked before graduation
- [ ] Type extracted and normalized from PLANNING.md metadata
- [ ] Destination folder mapped from type and confirmed with user
- [ ] Destination existence checked AFTER type determination (not blindly against apps/)
- [ ] README synthesized with type-specific sections (not copied verbatim)
- [ ] Git repo initialized only if not inside a parent repo (no nested .git/)
- [ ] ACTIVE.md update step skips silently if ACTIVE.md is missing
- [ ] Graduation date noted in original PLANNING.md
- [ ] Wait points present at key decisions (quality warning, destination confirmation, README review)
</acceptance-criteria>
