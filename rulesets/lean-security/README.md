# Ruleset: lean-security

A ruleset for multi-tenant SaaS built by startups and small companies. It holds two kinds of rules: build rules that keep the software secure, and reporting rules that keep coverage reports honest. It plugs into jig the same way as `neutral`. That proves a new ruleset can be added without changing the harness.

## What it assumes

One database shared by many customer organisations (tenants), users who log in, and outside services that call back through webhooks. The reference stack is Next.js, Postgres, a hosted login provider and Stripe. The build rules are written against that stack. A project on a different stack restates them in its standards record.

## Principles

These come from the project instructions and are locked.

1. **Right-sized.** Use the smallest set of controls that fits the actual risk and the size of the company.
2. **Highest-impact first.** Do the controls that matter most. List the rest as deliberately deferred, never just left out.
3. **Evidence comes from the work itself.** Audit evidence is produced by doing the work, not by a separate documentation effort.
4. **Automate first.** Assembling evidence by hand is waste.
5. **Continuous.** Compliance is the current state of the work, not a yearly effort.

1 to 3 carry the weight. 4 and 5 follow from them.

## Reference data

The control set is a single reference file that the project supplies, for example a CSV of control IDs. Rule LS-1 checks every cited control ID against it. This ruleset keeps no copy of it.

## Files

| File | What it holds |
|---|---|
| `rules.md` | Build rules LS-8 to LS-18 and reporting rules LS-1 to LS-5. Not yet tied to checks. |
| `spec-fields.md` | Extra fields this ruleset adds to the project's spec. |
| `spec-assistant.md` | The old prompt for writing project specs. Kept for reference. |
| `examples/baseline-assessment.yaml` | The old example spec, in the old format. |

## Still to do

- Tie each rule in `rules.md` to a check, once the slot exists.
- Move the security columns, and rows INV-1 to INV-5 of the standards template, out of the record templates and into this ruleset.
- Rewrite `spec-assistant.md` for the spec and scope templates.
