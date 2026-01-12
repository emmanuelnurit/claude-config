#!/bin/bash
# Backup current Claude Code configuration to this repository
# Usage: ./scripts/backup.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
CLAUDE_DIR="$HOME/.claude"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║       Claude Code Configuration Backup                   ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

# Backup agents
if [[ -d "$CLAUDE_DIR/agents" ]]; then
    print_status "Backing up agents..."
    rm -rf "$REPO_DIR/agents"
    cp -R "$CLAUDE_DIR/agents" "$REPO_DIR/"
    print_success "Agents backed up"
fi

# Backup skills
if [[ -d "$CLAUDE_DIR/skills" ]]; then
    print_status "Backing up skills..."
    rm -rf "$REPO_DIR/skills"
    cp -R "$CLAUDE_DIR/skills" "$REPO_DIR/"
    print_success "Skills backed up"
fi

# Backup commands
if [[ -d "$CLAUDE_DIR/commands" ]]; then
    print_status "Backing up commands..."
    rm -rf "$REPO_DIR/commands"
    cp -R "$CLAUDE_DIR/commands" "$REPO_DIR/"
    print_success "Commands backed up"
fi

# Backup settings
print_status "Backing up settings..."
mkdir -p "$REPO_DIR/settings"

if [[ -f "$CLAUDE_DIR/settings.json" ]]; then
    cp "$CLAUDE_DIR/settings.json" "$REPO_DIR/settings/"
fi

if [[ -f "$CLAUDE_DIR/tresor.config.json" ]]; then
    cp "$CLAUDE_DIR/tresor.config.json" "$REPO_DIR/settings/"
fi

if [[ -f "$CLAUDE_DIR/plugins/installed_plugins.json" ]]; then
    cp "$CLAUDE_DIR/plugins/installed_plugins.json" "$REPO_DIR/settings/"
fi

print_success "Settings backed up"

# Backup tresor
if [[ -d "$CLAUDE_DIR/tresor" ]]; then
    print_status "Backing up tresor..."
    rm -rf "$REPO_DIR/tresor"
    cp -R "$CLAUDE_DIR/tresor" "$REPO_DIR/"
    print_success "Tresor backed up"
fi

if [[ -d "$CLAUDE_DIR/tresor-resources" ]]; then
    print_status "Backing up tresor-resources..."
    rm -rf "$REPO_DIR/tresor-resources"
    cp -R "$CLAUDE_DIR/tresor-resources" "$REPO_DIR/"
    print_success "Tresor-resources backed up"
fi

echo ""
print_success "Backup complete!"
echo ""
print_status "Don't forget to commit your changes:"
echo "  cd $REPO_DIR"
echo "  git add -A"
echo "  git commit -m \"chore: backup claude config $(date +%Y-%m-%d)\""
echo "  git push"
