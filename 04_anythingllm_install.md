# STEP 04 — ANYTHINGLLM DESKTOP + JURIS WORKSPACE

**Time:** 15–20 minutes
**Prerequisite:** Steps 01–03 complete (you have a `sk-ant-` key, Ollama is running with `nomic-embed-text`, AgentMemory is healthy on port 3111)
**Output:** AnythingLLM Desktop installed, your JURIS workspace created and configured with the canonical settings

---

## WHAT THIS STEP DOES

AnythingLLM is the **JURIS** mind — the legal brain that holds your library of authoritative documents and answers questions by retrieval over that library. This step gets it installed and the JURIS workspace stood up with the exact configuration RAZOR runs. You'll add documents in Step 08 (Library Load) and paste your personalized system prompt in Step 05.

**Why this is a markdown guide and not a script:** AnythingLLM Desktop installs from a `.dmg` (drag-to-Applications), and the workspace setup is GUI-driven. There's no scriptable installer for the macOS version. The guide walks you through every click.

---

## STEPS

### 1. Download AnythingLLM Desktop

Open this URL in your browser:

```
https://useanything.com
```

Click the big **Download** button. Pick the **macOS (Apple Silicon)** build if you're on M1 / M2 / M3 / M4. It downloads a file named `AnythingLLMDesktop-Silicon.dmg` (or similar — about 470 MB).

> **Sacred Rule reminder:** after install, delete this `.dmg` from Downloads. Installers eat space. Step 02 of Tiddy Mini M4 freed 470 MB by purging this exact file.

### 2. Install the app

Double-click the downloaded `.dmg`. A Finder window opens showing the AnythingLLM icon and an Applications shortcut.

**Drag the AnythingLLM icon onto the Applications shortcut.** That copies it into `/Applications/`.

Eject the `.dmg` (right-click → Eject, or drag the disk icon to Trash). Then go to Downloads and delete the `.dmg` file itself.

### 3. First launch — verify it opens

Cmd+Space, type **AnythingLLM**, hit Return. The app launches.

On first launch macOS may say "AnythingLLM was downloaded from the Internet — are you sure?" — click **Open**.

You'll see the AnythingLLM onboarding wizard.

### 4. Onboarding — LLM provider

The wizard asks you to pick an **LLM Provider**. This is the AI that JURIS uses to *generate* answers (after retrieving documents from your library).

- Select **Anthropic** from the provider list.
- Paste your `sk-ant-...` key in the field.
- For **Chat Model**, select **claude-sonnet-4-6**. This is the JURIS-recommended default — best balance of capability and cost.
  - If `claude-sonnet-4-6` isn't in the dropdown, your AnythingLLM may be slightly old. Pick the newest Sonnet available, or update AnythingLLM after this step and switch later.
- Click **Continue**.

> **Note on costs:** the LLM provider here is paid per-token via your Anthropic API key. Typical JURIS usage runs $5–$20/month. Your $25 spending cap from Step 01 protects you from runaways.

### 5. Onboarding — Embedder Preference

The wizard now asks about **Embedder Preference**. This is the model that converts your documents into vectors for similarity search.

**Recommended for tribe members: AnythingLLM Native Embedder.**

- Select **AnythingLLM Embedder** (or "Native Embedder" — naming varies by version)
- This uses Xenova's `all-mpnet-base-v2` model, runs locally, costs nothing, and works out of the box. No API key needed.
- Click **Continue**.

**Alternative: Ollama nomic-embed-text** — only pick this if you want JURIS and AgentMemory to share the exact same embedding model (consistent vectors across the stack). To use it:

- Select **Ollama** as embedder
- Base URL: `http://127.0.0.1:11434`
- Model: `nomic-embed-text`
- (No API key needed — Ollama is local)

Either choice is fine. Tribe members default to Native. Power users sometimes pick Ollama for stack consistency.

### 6. Onboarding — Vector Database

Pick **LanceDB**. This is the default, runs locally on your Mac, free, and is what every tribe JURIS uses.

Click **Continue**.

### 7. Onboarding — Workspace creation

The wizard asks for a **Workspace Name**. **Type exactly:**

```
juris
```

(Lowercase. No spaces. This is the slug that MCP bridges in Step 06 will reference.)

Click **Create Workspace**.

You're now in the main AnythingLLM interface with your `juris` workspace ready.

### 8. Configure workspace settings (CRITICAL — these are JURIS-tuned)

In the left sidebar, find your `juris` workspace and click the **settings gear** (⚙) next to it.

Adjust these three values:

| Setting | Value | Why |
|---------|-------|-----|
| **Search Preference** | Accuracy Optimized | For legal research, accuracy beats speed every time |
| **Max Context Snippets** | **8** | JURIS pulls from 8 different library chunks per query — broader retrieval for complex equity questions |
| **Document Similarity Threshold** | **Low (≥ 0.25)** | Legal language is precise and inconsistent across centuries. Low threshold catches semantically-related chunks even when wording differs. |

Click **Save** or **Update Workspace**.

> **Don't** change anything else yet. Especially leave the system prompt field empty — Step 05 fills it.

### 9. Verify the Agent model

Some AnythingLLM versions have a separate "Agent" model setting (used when you type `@agent` in a chat). Confirm it matches your main LLM:

- Workspace settings → **Agent Skills** or **Chat Settings** → **Agent Model**
- Set it to the same Claude Sonnet 4.6 you picked in Step 4

(Updates can sometimes reset this. Check it any time you update AnythingLLM in the future.)

### 10. Test the workspace is live

Click into your `juris` workspace's chat. Type a quick test message:

```
Confirm you are running and tell me which model you are using.
```

JURIS responds (using Claude Sonnet 4.6) confirming it's alive. Because no documents are loaded yet, it'll respond from general knowledge — that's expected. Step 08 fills the library.

### 11. Get your AnythingLLM API key (for Step 06)

You need this for the MCP bridges in Step 06.

- Top-left menu → **Settings** (or the gear icon at the bottom-left)
- Navigate to **Tools** → **API Keys**
- Click **Generate New API Key**
- Name it: `JURIS local MCP`
- **Copy the generated key** — you'll need it in Step 06
- Store it in your password manager next to your Anthropic key

This AnythingLLM API key is separate from your Anthropic key. It lets local tools (MCP servers, scripts) talk to your AnythingLLM instance. It's a long random string, doesn't start with `sk-ant-`.

---

## WHAT YOU HAVE WHEN STEP 04 IS DONE

- AnythingLLM Desktop installed at `/Applications/AnythingLLM.app`
- `.dmg` installer deleted from Downloads
- LLM provider: Anthropic / Claude Sonnet 4.6
- Embedder: AnythingLLM Native (or Ollama nomic-embed-text if you chose that path)
- Vector DB: LanceDB (local)
- Workspace named `juris` created with:
  - Search: Accuracy Optimized
  - Max snippets: 8
  - Similarity threshold: Low (≥ 0.25)
- A test chat confirmed JURIS responds
- AnythingLLM API key generated and saved to your password manager

**You do NOT have yet:**
- Your personalized system prompt loaded (Step 05)
- Any documents in your library (Step 08)
- MCP bridges to Claude Desktop / Cowork / Claude Code (Step 06)
- Your launcher script (Step 07)

---

## TROUBLESHOOTING

**"AnythingLLM doesn't open — macOS blocks it"**
System Settings → Privacy & Security → look for "AnythingLLM was blocked from use" → click **Open Anyway**.

**"Anthropic provider rejects my key"**
Check the key is correct (try a fresh paste from your password manager). Verify the key isn't revoked at console.anthropic.com. Check your spending cap isn't already exceeded.

**"Embedder fails when I save settings"**
If you picked Ollama embedder and it errors: confirm Ollama is running (`curl http://localhost:11434/api/tags` from Terminal should return JSON). If not, run Step 02 again. If you can't get Ollama embedder to work, switch to AnythingLLM Native — same result, simpler stack.

**"Workspace settings keep reverting after I save"**
This sometimes happens on AnythingLLM updates. Settings menu → **About** → check version. Update to the latest from the in-app updater. Then re-apply settings.

**"I named the workspace something other than `juris`"**
That's fine for now — but Step 06 (MCP bridges) and Step 07 (launcher) reference the slug `juris`. Either:
- Delete the workspace and create a new one named `juris`, OR
- Edit the references in Steps 06 and 07 to match your actual slug

The slug is what MCP servers route to. Match it now if you can.

---

## NEXT

Open `05_system_prompt_builder.md` — this is where you personalize RAZOR's v3.0 system prompt with your operator name, jurisdiction, matter type, mission, and case details, then paste the result into AnythingLLM's workspace system prompt field. **This is the most important configuration step in the entire kit.**

---

*Step 04 of 10 — TRIBE JURIS KIT — Modeled after JURIS Razor Jurisprudence Engine*
