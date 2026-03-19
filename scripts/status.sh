#!/usr/bin/env bash
set -euo pipefail

# Usage: ./scripts/status.sh
# Shows the current state of all content across projects.

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo "========================================="
echo "  CONTENT PIPELINE STATUS"
echo "  $(date +%Y-%m-%d)"
echo "========================================="
echo ""

# Projects overview
echo "## PROJECTS"
echo ""
for project_dir in "$REPO_ROOT"/projects/*/; do
    project=$(basename "$project_dir")
    status_file="$project_dir/STATUS.md"
    if [ -f "$status_file" ]; then
        # Count completed and total checklist items
        total=$(grep -c '^\- \[' "$status_file" 2>/dev/null || true)
        done=$(grep -c '^\- \[x\]' "$status_file" 2>/dev/null || true)
        total=${total:-0}
        done=${done:-0}
        echo "  $project: $done/$total tasks complete"
    fi
done

echo ""
echo "## DRAFTS"
echo ""
draft_dir="$REPO_ROOT/content/drafts"
if [ -d "$draft_dir" ] && ls "$draft_dir"/*.md &>/dev/null; then
    for draft in "$draft_dir"/*.md; do
        echo "  - $(basename "$draft")"
    done
else
    echo "  (no drafts)"
fi

echo ""
echo "## PUBLISHED"
echo ""
pub_dir="$REPO_ROOT/content/published"
if [ -d "$pub_dir" ] && ls "$pub_dir"/*.md &>/dev/null; then
    for pub in "$pub_dir"/*.md; do
        echo "  - $(basename "$pub")"
    done
else
    echo "  (nothing published yet)"
fi

echo ""
echo "## CALENDAR"
echo ""
if [ -f "$REPO_ROOT/calendar.md" ]; then
    # Show next 5 upcoming items
    grep -E '^\|.*202[0-9]' "$REPO_ROOT/calendar.md" | head -5
else
    echo "  (no calendar yet)"
fi

echo ""
echo "========================================="
