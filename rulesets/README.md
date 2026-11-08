# rulesets/

A ruleset defines the rules about the software an AI agent builds. It specifies what the software must do or avoid, how each rule is checked, and what extra fields a project fills in. The agent cannot change those checks.

Each project picks exactly one ruleset in its spec, `docs/<project>.spec.md`:

```yaml
ruleset: neutral
ruleset_params: {}
```

## Rulesets and process rules

Rules about the jig process itself (how tasks, scopes and plans are written and closed) live in `harness/rules.md`. They apply to every project. A ruleset never repeats them.

That split is why a project needs only one ruleset. No ruleset builds on another, so no ruleset holds a copy of another's rules.

## What every ruleset contains

| File | What it holds |
|---|---|
| `README.md` | What the ruleset is for, the kind of software it assumes, and the extra fields it asks the project for. |
| `rules.md` or a table in `README.md` | One row per rule, with how it is checked and its install status. |

## Rulesets in this repo

| Ruleset | What it is for | Status |
|---|---|---|
| `neutral/` | Plain engineering rules. The reference: it shows jig works with no security content. | Rules proposed only |
| `lean-security/` | Multi-tenant SaaS for startups and small companies: secure build rules plus coverage reporting rules. | Rules drafted, not yet tied to checks |

## Every ruleset plugs in the same way

No ruleset gets special treatment. The harness never refers to a ruleset by name.

## Not built yet

The mechanism that ties each rule to a check (the slot) is not designed yet. The starting point is the invariant row in the standards record: ID, rule, kind, scope, mechanism, where it is enforced, install status, evidence. Until the slot exists, ruleset rules are guidance only.

## Field equivalents

Spec-kit calls the nearest thing a constitution, and Kiro uses steering files. Both hold project rules in prose. A jig ruleset ties every rule to a check.
