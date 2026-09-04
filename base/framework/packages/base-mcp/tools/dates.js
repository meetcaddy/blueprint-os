/**
 * BASE Dates — LOCAL calendar-date helpers.
 *
 * WHY THIS MODULE EXISTS:
 *
 * `base_record_groom` stamped `groom.last_groom` with
 * `new Date().toISOString().split('T')[0]` — and `toISOString()` is UTC BY
 * DEFINITION. Every other groom surface works in LOCAL dates, so a groom
 * recorded in the evening (any timezone west of UTC) stamped TOMORROW:
 * `last_groom` disagreed with the per-area stamps written in the same
 * session, and `next_groom_due` landed a day late. state.json disagreed
 * with itself. That is what this module fixes.
 *
 * A workspace's "today" is the operator's today. These helpers never touch UTC.
 *
 * ⚠️ Do NOT "simplify" these back to toISOString(). That is the bug.
 * ⚠️ Do NOT use `new Date("YYYY-MM-DD")` to parse a calendar date either — the
 *    ES spec parses a date-only string as UTC midnight, which reintroduces the
 *    same offset error through a different door.
 */

/** Format a Date as a LOCAL YYYY-MM-DD calendar date. */
export function fmtLocal(d) {
    const y = d.getFullYear();
    const m = String(d.getMonth() + 1).padStart(2, '0');
    const day = String(d.getDate()).padStart(2, '0');
    return `${y}-${m}-${day}`;
}

/** Today's LOCAL calendar date as YYYY-MM-DD. */
export function todayStr() {
    return fmtLocal(new Date());
}

/**
 * Add `days` to a YYYY-MM-DD calendar date, staying in LOCAL time throughout.
 *
 * Parsed field-by-field into a local-midnight Date rather than via
 * `new Date(dateStr)` (UTC midnight per spec). Local midnight also makes this
 * DST-safe: adding 7 days across a transition keeps the calendar date correct,
 * because Date's local setters normalise the wall clock for us. Starting from
 * an hour offset — as the old UTC round-trip did — is what puts a date within
 * one offset-shift of flipping.
 */
export function addDays(dateStr, days) {
    const [y, m, d] = String(dateStr).split('-').map(Number);
    const dt = new Date(y, m - 1, d); // local midnight
    dt.setDate(dt.getDate() + days);
    return fmtLocal(dt);
}
