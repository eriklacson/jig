# docs/decisions/

Every project decision is recorded here, one file per decision, named `<NNNN>-<short-title>.decision.md`. For example: `0001-azure-hosting.decision.md`. This folder is the only place decisions are kept.

`architecture.md` §7 lists decisions by ID and points here for the reasoning.

## When to write a decision record (ADR)

- You choose a technology.
- You change a scope. A scope change goes through a decision record and a new plan, never an edit to an approved plan.
- You choose an architecture pattern.
- A constraint applies only to this project.
- A security-relevant path is meant to fail open.

Routine implementation details don't need one.

## Format

```markdown
# NNNN — Title

**Status:** Proposed | Accepted | Superseded by NNNN
**Date:** YYYY-MM-DD
**Context:** What prompted this decision
**Decision:** What was decided
**Consequences:** What follows from it
**Affects:** IDs of the document rows or rules this changes
```

## What is checked at release

At release approval, the work is checked against the approved plan plus every accepted decision record.
