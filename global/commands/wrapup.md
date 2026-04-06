# /wrapup — Session Closure

Package session work into a structured proposal: facts about what changed, proposed project-file updates, and explicit learnings. All writes require approval.

## Instructions

### Step 1: Gather Facts

1. Run these git commands in parallel:
   - `git diff --stat` (uncommitted changes)
   - `git log --oneline -10` (recent commits)
   - `git status --short`
   - `git branch --show-current`
2. From the conversation context, identify:
   - What was worked on (topic, goal)
   - Key decisions made
   - Problems encountered and resolved

### Step 2: Find Active Project File

1. Scan `~/dev/claude-memory/projects/` for the active project matching current work.
2. If found, read current Log and Next sections.
3. If not found, note this — project updates will be skipped.

### Step 3: Build Proposals

**Project Log entry:**
- Format: `- [YYYY-MM-DD] <one-liner summarizing what was accomplished>`
- Only factual — what was done, not what might be done.
- Maximum 2 log entries per wrapup.

**Project Next updates:**
- Mark completed items: `- [ ]` → `- [x]`
- Add newly discovered items as `- [ ]`
- Maximum 5 next-item changes per wrapup.

### Step 4: Identify Learnings

**Two categories — keep them distinct:**

1. **Explicit learnings** — things Kelly directly stated as corrections or preferences during this session. These are eligible for write proposals.
   - Must be a direct quote or clear paraphrase of something Kelly said.
   - Format: `[correction]` or `[preference]` tag + the learning.

2. **Possible inferred learnings** — patterns you noticed but Kelly didn't explicitly state. These are shown for awareness only, NOT eligible for write proposals in V1.
   - Format: `[observed, not confirmed]` tag + what you noticed.

Before proposing any learning for write, check `~/dev/claude-memory/MEMORIES.md` for duplicates. Skip if already captured.

### Step 5: Check for Unresolved Items

Note any:
- Open questions that weren't answered
- Decisions that were deferred
- Work started but not completed

### Step 6: Produce Output

```
## Wrapup

### Facts
- <what was done — files, commits, branch, objective summary>
- <key decisions or outcomes>

### Proposals

**Project Log** (<project-name>):
- [YYYY-MM-DD] <one-liner>

**Next Updates:**
- [x] <completed item>
- [ ] <new discovered item>

### Explicit Learnings
- [correction] "<what Kelly said>"
- [preference] "<what Kelly said>"

### Observed (not confirmed)
- [observed] <pattern noticed — for awareness, no write proposed>

### Unresolved
- <open question or deferred decision>

Approve? You can say: approve all, approve specific items by name/number, skip a section, or skip entirely.
```

**Output constraints:**
- Facts: max 5 lines.
- Proposals: max 10 lines.
- Learnings: max 3 explicit + 3 observed.
- Unresolved: max 3 items.
- If a section is empty, omit it.
- Total output must fit one screen (~35 lines).

### Step 7: Execute Approved Writes

On approval, write ONLY what was approved:

1. **Project file updates:** Edit the Log section (append entry) and Next section (check off / add items) of the active project file.
2. **MEMORIES.md updates:** Only for approved explicit learnings. Append to the appropriate section (Behavioral Corrections or Stated Preferences). Never edit existing entries.
3. **Project notes file:** If the session involved substantive technical reasoning, findings, or design decisions worth preserving, append a dated entry to the project's `-notes.md` file. Only if the content would be useful for future sessions — skip for routine work.

After writing, show a brief confirmation of what was written and where.

## Constraints

- Never write anything without explicit approval.
- Natural-language approval: "approve all", "approve 1 and 3", "skip memory updates", "just the log entry", etc.
- Never write to: `~/.claude/CLAUDE.md`, `~/dev/CLAUDE.md`, `settings.json`, hook scripts, rules files, known-issues files.
- If no meaningful work happened (no commits, no file edits, no significant discussion), say "Nothing significant to wrap up" and stop.
- Distinguish facts (objective, verifiable) from proposals (suggested updates) from learnings (corrections/preferences). Never mix them.
- Only explicit learnings (things Kelly directly said) are eligible for MEMORIES.md writes. Inferred/observed items are shown for awareness only.
