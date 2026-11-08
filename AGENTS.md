# AGENTS.md

This file tells any AI coding agent how to work in this repository. It does not depend on one tool. Claude Code reads it through `CLAUDE.md`.

jig is an SDLC harness for coding agents. An SDLC (software development life cycle) is the path software takes from idea to release. A harness is everything around you that controls how you work: these instructions, the files you work from, and the checks that judge your output. You write the code. Checks you cannot change decide when the work is done. You never judge your own work.

## What to read first

1. `VOCABULARY.md` lists the terms used in this repo. Use them as defined there.
2. `docs/<project>.spec.md` says what the project is for. The `ruleset:` field in its frontmatter names the rules the project follows.
3. `rulesets/<ruleset>/README.md` describes those rules.
4. `harness/plans/CURRENT` holds the stub of the scope you are working on. Its plan is `harness/plans/<stub>.plan.md`. If `CURRENT` is missing, no plan is approved yet.

## How work moves

Work is cut into pieces in this order: the spec, then a scope, then a plan for that scope, then the tasks in the plan.

Every scope goes through the same six stages.

| Stage | What happens | Who decides it is done |
|---|---|---|
| READ | You load the files above, the scope in `docs/scopes/`, and the build records it covers. | You |
| PLAN | You draft `harness/drafts/<stub>.plan.md` (the tasks in order), `<stub>.check.sh` (the check for each task) and `<stub>.gate.yaml`. | You draft them |
| APPROVE | A person approves the plan and moves the three files into `harness/plans/`. From then on, you cannot edit them. | A person |
| IMPLEMENT | You work through the tasks in order. | The checks |
| VERIFY | Each task's check runs. You report its real output. | The checks |
| REPORT | A person audits the rows the scope covered, compares them with the build records, and approves the release. | A person |

Start in plan mode if your tool has one. Never skip PLAN. Never start IMPLEMENT before a person approves the plan.

## Tasks

A task is one step in the plan. Each task names the check that proves it.

A task is done only when its check passes. Your own judgment does not count.

Before the first round, write the task's tests and run them. They must fail, because nothing is built yet. The harness then hashes them into `<stub>.tests.sha`. From then on, you cannot change those tests. A test you can weaken proves nothing.

Each attempt at a task is a round. Every round is added to `<stub>.log.jsonl`.

When a task's check passes, run `harness/loop/mark-done.sh <stub> <task-id>`. It runs the check again and sets the task's status to `done` only if the check passes. You never edit the status yourself.

If you hit a question the files don't answer, stop. Write `STUCK` and the question. Do not guess.

If a task reaches its round limit, stop. The log records `BUDGET`. Report how far you got.

Always report the check's real output, not your summary of it.

## What you must never change

- Anything in `harness/plans/`. Only `mark-done.sh` changes a plan's status column.
- Any check, or any check result. A check you can edit proves nothing.
- A test after its hash is taken.
- The log, except through the harness scripts.
- Anything in `docs/`, except during PLAN with a person present.
- `VOCABULARY.md`.

## Where the rules come from

Two files hold the rules. Each rule is tied to a check you cannot change.

- `harness/rules.md` holds the process rules. They govern how tasks, scopes and plans are written and closed, and apply to every project.
- The project's ruleset holds the rules about the software you build.

This file holds no rules of either kind beyond what is above.

The mechanism that ties rules to checks (the slot) is not built yet. Until it is, treat both rule files as guidance, not as enforced checks.

## File names

Name every file you produce `<stub>.<type>.<extension>`, as listed in `VOCABULARY.md`. A plan and every file beside it use the stub of the scope they deliver.

## Changing scope

A change to scope needs a decision record in `docs/decisions/` and a new plan. Do not edit an approved plan.

## Never


- Never write a secret value into any file.
- Never build anything the scope does not ask for.
