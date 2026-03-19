#!/usr/bin/env bash
set -euo pipefail

# Usage: ./scripts/draft.sh <project> <template-type>
# Example: ./scripts/draft.sh codeilus launch-post
#
# Creates a new draft from a template, pre-filled with project data.

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT="${1:?Usage: draft.sh <project> <template-type>}"
TEMPLATE="${2:?Usage: draft.sh <project> <template-type>}"
DATE="$(date +%Y-%m-%d)"

TEMPLATE_FILE="$REPO_ROOT/templates/${TEMPLATE}.md"
PROJECT_DIR="$REPO_ROOT/projects/${PROJECT}"
DRAFT_DIR="$REPO_ROOT/content/drafts"

if [ ! -f "$TEMPLATE_FILE" ]; then
    echo "Error: Template '$TEMPLATE' not found at $TEMPLATE_FILE"
    echo "Available templates:"
    ls "$REPO_ROOT/templates/" | sed 's/\.md$//'
    exit 1
fi

if [ ! -d "$PROJECT_DIR" ]; then
    echo "Error: Project '$PROJECT' not found at $PROJECT_DIR"
    echo "Available projects:"
    ls "$REPO_ROOT/projects/"
    exit 1
fi

# Create draft filename
DRAFT_FILE="$DRAFT_DIR/${DATE}-${PROJECT}-${TEMPLATE}.md"

mkdir -p "$DRAFT_DIR"

# Copy template and substitute variables
sed -e "s/{PROJECT_NAME}/$PROJECT/g" \
    -e "s/{DATE}/$DATE/g" \
    "$TEMPLATE_FILE" > "$DRAFT_FILE"

echo "Draft created: $DRAFT_FILE"
echo ""
echo "Next steps:"
echo "  1. Open $DRAFT_FILE"
echo "  2. Fill in the template sections"
echo "  3. Use Claude Code: 'help me finish this draft using data from projects/$PROJECT/STATUS.md'"
echo "  4. When done, move to content/published/"
