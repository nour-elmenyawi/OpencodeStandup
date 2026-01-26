#!/bin/bash
# OpenCode Standup Installation Script
# Installs the AI standup system for managing development teams

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

INSTALL_DIR="$HOME/.local/share/opencode-standup"
BIN_DIR="$HOME/.local/bin"
SKILLS_DIR="$HOME/.opencode/skills"

echo -e "${BOLD}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}║                                                        ║${NC}"
echo -e "${BOLD}║           OpenCode Standup Installer                  ║${NC}"
echo -e "${BOLD}║                                                        ║${NC}"
echo -e "${BOLD}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check dependencies
echo -e "${BLUE}Checking dependencies...${NC}"

if ! command -v opencode &> /dev/null; then
    echo -e "${RED}✗ OpenCode is not installed${NC}"
    echo ""
    echo "Please install OpenCode first:"
    echo "  curl -fsSL https://opencode.ai/install | bash"
    echo ""
    exit 1
fi
echo -e "${GREEN}  ✓ OpenCode installed${NC}"

if ! command -v git &> /dev/null; then
    echo -e "${RED}✗ Git is not installed${NC}"
    exit 1
fi
echo -e "${GREEN}  ✓ Git installed${NC}"

if ! command -v jq &> /dev/null; then
    echo -e "${YELLOW}⚠ jq not found (optional, needed for metrics)${NC}"
    echo -e "${YELLOW}  Install with: sudo apt install jq${NC}"
fi

if ! command -v gh &> /dev/null; then
    echo -e "${YELLOW}⚠ GitHub CLI not found (optional, needed for PR features)${NC}"
    echo -e "${YELLOW}  Install with: sudo apt install gh${NC}"
fi

echo ""

# Detect OS and terminal emulator
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ -f "/proc/version" ]] && grep -qi "microsoft" /proc/version 2>/dev/null; then
        echo "wsl"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    else
        echo "unknown"
    fi
}

OS=$(detect_os)

case "$OS" in
    wsl)
        if command -v wt.exe &> /dev/null; then
            echo -e "${GREEN}  ✓ Windows Terminal detected (WSL)${NC}"
        else
            echo -e "${YELLOW}⚠ Windows Terminal not detected${NC}"
            echo -e "${YELLOW}  Automatic terminal launching may not work${NC}"
        fi
        ;;
    macos)
        if [[ -d "/Applications/iTerm.app" ]]; then
            echo -e "${GREEN}  ✓ iTerm2 detected${NC}"
        elif [[ -d "/Applications/Utilities/Terminal.app" ]]; then
            echo -e "${GREEN}  ✓ Terminal.app detected${NC}"
        else
            echo -e "${YELLOW}⚠ No terminal emulator detected${NC}"
        fi
        ;;
    linux)
        if command -v gnome-terminal &> /dev/null; then
            echo -e "${GREEN}  ✓ GNOME Terminal detected${NC}"
        elif command -v konsole &> /dev/null; then
            echo -e "${GREEN}  ✓ Konsole detected${NC}"
        elif command -v xterm &> /dev/null; then
            echo -e "${GREEN}  ✓ xterm detected${NC}"
        else
            echo -e "${YELLOW}⚠ No supported terminal emulator found${NC}"
            echo -e "${YELLOW}  Install: gnome-terminal, konsole, or xterm${NC}"
        fi
        ;;
    *)
        echo -e "${YELLOW}⚠ Unknown operating system${NC}"
        ;;
esac

echo ""

# Create directories
echo -e "${BLUE}Creating directories...${NC}"
mkdir -p "$INSTALL_DIR"
mkdir -p "$BIN_DIR"
mkdir -p "$SKILLS_DIR"
echo -e "${GREEN}  ✓ Directories created${NC}"

# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install skills
echo ""
echo -e "${BLUE}Installing OpenCode skills...${NC}"

SKILLS_UPDATED=0

for skill in architect developer qa-engineer code-reviewer; do
    skill_path="$SKILLS_DIR/$skill"
    
    if [[ -f "$skill_path/SKILL.md" ]]; then
        # Skill exists, check if we should update
        echo -e "${YELLOW}  • $skill skill already exists${NC}"
        
        # Compare files
        if ! diff -q "$SCRIPT_DIR/skills/$skill/SKILL.md" "$skill_path/SKILL.md" &> /dev/null; then
            echo -e "${YELLOW}    Skill has been updated. Update? (y/N)${NC}"
            read -r response
            if [[ "$response" =~ ^[Yy]$ ]]; then
                cp "$SCRIPT_DIR/skills/$skill/SKILL.md" "$skill_path/SKILL.md"
                echo -e "${GREEN}    ✓ Updated $skill skill${NC}"
                SKILLS_UPDATED=$((SKILLS_UPDATED + 1))
            else
                echo -e "${BLUE}    → Keeping existing $skill skill${NC}"
            fi
        else
            echo -e "${BLUE}    → Already up to date${NC}"
        fi
    else
        # New skill installation
        mkdir -p "$skill_path"
        cp "$SCRIPT_DIR/skills/$skill/SKILL.md" "$skill_path/SKILL.md"
        echo -e "${GREEN}  ✓ Installed $skill skill${NC}"
        SKILLS_UPDATED=$((SKILLS_UPDATED + 1))
    fi
done

# Install scripts
echo ""
echo -e "${BLUE}Installing scripts...${NC}"

for script in standup standup-metrics standup-pr-status standup-summary; do
    cp "$SCRIPT_DIR/bin/$script" "$BIN_DIR/$script"
    chmod +x "$BIN_DIR/$script"
    echo -e "${GREEN}  ✓ Installed $script${NC}"
done

# Check if BIN_DIR is in PATH
echo ""
echo -e "${BLUE}Checking PATH configuration...${NC}"

if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    echo -e "${YELLOW}⚠ $BIN_DIR is not in your PATH${NC}"
    echo ""
    echo "Add the following line to your shell configuration file:"
    echo ""
    
    if [[ "$SHELL" == *"zsh"* ]]; then
        echo -e "${BOLD}  ~/.zshrc${NC}"
        echo ""
        echo '  export PATH="$HOME/.local/bin:$PATH"'
    elif [[ "$SHELL" == *"bash"* ]]; then
        echo -e "${BOLD}  ~/.bashrc${NC}"
        echo ""
        echo '  export PATH="$HOME/.local/bin:$PATH"'
    else
        echo -e "${BOLD}  Your shell configuration file${NC}"
        echo ""
        echo '  export PATH="$HOME/.local/bin:$PATH"'
    fi
    
    echo ""
    echo "Then restart your terminal or run:"
    if [[ "$SHELL" == *"zsh"* ]]; then
        echo "  source ~/.zshrc"
    elif [[ "$SHELL" == *"bash"* ]]; then
        echo "  source ~/.bashrc"
    fi
    echo ""
else
    echo -e "${GREEN}  ✓ PATH is configured correctly${NC}"
fi

# Installation complete
echo ""
echo -e "${GREEN}${BOLD}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}${BOLD}║                                                        ║${NC}"
echo -e "${GREEN}${BOLD}║        Installation Complete! 🎉                      ║${NC}"
echo -e "${GREEN}${BOLD}║                                                        ║${NC}"
echo -e "${GREEN}${BOLD}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

if [[ $SKILLS_UPDATED -gt 0 ]]; then
    echo -e "${GREEN}Installed/Updated $SKILLS_UPDATED skill(s)${NC}"
    echo ""
fi

echo -e "${BOLD}Quick Start:${NC}"
echo ""
echo "  1. Navigate to any Git repository:"
echo -e "     ${BLUE}cd ~/my-project${NC}"
echo ""
echo "  2. Launch your AI standup team:"
echo -e "     ${BLUE}standup${NC}"
echo ""
echo "  3. Interact with each agent in their terminal windows"
echo ""
echo -e "${BOLD}Additional Commands:${NC}"
echo ""
echo -e "  ${BLUE}standup-metrics${NC}     - View team performance metrics"
echo -e "  ${BLUE}standup-summary${NC}     - Generate daily summary report"
echo -e "  ${BLUE}standup-pr-status${NC}   - Check PR status (requires gh CLI)"
echo ""
echo -e "${BOLD}Documentation:${NC}"
echo "  https://github.com/yourusername/opencode-standup"
echo ""
echo -e "${YELLOW}Note: Each project will have its own .standup/ directory${NC}"
echo -e "${YELLOW}      Add .standup/ to your .gitignore${NC}"
echo ""
