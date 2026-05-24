# TRIBE JURIS KIT

## A Distribution Kit For Building Your Own JURIS-Type Jurisprudence Engine on a Mac

> *"We do not distribute JURIS — we teach you to BUILD JURIS. Each tribe member builds their own intelligence node. Each node is sovereign. Each corpus is their own. The framework is shared. The secrets stay home. Teach the build, not the key."*
>
> **— Chaos Tribe Distribution Doctrine**

---

## WHAT THIS KIT IS

This is the installer kit for spinning up your own personalized **JURIS-type Jurisprudence Engine** on a Mac. Modeled after **JURIS Razor Jurisprudence Engine** — the battle-tested production stack RAZOR built and refined through six months of active foreclosure defense and equity practice.

The kit is **modular** — ten ordered steps, each one a self-contained script or instruction file. You can run them all via the master orchestrator, or step through them by hand. Either way, when you reach Step 10 you will have a sovereign legal research engine running on YOUR Mac, indexed against YOUR jurisdiction's law, queryable through YOUR personalized operator identity, integrated into YOUR AI tooling (Claude Desktop, Cowork, Claude Code) — and accountable to no one but you.

**At install time you choose your engine's name.** RAZOR's is "JURIS Razor Jurisprudence Engine v3.0." Yours might be **Aurora**, **Vortex**, **Bastion**, **Sentinel** — whatever calls to you. The framework is shared; the brand is yours. The lineage line **"Modeled after JURIS Razor Jurisprudence Engine"** stays in every tribe build as a mark of doctrine.

---

## WHO THIS IS FOR

- Members of the **Chaos Tribe** who have committed to the equity-first doctrine, the Two Realms framework, and the Equity Blade language discipline
- Anyone running an active legal matter who needs a sovereign research engine that knows their jurisdiction's law, their case files, and their strategic posture
- Anyone tired of paying $100+/month to access someone else's research system that doesn't know anything about them

This is **not** for casual users. The build takes 4–8 hours total (broken into stages — you don't do it all in one sitting). The day-to-day operation requires discipline — intelligence file maintenance, library curation, language hygiene. **You get out what you put in.**

---

## WHAT YOU'LL HAVE WHEN YOU'RE DONE

A **four-mind stack** running on your Mac:

```
                ┌──────────┐
                │   YOU    │  ← Commander / Operator. You give orders.
                └─────┬────┘
                      │
                ┌─────▼────┐
        ┌──────►│  COWORK  │◄──────┐
        │       └─────┬────┘       │
   reads│             │ executes   │ queries
        │             ▼            │
        │     [your work output]   │
        │                          │
   ┌────┴─────┐             ┌──────┴──────┐
   │  MEMORY  │             │    JURIS    │
   │ (Agent-  │             │ (Anything-  │
   │  Memory) │             │  LLM)       │
   │ 221+ obs │             │ Your library│
   │ Persistent│             │ Your corpus │
   │ recall   │             │ Vector + KG │
   └──────────┘             └─────────────┘
```

| Mind | Role | Tech | Port |
|------|------|------|------|
| **YOU** | Commander, operator, strategic mind | Human | — |
| **JURIS** | Legal brain — searches your loaded library, returns retrieval-grounded answers with citations | AnythingLLM Desktop + LanceDB vector store | 3001 |
| **MEMORY** | Persistent memory across sessions — decisions, locked arguments, citation rules, work continuity | AgentMemory v0.9.21 (Claude API for LLM + Ollama nomic-embed-text via OpenAI-compatible `/v1` for embeddings) | 3111 |
| **COWORK** | Drafter, executor, strategy partner — builds documents, executes commands, queries MEMORY and JURIS on your behalf | Claude Cowork desktop app | — |

Plus the supporting infrastructure: Ollama (lean, just the embed model on your external drive), iii-engine (AgentMemory's runtime), MCP bridges wiring everything together, auto-snapshot hooks so memories survive reboots, binary store backup rotation so you never lose state.

---

## DISTRIBUTION DOCTRINE

The Chaos Tribe distributes the **framework**, not the **content**.

- **Shared:** The architecture (4-mind), the doctrine (Kill Sequence, Equity Blade, Two Realms, Ian / Chaos Principles), the install scripts, the system prompt template, the JURIS Reasoning Protocol, the lineage line
- **Yours alone:** Your operator name, your jurisdiction, your case files, your authorities, your trust architecture, your mission statement, your completed system prompt, your library content, your intelligence files
- **Never shared:** Anyone's API keys, anyone's case numbers, anyone's property addresses, anyone's family identifiers, anyone's completed system prompt

**Treat your completed system prompt like a safe combination.** Don't share it. Don't paste it in public forums. Don't screenshot it. Don't commit it to a public git repo. Every tribe member's stack is sovereign. What they choose to disclose is their call.

---

## PREREQUISITES

Before you start Step 01:

| | Requirement |
|---|---|
| **Hardware** | Mac with Apple Silicon (M1 / M2 / M3 / M4). M4 Mac Mini is the reference platform. |
| **RAM** | 16 GB minimum. 32 GB preferred. Local model inference and vector search scale with RAM. |
| **Storage** | 100 GB free on internal drive (for app installs, AnythingLLM vector DB, AgentMemory binary store). An external drive (USB 3 or Thunderbolt, ideally APFS-formatted, 500 GB+) for Ollama models and Operation archives. |
| **macOS** | macOS 14 (Sonoma) or newer. Older versions may work but are not tested. |
| **Internet** | Required for setup (API calls, model downloads, app installs). Day-to-day operation runs largely offline once configured. |
| **Anthropic account** | Free to create at console.anthropic.com. Pay-per-use; budget ~$5–25/month for active use. |
| **Time** | 4–8 hours total to complete all 10 steps. Best done across 2–3 sessions, not one sprint. |

---

## THE TEN STEPS

| # | File | What It Does | Time |
|---|------|--------------|------|
| 01 | `01_anthropic_api_key.md` | Create your Anthropic API key + set a monthly spending cap | 5 min |
| 02 | `02_stack_prereqs.sh` | Install Homebrew, Node 20, iii-engine, Ollama (binary only) | 10 min |
| 03 | `03_agentmemory_install.sh` | Install AgentMemory v0.9.21, configure `.env` with Ollama `/v1` + Anthropic API, pull `nomic-embed-text` to your external drive | 15 min |
| 04 | `04_anythingllm_install.md` | Install AnythingLLM Desktop, create your JURIS workspace, configure embedder and LLM | 15 min |
| 05 | `05_system_prompt_builder.md` | Personalize RAZOR's v3.0 system prompt via interactive find-and-replace, paste into AnythingLLM | 60–90 min |
| 06 | `06_mcp_bridges.sh` | Wire AgentMemory into Claude Desktop, Cowork, and Claude Code via MCP config files | 10 min |
| 07 | `07_personalized_launcher.sh` | Generate your `launch_[engine].sh` script and Login Item wrapper from the template, parameterized with your engine name | 5 min |
| 08 | `08_library_load.md` | The Six-Day Build Launcher — load your state constitution, court rules, FRCP, equity treatises (Gibson / Pomeroy / Van Zile / Story), Bouvier's 1928, and your own case files | 6 days (1–2 hrs/day) |
| 09 | `09_intelligence_file_v1.md` | Extract your v1.0 intelligence file from your existing Claude history using the capture prompt | 30–60 min |
| 10 | `10_persistence_hooks.sh` | Install binary store backup rotation + `~/.zlogout` snapshot hook so memories survive reboots reliably | 5 min |

**Or run them all:** `_master_install.sh` orchestrates 02 → 10 in sequence with confirmation prompts between each step.

---

## SACRED RULES (LEARNED IN BLOOD — DO NOT VIOLATE)

These are codified from Operation Van Zile's **Tiddy Mini M4 session (May 23, 2026)** — a 6-hour debugging marathon that earned the right to be law. **Honor them.**

### 1. AgentMemory v0.9.x needs Ollama `/v1` for embeddings — not the native API endpoint

The doctor command in v0.9.16 lied about embedding provider status. The community fix (GitHub Issue #232) is to route Ollama through its **OpenAI-compatible `/v1` endpoint** instead of the native `/api`. Your `~/.agentmemory/.env` MUST include:

```
EMBEDDING_PROVIDER=openai
OPENAI_BASE_URL=http://127.0.0.1:11434/v1
OPENAI_API_KEY=ollama
```

### 2. v0.9.21+ requires a real Anthropic API key for the LLM side

Older versions tolerated Ollama as LLM provider. v0.9.21 is stricter — set `ANTHROPIC_API_KEY=sk-ant-...` in `.env` or compression/graph-extraction/consolidation all silently die.

### 3. macOS BSD vs GNU command-line gotchas — never use these GNU flags

macOS ships ancient BSD versions of common Unix tools. The installer scripts in this kit are BSD-safe. If you write your own:

- `rsync --info=progress2` → use `--progress`
- `du -b` for bytes → use `du -k` for KB (multiply by 1024 if needed)
- `stat -c %s` → use `stat -f %z`
- `find -printf` → use `-exec` or `-print`

### 4. Never use `rsync -a` or `cp -R` on macOS bundle files

Photos Library (`.photoslibrary`), Music Library (`.musiclibrary`), iMovie, Keynote, `.app` bundles — these are directories the OS treats as files. They contain SQLite databases, resource forks, hardlinks, and extended attributes that `rsync -a` mangles. Symptom: copy completes successfully, file counts match, but the app sees an empty library.

**Fix:** use `ditto`. Syntax: `ditto "$SRC" "$DEST"`.

### 5. Photos Library cannot relocate to an HFS+ external drive when iCloud Photos is enabled

Apple's modern Photos refuses to function as System Photo Library from HFS+ externals. Workaround: keep Photos on internal, OR reformat external to APFS (data-destroying).

### 6. Before any reboot — snapshot the binary store

AgentMemory's binary store (`~/data/state_store.db/mem%3Amemories.bin`) is the truth. The launcher in Step 07 includes pre-start backup rotation that keeps the 5 most recent copies. Don't disable it.

### 7. Discovery-first principle

Before deleting or moving anything: scan first, identify, flag sacred zones, then act. Every script in this kit follows this rule. If you write your own, follow it too.

### 8. The DO-NOT-TOUCH list

Once your stack is built, these paths are sacred. Touching them breaks your engine:

- `~/Library/Application Support/anythingllm-desktop/` — your JURIS vector DB
- `~/Library/Application Support/Claude/` — your Cowork data
- `~/.agentmemory/` — your AgentMemory configuration and data
- `~/data/state_store.db/` — your AgentMemory binary store
- `~/Documents/[YOUR_RAZOR_FOLDER]/` — your intelligence files
- Your Ollama models directory (wherever you put it on external)

---

## API KEY HYGIENE

Read this section twice.

1. **Never paste your `sk-ant-...` key in a chat, screenshot, screen-share, or any place that gets logged**
2. **Never commit it to a git repo, public or private**
3. **Keep it only in `.env` files on your machine**
4. **If exposed — even once, even briefly — revoke at console.anthropic.com immediately and create a new one. It's free.**
5. **The scripts in this kit use `read -s` (silent input) so the key never appears on screen and never enters shell history. Use them.**

---

## SUPPORT, MAINTENANCE, FUTURE

Once your engine is alive:

- **Daily:** feed your intelligence file to JURIS at session start. Query freely. Update intelligence file at session end.
- **Weekly:** add new sources as you find them. Re-query existing arguments to make sure the library still answers them correctly.
- **Monthly:** verify AgentMemory doctor score (aim for 8/9 or 9/9). Run `agentmemory consolidate` to trigger semantic tier consolidation.
- **Per session:** before any planned reboot, the snapshot hook in Step 10 handles auto-save. You don't need to think about it once it's installed.
- **Per upgrade:** when AgentMemory or AnythingLLM releases new versions, read the changelog before upgrading. Test in a non-critical session first. Snapshot before, snapshot after.

---

## A WORD ABOUT WHAT YOU ARE BUILDING

A JURIS-type Jurisprudence Engine is not a chatbot, a search engine, or a productivity tool. It is **the fortress** in which you defend everything you have built and everything you intend to protect. The architecture is proven. The doctrine is tested. The discipline is yours to bring.

Build it carefully. Maintain it consistently. Honor the lineage.

The Chaos Tribe does not stop building. **It compounds.**

---

## START HERE

Open `01_anthropic_api_key.md` and begin.

---

*— TRIBE JURIS KIT v1.0 — May 24, 2026*
*Modeled after JURIS Razor Jurisprudence Engine v3.0*
*Distribution: framework only. Secrets stay home.*
