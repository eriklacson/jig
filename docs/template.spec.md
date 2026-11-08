---
doc: spec
project: UNSPECIFIED          # short name, lowercase with hyphens
ruleset: neutral              # which ruleset this project follows: a folder name under rulesets/
ruleset_params: {}            # extra fields the chosen ruleset asks for; see rulesets/<name>/README.md
version: 0.1
date: YYYY-MM-DD
---

# Spec — {{PROJECT}}

> Copy this file to `docs/<project>.spec.md`.
> This document says what the project is for. It is the top of the chain: spec → scope → plan → task.
> The build records in `docs/` (`build.architecture.md` and the rest) describe the system the spec covers.
> Each piece of work is cut out of this spec as a scope in `docs/scopes/`.

## 1. Goal

One sentence: what this project achieves, and for whom.

## 2. Outcomes

What will be true when the project is finished. Each outcome is covered by at least one scope, or listed as deferred.

| ID | Outcome | Covered by scope |
|---|---|---|
| O-1 | | |

## 3. Constraints

Limits every scope must stay within.

| ID | Constraint |
|---|---|
| C-1 | |

## 4. Deferred

Outcomes this project deliberately leaves for later, and why. Listing them here stops them from being dropped silently.

| ID | Deferred outcome | Why |
|---|---|---|
| DF-1 | | |

## 5. Open items

| ID | Item | Why it is still open | What it blocks |
|---|---|---|---|
