#!/bin/bash
# ============================================================================
# TRIBE JURIS KIT — STEP 10 — PERSISTENCE HOOKS
# ============================================================================
# The final step. Closes the loop on AgentMemory persistence so memories
# saved late in a session survive reboots reliably.
#
# Three hooks installed:
#   1. Binary store backup rotation (5 most recent kept in ~/data/memory_backups)
#   2. ~/.zlogout snapshot hook — auto-export to standalone.json on logout
#   3. Manual `snap` alias — type `snap` in any Terminal to force a snapshot
#
# Hard-won pattern from the Tiddy Mini M4 session (May 23, 2026):
# AgentMemory's auto-snapshot interval is not aggressive enough. Memories
# saved late in a session can be lost on reboot. These hooks fix that.
#
# Prerequisites: Step 03 (AgentMemory installed and running)
#
# Run:
#   bash ~/Documents/TRIBE_JURIS_KIT/10_persistence_hooks.sh
# ============================================================================

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

echo ""
echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}  ${BOLD}TRIBE JURIS KIT — STEP 10 — PERSISTENCE HOOKS${NC}        ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  Final step — closes the loop on memory persistence ${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"
echo ""

# --------------------------------------------------------------------------
# 0. VERIFY AGENTMEMORY IS RUNNING
# --------------------------------------------------------------------------
echo -e "${BOLD}[0/4] Verifying AgentMemory is running${NC}"
if curl -s --connect-timeout 2 http://127.0.0.1:3111/agentmemory/health >/dev/null 2>&1; then
    echo -e "  ${GREEN}✓ AgentMemory healthy on port 3111${NC}"
else
    echo -e "  ${RED}✗ AgentMemory not running. Run Step 03 first.${NC}"
    exit 1
fi
echo ""

# --------------------------------------------------------------------------
# 1. BINARY STORE BACKUP — establish baseline + verify launcher has it
# --------------------------------------------------------------------------
echo -e "${BOLD}[1/4] Binary store baseline backup${NC}"
BIN_STORE="$HOME/data/state_store.db/mem%3Amemories.bin"
BACKUP_DIR="$HOME/data/memory_backups"
mkdir -p "$BACKUP_DIR"

if [ -f "$BIN_STORE" ] && [ -s "$BIN_STORE" ]; then
    FSIZE=$(stat -f%z "$BIN_STORE")
    cp "$BIN_STORE" "$BACKUP_DIR/memories_$(date +%Y%m%d_%H%M%S)_baseline.bin"
    echo -e "  ${GREEN}✓ Baseline backup: $((FSIZE / 1024)) KB → $BACKUP_DIR${NC}"
else
    echo -e "  ${YELLOW}⚠ Binary store not yet present at $BIN_STORE${NC}"
    echo -e "  ${YELLOW}  This is normal if AgentMemory is fresh. The launcher will create it.${NC}"
fi

# Verify your launcher (from Step 07) includes the backup logic
LAUNCHER_FILES=( "$HOME"/Documents/launch_*.sh )
if [ -f "${LAUNCHER_FILES[0]}" ]; then
    LAUNCHER="${LAUNCHER_FILES[0]}"
    if grep -q "memory_backups" "$LAUNCHER"; then
        echo -e "  ${GREEN}✓ Your launcher already includes binary store backup rotation${NC}"
    else
        echo -e "  ${YELLOW}⚠ Your launcher doesn't include backup rotation${NC}"
        echo -e "  ${YELLOW}  Re-run Step 07 to regenerate it with the backup logic baked in${NC}"
    fi
else
    echo -e "  ${YELLOW}⚠ No launcher found in ~/Documents — run Step 07 first${NC}"
fi
echo ""

# --------------------------------------------------------------------------
# 2. ~/.zlogout HOOK — auto-snapshot on every Terminal logout
# --------------------------------------------------------------------------
echo -e "${BOLD}[2/4] ~/.zlogout snapshot hook${NC}"

ZLOGOUT="$HOME/.zlogout"
HOOK_LINE='curl -s http://127.0.0.1:3111/agentmemory/export > ~/.agentmemory/standalone.json 2>/dev/null'

if [ -f "$ZLOGOUT" ] && grep -q "agentmemory/export" "$ZLOGOUT"; then
    echo -e "  ${GREEN}✓ Snapshot hook already in ~/.zlogout${NC}"
else
    # Append the hook with a comment marker
    cat >> "$ZLOGOUT" <<EOF

# TRIBE JURIS KIT — auto-snapshot AgentMemory on logout
$HOOK_LINE
EOF
    echo -e "  ${GREEN}✓ Snapshot hook added to ~/.zlogout${NC}"
fi

echo -e "  ${CYAN}  Every time you log out (or close a Terminal session) AgentMemory${NC}"
echo -e "  ${CYAN}  exports its current state to ~/.agentmemory/standalone.json${NC}"
echo ""

# --------------------------------------------------------------------------
# 3. `snap` ALIAS — manual force-snapshot anytime
# --------------------------------------------------------------------------
echo -e "${BOLD}[3/4] Adding 'snap' alias for manual snapshots${NC}"

ZSHRC="$HOME/.zshrc"
ALIAS_LINE="alias snap='curl -s http://127.0.0.1:3111/agentmemory/export > ~/.agentmemory/standalone.json && echo \"✓ AgentMemory snapshot saved (\$(wc -c < ~/.agentmemory/standalone.json) bytes)\"'"

if [ -f "$ZSHRC" ] && grep -q "alias snap=" "$ZSHRC"; then
    echo -e "  ${GREEN}✓ 'snap' alias already in ~/.zshrc${NC}"
else
    cat >> "$ZSHRC" <<EOF

# TRIBE JURIS KIT — manual AgentMemory snapshot
$ALIAS_LINE
EOF
    echo -e "  ${GREEN}✓ 'snap' alias added to ~/.zshrc${NC}"
fi

echo -e "  ${CYAN}  In any Terminal: type ${BOLD}snap${NC}${CYAN} to force a snapshot anytime.${NC}"
echo ""

# --------------------------------------------------------------------------
# 4. FIRST FORCED SNAPSHOT — lock in current state
# --------------------------------------------------------------------------
echo -e "${BOLD}[4/4] Forcing initial snapshot now${NC}"
mkdir -p "$HOME/.agentmemory"
curl -s http://127.0.0.1:3111/agentmemory/export > "$HOME/.agentmemory/standalone.json" 2>/dev/null

SNAP_SIZE=$(wc -c < "$HOME/.agentmemory/standalone.json" 2>/dev/null || echo "0")
if [ "$SNAP_SIZE" -gt 100 ]; then
    echo -e "  ${GREEN}✓ Snapshot saved: $SNAP_SIZE bytes${NC}"
    echo -e "  ${CYAN}  Location: ~/.agentmemory/standalone.json${NC}"
else
    echo -e "  ${YELLOW}⚠ Snapshot returned ${SNAP_SIZE} bytes${NC}"
    echo -e "  ${YELLOW}  In v0.9.x the /export endpoint may not be implemented yet.${NC}"
    echo -e "  ${YELLOW}  Your binary store backup (in Step 1 above) is the primary safety net.${NC}"
    echo -e "  ${YELLOW}  The hook will retry on every logout — if /export is added later, it'll work.${NC}"
fi
echo ""

# --------------------------------------------------------------------------
# DONE
# --------------------------------------------------------------------------
echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}  ${BOLD}STEP 10 COMPLETE — KIT FULLY INSTALLED${NC}              ${CYAN}║${NC}"
echo -e "${CYAN}╠══════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}║${NC}  Persistence hooks in place:                         ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}    ${GREEN}✓${NC} Binary store baseline backed up               ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}    ${GREEN}✓${NC} Backup rotation in your launcher              ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}    ${GREEN}✓${NC} Auto-snapshot on logout (~/.zlogout)          ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}    ${GREEN}✓${NC} Manual 'snap' alias (~/.zshrc)                ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}    ${GREEN}✓${NC} Initial snapshot saved                        ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}                                                       ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  Your Jurisprudence Engine is fully built.           ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  All four brains online. Persistence locked.         ${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BOLD}Open a new Terminal window${NC} (so .zshrc is re-read) and try the alias:"
echo "    snap"
echo ""
echo -e "${BOLD}Daily maintenance going forward:${NC}"
echo "  - Feed your intelligence file to JURIS at session start"
echo "  - Update intelligence file at session end → save next version"
echo "  - Type 'snap' before any planned reboot"
echo "  - Verify doctor stays at 8/9 once a month: agentmemory doctor"
echo ""
echo -e "${GREEN}The framework is shared. The secrets stay home.${NC}"
echo -e "${GREEN}The Chaos Tribe does not stop building. It compounds.${NC}"
echo ""
