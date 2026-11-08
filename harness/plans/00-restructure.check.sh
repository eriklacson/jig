#!/usr/bin/env bash
# Checks for plan 00-restructure.
# Approved with the plan. The agent must not edit this file.
#
#   bash harness/plans/00-restructure.check.sh        run every check
#   bash harness/plans/00-restructure.check.sh T-3    run only the checks for task T-3
#
# Exit code = number of failing checks. 0 means done.

set -u
cd "$(dirname "$0")/../.." || exit 125

case "${1:-all}" in
  T-1) want="L V N" ;;
  T-2) want="A" ;;
  T-3) want="C" ;;
  T-4) want="E" ;;
  T-5) want="H" ;;
  T-6) want="R B" ;;
  all) want="L V N A C E H R B" ;;
  *) echo "unknown task: $1" >&2; exit 125 ;;
esac

pass=0
fail=0
check() { # id, description, command...
  local id="$1" desc="$2" group="${1%%-*}"; shift 2
  case " $want " in *" $group "*) ;; *) return 0 ;; esac
  if "$@" >/dev/null 2>&1; then
    pass=$((pass + 1)); printf 'PASS %-5s %s\n' "$id" "$desc"
  else
    fail=$((fail + 1)); printf 'FAIL %-5s %s\n' "$id" "$desc"
  fi
}
exists() { for f in "$@"; do [ -e "$f" ] || return 1; done; }
absent() { for f in "$@"; do [ ! -e "$f" ] || return 1; done; }
has()    { grep -qiE -- "$2" "$1"; }
lacks()  { [ -f "$1" ] && ! grep -qiE -- "$2" "$1"; }

# Files outside the lean-security ruleset and this plan.
scan_files() {
  find . -path ./.git -prune -o -path ./rulesets/lean-security -prune \
    -o -path './harness/plans/00-restructure.*' -prune -o -type f -print0
}
none_match() { # regex, extra excluded path (optional)
  local hits
  hits=$(scan_files | xargs -0 grep -IliE -- "$1" 2>/dev/null | grep -v -- "${2:-^$}")
  [ -z "$hits" ]
}

# Hashes of the files provided with this plan.
provided_unchanged() {
  sha256sum -c --quiet 2>/dev/null <<'EOF'
ed2b41fcd7cf861bc7b9e616108d35de1a506520629b364bb10b42b1db1a4cc0  VOCABULARY.md
e38da7869f3612d7d09cf5b5a94673750d779a9437f8c9c435c6b6fa066b45eb  docs/template.spec.md
ca6daf1dc25c901907611458c2a786352f98c47452b692c2bd539b82ce5a7480  docs/scopes/template.scope.md
2896246ec0c301b19690367eec5172d1138cd0b460d364903ecc611facb11d2b  docs/template.architecture.md
fd8e742b1cfd0153bd739e70a41878c2c40cfb1b1afb4c8a97f9e80c2bb51520  docs/template.routes.md
e337328b0afadeaf3b67c78a15d24b33ce763a1beb842f7146bc1a5727b627f2  docs/template.schema.md
bb0acb2dea77497a1035d078be00d6cddac869c55914eb18a65bacbf9e016917  docs/template.integrations.md
05f60151f83bc4d58e416cab882e99c353553d36803bdc3a9a50df87c1a198cd  docs/template.standards.md
423b40f3289892e9710fbfe9d1f2969bc2c515f017fe259bf7647ca6eead6695  harness/rules.md
8459838738c4076cdab204c644b5cd669728c323e73b06dfb7f49bfba19dea58  harness/plans/template.plan.md
cd08513cac9ebabe1842af1c97cf4ae4d4edfbcebba4e298883c389a50ae4e19  harness/plans/CURRENT
34da4a7e0ac806288fa4d06105a76c42c50429d7936c4dccab1a2bdf0ae41552  .claude/hooks/README.md
c073eb873c092db7eddd358e13c9b7605fe6e5eb0999abcf13a2d29529970b7f  rulesets/lean-security/rules.md
EOF
}

# --- L: harness layout (T-1)
check L-1 "harness READMEs and drafts/ exist" \
  exists harness/README.md harness/loop/README.md harness/drafts/.gitkeep
check L-2 "old task files and unit folders removed" absent .claude/tasks.md harness/units
check L-3 ".claude/loop.md points to harness/plans/CURRENT, 5 lines max" \
  bash -c '[ -f .claude/loop.md ] && [ "$(wc -l < .claude/loop.md)" -le 5 ] && grep -q "harness/plans/CURRENT" .claude/loop.md'
check L-4 "no loop scripts written (not in this plan)" \
  bash -c '! ls harness/loop/*.sh >/dev/null 2>&1'
check L-5 "loop README lists mark-done.sh as unbuilt" bash -c \
  'grep -q "mark-done.sh" harness/loop/README.md && grep -q "unbuilt" harness/loop/README.md'
check L-6 "harness README explains drafts/, plans/, docs/, the file name rule and rules.md" bash -c \
  'f=harness/README.md; grep -q "drafts/" $f && grep -q "plans/" $f && grep -q "docs/" $f && grep -q "<stub>.<type>" $f && grep -q "rules.md" $f'
check V-1 "provided files unchanged" provided_unchanged
check N-1 "every file in docs/, harness/drafts/ and harness/plans/ is named <stub>.<type>.<ext>" bash -c '
  bad=$(find docs harness/drafts harness/plans -type f ! -name README.md ! -name .gitkeep ! -name CURRENT 2>/dev/null |
    xargs -r -n1 basename | grep -vE "^[a-z0-9][a-z0-9-]*\.((spec|scope|decision|plan|architecture|routes|schema|integrations|standards)\.md|check\.sh|gate\.yaml|log\.jsonl|(approved|tests)\.sha)$")
  [ -z "$bad" ]'

# --- A: agent instructions (T-2)
check A-0 "AGENTS.md calls jig an SDLC harness for coding agents and defines SDLC" bash -c \
  'grep -qi "SDLC harness for coding agents" AGENTS.md && grep -qi "software development life cycle" AGENTS.md'
check A-1 "AGENTS.md has the six stages" bash -c \
  'for s in READ PLAN APPROVE IMPLEMENT VERIFY REPORT; do grep -q "$s" AGENTS.md || exit 1; done'
check A-2 "AGENTS.md forbids push" has AGENTS.md 'push'
check A-3 "AGENTS.md names tasks, the ruleset, the spec, mark-done.sh, the file name rule and harness/rules.md" bash -c \
  'grep -qi "task" AGENTS.md && grep -qi "ruleset" AGENTS.md && grep -q "spec.md" AGENTS.md && grep -q "mark-done.sh" AGENTS.md && grep -q "<stub>.<type>" AGENTS.md && grep -q "harness/rules.md" AGENTS.md'
check A-4 "CLAUDE.md imports @AGENTS.md, 15 lines max" bash -c \
  'grep -qx "@AGENTS.md" CLAUDE.md && [ "$(wc -l < CLAUDE.md)" -le 15 ]'

# --- C: rulesets (T-3)
check C-1 "ruleset files exist" exists rulesets/README.md rulesets/neutral/README.md \
  rulesets/lean-security/README.md rulesets/lean-security/rules.md \
  rulesets/lean-security/spec-fields.md rulesets/lean-security/spec-assistant.md \
  rulesets/lean-security/examples/baseline-assessment.yaml
check C-2 "csflite/, claude-project/ and contexts/ removed" absent csflite claude-project contexts
check C-3 "lean-security links the CSFLite repo and its reference file" bash -c \
  'grep -q "github.com/eriklacson/CSFLite" rulesets/lean-security/README.md && grep -q "csf_lookup.csv" rulesets/lean-security/README.md'
check C-4 "lean-security rules marked unbuilt" has rulesets/lean-security/rules.md 'unbuilt'
check C-5 "spec-fields defines ruleset_params incl. controls_in_scope" bash -c \
  'grep -q "ruleset_params" rulesets/lean-security/spec-fields.md && grep -q "controls_in_scope" rulesets/lean-security/spec-fields.md'
check C-6 "neutral rules marked unbuilt" has rulesets/neutral/README.md 'unbuilt'
check C-7 "baseline example flagged legacy on line 1" bash -c \
  'head -1 rulesets/lean-security/examples/baseline-assessment.yaml | grep -qiE "^#.*legacy"'
check C-8 "rulesets README: one ruleset per project, process rules in harness/rules.md" bash -c \
  'grep -q "harness/rules.md" rulesets/README.md && grep -qiE "exactly one|one ruleset" rulesets/README.md'
check C-9 "lean-security README states the multi-tenant SaaS assumption" has rulesets/lean-security/README.md 'multi-tenant'

# --- E: stack example (T-4)
check E-1 "python-poetry example files exist" exists examples/python-poetry/README.md \
  examples/python-poetry/pyproject.toml examples/python-poetry/.pre-commit-config.yaml \
  examples/python-poetry/.github/workflows/ci.yaml
check E-2 "stack files removed from root" absent pyproject.toml .pre-commit-config.yaml .github/workflows/ci.yaml
check E-3 "example Poetry name is jig-python-example" \
  has examples/python-poetry/pyproject.toml '^name = "jig-python-example"'
check E-4 "example README explains pytest exit 5" has examples/python-poetry/README.md 'exit.{0,12}5'

# --- H: housekeeping (T-5)
check H-1 "docs/ is not gitignored" bash -c '! git check-ignore -q docs/template.spec.md'
check H-2 "setup.sh does not exclude .claude/ or harness/" bash -c \
  '! grep -qE "^[[:space:]]*(\.claude|harness)/?[[:space:]]*$" setup.sh'
check H-3 "setup.sh has no Poetry install or /project: command" lacks setup.sh 'poetry|/project:'
check H-4 "settings.json blocks push and edits to harness/plans" python3 -c '
import json, sys
s = json.load(open(".claude/settings.json"))["permissions"]
need = {"Bash(git push *)", "Edit(harness/plans/**)", "Write(harness/plans/**)"}
stale = ("csflite", "contexts", "templates/", "protocols/", "Write(decisions/")
sys.exit(0 if need <= set(s.get("deny", [])) and not any(x in a for a in s.get("allow", []) for x in stale) else 1)'
check H-5 "docs/decisions/README.md gives the file name, no CSFLite field" bash -c \
  'grep -q "ADR" docs/decisions/README.md && grep -q ".decision.md" docs/decisions/README.md && ! grep -qi "csflite" docs/decisions/README.md'
check H-6 ".gitignore still ignores secrets" bash -c 'grep -qx ".env" .gitignore && grep -qx "*.pem" .gitignore'

# --- R and B: README, brand and retired terms (T-6)
check R-1 "README is about jig and names spec, scope, plan and task" bash -c \
  'grep -qw jig README.md && for t in spec scope plan task; do grep -qiw "$t" README.md || exit 1; done'
check R-2 "README defines SDLC and harness, calls jig an SDLC harness, says boilerplate, then a Why section" bash -c \
  'intro=$(awk "/^## /{exit} {print}" README.md)
   d=$(echo "$intro" | grep -ni "software development life cycle" | head -1 | cut -d: -f1)
   u=$(echo "$intro" | grep -ni "SDLC harness for coding agents" | head -1 | cut -d: -f1)
   [ -n "$d" ] && [ -n "$u" ] && [ "$d" -le "$u" ] &&
   echo "$intro" | grep -qiE "harness(\*\*)? is " &&
   echo "$intro" | grep -qi "boilerplate" && echo "$intro" | grep -qi "template repository" &&
   awk "/^## /{print; exit}" README.md | grep -qi "why"'
check R-3 "README explains adding jig to an existing repo and says not to overwrite" bash -c \
  'grep -qi "^## add jig to a repo you already have" README.md &&
   awk "/^## Add jig to a repo/{f=1;next} /^## /{f=0} f" README.md | grep -qi "never overwrite" &&
   awk "/^## Add jig to a repo/{f=1;next} /^## /{f=0} f" README.md | grep -qi "template"'
check B-1 "no brand or CSFLite terms outside rulesets/lean-security" \
  none_match 'csflite|lean ?security|leansec|conduit|maturity'
check B-2 "no retired terms outside VOCABULARY.md" \
  none_match 'tasks\.md|verify\.sh|design mode|seed document|project\.yaml|engagement|harness/units|unit contract|context_params|contexts/|docs/scope\.md|docs/spec\.md|plan-template\.md|scope-template\.md' '^\./VOCABULARY\.md$'
check B-3 "no /project: commands anywhere" none_match '/project:'

echo "passing $pass / $((pass + fail))"
[ "$fail" -gt 125 ] && fail=125
exit "$fail"
