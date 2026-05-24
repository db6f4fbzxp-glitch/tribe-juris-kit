#!/bin/bash
# ============================================================================
# TRIBE JURIS KIT — STEP 02 — STACK PREREQUISITES
# ============================================================================
# Installs the four foundational pieces every tribe JURIS engine needs:
#   1. Homebrew (Mac package manager)
#   2. Node.js 20+ (runs AgentMemory and friends)
#   3. iii-engine (AgentMemory's runtime layer)
#   4. Ollama (local model server — lean, just for embeddings)
#
# DESIGN NOTES:
#   - Idempotent: re-running this is safe. Each step checks what's already
#     installed and skips it. Run it 100 times — same result.
#   - BSD-safe: no GNU command flags (per TRIBE JURIS KIT Sacred Rule #3).
#   - Discovery-first: detects available external drives for Ollama models.
#   - Interactive where needed, automated where not.
#
# Run:
#   bash ~/Documents/TRIBE_JURIS_KIT/02_stack_prereqs.sh
# ============================================================================

# NOTE: No `set -e`. We want to continue past non-fatal "already installed"
# states. Each section handles its own errors.

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

echo ""
echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}  ${BOLD}TRIBE JURIS KIT — STEP 02 — STACK PREREQS${NC}            ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  Homebrew → Node 20 → iii-engine → Ollama            ${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"
echo ""

# --------------------------------------------------------------------------
# 0. ARCHITECTURE & PLATFORM CHECK
# --------------------------------------------------------------------------
echo -e "${BOLD}[0/5] Platform check${NC}"
ARCH=$(uname -m)
OS=$(uname -s)
if [ "$OS" != "Darwin" ]; then
    echo -e "  ${RED}✗ This script is for macOS only. Detected: $OS. Aborting.${NC}"
    exit 1
fi
echo -e "  ${GREEN}✓ macOS detected (architecture: $ARCH)${NC}"
if [ "$ARCH" != "arm64" ]; then
    echo -e "  ${YELLOW}⚠ Apple Silicon (arm64) is recommended. You have $ARCH.${NC}"
    echo -e "  ${YELLOW}  The stack will work, just slower. Continue.${NC}"
fi
echo ""

# --------------------------------------------------------------------------
# 1. HOMEBREW
# --------------------------------------------------------------------------
echo -e "${BOLD}[1/5] Homebrew (Mac package manager)${NC}"
if command -v brew &>/dev/null; then
    BREW_VERSION=$(brew --version | head -1)
    echo -e "  ${GREEN}✓ Homebrew already installed — $BREW_VERSION${NC}"
else
    echo -e "  ${YELLOW}→ Installing Homebrew...${NC}"
    echo -e "  ${YELLOW}  (You'll be prompted for your Mac password.)${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Add brew to PATH for the current shell (and inform user how to make permanent)
    if [ -d /opt/homebrew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        echo -e "  ${GREEN}✓ Homebrew installed at /opt/homebrew${NC}"
        echo -e "  ${YELLOW}  Add this to your ~/.zshrc to make it permanent:${NC}"
        echo -e "  ${YELLOW}    eval \"\$(/opt/homebrew/bin/brew shellenv)\"${NC}"
    elif [ -d /usr/local/Homebrew ]; then
        eval "$(/usr/local/bin/brew shellenv)"
        echo -e "  ${GREEN}✓ Homebrew installed at /usr/local${NC}"
    else
        echo -e "  ${RED}✗ Homebrew install failed. Aborting.${NC}"
        exit 1
    fi
fi
echo ""

# --------------------------------------------------------------------------
# 2. NODE.JS 20+
# --------------------------------------------------------------------------
echo -e "${BOLD}[2/5] Node.js 20+ (for AgentMemory)${NC}"
NEED_NODE_INSTALL=0
if command -v node &>/dev/null; then
    NODE_VERSION=$(node --version | sed 's/v//')
    NODE_MAJOR=$(echo "$NODE_VERSION" | cut -d. -f1)
    if [ "$NODE_MAJOR" -ge 20 ]; then
        echo -e "  ${GREEN}✓ Node.js v$NODE_VERSION already installed (>= 20)${NC}"
    else
        echo -e "  ${YELLOW}⚠ Node.js v$NODE_VERSION installed but < 20. Upgrading.${NC}"
        NEED_NODE_INSTALL=1
    fi
else
    echo -e "  ${YELLOW}→ Node.js not found. Installing v20.${NC}"
    NEED_NODE_INSTALL=1
fi

if [ "$NEED_NODE_INSTALL" = "1" ]; then
    brew install node@20
    # node@20 is keg-only — link it explicitly
    brew link --overwrite --force node@20 2>/dev/null || true
    NODE_VERSION=$(node --version | sed 's/v//')
    echo -e "  ${GREEN}✓ Node.js v$NODE_VERSION installed${NC}"
fi
echo ""

# --------------------------------------------------------------------------
# 3. EXTERNAL DRIVE DETECTION (for Ollama models)
# --------------------------------------------------------------------------
echo -e "${BOLD}[3/5] External drive detection${NC}"
echo -e "  ${CYAN}Ollama models can be large (274 MB for nomic-embed-text).${NC}"
echo -e "  ${CYAN}Storing them on an external drive keeps your main drive lean.${NC}"
echo ""

# List volumes that aren't the system drive or Time Machine
AVAILABLE_VOLUMES=$(ls /Volumes/ 2>/dev/null | grep -v "^Macintosh HD$" | grep -v "^com.apple" | grep -v "Backups.backupdb")

if [ -z "$AVAILABLE_VOLUMES" ]; then
    echo -e "  ${YELLOW}⚠ No external drives detected.${NC}"
    echo -e "  ${YELLOW}  Ollama models will go to default location: ~/.ollama/models${NC}"
    OLLAMA_MODELS_PATH="$HOME/.ollama/models"
else
    echo -e "  ${GREEN}Available external volumes:${NC}"
    i=1
    declare -a VOLUMES
    while IFS= read -r vol; do
        VOLUMES[$i]="$vol"
        SIZE=$(df -h "/Volumes/$vol" 2>/dev/null | tail -1 | awk '{print $4}')
        echo -e "    $i) $vol  (${SIZE} free)"
        i=$((i + 1))
    done <<< "$AVAILABLE_VOLUMES"
    echo -e "    0) Use default (~/.ollama/models on main drive)"
    echo ""
    printf "  Pick a volume for Ollama models [0-$((i-1))]: "
    read VOL_CHOICE
    if [ "$VOL_CHOICE" = "0" ] || [ -z "$VOL_CHOICE" ]; then
        OLLAMA_MODELS_PATH="$HOME/.ollama/models"
    else
        CHOSEN="${VOLUMES[$VOL_CHOICE]}"
        if [ -z "$CHOSEN" ]; then
            echo -e "  ${YELLOW}⚠ Invalid choice. Using default.${NC}"
            OLLAMA_MODELS_PATH="$HOME/.ollama/models"
        else
            OLLAMA_MODELS_PATH="/Volumes/$CHOSEN/ollama_models"
            mkdir -p "$OLLAMA_MODELS_PATH"
            echo -e "  ${GREEN}✓ Ollama models will live at: $OLLAMA_MODELS_PATH${NC}"
        fi
    fi
fi

# Persist OLLAMA_MODELS_PATH choice for Step 03 to read
echo "$OLLAMA_MODELS_PATH" > ~/.tribe_juris_kit_ollama_path
echo -e "  ${CYAN}  Saved to ~/.tribe_juris_kit_ollama_path (Step 03 will read this)${NC}"
echo ""

# --------------------------------------------------------------------------
# 4. OLLAMA
# --------------------------------------------------------------------------
echo -e "${BOLD}[4/5] Ollama (local model server)${NC}"
if command -v ollama &>/dev/null; then
    OLLAMA_VERSION=$(ollama --version 2>&1 | head -1)
    echo -e "  ${GREEN}✓ Ollama already installed — $OLLAMA_VERSION${NC}"
else
    echo -e "  ${YELLOW}→ Installing Ollama via Homebrew...${NC}"
    brew install ollama
    OLLAMA_VERSION=$(ollama --version 2>&1 | head -1)
    echo -e "  ${GREEN}✓ Ollama installed — $OLLAMA_VERSION${NC}"
fi

# Start Ollama if not already running (Step 03 needs it for the embed pull)
if curl -s --connect-timeout 2 http://127.0.0.1:11434/api/tags >/dev/null 2>&1; then
    echo -e "  ${GREEN}✓ Ollama server already running on port 11434${NC}"
else
    echo -e "  ${YELLOW}→ Starting Ollama server in the background...${NC}"
    export OLLAMA_MODELS="$OLLAMA_MODELS_PATH"
    ollama serve &>/tmp/ollama_startup.log &
    disown
    # Wait for it
    WAITED=0
    while ! curl -s --connect-timeout 2 http://127.0.0.1:11434/api/tags >/dev/null 2>&1; do
        sleep 2
        WAITED=$((WAITED + 2))
        if [ "$WAITED" -ge 30 ]; then
            echo -e "  ${RED}✗ Ollama did not respond within 30s. Check /tmp/ollama_startup.log${NC}"
            break
        fi
    done
    if curl -s --connect-timeout 2 http://127.0.0.1:11434/api/tags >/dev/null 2>&1; then
        echo -e "  ${GREEN}✓ Ollama running (models path: $OLLAMA_MODELS_PATH)${NC}"
    fi
fi
echo ""

# --------------------------------------------------------------------------
# 5. III-ENGINE (AgentMemory's runtime layer)
# --------------------------------------------------------------------------
echo -e "${BOLD}[5/5] iii-engine (AgentMemory runtime)${NC}"
if command -v iii &>/dev/null; then
    III_VERSION=$(iii --version 2>&1 | head -1 || echo "version unknown")
    echo -e "  ${GREEN}✓ iii-engine already installed — $III_VERSION${NC}"
else
    echo -e "  ${YELLOW}→ Installing iii-engine via official installer...${NC}"
    curl -fsSL https://install.iii.dev/iii/main/install.sh | sh
    if command -v iii &>/dev/null; then
        echo -e "  ${GREEN}✓ iii-engine installed${NC}"
    else
        echo -e "  ${YELLOW}⚠ iii-engine command not on PATH yet.${NC}"
        echo -e "  ${YELLOW}  AgentMemory's npx will install it on first run if missing.${NC}"
        echo -e "  ${YELLOW}  This is fine — proceed to Step 03.${NC}"
    fi
fi
echo ""

# --------------------------------------------------------------------------
# STATUS SUMMARY
# --------------------------------------------------------------------------
echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}  ${BOLD}STEP 02 STATUS${NC}                                      ${CYAN}║${NC}"
echo -e "${CYAN}╠══════════════════════════════════════════════════════╣${NC}"
command -v brew &>/dev/null && \
    echo -e "${CYAN}║${NC}  ${GREEN}✓${NC} Homebrew      installed                          ${CYAN}║${NC}" || \
    echo -e "${CYAN}║${NC}  ${RED}✗${NC} Homebrew      MISSING                            ${CYAN}║${NC}"
command -v node &>/dev/null && \
    echo -e "${CYAN}║${NC}  ${GREEN}✓${NC} Node.js       $(node --version)                            ${CYAN}║${NC}" || \
    echo -e "${CYAN}║${NC}  ${RED}✗${NC} Node.js       MISSING                            ${CYAN}║${NC}"
command -v ollama &>/dev/null && \
    echo -e "${CYAN}║${NC}  ${GREEN}✓${NC} Ollama        installed                          ${CYAN}║${NC}" || \
    echo -e "${CYAN}║${NC}  ${RED}✗${NC} Ollama        MISSING                            ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}     Ollama models → $OLLAMA_MODELS_PATH"
echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}Step 02 complete.${NC}"
echo ""
echo "Next: bash ~/Documents/TRIBE_JURIS_KIT/03_agentmemory_install.sh"
echo ""
