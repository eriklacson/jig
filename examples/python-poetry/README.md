# examples/python-poetry/

Starter files for a project that uses Python and Poetry. Copy them into the project's root folder.

| File | What it does |
|---|---|
| `pyproject.toml` | Poetry settings, plus settings for Black, Ruff, Bandit and pytest. |
| `.pre-commit-config.yaml` | Runs the same checks before every commit. |
| `.github/workflows/ci.yaml` | Runs the same checks in GitHub Actions. |

After copying:

1. Change the project name in `pyproject.toml`.
2. Run `poetry install --with dev && poetry run pre-commit install`.

## Expected failure

pytest exits with code 5 when it finds no tests. Until the project has tests, CI and the pre-commit hook will fail. That is on purpose: a project with no tests should not pass.
