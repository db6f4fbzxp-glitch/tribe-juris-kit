# TRIBE JURIS KIT

**Build your own Jurisprudence Engine on your Mac.**

A distribution kit for spinning up a sovereign legal research stack — modeled after **JURIS Razor Jurisprudence Engine**.

🌐 **Live field manual:** [tribe-juris-kit GitHub Pages](https://YOUR-USERNAME.github.io/tribe-juris-kit/)

---

## What This Is

A ten-step kit that installs a complete **JURIS-type Jurisprudence Engine** on a Mac:

```
        YOU
         │
      COWORK ◄─── (Claude desktop app)
         │
    ┌────┴────┐
   JURIS    MEMORY
(AnythingLLM)(AgentMemory)
   port      port
   3001      3111
```

You name your engine. You hold the keys. The framework is shared; your secrets stay home.

---

## Quick Start

After cloning this repo, work through the ten steps in order. **Total time: 4–8 hours** across 2–3 sessions.

```bash
# 1. Get your Anthropic API key
open 01_anthropic_api_key.md

# 2. Install prerequisites (Homebrew, Node, Ollama, iii-engine)
bash 02_stack_prereqs.sh

# 3. Install AgentMemory v0.9.21 with the perfected stack config
bash 03_agentmemory_install.sh

# 4. Install AnythingLLM Desktop + create JURIS workspace
open 04_anythingllm_install.md

# 5. Personalize the system prompt via Cowork
open 05_system_prompt_builder.md

# 6-10. (coming) — MCP bridges, launcher, library, intelligence file, persistence hooks
```

Or download individual scripts directly:

```bash
curl -fsSL https://raw.githubusercontent.com/YOUR-USERNAME/tribe-juris-kit/main/02_stack_prereqs.sh | bash
curl -fsSL https://raw.githubusercontent.com/YOUR-USERNAME/tribe-juris-kit/main/03_agentmemory_install.sh | bash
```

---

## The Stack

| Component | Version | Port | Purpose |
|-----------|---------|------|---------|
| **AnythingLLM** (JURIS) | latest | 3001 | Legal research engine — your library + LLM |
| **AgentMemory** (MEMORY) | v0.9.21+ | 3111 | Persistent cross-session memory |
| **Ollama** | latest | 11434 | Local embedding server (nomic-embed-text) |
| **iii-engine** | latest | — | AgentMemory's runtime layer |
| **Claude Sonnet 4.6** | API | — | Default LLM for both JURIS and MEMORY |

Storage layout:
- Main drive: AnythingLLM data, AgentMemory data, Cowork data
- External drive (recommended): Ollama models (~274 MB just for `nomic-embed-text`)

---

## The Ten Steps

| # | File | Type | Time |
|---|------|------|------|
| 00 | `00_README.md` | doctrine | — |
| 01 | `01_anthropic_api_key.md` | manual | 5 min |
| 02 | `02_stack_prereqs.sh` | script | 10 min |
| 03 | `03_agentmemory_install.sh` | script | 15 min |
| 04 | `04_anythingllm_install.md` | manual | 15 min |
| 05 | `05_system_prompt_builder.md` | interactive | 60–90 min |
| 06 | `06_mcp_bridges.sh` | script | 10 min |
| 07 | `07_personalized_launcher.sh` | script | 5 min |
| 08 | `08_library_load.md` | 6-day build | — |
| 09 | `09_intelligence_file_v1.md` | interactive | 30–60 min |
| 10 | `10_persistence_hooks.sh` | script | 5 min |

---

## Sacred Rules

Eight hard-learned lessons codified during the **Tiddy Mini M4** session (May 23, 2026). See `index.html` or `00_README.md` for the full list. Highlights:

- **AgentMemory v0.9.x needs Ollama via `/v1`** — GitHub Issue #232 workaround for the native-endpoint detection bug
- **v0.9.21+ requires real Anthropic API key** for LLM (compression / graph extraction / consolidation)
- **macOS BSD vs GNU gotchas** — use `du -k` not `du -b`, `--progress` not `--info=progress2`, `stat -f %z` not `stat -c %s`
- **Never `rsync -a` macOS bundles** — use `ditto` for `.photoslibrary` / `.app` / `.keynote` / etc.
- **Photos can't live on HFS+ external** when iCloud Photos is enabled
- **Snapshot the binary store before every reboot** — auto-rotation included in Step 10
- **Discovery-first principle** — every script scans before it acts
- **Do-Not-Touch list** — paths that would kill your engine if modified

---

## Security

All scripts in this kit follow the same security pattern for the Anthropic API key:

- Interactive **hidden input** (`read -s`) — characters never appear on screen
- Key **never enters shell history**
- Key **never lives in any script as plaintext**
- `.env` files locked to `mode 0600` (owner read/write only)
- Variable `unset` from environment immediately after `.env` is written

**Never paste your `sk-ant-...` key into a chat, screenshot, or git commit.** If exposed, revoke at console.anthropic.com immediately and create a new one (free).

---

## License

Apache 2.0 — see `LICENSE` for full text.

Same license as the AgentMemory project this kit depends on.

---

## Lineage

> *Modeled after JURIS Razor Jurisprudence Engine*

The framework is shared. The secrets stay home. The Chaos Tribe does not stop building. It compounds.

---

**Built by Razor Jurisprudence — May 2026**
