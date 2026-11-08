---
plan: 00-restructure
status: approved              # Erik places this file here directly; it is the first plan
round_limit: 3
---

# Plan 00 — Restructure the repo into jig

## Background

This repo is being restructured in place. It becomes **jig**, a harness for building any software with AI coding agents. Today it is a template tied to lean security and CSFLite.

This is the first plan, so the harness that would normally run it does not exist yet. `mark-done.sh` and the Stop hook are not built. You run the check script yourself after each task. Erik updates the Status column at release approval.

The current `CLAUDE.md` is the old instruction file. For this plan, follow only its six-stage process and its rule against pushing. Ignore everything else in it (CSFLite, `controls.json`, the seed document). This file replaces it.

`VOCABULARY.md` lists the terms jig uses. Use those terms in every file you write.

## Rules for this plan

- Start in Plan Mode. Present how you will do the tasks and wait for Erik to approve.
- Never edit anything in `harness/plans/`. It holds this approved plan and its checks.
- Never push. Never add a git remote.
- `check.sh` decides when a task is done, not you. Run `bash harness/plans/00-restructure.check.sh T-n` after each task and report its real output.
- If a task's check still fails after 3 rounds, stop and report `BUDGET`.
- If this file does not answer a question you have, stop. Write `STUCK` and the question. Do not guess.
- Use `git mv` to move files, so their history follows them.
- Make one commit per task. Do not squash.

## Writing style

Every file you write must follow these rules:

- Say what the thing does, and for whom: the agent, the project, or the person.
- Replace jargon with what it means. Use a jig term only if `VOCABULARY.md` defines it, and explain it the first time it appears in a file.
- Write full sentences, one idea each.
- Be concrete. Name the file, the command or the field.
- When a rule protects something, say what it protects. For example: "The agent cannot change the checks. A check the agent can edit proves nothing."

Example:

> A ruleset defines the rules under which an AI agent is allowed to work. It specifies what the agent must follow, how each rule is checked, and what extra fields a project fills in. The agent cannot change those checks.

## Files provided with this plan

Erik places these before you start. Do not change them. `00-restructure.check.sh` holds their hashes.

- `VOCABULARY.md`
- `docs/template.spec.md`, `docs/scopes/template.scope.md`
- `docs/template.architecture.md`, `template.routes.md`, `template.schema.md`, `template.integrations.md`, `template.standards.md`
- `harness/rules.md` (the process rules)
- `harness/plans/CURRENT`, `harness/plans/template.plan.md`
- `rulesets/lean-security/rules.md` (build rules and reporting rules)
- `harness/plans/00-restructure.plan.md` (this plan) and `harness/plans/00-restructure.check.sh` (its checks)
- `.claude/hooks/README.md`

## Target layout

```
AGENTS.md                      instructions for any AI agent
CLAUDE.md                      loads AGENTS.md into Claude Code, plus Claude-only notes
VOCABULARY.md                  provided
README.md                      rewritten for jig
setup.sh                       excludes only personal and scratch files
.gitignore                     no longer ignores docs/
.claude/
  settings.json                blocks any push and any edit to harness/plans/**
  loop.md                      three lines pointing to harness/plans/CURRENT
  hooks/README.md              provided
docs/
  template.spec.md             provided
  template.architecture.md template.routes.md template.schema.md
  template.integrations.md template.standards.md                    provided
  scopes/template.scope.md     provided
  decisions/README.md          decision record format and file name; the only place decisions are kept
harness/
  README.md                    what drafts/ and plans/ are for, who may write each, and the file names
  rules.md                     provided: the process rules every project follows
  drafts/                      empty; keep it in git with a .gitkeep
  plans/                       provided: CURRENT, template.plan.md, plan 00 and its checks
  loop/README.md               mark-done.sh, stop-check.sh, gate.sh: not written yet
rulesets/
  README.md                    what a ruleset is; one per project; the slot is not designed yet
  neutral/README.md            reference ruleset; proposed rules about the software, all unbuilt
  lean-security/
    README.md                  second ruleset; links to the CSFLite repo
    rules.md                   provided: build rules and reporting rules
    spec-fields.md             extra fields this ruleset adds to the spec
    spec-assistant.md          was claude-project/system-instruction.md
    examples/baseline-assessment.yaml
examples/
  python-poetry/
    README.md
    pyproject.toml
    .pre-commit-config.yaml
    .github/workflows/ci.yaml
```

## Tasks

Do the tasks in order. Each task's check is `bash harness/plans/00-restructure.check.sh <task-id>`.

| ID | Task | Depends on | Checks it turns green | Round limit | Status |
|---|---|---|---|---|---|
| T-1 | Harness folders, terms and file names | — | L-*, V-1, N-1 | 3 | todo |
| T-2 | Instructions for the agent | T-1 | A-* | 3 | todo |
| T-3 | Move lean security content into its ruleset | T-2 | C-* | 3 | todo |
| T-4 | Stack files become an example | T-3 | E-* | 3 | todo |
| T-5 | Repo housekeeping | T-4 | H-* | 3 | todo |
| T-6 | README | T-5 | R-*, B-* | 3 | todo |

### T-1 — Harness folders, terms and file names

- Create `harness/README.md`. It must explain the two folders. The agent drafts plans in `drafts/`. A person moves an approved plan into `plans/`, and after that only the harness scripts write there. It must also say the agent never writes to `docs/` from here, and that deleting `harness/` leaves a project that still builds. It must state the file name rule: every file in `drafts/` and `plans/` is `<stub>.<type>.<extension>`, with the stub of the scope the plan delivers. It must point to `harness/rules.md` for the process rules.
- Create `harness/loop/README.md`. List `mark-done.sh`, `stop-check.sh` and `gate.sh`, each with install status `unbuilt`, and what each will do. Say that `stop-check.sh` takes and verifies the tests hash (`<stub>.tests.sha`). Do not write the scripts.
- Create `harness/drafts/.gitkeep`.
- Delete `.claude/tasks.md`. Tasks are now rows in a plan.
- Create `.claude/loop.md`: three lines pointing to `harness/plans/CURRENT`.

### T-2 — Instructions for the agent

- Write `AGENTS.md`. Take the six-stage process and the rule against pushing from the old `CLAUDE.md`. Use `VOCABULARY.md` terms.
- `AGENTS.md` must open by saying jig is an SDLC harness for coding agents, defining both terms as `VOCABULARY.md` does. It must also say these things. Work is cut into spec, scope, plan and task. The rules come from the ruleset named in the project's spec. A task is done only when its check passes. Only `mark-done.sh` sets a task's status. The agent never edits a check, a check result, an approved plan or a hashed test. Every file the agent produces is named `<stub>.<type>.<extension>`. The process rules live in `harness/rules.md`; the rules about the software live in the project's ruleset.
- Do not copy any ruleset rule into `AGENTS.md`. No CSFLite, no coverage scoring, no maturity.
- Rewrite `CLAUDE.md` to this pattern, which the CSFLite repo already uses:

```
# CLAUDE.md

The instructions for all AI agents live in `AGENTS.md`. Claude Code loads that file through the import below. Put shared instructions there. Add here only what applies to Claude Code alone.

@AGENTS.md
```

### T-3 — Move lean security content into its ruleset

- Move `claude-project/system-instruction.md` to `rulesets/lean-security/spec-assistant.md`.
- Move `claude-project/examples/baseline-assessment.yaml` to `rulesets/lean-security/examples/`. Add a first-line comment saying it uses the legacy project.yaml format.
- `rulesets/lean-security/rules.md` is provided. Confirm that every rule in the old `CLAUDE.md` (hard prohibitions and operating context) and in `claude-project/project-yaml-schema.md` (validation rules) appears in it, either as a rule or in its "Rules that moved out" table. If one is missing, stop with `STUCK` and name it. Do not edit the file.
- Write `rulesets/lean-security/spec-fields.md`. Move the CSFLite-only fields from `project-yaml-schema.md` there: `target_framework`, `controls_in_scope`, `implementation_focus` and the document subtypes. They become `ruleset_params` in the project's spec.
- Write `rulesets/lean-security/README.md`. Say what it assumes: a multi-tenant SaaS on Next.js, Postgres, a hosted login provider and Stripe. Say it holds build rules and reporting rules. Say the CSFLite reference data lives in the CSFLite repo, in `data/csf_lookup.csv` (its ADR-0004). Link to https://github.com/eriklacson/CSFLite. Keep no local copy.
- Delete `csflite/`, `claude-project/seed-document-template.md` and `claude-project/project-yaml-schema.md`. Then delete the empty `claude-project/`.
- Write `rulesets/README.md`. Say what a ruleset is: rules about the software. Say each project uses exactly one, no ruleset builds on another, and the process rules live in `harness/rules.md`. Say every ruleset plugs in the same way and the slot is not designed yet.
- Write `rulesets/neutral/README.md`. Say it is the reference ruleset, with plain engineering rules about the software. List the proposed rules: every external interface has a contract test, the full test suite passes every round, and the code builds and the linter passes. Mark all of them `unbuilt`.

### T-4 — Stack files become an example

- Move `pyproject.toml`, `.pre-commit-config.yaml` and `.github/workflows/ci.yaml` into `examples/python-poetry/`. Keep the `.github/workflows/` path inside it.
- Change the Poetry `name` to `jig-python-example`. Remove `Lean Security` from `description`.
- Write `examples/python-poetry/README.md`. Say these files are for copying into a Python and Poetry project. Explain that pytest exits with code 5 when a project has no tests, so CI fails until tests exist, and that this is on purpose.

### T-5 — Repo housekeeping

- `.gitignore`: remove `docs/`. Keep the secrets and build entries.
- `setup.sh`: stop excluding `.claude/`. Keep `CLAUDE.local.md`, `scratch/`, `notes/` and `*.local.*`. Do not exclude `harness/`. Remove the Poetry install, which moved to the example. Update the header comment and the final message for jig: no brand, no `/project:new-project`.
- `.claude/settings.json`: remove `Write(csflite/**)`, `Write(templates/**)`, `Write(protocols/**)` and `Write(decisions/**)`. Add `Write(rulesets/**)`, `Write(harness/**)` and `Write(examples/**)`. Add `Edit(harness/plans/**)` and `Write(harness/plans/**)` to the deny list. Keep every existing deny entry.
- `docs/decisions/README.md`: use the decision record format from the old `system-instruction.md`, without the CSFLite Controls field. Name each record `<NNNN>-<short-title>.decision.md`. Say this folder is the only place decisions are kept, and that `architecture.md` §7 points here.

### T-6 — README

- Rewrite `README.md` for jig. Open with three things, in this order. First, what jig is: an SDLC harness for coding agents. Define "software development life cycle (SDLC)" and "harness" in plain words before using the phrase, as `VOCABULARY.md` does. Say that checks the agent cannot change decide when work is done. Second, that jig is a boilerplate: a GitHub template repository you create each project repo from. Third, a section headed "Why jig exists": the problem of agents judging their own work, and how jig answers it. Then cover what a new project gets from the boilerplate and what it adds, how work is cut up (spec, scope, plan, task), the file name rule, its three levels (harness, ruleset, project), the folder layout, how to start a project, and a section "Add jig to a repo you already have". That section lists what to copy by hand, says never to overwrite a file that already exists (merge instead), and tells people to follow the jig template when they merge. List the install script as not written in the status table. No brand, no CSFLite, no Conduit, no `/project:` commands.
- Replace the license line with `UNSPECIFIED. Decided at release approval.` The current line carries the brand, which check B-1 forbids.

## Not in this plan

Do not do any of these:

- Design the slot.
- Write `mark-done.sh`, `stop-check.sh` or `gate.sh`, or add the Stop hook to `settings.json`.
- Move security columns out of the five records.
- Define the neutral ruleset's rules beyond the proposed list.
- Add the merge-blocker toolkit.
- Change anything in `docs/` except creating `docs/decisions/README.md`.

## When you finish

When `bash harness/plans/00-restructure.check.sh` returns 0 with no task id, print its full output and the list of commits, then stop. Do not edit the Status column. Erik records it at release approval.

At release approval, Erik also deletes `harness/plans/00-restructure.*` and `harness/plans/CURRENT` in a final commit. Git history keeps them. This plan belongs to the jig repo itself, so projects created from the boilerplate must not inherit it.
