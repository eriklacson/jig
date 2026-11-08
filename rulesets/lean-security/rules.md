# lean-security rules

Two kinds of rules about the software. **Build rules** keep a multi-tenant SaaS secure. **Reporting rules** keep coverage reports honest. None is tied to a working check yet, so all are `unbuilt`.

Rules about the jig process itself are not here. They live in `harness/rules.md`.

## Build rules

These assume a multi-tenant SaaS: one database shared by many customer organisations (tenants), users who log in, and outside services that call back through webhooks. The reference stack is Next.js, Postgres, a hosted login provider and Stripe. Each check is generated from rows in the build records, so no judgment is needed to run it.

| ID | Rule | How it is checked | Fed by | Install status |
|---|---|---|---|---|
| LS-8 | The tenant id comes from the login session, never from the request. | For every tenant-scoped route, a test logs in as tenant A, asks for tenant B's record, and expects 404. | `build.routes.md`, Tenant-scoped = yes | unbuilt |
| LS-9 | Tenant filtering happens in the database, not in handler code. | A query on the test database confirms every table with the tenant field has Postgres row-level security switched on. | `build.schema.md`, tenant field | unbuilt |
| LS-10 | Every route needs a login, unless a decision record says it is public. | A test calls each route with no session. It expects 401, except for routes listed in routes §2 with a decision reference. | `build.routes.md` §1 and §2 | unbuilt |
| LS-11 | Admin actions check the user's role on the server. | Each route in routes §3 is called by a normal user, who must get 403. | `build.routes.md` §3 | unbuilt |
| LS-12 | Every inbound webhook checks its signature and rejects replays. | Per webhook: a bad signature gets 4xx, and a resent old event gets 4xx. | `build.integrations.md` §3 | unbuilt |
| LS-13 | No secret value exists in the code or in git history. | `gitleaks` scans the full history in CI. | `build.standards.md` INV-4 | unbuilt |
| LS-14 | Every environment variable the code reads is listed in `.env.example`. | A script compares the variables read in the code against `.env.example`. | `build.integrations.md` §4 | unbuilt |
| LS-15 | Error responses never contain a stack trace. | A test forces a failure in a handler and checks the response body. | `build.standards.md` §4 | unbuilt |
| LS-16 | List endpoints cap their page size. | A test asks for 100,000 rows and expects the cap. | `build.standards.md` §6 | unbuilt |
| LS-17 | Personal data never reaches the logs. | Tests use marker emails like `canary-…@test`. The check fails if a marker appears in the captured logs. | `build.schema.md`, sensitive fields | unbuilt |
| LS-18 | No dependency has a known critical vulnerability. | `osv-scanner` runs in CI and fails on critical findings. | — | unbuilt |

## Reporting rules

Collected from the old template's `CLAUDE.md` and its spec checks. These keep CSFLite coverage reports honest.

| ID | Rule | How it is checked | Where it came from | Install status |
|---|---|---|---|---|
| LS-1 | Every control ID cited exists in the CSFLite reference data. | A script checks every cited ID against `data/csf_lookup.csv` in the CSFLite repo. | Old CLAUDE.md; old spec check 1 | unbuilt |
| LS-2 | Score coverage only: does the control exist? Never score maturity. | A check fails on maturity terms in any report. | Old CLAUDE.md | unbuilt |
| LS-3 | Never claim compliance or certification. | A check fails on certification claims in any report. | Old CLAUDE.md | unbuilt |
| LS-4 | Prefer clear governance over adding more tools. | A person judges it at plan approval. | Old CLAUDE.md | unbuilt |
| LS-5 | Every spec includes the coverage-only constraint. | A check over the spec's constraints table. | Old spec check 3 | unbuilt |

## Rules that moved out

| Old rule | Moved to | Why |
|---|---|---|
| LS-6: criteria can be checked by a command or marked for a person | `harness/rules.md` P-6 | It governs how scopes are written, which is process. |
| LS-7: constraints are specific enough to enforce | `harness/rules.md` P-7 | Same reason. |
| Never push to a remote | `AGENTS.md` | It applies to every project. |
| Build only what the scope asks for | `AGENTS.md` | Same reason. |
| At least one deliverable and one criterion | `harness/rules.md` P-5 | Process, not security. |
| Project name is lowercase with hyphens | `harness/rules.md` P-10 | Process, not security. |
| App deliverables must set stack flags | Dropped | The stack is now set in the architecture record §3. |

## Overlap with the standards template

INV-1 to INV-5 in `docs/template.standards.md` are security rules that sit inside a generic template. LS-8, LS-9 and LS-13 cover INV-1, INV-2 and INV-4. Moving those rows out of the template and into this ruleset is the open column-split task.

## Open

The five principles have no checks of their own yet. Two examples of how they could be checked:

- Evidence comes from the work: a task's check fails if the task ends without producing its declared evidence file.
- Right-sized: plan approval fails if a control has no risk mapped to it.
