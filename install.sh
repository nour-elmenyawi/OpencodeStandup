#!/usr/bin/env bash
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
SKILLS_DIR="$HOME/.config/opencode/skills"

echo -e "${BOLD}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}║                                                        ║${NC}"
echo -e "${BOLD}║           OpenCode Standup Installer                  ║${NC}"
echo -e "${BOLD}║                                                        ║${NC}"
echo -e "${BOLD}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check dependencies
echo -e "${BLUE}Checking dependencies...${NC}"

# Check Bash version
if ((BASH_VERSINFO[0] < 4)); then
    echo -e "${RED}✗ Bash 4.0 or higher is required (you have $BASH_VERSION)${NC}"
    echo ""
    case "$OS" in
        macos)
            echo "Install with:"
            echo "  brew install bash"
            echo ""
            echo "Then add to your ~/.zshrc or ~/.bashrc:"
            echo '  export PATH="/opt/homebrew/bin:$PATH"'
            ;;
        *)
            echo "Install with:"
            echo "  sudo apt install bash"
            ;;
    esac
    echo ""
    exit 1
fi
echo -e "${GREEN}  ✓ Bash $BASH_VERSION${NC}"

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

if ! command -v tmux &> /dev/null; then
    echo -e "${RED}✗ tmux is not installed${NC}"
    case "$OS" in
        macos)
            echo -e "${YELLOW}  Install with: brew install tmux${NC}"
            ;;
        *)
            echo -e "${YELLOW}  Install with: sudo apt install tmux${NC}"
            ;;
    esac
    exit 1
fi
echo -e "${GREEN}  ✓ tmux installed${NC}"

if ! command -v jq &> /dev/null; then
    echo -e "${YELLOW}⚠ jq not found (optional, needed for metrics)${NC}"
    case "$OS" in
        macos)
            echo -e "${YELLOW}  Install with: brew install jq${NC}"
            ;;
        *)
            echo -e "${YELLOW}  Install with: sudo apt install jq${NC}"
            ;;
    esac
fi

if ! command -v gh &> /dev/null; then
    echo -e "${YELLOW}⚠ GitHub CLI not found (optional, needed for PR features)${NC}"
    case "$OS" in
        macos)
            echo -e "${YELLOW}  Install with: brew install gh${NC}"
            ;;
        *)
            echo -e "${YELLOW}  Install with: sudo apt install gh${NC}"
            ;;
    esac
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
        elif [[ -d "/System/Applications/Utilities/Terminal.app" ]] || [[ -d "/Applications/Utilities/Terminal.app" ]]; then
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

for script in standup standup-shutdown standup-metrics standup-pr-status standup-summary; do
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
    
    # Determine shell config file
    SHELL_CONFIG=""
    if [[ "$SHELL" == *"zsh"* ]]; then
        SHELL_CONFIG="$HOME/.zshrc"
    elif [[ "$SHELL" == *"bash"* ]]; then
        SHELL_CONFIG="$HOME/.bashrc"
    fi
    
    if [[ -n "$SHELL_CONFIG" ]]; then
        echo -e "Would you like to automatically add $BIN_DIR to your PATH? (y/N)"
        read -r response
        
        if [[ "$response" =~ ^[Yy]$ ]]; then
            # Check if PATH export already exists in the file
            if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$SHELL_CONFIG" 2>/dev/null && \
               ! grep -q 'export PATH="\$HOME/.local/bin:\$PATH"' "$SHELL_CONFIG" 2>/dev/null; then
                echo "" >> "$SHELL_CONFIG"
                echo '# Added by opencode-standup installer' >> "$SHELL_CONFIG"
                echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$SHELL_CONFIG"
                echo -e "${GREEN}  ✓ Added PATH configuration to $SHELL_CONFIG${NC}"
                echo ""
                echo -e "${YELLOW}Run this command to apply the changes:${NC}"
                if [[ "$SHELL" == *"zsh"* ]]; then
                    echo "  source ~/.zshrc"
                else
                    echo "  source ~/.bashrc"
                fi
            else
                echo -e "${BLUE}  → PATH export already exists in $SHELL_CONFIG${NC}"
            fi
        else
            echo "Add the following line to your shell configuration file:"
            echo ""
            echo -e "${BOLD}  $(basename "$SHELL_CONFIG")${NC}"
            echo ""
            echo '  export PATH="$HOME/.local/bin:$PATH"'
            echo ""
            echo "Then restart your terminal or run:"
            if [[ "$SHELL" == *"zsh"* ]]; then
                echo "  source ~/.zshrc"
            else
                echo "  source ~/.bashrc"
            fi
        fi
    else
        echo "Add the following line to your shell configuration file:"
        echo ""
        echo '  export PATH="$HOME/.local/bin:$PATH"'
        echo ""
        echo "Then restart your terminal"
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
echo "  3. Interact with each role in the tmux panes"
echo ""
echo -e "${BOLD}Additional Commands:${NC}"
echo ""
echo -e "  ${BLUE}standup-shutdown${NC}    - Gracefully end session with summaries"
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