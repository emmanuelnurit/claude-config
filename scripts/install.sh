#!/bin/bash
# Installation script for Claude Code configuration
# Usage: ./scripts/install.sh [--force]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
CLAUDE_DIR="$HOME/.claude"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if --force flag is passed
FORCE=false
if [[ "$1" == "--force" ]]; then
    FORCE=true
fi

echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║       Claude Code Configuration Installer                ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

# Check if Claude directory exists
if [[ ! -d "$CLAUDE_DIR" ]]; then
    print_warning "Claude directory not found. Creating $CLAUDE_DIR"
    mkdir -p "$CLAUDE_DIR"
fi

# Create backup if not forcing
if [[ "$FORCE" == false ]]; then
    BACKUP_DIR="$CLAUDE_DIR/backup_$(date +%Y%m%d_%H%M%S)"
    print_status "Creating backup at $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"

    for dir in agents skills commands; do
        if [[ -d "$CLAUDE_DIR/$dir" ]]; then
            cp -R "$CLAUDE_DIR/$dir" "$BACKUP_DIR/" 2>/dev/null || true
        fi
    done

    if [[ -f "$CLAUDE_DIR/settings.json" ]]; then
        cp "$CLAUDE_DIR/settings.json" "$BACKUP_DIR/" 2>/dev/null || true
    fi

    print_success "Backup created"
fi

# Install agents
print_status "Installing agents..."
mkdir -p "$CLAUDE_DIR/agents"
cp -R "$REPO_DIR/agents/"* "$CLAUDE_DIR/agents/" 2>/dev/null || true
print_success "Agents installed"

# Install skills
print_status "Installing skills..."
mkdir -p "$CLAUDE_DIR/skills"
cp -R "$REPO_DIR/skills/"* "$CLAUDE_DIR/skills/" 2>/dev/null || true
print_success "Skills installed"

# Install commands
print_status "Installing commands..."
mkdir -p "$CLAUDE_DIR/commands"
cp -R "$REPO_DIR/commands/"* "$CLAUDE_DIR/commands/" 2>/dev/null || true
print_success "Commands installed"

# Install settings (with confirmation)
if [[ -f "$CLAUDE_DIR/settings.json" ]] && [[ "$FORCE" == false ]]; then
    print_warning "settings.json already exists."
    read -p "Do you want to overwrite it? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cp "$REPO_DIR/settings/settings.json" "$CLAUDE_DIR/"
        print_success "settings.json installed"
    else
        print_status "Skipping settings.json"
    fi
else
    cp "$REPO_DIR/settings/settings.json" "$CLAUDE_DIR/" 2>/dev/null || true
    print_success "settings.json installed"
fi

# Install tresor config
if [[ -f "$REPO_DIR/settings/tresor.config.json" ]]; then
    cp "$REPO_DIR/settings/tresor.config.json" "$CLAUDE_DIR/" 2>/dev/null || true
    print_success "tresor.config.json installed"
fi

# Install tresor resources
if [[ -d "$REPO_DIR/tresor" ]]; then
    print_status "Installing tresor..."
    cp -R "$REPO_DIR/tresor" "$CLAUDE_DIR/" 2>/dev/null || true
    print_success "Tresor installed"
fi

if [[ -d "$REPO_DIR/tresor-resources" ]]; then
    print_status "Installing tresor-resources..."
    cp -R "$REPO_DIR/tresor-resources" "$CLAUDE_DIR/" 2>/dev/null || true
    print_success "Tresor-resources installed"
fi

echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║                 Installation Complete!                   ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""
print_status "Installed components:"
echo "  - $(ls -1 "$CLAUDE_DIR/agents"/*.md 2>/dev/null | wc -l | tr -d ' ') agents"
echo "  - $(find "$CLAUDE_DIR/skills" -name "*.md" 2>/dev/null | wc -l | tr -d ' ') skills"
echo "  - $(ls -1 "$CLAUDE_DIR/commands"/*.md 2>/dev/null | wc -l | tr -d ' ') commands"
echo ""
print_status "Recommended plugins to install:"
echo "  claude plugin install superpowers@superpowers-dev"
echo "  claude plugin install context7@claude-plugins-official"
echo "  claude plugin install playwright@claude-plugins-official"
echo "  claude plugin install serena@claude-plugins-official"
echo ""
print_success "Done! Restart Claude Code to apply changes."
