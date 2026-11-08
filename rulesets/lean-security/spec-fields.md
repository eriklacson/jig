# lean-security spec fields

A project using this ruleset adds these fields under `ruleset_params` in the frontmatter of the project's spec, `docs/<project>.spec.md`.

```yaml
ruleset: lean-security
ruleset_params:
  target_framework: SOC 2          # optional: SOC 2, HIPAA, ISO 27001, PDPA, MAS TRM
  controls_in_scope: [all]         # CSFLite control IDs, or [all]
  implementation_focus:            # optional: for projects that build controls
    - domain: iam
      controls: [PR.AA-01, PR.AA-03]
  risk_threshold: UNSPECIFIED      # how much risk the project accepts; drives "right-sized"
```

| Field | Required | What it is |
|---|---|---|
| `target_framework` | no | A regulation or standard the work maps to. Leave it out for governance-only work. |
| `controls_in_scope` | yes | The CSFLite controls this project covers. Each ID must exist in the reference data (LS-1). |
| `implementation_focus` | no | For projects that build controls: each area of work and the controls it covers. |
| `risk_threshold` | no | The cut-off for what counts as right-sized. Its format is not decided. |

## Deliverable types

This ruleset recognises these deliverable types in the deliverables table of each scope:

`gap-analysis` · `policy` · `mapping` · `assessment-report` · `executive-summary`

## Removed from the old spec

- `implementation_focus.protocols`. The `protocols/` folder is gone. Interface definitions now go in `integrations.md`.
- `stack`. The stack is now set in `architecture.md` §3.
