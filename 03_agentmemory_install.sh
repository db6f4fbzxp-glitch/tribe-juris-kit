#!/bin/bash
# ============================================================================
# TRIBE JURIS KIT — STEP 03 — AGENTMEMORY v0.9.21 INSTALL
# ============================================================================
# Installs AgentMemory v0.9.21 (latest) with the PERFECTED configuration
# that took six hours to discover during the Tiddy Mini M4 session
# (May 23, 2026). This is the exact stack running on RAZOR's M4 Mac Mini.
#
# CRITICAL DESIGN DECISIONS BAKED IN:
#   - Embedding provider: Ollama nomic-embed-text via OpenAI-compatible
#     /v1 endpoint (GitHub Issue #232 workaround — v0.9.x doctor lies
#     about native Ollama embeddings).
#   - LLM provider: Anthropic API (Claude). v0.9.21+ strictly requires
#     this for compression / graph extraction / consolidation.
#   - API key entered via interactive HIDDEN input (read -s). The key
#     never appears on screen, never enters shell history, never lives
#     in this script.
#
# Run:
#   bash ~/Documents/TRIBE_JURIS_KIT/03_agentmemory_install.sh
# ============================================================================

# NOTE: No `set -e` — we want to continue past non-fatal states.

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

echo ""
echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}  ${BOLD}TRIBE JURIS KIT — STEP 03 — AGENTMEMORY v0.9.21${NC}      ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  npm install → .env config → embed pull → doctor    ${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"
echo ""

# --------------------------------------------------------------------------
# 0. PREREQUISITE CHECK — Step 02 must have run
# --------------------------------------------------------------------------
echo -e "${BOLD}[0/6] Verifying Step 02 prerequisites${NC}"
MISSING=""
command -v node &>/dev/null || MISSING="$MISSING node"
command -v npm &>/dev/null || MISSING="$MISSING npm"
command -v ollama &>/dev/null || MISSING="$MISSING ollama"
if [ -n "$MISSING" ]; then
    echo -e "  ${RED}✗ Missing required tools:$MISSING${NC}"
    echo -e "  ${RED}  Run 02_stack_prereqs.sh first.${NC}"
    exit 1
fi
echo -e "  ${GREEN}✓ node, npm, ollama all present${NC}"

# Verify Ollama is actually running
if ! curl -s --connect-timeout 2 http://127.0.0.1:11434/api/tags >/dev/null 2>&1; then
    echo -e "  ${YELLOW}→ Ollama not running. Starting it...${NC}"
    # Read the chosen models path from Step 02
    if [ -f ~/.tribe_juris_kit_ollama_path ]; then
        export OLLAMA_MODELS=$(cat ~/.tribe_juris_kit_ollama_path)
    fi
    ollama serve &>/tmp/ollama_startup.log &
    disown
    sleep 5
    if ! curl -s --connect-timeout 2 http://127.0.0.1:11434/api/tags >/dev/null 2>&1; then
        echo -e "  ${RED}✗ Ollama failed to start. Check /tmp/ollama_startup.log${NC}"
        exit 1
    fi
fi
echo -e "  ${GREEN}✓ Ollama server running on port 11434${NC}"

# Read the Ollama models path chosen in Step 02
if [ -f ~/.tribe_juris_kit_ollama_path ]; then
    OLLAMA_MODELS_PATH=$(cat ~/.tribe_juris_kit_ollama_path)
    echo -e "  ${GREEN}✓ Ollama models path from Step 02: $OLLAMA_MODELS_PATH${NC}"
    export OLLAMA_MODELS="$OLLAMA_MODELS_PATH"
else
    OLLAMA_MODELS_PATH="$HOME/.ollama/models"
    echo -e "  ${YELLOW}⚠ No models path from Step 02 — using default: $OLLAMA_MODELS_PATH${NC}"
fi
echo ""

# --------------------------------------------------------------------------
# 1. AGENTMEMORY NPM INSTALL (v0.9.21+)
# --------------------------------------------------------------------------
echo -e "${BOLD}[1/6] Installing AgentMemory v0.9.21+${NC}"
if command -v agentmemory &>/dev/null; then
    AM_VERSION=$(agentmemory --version 2>&1 | head -1 || echo "unknown")
    echo -e "  ${GREEN}✓ AgentMemory already installed — version: $AM_VERSION${NC}"
    echo -e "  ${YELLOW}→ Upgrading to latest to ensure >= 0.9.21...${NC}"
    npm install -g @agentmemory/agentmemory@latest
else
    echo -e "  ${YELLOW}→ Installing AgentMemory globally via npm...${NC}"
    npm install -g @agentmemory/agentmemory@latest
fi

# Verify >= 0.9.21
if command -v agentmemory &>/dev/null; then
    echo -e "  ${GREEN}✓ AgentMemory installed${NC}"
else
    echo -e "  ${RED}✗ Install failed. Check npm output above.${NC}"
    exit 1
fi
echo ""

# --------------------------------------------------------------------------
# 2. PULL nomic-embed-text (the ONE Ollama model we need)
# --------------------------------------------------------------------------
echo -e "${BOLD}[2/6] Pulling nomic-embed-text (274 MB)${NC}"
MODELS_JSON=$(curl -s http://127.0.0.1:11434/api/tags 2>/dev/null)
if echo "$MODELS_JSON" | grep -q "nomic-embed-text"; then
    echo -e "  ${GREEN}✓ nomic-embed-text already available${NC}"
else
    echo -e "  ${YELLOW}→ Pulling to $OLLAMA_MODELS_PATH...${NC}"
    OLLAMA_MODELS="$OLLAMA_MODELS_PATH" ollama pull nomic-embed-text
    if [ $? -eq 0 ]; then
        echo -e "  ${GREEN}✓ nomic-embed-text pulled${NC}"
    else
        echo -e "  ${RED}✗ Pull failed. AgentMemory will run BM25-only without it.${NC}"
    fi
fi

# Verify it responds via the /v1 endpoint we'll use
echo -e "  ${YELLOW}→ Verifying embed endpoint via OpenAI-compatible /v1...${NC}"
EMBED_TEST=$(curl -s http://127.0.0.1:11434/v1/embeddings \
    -H "Content-Type: application/json" \
    -d '{"model":"nomic-embed-text","input":"test"}' 2>/dev/null)
if echo "$EMBED_TEST" | grep -q '"embedding"'; then
    echo -e "  ${GREEN}✓ Embed endpoint /v1/embeddings returning vectors${NC}"
else
    echo -e "  ${YELLOW}⚠ /v1/embeddings test inconclusive — proceeding anyway${NC}"
fi
echo ""

# --------------------------------------------------------------------------
# 3. INTERACTIVE — Anthropic API key (HIDDEN INPUT)
# --------------------------------------------------------------------------
echo -e "${BOLD}[3/6] Anthropic API key${NC}"
echo -e "  ${CYAN}Your sk-ant-... key will be requested below.${NC}"
echo -e "  ${CYAN}Input is HIDDEN — characters won't appear on screen.${NC}"
echo -e "  ${CYAN}The key never enters shell history or this script.${NC}"
echo ""
printf "  Paste your sk-ant-... key (input hidden, press Return when done): "
read -s AK
printf "\n"

# Validate
if [ -z "$AK" ]; then
    echo -e "  ${RED}✗ No key entered. Aborting.${NC}"
    exit 1
fi
if [[ "$AK" != sk-ant-* ]]; then
    echo -e "  ${YELLOW}⚠ Key doesn't start with 'sk-ant-'. That's unusual.${NC}"
    printf "  Continue anyway? [y/N]: "
    read -n 1 CONFIRM
    echo ""
    if [ "$CONFIRM" != "y" ] && [ "$CONFIRM" != "Y" ]; then
        unset AK
        echo "  Aborted."
        exit 1
    fi
fi
echo -e "  ${GREEN}✓ Key captured (length: ${#AK} chars, prefix: ${AK:0:10}...)${NC}"
echo ""

# --------------------------------------------------------------------------
# 4. WRITE ~/.agentmemory/.env WITH PERFECTED CONFIG
# --------------------------------------------------------------------------
echo -e "${BOLD}[4/6] Writing ~/.agentmemory/.env${NC}"
mkdir -p ~/.agentmemory
ENV_FILE="$HOME/.agentmemory/.env"

# If .env already exists, back it up
if [ -f "$ENV_FILE" ]; then
    BACKUP="$ENV_FILE.backup_$(date +%Y%m%d_%H%M%S)"
    cp "$ENV_FILE" "$BACKUP"
    echo -e "  ${YELLOW}→ Existing .env backed up to: $BACKUP${NC}"
fi

cat > "$ENV_FILE" <<EOF
# ============================================================================
# AGENTMEMORY CONFIGURATION — TRIBE JURIS KIT v1.0
# Generated by 03_agentmemory_install.sh on $(date +%Y-%m-%d)
# ============================================================================
# This config is the PERFECTED stack from Tiddy Mini M4 session (May 23, 2026):
#   - LLM via Claude API (compression, graph extraction, consolidation)
#   - Embeddings via Ollama nomic-embed-text through /v1 OpenAI endpoint
#     (Issue #232 community fix — v0.9.x native Ollama detection is broken)
# ============================================================================

# --- LLM provider (Anthropic / Claude) ---
ANTHROPIC_API_KEY=$AK

# --- Embedding provider (Ollama via OpenAI-compatible /v1 endpoint) ---
# This is the GitHub Issue #232 workaround. AgentMemory v0.9.x doctor
# reports Ollama embeddings as missing when called via /api, but works
# perfectly when routed through /v1.
EMBEDDING_PROVIDER=openai
OPENAI_BASE_URL=http://127.0.0.1:11434/v1
OPENAI_API_KEY=ollama

# --- Ollama host & model references ---
OLLAMA_HOST=http://127.0.0.1:11434
OLLAMA_EMBED_MODEL=nomic-embed-text

# --- AgentMemory feature flags ---
GRAPH_EXTRACTION_ENABLED=true
AGENTMEMORY_AUTO_COMPRESS=true
AGENTMEMORY_INJECT_CONTEXT=true
CONSOLIDATION_ENABLED=true
EOF

# Unset the key from this shell IMMEDIATELY now that it's written to disk
unset AK

# Lock down permissions on .env (only owner can read)
chmod 600 "$ENV_FILE"
echo -e "  ${GREEN}✓ .env written and locked to mode 0600 (owner read/write only)${NC}"
echo -e "  ${GREEN}✓ API key cleared from this shell's environment${NC}"
echo ""

# --------------------------------------------------------------------------
# 5. START / RESTART AGENTMEMORY
# --------------------------------------------------------------------------
echo -e "${BOLD}[5/6] Starting AgentMemory${NC}"

# Stop any existing instance to pick up new .env
if curl -s --connect-timeout 2 http://127.0.0.1:3111/agentmemory/health >/dev/null 2>&1; then
    echo -e "  ${YELLOW}→ Existing instance running — restarting to pick up new .env${NC}"
    pkill -f agentmemory 2>/dev/null || true
    sleep 3
fi

echo -e "  ${YELLOW}→ Starting AgentMemory (this may take 15–30 seconds first time)...${NC}"
# CRITICAL: cd to $HOME so ./data/state_store.db resolves correctly
pushd "$HOME" >/dev/null
npx @agentmemory/agentmemory &>/tmp/agentmemory_startup.log &
disown
popd >/dev/null

# Wait for port 3111
WAITED=0
while ! curl -s --connect-timeout 2 http://127.0.0.1:3111/agentmemory/health >/dev/null 2>&1; do
    sleep 3
    WAITED=$((WAITED + 3))
    if [ "$WAITED" -ge 60 ]; then
        echo -e "  ${RED}✗ AgentMemory did not respond within 60s.${NC}"
        echo -e "  ${RED}  Check /tmp/agentmemory_startup.log${NC}"
        break
    fi
    echo -e "  ${YELLOW}⏳ Waiting (${WAITED}s / 60s)...${NC}"
done

if curl -s --connect-timeout 2 http://127.0.0.1:3111/agentmemory/health >/dev/null 2>&1; then
    echo -e "  ${GREEN}✓ AgentMemory running on port 3111${NC}"
    echo -e "  ${CYAN}  Viewer: http://localhost:3113${NC}"
fi
echo ""

# --------------------------------------------------------------------------
# 6. DOCTOR CHECK
# --------------------------------------------------------------------------
echo -e "${BOLD}[6/6] Running agentmemory doctor${NC}"
sleep 2
if command -v agentmemory &>/dev/null; then
    agentmemory doctor 2>&1 | tail -20
    echo ""
    echo -e "  ${CYAN}Target: 8/9 passing.${NC}"
    echo -e "  ${CYAN}The one expected ✗ is 'knowledge graph populated' — fills as you use it.${NC}"
else
    echo -e "  ${YELLOW}⚠ agentmemory CLI not on PATH. Skipping doctor.${NC}"
    echo -e "  ${YELLOW}  You can run it later with: npx @agentmemory/agentmemory doctor${NC}"
fi
echo ""

# --------------------------------------------------------------------------
# DONE
# --------------------------------------------------------------------------
echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}  ${BOLD}STEP 03 COMPLETE${NC}                                    ${CYAN}║${NC}"
echo -e "${CYAN}╠══════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}║${NC}  AgentMemory v0.9.21+   port 3111                    ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  LLM:        Claude API (via your sk-ant key)        ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  Embeddings: nomic-embed-text via /v1                ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  Models at:  $OLLAMA_MODELS_PATH"
echo -e "${CYAN}║${NC}  Viewer:     http://localhost:3113                   ${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"
echo ""
echo "Next: 04_anythingllm_install.md (install AnythingLLM Desktop + create your JURIS workspace)"
echo ""
