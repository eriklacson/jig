# Ruleset: neutral

The reference ruleset. It holds plain engineering rules about the software, with no security content. If jig works with this ruleset alone, the harness does not depend on any one field.

The rules about the jig process itself (tasks, scopes, plans, file names) are not here. They live in `harness/rules.md` and apply to every project.

## Extra fields for the spec

None.

## Proposed rules

These rules are proposals, not agreed. None is tied to a check yet, so all are `unbuilt`.

| ID | Rule | How it would be checked | Fed by | Install status |
|---|---|---|---|---|
| N-1 | Every external interface listed in the routes record has a contract test. | The system-wide check fails on any route without one. | `build.routes.md` §1 | unbuilt |
| N-2 | The project's full test suite passes every round, not just the current task's tests. | The gate runs the full suite each round. A failure outside the task blocks the round. | — | unbuilt |
| N-3 | The code builds and the linter passes. | The gate runs the build and lint commands named in `build.standards.md`. | `build.standards.md` §1 | unbuilt |

## Moved to the harness

Rules N-1 and N-3 to N-7 from the earlier draft govern the jig process, not the software. They are now P-1, P-4, P-5, P-8, P-9 and P-10 in `harness/rules.md`.
