# jig

A **software development life cycle (SDLC)** is the path software takes from idea to release: deciding what to build, planning it, building it, checking it and shipping it. A **harness** is everything around a coding agent that controls how it works: the instructions it reads, the files it works from, and the checks that judge its output.

**jig is an SDLC harness for coding agents.** It takes an AI coding agent through every stage of the life cycle and controls each one. The agent writes the code. Checks the agent cannot change decide when each piece of work is done. A person approves the plan before work starts and approves the result before it ships. It works for new projects and for existing codebases.

**jig is a boilerplate.** It is a GitHub template repository. You don't install it or call it from your code. You create a new repo from it, one per project, and fill in its templates.

## Why jig exists

Coding agents write code quickly, but they are poor judges of their own work. Left alone, an agent decides for itself when a task is finished. It can report a task done when the tests never ran, change a test until it passes, or build something nobody asked for. The usual fix is to have a person review every change, which gives back most of the time the agent saved.

jig takes the decision away from the agent and keeps people only where judgment is needed:

- **A check decides when a task is done, not the agent.** The agent cannot edit the check or its result.
- **Tests are locked before any code is written.** Their hash is taken while they still fail, so the agent cannot weaken them later.
- **People approve twice.** Once when the plan is ready, once when the result is ready. Everything between those two points runs on checks.
- **Every step leaves a file behind.** The spec, the scope, the plan and the log link each change back to the requirement that asked for it. That trail is also your evidence for an audit.

## What a new project gets from the boilerplate

| Comes with the boilerplate | You add in each project |
|---|---|
| `AGENTS.md`, `CLAUDE.md`, `VOCABULARY.md` | Your code and its tests |
| `harness/`: process rules, plan template, folder layout | Plans for your scopes, drafted by the agent |
| `docs/`: templates for the spec, scopes, records and decisions | Your spec, records, scopes and decision records |
| `rulesets/`: `neutral` and `lean-security` | Your choice of one ruleset, named in your spec |
| `examples/python-poetry/` | The stack files you copy from it, if any |

A new project starts with no plans. `harness/plans/` holds only `template.plan.md`.

## How work is cut up

| Piece | What it is | Where it lives |
|---|---|---|
| Spec | What the project is for: goal, outcomes, and the ruleset it follows. | `docs/<project>.spec.md` |
| Records | Five documents describing the system, each as a build/audit pair. | `docs/build.<record>.md`, `docs/audit.<record>.md` |
| Scope | A part of the spec built as one piece, with its own success criteria. | `docs/scopes/<stub>.scope.md` |
| Plan | The tasks for one scope, in order, each with its check. | `harness/plans/<stub>.plan.md` |
| Task | One step in the plan. The agent's loop works through them. | A row in the plan |

## How jig is organised

jig has three levels. Each one has a different job.

| Level | What it does | Where it lives |
|---|---|---|
| Harness | Runs the process and enforces the process rules: how tasks, scopes and plans are written and closed. | `AGENTS.md`, `harness/`, `harness/rules.md`, the templates in `docs/` |
| Ruleset | Defines the rules about the software and how each rule is checked. | `rulesets/<name>/` |
| Project | One codebase, using exactly one ruleset. | A repo created from jig |

Two rulesets ship with jig. `neutral` holds plain engineering rules and is the reference. `lean-security` is for multi-tenant SaaS: secure build rules plus coverage reporting rules. Both plug in the same way. No ruleset builds on another, because the process rules every project needs live in the harness.

## What is in the repo

```
AGENTS.md            instructions for any AI agent
CLAUDE.md            loads AGENTS.md into Claude Code
VOCABULARY.md        the terms used in this repo
docs/                the spec, the five records, the scopes and the decision records
harness/             drafts, approved plans, and the scripts that hold the loop to the checks
rulesets/            neutral, lean-security
examples/            starter files for a stack (python-poetry)
setup.sh             run once after cloning
```

## Two ways in

- **Existing codebase.** Describe the system as it is now (audit mode). Describe the change you want (build mode). Then plan, build and check.
- **New project.** Describe what you want to build (build mode). Then plan, build and check.

Both end the same way. When a scope is finished, fill the rows it covered in the audit records and compare them with the build records. Any row that differs is a gap between what was asked for and what got built.

Every file the process produces is named `<stub>.<type>.<extension>`, for example `01-login.scope.md` and `01-login.plan.md`. `VOCABULARY.md` lists the types.

## Start a project

1. On GitHub, choose **Use this template** on the jig repo to create your project repo. Clone it and run `./setup.sh`.
2. Copy `docs/template.spec.md` to `docs/<project>.spec.md` and fill it in. Set `ruleset:` in its frontmatter.
3. Copy each record template (`docs/template.architecture.md` and the rest) to `build.<record>.md`. For an existing codebase, also copy it to `audit.<record>.md`.
4. Copy `docs/scopes/template.scope.md` to `docs/scopes/01-<name>.scope.md` and fill it in.
5. Open your agent. It reads `AGENTS.md`, starts at READ and drafts a plan for that scope.

## Add jig to a repo you already have

GitHub cannot merge a template into a repo that already exists. So you copy the files in by hand.

1. Clone jig next to your repo.
2. Copy these into your repo: `AGENTS.md`, `CLAUDE.md`, `VOCABULARY.md`, `.claude/`, `harness/`, `docs/` and one folder from `rulesets/` (with `rulesets/README.md`).
3. Do not copy jig's own `README.md`, `examples/` or `setup.sh`. If you want what `setup.sh` does, run its commands yourself.
4. **Never overwrite a file that already exists.** This matters most for `AGENTS.md`, `CLAUDE.md`, `.gitignore` and `.claude/settings.json`. Open both versions and merge them. Keep your content.
5. Follow the jig template when you merge. Use its headings and its order, so an agent reads your file the same way it reads jig's. Keep the deny rules in `.claude/settings.json`. They stop the agent from editing approved plans.
6. Carry on from step 2 of "Start a project". Fill the audit records as well as the build records.

## What is built so far

| Part | Status |
|---|---|
| Process, terms, folder layout | In place |
| Templates (spec, scope, plan, five records) and file naming | In place |
| Slot (ties each rule to a check) | Not designed |
| Loop scripts (`mark-done.sh`, `stop-check.sh`, `gate.sh`) | Not written |
| Install script for an existing repo (today: copy by hand) | Not written |
| Process rules (`harness/rules.md`) | Written, not yet tied to checks |
| `neutral` ruleset | Proposed only |
| `lean-security` ruleset | Drafted, not yet tied to checks |

## License

UNSPECIFIED. Decided at release approval.
