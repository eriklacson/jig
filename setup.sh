#!/usr/bin/env bash
# Post-clone setup for jig projects.
# Run once after cloning.
#
# Usage:
#   git clone <template-repo> my-project
#   cd my-project
#   ./setup.sh

set -euo pipefail

# Create .git/info/exclude for local-only ignores
# These patterns are ignored locally but never committed to .gitignore,
# so they don't affect collaborators or downstream repos.
mkdir -p .git/info
cat > .git/info/exclude << 'EOF'
# Local-only ignores — not shared via .gitignore
# See: https://git-scm.com/docs/gitignore

# Personal Claude Code overrides
CLAUDE.local.md

# Local notes and scratch files
scratch/
notes/
*.local.*
EOF

echo "✓ .git/info/exclude created"


echo "✓ Template ready. Copy docs/template.spec.md to docs/<project>.spec.md to start."
