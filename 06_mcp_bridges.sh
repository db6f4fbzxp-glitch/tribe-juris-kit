#!/bin/bash
# ============================================================================
# TRIBE JURIS KIT — STEP 06 — MCP BRIDGES + CHROME ARM
# ============================================================================
# Wires AgentMemory into every AI tool you use on this Mac so they all share
# the same memory. Sets up Cowork's Chrome arm via the Claude in Chrome
# extension for browser-driven research (JEDS, county recorders, gov sites).
#
# What this script does:
#   1. Detects which Claude clients are installed (Claude Desktop, Cowork,
#      Claude Code)
#   2. Adds the agentmemory MCP server to each one's config file
#   3. Backs up any existing config before modifying
#   4. Prints Chrome extension install instructions (manual — Chrome
#      extensions can only be installed by the user clicking through
#      Chrome Web Store)
#   5. Tells you how to restart each client to load the new MCP
#
# Prerequisite: Step 03 complete (AgentMemory running on port 3111)
#
# Run:
#   bash ~/Documents/TRIBE_JURIS_KIT/06_mcp_bridges.sh
# ============================================================================

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

echo ""
echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}  ${BOLD}TRIBE JURIS KIT — STEP 06 — MCP + CHROME${NC}             ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  Wire AgentMemory into every AI tool                 ${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"
echo ""

# --------------------------------------------------------------------------
# 0. VERIFY AGENTMEMORY IS RUNNING
# --------------------------------------------------------------------------
echo -e "${BOLD}[0/4] Verifying AgentMemory is running${NC}"
if curl -s --connect-timeout 2 http://127.0.0.1:3111/agentmemory/health >/dev/null 2>&1; then
    echo -e "  ${GREEN}✓ AgentMemory healthy on port 3111${NC}"
else
    echo -e "  ${RED}✗ AgentMemory not running on port 3111. Run Step 03 first.${NC}"
    exit 1
fi
echo ""

# --------------------------------------------------------------------------
# Helper: add agentmemory MCP entry to any JSON config file (Python inline)
# --------------------------------------------------------------------------
add_agentmemory_mcp() {
    local CONFIG_PATH="$1"
    local CLIENT_NAME="$2"

    # Backup existing config if present
    if [ -f "$CONFIG_PATH" ]; then
        BACKUP="${CONFIG_PATH}.backup_$(date +%Y%m%d_%H%M%S)"
        cp "$CONFIG_PATH" "$BACKUP"
        echo -e "    ${CYAN}→ Backed up existing config to: ${BACKUP##*/}${NC}"
    fi

    # Ensure parent directory exists
    mkdir -p "$(dirname "$CONFIG_PATH")"

    # Use python3 to safely add/update the agentmemory entry without
    # nuking any other MCP servers the user may have configured
    python3 - "$CONFIG_PATH" <<'PYEOF'
import json, sys, pathlib
path = pathlib.Path(sys.argv[1])
data = {}
if path.exists():
    try:
        data = json.loads(path.read_text() or "{}")
    except json.JSONDecodeError:
        print("    ⚠ existing config wasn't valid JSON — starting fresh", file=sys.stderr)
        data = {}

data.setdefault("mcpServers", {})
data["mcpServers"]["agentmemory"] = {
    "command": "npx",
    "args": ["-y", "agentmemory-mcp"]
}
path.write_text(json.dumps(data, indent=2))
print(f"    ✓ Wrote agentmemory MCP entry")
PYEOF
}

# --------------------------------------------------------------------------
# 1. CLAUDE DESKTOP
# --------------------------------------------------------------------------
echo -e "${BOLD}[1/4] Claude Desktop${NC}"
CLAUDE_DESKTOP_CFG="$HOME/Library/Application Support/Claude/claude_desktop_config.json"
if [ -d "/Applications/Claude.app" ] || [ -f "$CLAUDE_DESKTOP_CFG" ]; then
    echo -e "  ${GREEN}✓ Claude Desktop detected${NC}"
    echo -e "    Config: $CLAUDE_DESKTOP_CFG"
    add_agentmemory_mcp "$CLAUDE_DESKTOP_CFG" "Claude Desktop"
    echo -e "    ${YELLOW}→ Quit Claude Desktop fully (Cmd+Q) and reopen to load the MCP${NC}"
else
    echo -e "  ${YELLOW}⊘ Claude Desktop not installed — skipping${NC}"
fi
echo ""

# --------------------------------------------------------------------------
# 2. COWORK
# --------------------------------------------------------------------------
# Cowork shares Claude Desktop's MCP config path on macOS (same Claude binary
# under the hood). If Cowork uses a different path on your machine, the same
# config we just wrote covers both.
echo -e "${BOLD}[2/4] Cowork (Claude desktop app)${NC}"
echo -e "  ${CYAN}Cowork reads the same MCP config as Claude Desktop above.${NC}"
echo -e "  ${GREEN}✓ Already wired by Step 1${NC}"
echo -e "    ${YELLOW}→ If Cowork is running, fully quit it (Cmd+Q) and reopen${NC}"
echo ""

# --------------------------------------------------------------------------
# 3. CLAUDE CODE (if installed)
# --------------------------------------------------------------------------
echo -e "${BOLD}[3/4] Claude Code${NC}"
CLAUDE_CODE_CFG="$HOME/.claude.json"
if command -v claude &>/dev/null || [ -f "$CLAUDE_CODE_CFG" ]; then
    echo -e "  ${GREEN}✓ Claude Code detected${NC}"
    echo -e "    Config: $CLAUDE_CODE_CFG"
    add_agentmemory_mcp "$CLAUDE_CODE_CFG" "Claude Code"
    echo -e "    ${YELLOW}→ Restart any active Claude Code session to load the MCP${NC}"
    echo ""
    echo -e "    ${CYAN}OPTIONAL: install the full agentmemory plugin for hooks/skills/MCP at once:${NC}"
    echo -e "    ${CYAN}  In a Claude Code session run:${NC}"
    echo -e "    ${CYAN}    /plugin marketplace add rohitg00/agentmemory${NC}"
    echo -e "    ${CYAN}    /plugin install agentmemory${NC}"
    echo -e "    ${CYAN}  That gets you 12 hooks, 4 slash commands (/recall /remember /session-history /forget),${NC}"
    echo -e "    ${CYAN}  and 41 MCP tools — auto-capture of your coding work into MEMORY.${NC}"
else
    echo -e "  ${YELLOW}⊘ Claude Code not installed — skipping${NC}"
    echo -e "    ${CYAN}  (Install later from claude.ai/code if you want the hooks/skills pipeline)${NC}"
fi
echo ""

# --------------------------------------------------------------------------
# 4. CLAUDE IN CHROME EXTENSION (manual — must click through Chrome Web Store)
# --------------------------------------------------------------------------
echo -e "${BOLD}[4/4] Claude in Chrome — COWORK's browser arm${NC}"
echo -e "  ${CYAN}Chrome extensions cannot be installed via script — Chrome blocks it.${NC}"
echo -e "  ${CYAN}You install it manually (2 minutes):${NC}"
echo ""
echo -e "  ${BOLD}1.${NC} Open Chrome on this Mac (or open Chrome from any browser):"
echo -e "       ${YELLOW}https://claude.ai/chrome${NC}"
echo ""
echo -e "  ${BOLD}2.${NC} Click ${BOLD}Add to Chrome${NC} → confirm in the popup."
echo ""
echo -e "  ${BOLD}3.${NC} Sign in with your Claude account (same login as Cowork)."
echo ""
echo -e "  ${BOLD}4.${NC} The extension icon appears in Chrome's toolbar."
echo -e "       Click it once to verify it connects to your Claude account."
echo ""
echo -e "  ${BOLD}What this gives you:${NC}"
echo -e "    - COWORK can drive any Chrome tab on demand"
echo -e "    - Pull court dockets from JEDS"
echo -e "    - Scrape county recorder pages"
echo -e "    - Fill forms and submit on your behalf (after you confirm)"
echo -e "    - Read web content into your work without copy-paste"
echo -e "    - Screenshot evidence with one command"
echo ""
echo -e "  ${CYAN}The Chrome arm uses your same Claude subscription / API — no extra setup.${NC}"
echo ""

# --------------------------------------------------------------------------
# DONE
# --------------------------------------------------------------------------
echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}  ${BOLD}STEP 06 COMPLETE${NC}                                    ${CYAN}║${NC}"
echo -e "${CYAN}╠══════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}║${NC}  AgentMemory MCP wired into:                         ${CYAN}║${NC}"
[ -f "$CLAUDE_DESKTOP_CFG" ] && echo -e "${CYAN}║${NC}    ${GREEN}✓${NC} Claude Desktop                              ${CYAN}║${NC}"
[ -f "$CLAUDE_DESKTOP_CFG" ] && echo -e "${CYAN}║${NC}    ${GREEN}✓${NC} Cowork (shares Claude Desktop config)        ${CYAN}║${NC}"
[ -f "$CLAUDE_CODE_CFG" ] && echo -e "${CYAN}║${NC}    ${GREEN}✓${NC} Claude Code                                  ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}                                                       ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  Chrome extension: install manually at               ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}    claude.ai/chrome                                  ${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BOLD}TEST AFTER RESTARTING YOUR CLAUDE APPS:${NC}"
echo "  In a new Cowork or Claude Desktop session, ask:"
echo "    \"Use memory_smart_search to find anything about my engine setup\""
echo "  If it returns results (or 'no memories yet, here's what I'll do'), the MCP is live."
echo ""
echo "Next: bash ~/Documents/TRIBE_JURIS_KIT/07_personalized_launcher.sh"
echo ""
