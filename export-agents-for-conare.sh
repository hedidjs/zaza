#!/bin/bash

# Export all Claude Code agents to a single Context Item for Conare
# Usage: ./export-agents-for-conare.sh

OUTPUT_FILE="conare-agents-context.md"
AGENTS_DIR=".claude/agents"

echo "🤖 Exporting Claude Code Agents to Conare Context Item..."
echo ""

# Start the context file
cat > "$OUTPUT_FILE" << 'EOF'
# Claude Code Agents - Context Item for Conare

This context item contains all custom Claude Code agents from this project.
You can reference these agents when working on tasks.

---

EOF

# Count agents
AGENT_COUNT=$(find "$AGENTS_DIR" -name "*.md" -type f | wc -l | tr -d ' ')
echo "📦 Found $AGENT_COUNT agents"
echo ""

# Add each agent to the context file
for agent_file in "$AGENTS_DIR"/*.md; do
    if [ -f "$agent_file" ]; then
        agent_name=$(basename "$agent_file" .md)
        echo "  ✓ Adding: $agent_name"

        cat >> "$OUTPUT_FILE" << EOF

## Agent: $agent_name

\`\`\`markdown
$(cat "$agent_file")
\`\`\`

---

EOF
    fi
done

echo ""
echo "✅ Export complete!"
echo ""
echo "📄 Output file: $OUTPUT_FILE"
echo ""
echo "🎯 Next steps:"
echo "   1. Open Conare"
echo "   2. In the right panel, find 'Context Items'"
echo "   3. Click the input box and select: $OUTPUT_FILE"
echo "   4. Toggle it ON to enable all agents"
echo ""
echo "💡 Now you can ask Claude to use any agent like:"
echo "   'Use the mobile-developer agent to help me with Flutter'"
echo "   'Act as the database-optimization agent and check my queries'"
echo ""
