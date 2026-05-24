# STEP 01 — ANTHROPIC API KEY

**Time:** 5 minutes
**Cost:** Free to create the key. Set a $25/month cap on actual usage.
**Output:** Your `sk-ant-...` key safely stored in your password manager.

---

## WHY THIS COMES FIRST

Every other step in this kit depends on a working Anthropic API key. AgentMemory uses it for memory compression and graph extraction. AnythingLLM uses it for the JURIS workspace's LLM responses. Cowork (Claude Desktop) and Claude Code use your subscription, not this key — but the engine itself runs on it.

**Your key. Your billing. Your engine.**

---

## SECURITY RULES — READ TWICE, ENFORCE FOREVER

1. **Never paste your `sk-ant-...` key in a chat, screenshot, screen-share, or any place that gets logged.** Not to other tribe members. Not to me. Not to anyone.
2. **Never commit it to any git repository, public or private.**
3. **Keep it only in `.env` files on your machine and in a password manager.**
4. **If the key is ever exposed — even briefly — revoke it immediately at console.anthropic.com and create a new one. It is free to create new keys.**
5. **Every script in this kit uses interactive hidden input** (`read -s` pattern) so the key never appears on screen or enters shell history. Use the scripts. Don't paste keys into one-off commands.

---

## STEPS

### 1. Go to the Anthropic console
Open `https://console.anthropic.com` in your browser.

### 2. Sign in or sign up
Use the same account you use for Claude.ai if you have one — they share login. If not, sign up. Email + verification.

### 3. Add payment method (one-time setup)
Left sidebar → **Billing** → add a credit card. Pay-per-use; you pay only for tokens you actually consume.

### 4. Set a spending cap (CRITICAL)
Still in **Billing**:
- Click **Usage Limits**
- Set a **monthly hard cap** at **$25**
- Save

This is a hard ceiling. If your API hits the cap, requests just stop until next billing cycle. You can raise it later if your usage grows. Typical JURIS-engine usage runs **$5–$20/month** — $25 leaves comfortable headroom. **Without this cap, a runaway loop in a misbehaving script could cost you hundreds of dollars before you notice.** Set the cap.

### 5. Create the API key
Left sidebar → **API Keys** → **Create Key** (top right).

Name it something specific to this purpose, like:
- `JURIS engine — [Your Mac name]`
- `[Engine Name] AgentMemory`
- `Personal JURIS — Created [Month Year]`

Avoid generic names like "default" or "test" — when you have multiple keys later, descriptive names save you. Click **Create**.

### 6. COPY THE KEY IMMEDIATELY
The key appears **once**. It starts with `sk-ant-api03-...` and runs about 100+ characters.

**The instant it appears:**
- Click the copy icon next to it
- Paste it into your password manager (1Password, Bitwarden, Apple Passwords, etc.)
- Tag it as `Anthropic API Key — JURIS engine` so you can find it again

**If you close the page without copying — the key is gone forever.** Anthropic will not show it to you again. You'd need to delete the lost key and create a new one. (Free, but inconvenient.)

### 7. Verify the key works (optional but recommended)
In Terminal (this is the ONLY time you'll have the key in your terminal, and only briefly):

```bash
printf "Paste your sk-ant-... key to test (input hidden): "
read -s TESTKEY
printf "\n"
curl -s https://api.anthropic.com/v1/models \
  -H "x-api-key: $TESTKEY" \
  -H "anthropic-version: 2023-06-01" | python3 -m json.tool | head -20
unset TESTKEY
```

If you see a JSON response with `"models": [...]` listing things like `claude-sonnet-4-6` — your key works.
If you see `"authentication_error"` — the key didn't paste correctly, try again from your password manager.

The `unset TESTKEY` at the end removes the key from your shell's environment immediately. Plus the `read -s` already kept it out of your shell history.

---

## WHAT YOU HAVE WHEN STEP 01 IS DONE

- A `sk-ant-api03-...` key stored in your password manager
- A credit card on file at console.anthropic.com
- A **$25/month hard cap** configured on the account
- Verified the key works (optional)

**You do NOT have:**
- The key written down on paper
- The key in a text file on your desktop
- The key in any chat history
- The key in any git repo

If any of those exist, fix it now before moving on.

---

## NEXT

Open `02_stack_prereqs.sh` and run it. That script installs Homebrew, Node.js, iii-engine, and Ollama — no API key needed at that step. We come back to your key in Step 03 when AgentMemory needs it.

---

*Step 01 of 10 — TRIBE JURIS KIT — Modeled after JURIS Razor Jurisprudence Engine*
