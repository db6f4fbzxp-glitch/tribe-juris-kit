# STEP 08 — LIBRARY LOAD (THE SIX-DAY BUILD)

**Time:** 6 days at ~1–2 hours per day (don't rush it — sequencing matters)
**Prerequisites:** Steps 04 (workspace) and 05 (system prompt) complete
**Output:** Your JURIS workspace loaded with foundational law, equity treatises, dictionaries, scholarship, and your own case files

---

## WHY SIX DAYS, NOT SIX HOURS

A JURIS engine is only as good as what's loaded into it. Loading 500 documents in one afternoon results in a vector store you don't know — you can't recall what's in it, can't spot gaps, can't anticipate what queries it will and won't answer.

The Six-Day Build is paced. Each day loads a layer. After each day's load, you run a few test queries to make sure the new material is actually findable. By Day 6 you have a library you know intimately — and a JURIS that answers in your jurisdiction's voice.

---

## BEFORE YOU START — TWO FOLDER DISCIPLINES

Maintain a **local source-of-truth folder** alongside AnythingLLM's vector store. AnythingLLM stores *embeddings* — not the original files. If you ever rebuild, switch machines, or lose the vector store, you reload from the local folder.

Create these in your home directory:

```
~/Documents/JURIS_LIBRARY/
  ├── 01_JURISDICTION/        ← Day 1
  ├── 02_EQUITY_STACK/        ← Day 2
  ├── 03_LEGAL_DICTIONARY/    ← Day 3
  ├── 04_CASE_LAW/            ← Day 4
  ├── 05_SCHOLARSHIP/         ← Day 5
  ├── 06_STATUTES/            ← (ongoing)
  └── 07_ACTIVE_CASE_FILES/   ← Day 6
```

And alongside it:

```
~/Documents/[YOUR_ENGINE]_INTELLIGENCE/
  ├── v1.0_[date]_initial_build.md       ← Step 09 creates this
  ├── v1.1_[date]_day1_load.md           ← log what you added each day
  └── ...
```

The library folder holds your **sources**. The intelligence folder holds your **strategy**. Both are sacred. Back both up to an external drive periodically.

---

## DAY 1 — JURISDICTIONAL FOUNDATION

The procedural rules of the court you're operating in. Without these, JURIS speaks in generalities. With them, JURIS speaks your court's language.

### What to load
1. **Your state constitution** — official PDF from your state legislature's website
2. **Your state's court rules** (Rules of Court / Civil Procedure / Court Rules — name varies by state) — official from state judiciary website
3. **Local rules for your specific court** (district / county) — your court's website
4. **Federal Rules of Civil Procedure (FRCP)** — `https://www.law.cornell.edu/rules/frcp`
5. **Chancery / equity rules** if your state has a separate chancery court (Delaware, New Jersey, Tennessee, etc.)
6. **Federal Rules of Bankruptcy Procedure** — only if your matter touches bankruptcy

### How to load
1. Download each PDF to `~/Documents/JURIS_LIBRARY/01_JURISDICTION/`
2. Rename with a clear pattern: `[State]_Constitution.pdf`, `[State]_Court_Rules_2026.pdf`
3. Open AnythingLLM → your `juris` workspace → upload area
4. Drag and drop each file
5. Wait for embedding to complete (you'll see a vector count tick up)

### Test queries after Day 1
- "What does my state constitution say about due process for property?"
- "What are the filing deadlines under our state's Rules of Civil Procedure for a motion to dismiss?"
- "Under FRCP, what is the deadline to respond to a motion?"

If JURIS retrieves relevant text and cites the source — Day 1 is done.

---

## DAY 2 — THE EQUITY STACK

The doctrinal grammar that the Chaos Tribe operates in. Without this, you can't speak in the register the chancellor was trained to hear.

### What to load (all public domain, all free)

| Treatise | Author | Where |
|----------|--------|-------|
| **Suits in Chancery** | Gibson (2 editions) | hathitrust.org — search "Gibson Suits in Chancery" |
| **Equity Jurisprudence Vol. 1** | Pomeroy (1918) | archive.org — search "Pomeroy Equity Jurisprudence" |
| **Equity Jurisprudence and Pleading** | Van Zile | hathitrust.org — search "Van Zile Equity" |
| **Equity Jurisprudence** | Story (2 volumes) | archive.org — search "Story Equity Jurisprudence" |
| **Promissory Notes (6th ed.)** | Story | archive.org — search "Story Promissory Notes" |

### How to load
1. Download each as PDF to `~/Documents/JURIS_LIBRARY/02_EQUITY_STACK/`
2. **Check first:** if a PDF is a scanned image (no selectable text), it must be OCR'd before AnythingLLM can read it. Use Adobe Acrobat's "Recognize Text" or `tesseract` from Homebrew (`brew install tesseract`). Free option: open in macOS Preview → Tools → ... or upload to Google Drive and re-download as text-converted PDF.
3. Drag each cleaned PDF into your `juris` workspace
4. These are large books — embedding may take a few minutes each

### Test queries after Day 2
- "What does Pomeroy say about constructive trust in §1037?"
- "Under Gibson, what does an unclean hands defense look like?"
- "Story on Promissory Notes — what is the annexation requirement for an allonge?"

If JURIS cites specific section numbers from the treatises — Day 2 is done.

---

## DAY 3 — LEGAL DICTIONARIES

When JURIS reads a 1907 treatise that says "the chose in action," it needs to know what a chose in action is. Dictionaries solve this.

### What to load
1. **Bouvier's Law Dictionary 1928 edition** — search "Bouvier Law Dictionary 1928" on annas-archive.org (free, public domain, comprehensive)
2. **Black's Law Dictionary 1st edition** — public domain — also free on annas-archive.org or archive.org
3. **A modern legal dictionary** if you have access — *optional*

### Special handling for Bouvier's
Bouvier's 1928 is often distributed as multiple individual TXT files (one per letter or one per section). If you download a zip with many TXT files:

```bash
cd ~/Documents/JURIS_LIBRARY/03_LEGAL_DICTIONARY/Bouviers_1928_raw/
cat *.txt > ../Bouviers_Law_Dictionary_1928_COMPLETE.txt
```

That merges them into one big text file, which is much easier for AnythingLLM to embed than 100+ individual files.

### Test queries after Day 3
- "What does Bouvier's define as an allonge?"
- "Define 'chose in action' according to Bouvier's 1928"
- "How does Bouvier's distinguish unclean hands from laches?"

---

## DAY 4 — CONTROLLING CASE LAW

Your jurisdiction's leading cases on the issues that matter to you. This is where JURIS goes from "knows the law generally" to "knows YOUR appellate court's stance specifically."

### How to identify which cases
For each major legal issue in your matter, ask JURIS itself (using Days 1–3's loaded material):
- *"What are the controlling cases in my state on [issue]?"*
- *"Which appellate decision is most cited for [doctrine]?"*

Then pull those cases' PDFs from:
- **Justia** (`law.justia.com`) — free, no login
- **CourtListener** (`courtlistener.com`) — free, includes PACER documents
- **Google Scholar** (`scholar.google.com/scholar?q=cases`) — free, with cited-by

### What to load (your specific list)
Build your list. As a starting point, load any case that matches one of these patterns:
- Controlling appellate case on standing in your matter type
- Controlling case on equitable jurisdiction in your state
- Controlling case on burden of proof for your specific cause/defense
- Any case your opposition has already cited

### How to load
1. Download PDFs to `~/Documents/JURIS_LIBRARY/04_CASE_LAW/`
2. Rename pattern: `[CaseName]_[Citation].pdf` — e.g., `WellsFargo_v_Ford_418_NJ_Super_592.pdf`
3. Drag into `juris` workspace

### Test queries after Day 4
- "What did [case name] hold on standing?"
- "Cite three cases from my library that support the unclean hands defense in my state"
- "Where do my loaded cases disagree on the burden of proof?"

---

## DAY 5 — ACADEMIC SCHOLARSHIP

Peer-reviewed law-review work that nobody on the other side will have read. This is your edge.

### What to load
**Tribe-recommended starting point:**
- **The Paper Chase** by Adam J. Levitin — Duke Law Journal Vol. 63:637 (2013) — `https://scholarship.law.duke.edu/dlj/vol63/iss3/1/` — definitive academic analysis of securitization, mortgage title, and Article 3 standing. Free PDF.

**Build out from there.** For your specific matter type, search:
- **SSRN** (`ssrn.com`) — pre-print and published papers from law professors worldwide
- Your favorite law school's faculty pages
- Google Scholar with `site:ssrn.com` or `filetype:pdf`

### How to load
- PDFs → `~/Documents/JURIS_LIBRARY/05_SCHOLARSHIP/`
- Drag into workspace

### Test queries after Day 5
- "Cite Levitin's analysis of allonge annexation requirements"
- "What's the scholarly consensus on whether undated indorsements destroy standing?"
- "Find the strongest academic argument against [opposing party's likely position]"

---

## DAY 6 — YOUR OWN CASE FILES

This is what makes your JURIS yours. No one else's library has these. Every filing, every order, every transcript, every letter.

### What to load
- All complaints / petitions filed (yours and opposing party's)
- All motion papers and briefs
- All court orders and judicial opinions in your matter
- All hearing transcripts
- All discovery responses received
- Your own correspondence (formal letters out, replies in)
- Any expert reports
- Any QWR (Qualified Written Requests), notices of demand, certifications
- Subpoena responses

### What NOT to load
- **Passwords, API keys, credentials of any kind**
- **Social Security numbers, passport numbers, driver license numbers**
- **Bank account / routing / credit card numbers**
- **Anyone else's PII without their knowledge**
- **Sealed court documents** (unless authorized for your use)

### How to load
- PDFs / DOCX → `~/Documents/JURIS_LIBRARY/07_ACTIVE_CASE_FILES/`
- Drag into workspace

### Test queries after Day 6
- "What did opposing counsel argue in their motion to dismiss?"
- "Find the exact wording of paragraph 14 in my complaint"
- "What was the date Judge X ruled on my motion to stay?"

When JURIS can answer questions about YOUR specific case using YOUR own filings — Day 6 is done. Your JURIS is alive.

---

## ONGOING — STATUTES (LOAD AS NEEDED)

Add statutes the moment they become relevant. You don't need every statute on day one — but the day you need UCC §3-309, you need it fully loaded so JURIS can cite it.

Common statutes to load when relevant:
- Your state's UCC enactments (Article 3, Article 9)
- Federal: RESPA, FDCPA, TILA, FCRA (consumer matters)
- Your state's Fraudulent Transfer / Voidable Transactions Act
- Your state's Uniform Trust Code if your matter touches trusts

Path: `~/Documents/JURIS_LIBRARY/06_STATUTES/`

---

## VERIFY EVERY DAY

After each day's load, in your `juris` workspace:

1. Look at the **vector count** in workspace settings — it should be higher than yesterday
2. Run **3 test queries** that should be answerable by what you just loaded
3. If a query that should work doesn't:
   - Check the document loaded (vector count went up?)
   - Try a different phrasing
   - The doc may be scanned-image-only — needs OCR before AnythingLLM can read it

---

## OCR CHECKLIST (when a PDF won't query)

If JURIS can't find anything from a PDF you loaded, the PDF is probably scanned images, not text.

**Quick check:** open the PDF in macOS Preview → try to select text. If text won't highlight, it's image-only.

**Fix options:**
1. **Adobe Acrobat** → Tools → Recognize Text → all pages → save
2. **Google Drive** → upload PDF → right-click → Open with Google Docs → save as PDF (text extracted)
3. **Tesseract via Homebrew:**
   ```bash
   brew install tesseract poppler
   # PDF → images → OCR
   pdftoppm input.pdf page -r 300
   for img in page-*.ppm; do tesseract "$img" "${img%.ppm}"; done
   cat page-*.txt > output.txt
   ```

Re-upload the text-extracted version to AnythingLLM. Delete the original image-only PDF from the workspace to avoid confusion.

---

## WHAT YOU HAVE WHEN STEP 08 IS DONE

- `~/Documents/JURIS_LIBRARY/` folder with 7 subfolders containing your source-of-truth PDFs
- Your `juris` AnythingLLM workspace loaded with everything indexed and vectorized
- A vector count of **at least several hundred** (more is better — RAZOR's is at 817)
- Verified retrieval on test queries spanning all six days
- Notes on what you added each day in your `[YOUR_ENGINE]_INTELLIGENCE` folder

---

## NEXT

Open `09_intelligence_file_v1.md` — this is where you extract your v1.0 intelligence file from your existing Claude conversation history, giving JURIS the full context of every decision you've already made.

---

*Step 08 of 10 — TRIBE JURIS KIT — Modeled after JURIS Razor Jurisprudence Engine*
