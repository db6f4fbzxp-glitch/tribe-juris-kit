# TRIBE JURIS KIT — WINDOWS QUICKSTART

**Status:** Early beta — Mac is the primary tested platform. Windows works with one small prerequisite: **Git Bash** (a free Unix-style shell for Windows). Everything else translates cleanly.

> *We see you, Windows users. The tribe doesn't exclude anyone.*

---

## TL;DR — THE WINDOWS PATH IN 30 SECONDS

1. Install **Git Bash** (5-min one-time setup) — gives you a working `bash` + curl on Windows
2. Use Git Bash to run every `.sh` script the same way Mac users do
3. The five Mac-specific path translations and one Login-Item-vs-Task-Scheduler difference are documented below
4. Steps 01, 04, 05, 08, 09 are 100% platform-agnostic (markdown only)
5. Steps 02, 03, 06, 07, 10 (shell scripts) work in Git Bash with the path adjustments below

---

## STEP 0 — INSTALL GIT BASH (one-time, 5 minutes)

1. Go to **`https://gitforwindows.org`**
2. Click **Download** — latest installer (~50 MB)
3. Run the installer — accept defaults for everything except:
   - "Choosing the default editor" → pick **Visual Studio Code** or whatever editor you use
   - "Adjusting your PATH environment" → pick **"Git from the command line and also from 3rd-party software"** (the middle option)
4. Finish install
5. From the Start menu, launch **Git Bash**
6. You now have a Unix-style terminal on Windows. `curl`, `bash`, `grep`, all work.

**Test it:**
```bash
curl -s https://raw.githubusercontent.com/db6f4fbzxp-glitch/tribe-juris-kit/main/00_README.md | head -10
```
If you see the kit's README text, you're set.

---

## PATH TRANSLATIONS — WINDOWS vs MAC

| Mac path | Windows path (in Git Bash) | Windows path (PowerShell / Explorer) |
|---|---|---|
| `~/` | `/c/Users/YourName/` | `C:\Users\YourName\` or `%USERPROFILE%` |
| `~/Library/Application Support/` | `~/AppData/Roaming/` (Git Bash) | `%APPDATA%` |
| `~/Library/Application Support/Claude/claude_desktop_config.json` | `~/AppData/Roaming/Claude/claude_desktop_config.json` | `%APPDATA%\Claude\claude_desktop_config.json` |
| `~/Library/Application Support/anythingllm-desktop/` | `~/AppData/Roaming/anythingllm-desktop/` | `%APPDATA%\anythingllm-desktop\` |
| `~/.agentmemory/.env` | `~/.agentmemory/.env` (same — home folder is consistent) | `%USERPROFILE%\.agentmemory\.env` |
| `/Volumes/HD2/` (external drive) | `/d/` or `/e/` etc. (whatever letter your external drive is) | `D:\` or `E:\` etc. |
| `~/.zlogout` | `~/.bash_logout` (Git Bash) | (use Task Scheduler — see below) |
| `~/.zshrc` | `~/.bashrc` (Git Bash) | (PowerShell uses `$PROFILE`) |

---

## TOOL EQUIVALENTS — WHAT REPLACES WHAT

| Mac tool | Windows equivalent |
|---|---|
| **Homebrew** (`brew install ...`) | **Scoop** (`scoop install ...`) — `scoop.sh` — OR **winget** built into Windows 11 |
| `open -a AppName` | `start AppName` (in cmd) or just `AppName.exe` (PowerShell) |
| `osascript -e 'tell application X to quit'` | `taskkill /IM X.exe /F` or `Stop-Process -Name X -Force` |
| `pkill -f processname` | `taskkill /F /FI "imagename eq processname.exe"` |
| `~/.zlogout` auto-logout hook | **Task Scheduler** triggered on logoff event (see Step 10 below) |
| **Login Items** (System Settings) | **Task Scheduler** → triggered on logon (see Step 07 below) |
| `ditto` (preserves macOS bundles) | Not needed — Windows doesn't have bundles. Regular `cp -r` works. |
| `stat -f%z` | `stat -c%s` (Git Bash already has this) or `(Get-Item).Length` (PowerShell) |

---

## STEP-BY-STEP — RUNNING THE KIT ON WINDOWS

### Step 01 — Anthropic API key
✅ **No changes.** Identical to Mac. Browser steps only.

### Step 02 — Stack prerequisites
Run in **Git Bash**:
```bash
curl -fsSL https://raw.githubusercontent.com/db6f4fbzxp-glitch/tribe-juris-kit/main/02_stack_prereqs.sh | bash
```
**Differences from Mac:**
- The script tries `brew install` — that won't work on Windows. **Manually install instead:**
  - **Node.js 20+:** download from `nodejs.org` or `winget install OpenJS.NodeJS.LTS`
  - **Ollama:** download Windows installer from `https://ollama.com/download/windows`
  - **iii-engine:** the curl command in the script works in Git Bash
- The "external drive detection" portion lists `/Volumes/` — on Windows, your drives are `/c/`, `/d/`, `/e/`. Manually edit the `OLLAMA_MODELS` path when prompted to point to your chosen drive letter (e.g., `D:/ollama_models`).

### Step 03 — AgentMemory v0.9.21 install
Run in **Git Bash**:
```bash
curl -fsSL https://raw.githubusercontent.com/db6f4fbzxp-glitch/tribe-juris-kit/main/03_agentmemory_install.sh | bash
```
**Differences from Mac:**
- The `.env` file lands at `~/.agentmemory/.env` (same path in Git Bash)
- The interactive API key prompt (`read -s`) works in Git Bash
- AgentMemory binary store lives at `~/data/state_store.db/` (Git Bash treats this as `C:\Users\YourName\data\`)

### Step 04 — AnythingLLM Desktop
✅ **No script. Download instead.**
- Go to `https://useanything.com`
- Pick the **Windows** installer (`.exe`)
- Install, launch, create your `juris` workspace
- Workspace settings identical to Mac (Accuracy Optimized / 8 snippets / Low ≥0.25)

### Step 05 — System Prompt Builder
✅ **No changes.** Identical to Mac. Markdown content + Cowork interaction only.

### Step 06 — MCP Bridges + Chrome arm
Run in **Git Bash**:
```bash
curl -fsSL https://raw.githubusercontent.com/db6f4fbzxp-glitch/tribe-juris-kit/main/06_mcp_bridges.sh | bash
```
**Differences from Mac:**
- The script looks for Claude Desktop config at `~/Library/Application Support/Claude/claude_desktop_config.json` — on Windows that's `~/AppData/Roaming/Claude/claude_desktop_config.json`
- **Manual fix:** after running the script, also copy the `agentmemory` MCP block to the Windows path if your Claude Desktop is the Windows app:
  ```bash
  cp ~/Library/Application\ Support/Claude/claude_desktop_config.json ~/AppData/Roaming/Claude/claude_desktop_config.json
  ```
  (Create the AppData/Roaming/Claude folder first if it doesn't exist.)
- Chrome extension install is identical — visit `claude.ai/chrome` in your browser.

### Step 07 — Personalized Launcher
Run in **Git Bash** as usual. The generated `launch_[engine].sh` works fine in Git Bash.

**To make it auto-run at logon on Windows** (replacing the Mac Login Item):
1. Open **Task Scheduler** (Start menu → search "Task Scheduler")
2. **Action → Create Basic Task**
3. Name: `[Engine] Launcher`
4. Trigger: **When I log on**
5. Action: **Start a program**
6. Program: `C:\Program Files\Git\bin\bash.exe`
7. Arguments: `-c "bash /c/Users/YourName/Documents/launch_[engine].sh"`
8. Finish

That's the Windows equivalent of the Mac Login Item.

### Step 08 — Library Load (Six-Day Build)
✅ **No changes.** Identical to Mac. Markdown only.

### Step 09 — Intelligence File v1.0
✅ **No changes.** Identical to Mac. Markdown + Cowork interaction.

### Step 10 — Persistence Hooks
Run in **Git Bash** as usual.

**Differences from Mac:**
- The hook gets appended to `~/.bash_logout` (Git Bash) instead of `~/.zlogout`
- Git Bash's `.bash_logout` only fires when you exit Git Bash — not when Windows shuts down
- **For shutdown-triggered snapshots,** create a Task Scheduler task:
  1. Open Task Scheduler
  2. Create Task → Triggers tab → New → **On an event** → Log: System → Source: User32 → Event ID: 1074 (system shutdown)
  3. Action: `bash.exe -c "curl -s http://127.0.0.1:3111/agentmemory/export > ~/.agentmemory/standalone.json"`

The `snap` alias works in Git Bash exactly like on Mac.

---

## WHAT WORKS AS-IS ON WINDOWS

✅ Every Markdown file (01, 04, 05, 08, 09) renders identically — they're plain reading material  
✅ Every shell script runs in Git Bash with minor path adjustments noted above  
✅ The Chrome extension is platform-independent (any modern Chrome works)  
✅ AnythingLLM has a native Windows installer  
✅ Ollama has a native Windows installer  
✅ Node.js / npm work identically on Windows  
✅ The `snap` alias and the manual `curl` snapshot pattern work in Git Bash  

## WHAT'S DIFFERENT (NOT WORSE — JUST DIFFERENT)

🔄 Path syntax (forward slashes vs backslashes — Git Bash normalizes most of it)  
🔄 No Homebrew — use Scoop or winget or direct installers  
🔄 No Login Items — use Task Scheduler  
🔄 No native AppleScript — use PowerShell or batch equivalents for app control  

## COMING (PROPER WINDOWS PORT)

A `windows/` subfolder with native `.ps1` PowerShell scripts is on the roadmap. For now, **Git Bash gives you 95% of Mac parity**. The remaining 5% (auto-start at logon, shutdown hooks) is documented above as Task Scheduler recipes.

If you build something Windows-specific that should ship with the kit (a PowerShell port, a Task Scheduler XML import, a Scoop bucket), open a PR — the framework is shared.

---

## QUESTIONS / TROUBLE

If something doesn't work in Git Bash that should:
1. Check the Mac path in the script vs the Windows path translation above
2. Verify Git Bash is current (`git --version`)
3. Check that PATH includes Git's bin directory
4. Open an issue at: `https://github.com/db6f4fbzxp-glitch/tribe-juris-kit/issues`

---

*The framework is shared. The secrets stay home. The tribe doesn't exclude.*
*— TRIBE JURIS KIT — Windows Quickstart v0.1*
