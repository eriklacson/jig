# CLAUDE.md

The instructions for all AI agents live in `AGENTS.md`. Claude Code loads that file through the import below. Put shared instructions there. Add here only what applies to Claude Code alone.

@AGENTS.md

## Claude Code only

- Use Plan Mode for the PLAN stage. Present the plan there and wait for approval.
- A Stop hook will run the current task's check before you can finish. See `.claude/hooks/README.md`. It is not built yet.
