# STEP 09 — INTELLIGENCE FILE v1.0

**Time:** 30–90 minutes (depending on how much Claude history you have)
**Prerequisites:** Steps 04 (workspace) and 05 (system prompt) complete; ideally Days 1–5 of Step 08 done
**Output:** A complete `v1.0_[date]_initial_build.md` intelligence file you feed to JURIS at every session start

---

## WHY THIS STEP MATTERS

Every AI session starts from zero — including JURIS. When you close a chat and open a new one, JURIS does not remember what you discussed yesterday, what arguments you locked last week, or what citation corrections you made last month. The vector library is there — your documents are indexed — but the *strategic context* of your litigation lives nowhere unless you put it somewhere.

**The Intelligence File is where you put it.**

It is a structured Markdown document — your living strategic record. Every JURIS session starts with: *"Here is my current intelligence file. Read it and confirm you are current."* JURIS reads it, confirms, and the session begins at full context. Without this file, every session re-learns your case from scratch. With it, JURIS picks up exactly where you left off.

---

## YOU ALREADY HAVE THE RAW MATERIAL

If you've been working with Claude in any form — claude.ai web, Cowork desktop, Claude in Chrome, Claude Code — you already have raw material for your v1.0. Every conversation where you discussed your case, your documents, your arguments, your jurisdiction, your family structure, your mission — that's all source. Claude has been holding context that belongs in your JURIS brain. **This step extracts it, structures it, and makes it permanent.**

This is not starting from scratch. This is taking what already exists in your Claude sessions and converting it into a format that travels with you — that you own, that you control, that you can feed to any AI system forever.

---

## THE WORKFLOW

### Step 1 — Export your Claude conversation history

Claude.ai supports exporting your conversations. Here's how:

1. Sign in to **claude.ai** in a browser
2. Click your profile icon (bottom left) → **Settings**
3. Find **Privacy** or **Data Controls** section
4. Click **Export Data**
5. Claude prepares your archive and emails you a download link (usually within a few minutes)
6. Download the ZIP file
7. Extract — inside you'll find your conversations as JSON or text files

### Step 2 — Identify the relevant conversations

You don't need every conversation. You need the substance. Open the conversations relevant to your case — the ones where you discussed legal strategy, your documents, your arguments, your family structure, your mission.

Make a list of which conversation IDs / titles matter. You'll paste those into your capture session.

### Step 3 — Run the v1.0 Capture Prompt

Open a **fresh Cowork session** (or Claude Desktop, or claude.ai web — wherever you do focused conversation). Paste the **Capture Prompt** below, then paste your relevant conversation history below it.

---

## THE v1.0 CAPTURE PROMPT — COPY AND USE

> Copy everything between the triple-dash lines below this paragraph and paste it as the first message to a fresh Claude session, followed by your conversation history.

---

I am building a private AI legal research system called a JURIS-type Jurisprudence Engine. I need you to create my **Intelligence File v1.0** from my conversation history.

I am going to paste relevant portions of my Claude conversation history below this prompt. Read everything carefully. Then produce a structured intelligence file in Markdown that captures ALL of the following — **do not leave out a single section**:

**1. ACTIVE CASES**
Every legal matter I have discussed. For each: court level + jurisdiction, parties referenced by role (servicer / trustee / opposing counsel — no real names where I used roles), current procedural status, strategy framework.

**2. KEY LEGAL ARGUMENTS DEVELOPED**
Every argument we worked on. For each: the doctrine being invoked, the authority being cited, whether it is locked (final and ready to file) or still developing.

**3. AUTHORITIES IDENTIFIED**
Every case, statute, treatise, and section I cited or discussed — with full citation where available. Group by jurisdiction (federal / state / persuasive).

**4. DOCUMENTS IN MY LIBRARY**
Every source I mentioned loading or planning to load into my research system. Note which I've already loaded vs. which are on the to-load list.

**5. CITATION INTEGRITY RULES**
Any rules I established about which source supports which proposition — explicit one-source-one-proposition discipline to prevent cross-contamination.

**6. PROCEDURAL STATUS**
Where each matter stands right now — what has been filed, what is pending, what is upcoming. Deadlines if mentioned.

**7. OPEN ITEMS**
Everything raised but not resolved. Questions still open. Items still needed. Tasks pending. Citation corrections to verify.

**8. MISSION AND ASSET STRUCTURE**
As described in my conversations — roles only, no identifying details. The "why" behind my JURIS engine. What I'm protecting. Who inherits the fortress.

**FORMAT:**
- Markdown with clear H2 headers per section
- Use role-only language (Son 1 / Daughter 1 / Servicer / Trustee — never real names)
- No case numbers in the body — refer to cases by jurisdiction and role
- Cite sources where possible (Bouvier's §X, Pomeroy §Y, AmJur Z)

**PROCESS:**
When you're done with the draft, **read it back to me section by section**, asking after each: *"Is anything missing or wrong in this section?"*

Do not mark the file complete until I confirm each section is accurate and nothing has been omitted.

After confirmation, output the final file as one clean Markdown block I can copy and save.

[PASTE YOUR CONVERSATION HISTORY BELOW THIS LINE]

---

## STEP 4 — CONFIRM AND LOCK

Don't accept the first draft as final. Claude will produce a draft. Then it should read each section back. **Correct every error. Add everything that was missed.** Only when you can say with confidence "nothing is missing" do you lock v1.0.

This usually takes 2–4 rounds of review. That's normal and expected. Your v1.0 is your foundation — it deserves the time.

---

## STEP 5 — SAVE THE FILE

Once locked, save the final Markdown block to a file:

```
~/Documents/[YOUR_ENGINE]_INTELLIGENCE/v1.0_[YYYY-MM-DD]_initial_build.md
```

For example, if your engine is named "Aurora" and today is May 24, 2026:
```
~/Documents/AURORA_INTELLIGENCE/v1.0_2026-05-24_initial_build.md
```

Create the folder if it doesn't exist:
```bash
mkdir -p ~/Documents/[YOUR_ENGINE]_INTELLIGENCE
```

---

## STEP 6 — LOAD IT INTO JURIS

Two ways to use your intelligence file going forward:

### A. Persistent (recommended)
Upload the file into your `juris` AnythingLLM workspace just like any other document. JURIS can now retrieve from your own strategic history when answering research questions.

### B. Per-session (also use this)
At the start of every JURIS session, paste the current intelligence file directly into the chat and say:

> *"Here is my current intelligence file v[X.X]. Read it and confirm you are current before we begin any research."*

JURIS reads, confirms, and the session begins at full context. Every query benefits from the full picture.

**Do both A and B.** A makes it permanently retrievable. B brings it to the top of working context for the current session.

---

## VERSION CONTROL — INCREMENT AS YOU GO

Your intelligence file is **living**. Update it at the end of every significant session. Numbering pattern:

| Event | Version increment | Example |
|-------|-------------------|---------|
| Initial capture from Claude history | **v1.0** | `v1.0_2026-05-24_initial_build.md` |
| New document ingested into library | Minor: **v1.0 → v1.1** | `v1.1_2026-05-30_added_pomeroy.md` |
| New argument developed and locked | Minor: **v1.1 → v1.2** | `v1.2_2026-06-05_unclean_hands_locked.md` |
| Filing served or court order received | **Major: v1.x → v2.0** | `v2.0_2026-06-15_motion_served.md` |
| Case milestone — hearing, ruling | **Major: v2.x → v3.0** | `v3.0_2026-07-01_motion_granted.md` |
| Citation correction or integrity update | Minor: **v3.0 → v3.1** | `v3.1_2026-07-03_citation_fix.md` |

**Never overwrite an old version.** Always create a new numbered file. The full archive is the audit trail of your strategy from day one to final resolution.

---

## ASK YOUR ENGINE TO PRODUCE THE UPDATE FOR YOU

At the end of every significant Cowork or JURIS session, paste this prompt to wrap up:

> *"Produce an intelligence file update. Capture: what was drafted or decided today, any arguments developed or locked, any citation corrections made, any open items that remain, any new authorities we identified. Format it as an addendum to v[CURRENT VERSION] ready to become v[NEXT VERSION]. Output as one Markdown block I can copy."*

Copy the output. Save as the next version. Done. Five minutes to capture, lifetime value.

---

## WHAT YOU HAVE WHEN STEP 09 IS DONE

- A complete `v1.0_[date]_initial_build.md` intelligence file with all 8 mandatory sections
- Section-by-section verification with Claude — nothing missing
- Saved to `~/Documents/[YOUR_ENGINE]_INTELLIGENCE/` (versioned, never overwritten)
- Uploaded into your `juris` AnythingLLM workspace for permanent retrievability
- The capture prompt and the update prompt saved for future reuse
- A clear versioning pattern for evolving the file as your case develops

**Your JURIS now knows everything you've ever told any AI about your case.** That intelligence is yours, permanent, portable.

---

## NEXT

Open `10_persistence_hooks.sh` — this is the final step. It installs the binary store backup rotation and the auto-snapshot logout hook so your AgentMemory state survives every reboot reliably. Closes the loop.

---

*Step 09 of 10 — TRIBE JURIS KIT — Modeled after JURIS Razor Jurisprudence Engine*
