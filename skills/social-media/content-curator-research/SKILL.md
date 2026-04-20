---
name: content-curator-research
description: Autonomous 3x/day AI intel sweep — fetches HackerNews, GitHub Trending, Google AI Blog, ArXiv, X/Twitter, and star-history.com, filters for AI/LLM/agent topics, appends to a daily research file in a GitHub repo with a "What's Hot Right Now" table of contents followed by deep-dive sections.
author: Dhruvi Kothari
---

You are an autonomous AI research agent. Run every step in order. Do not ask questions. If a source fails, log it and continue.

Config:
```json
{
  "email": "<YOUR_EMAIL>",
  "repo_url": "<YOUR_REPO_SSH_URL>",
  "repo_clone_dir": "<YOUR_LOCAL_REPO_DIR>",
  "output_subdir": "content-curator",
  "cadence": "0 6,12,17 * * *",
  "topics": ["LLM", "Claude", "OpenAI", "MCP", "ADK", "agent", "open-source AI", "AI orchestration", "transformer", "fine-tuning", "RAG", "agentic", "multimodal", "reasoning model", "harness", "vibe coding"],
  "star_history_url": "https://star-history.com/compare"
}
```

> **Setup:** Replace `<YOUR_EMAIL>`, `<YOUR_REPO_SSH_URL>`, and `<YOUR_LOCAL_REPO_DIR>` with your own values before using this skill.

### Step 1 — Prepare repo

Expand `<YOUR_LOCAL_REPO_DIR>` to absolute path. If it doesn't exist:
```bash
git clone <YOUR_REPO_SSH_URL> <YOUR_LOCAL_REPO_DIR>
```
If it exists:
```bash
cd <YOUR_LOCAL_REPO_DIR> && git pull --rebase origin main
```

Ensure `<YOUR_LOCAL_REPO_DIR>/content-curator/` exists. Determine today's filename: `research-MMDDYY.md` (e.g. `research-042026.md`).

Determine sweep number: if the file doesn't exist → sweep 1. If it exists, count existing `## Sweep` headings in it → that count + 1 is this run's sweep number.

### Step 2 — HackerNews

WebFetch `https://hacker-news.firebaseio.com/v0/topstories.json` → first 30 IDs. For each, WebFetch `https://hacker-news.firebaseio.com/v0/item/{id}.json`. Filter by topic keywords (case-insensitive on title/url). Sort by score. Keep top 5. Extract: title, score, comment count, URL, 2–3 sentence "why it matters" note.

### Step 3 — GitHub Trending

WebFetch `https://github.com/trending?since=daily` and `https://github.com/trending/python?since=daily`. Filter repos whose name or description matches any topic keyword. Keep top 5 unique. Extract: repo name, description, stars-today, URL, 2–3 sentence summary.

### Step 4 — Google AI Blog

WebFetch `https://blog.google/technology/ai/rss/`. Parse 8 most recent items. Extract: title, pubDate, link, 2–3 sentence editorial summary.

### Step 5 — ArXiv

WebFetch `https://arxiv.org/search/?searchtype=all&query=llm+agents&start=0` and `https://arxiv.org/search/?searchtype=all&query=AI+orchestration+agents&start=0`. Top 5 by recency, dedup by title. Extract: title, first 2 authors, full abstract, URL, "why this paper matters" note.

### Step 6 — X/Twitter Signals

WebSearches:
- `"LLM agents" site:x.com OR site:twitter.com`
- `"Claude" OR "OpenAI" "agent" site:x.com`
- `"MCP" OR "ADK" "AI" site:x.com`

Extract 5–8 posts: handle, snippet, engagement, 1–2 sentence angle note.

### Step 7 — Star History

WebFetch `https://star-history.com/compare`. Note velocity observations. If none, write "No data extracted."

### Step 8 — Synthesize "What's Hot" for this sweep

Generate 4–6 editorial bullets: cross-source themes, surprising signals, narrative threads, angles for builders/PMs/devs. Each bullet becomes an anchor link to a deep-dive section.

### Step 9 — Write or append to daily file

Path: `<YOUR_LOCAL_REPO_DIR>/content-curator/research-MMDDYY.md`.

**If the file does not exist**, create it with this top-of-file header before adding the sweep:
```markdown
# AI Intel Report — MM/DD/YY

> Pick a topic from any sweep's **What's Hot** below to draft content via `/content-curator`.

---
```

**Append this sweep block** to the file:
```markdown
## Sweep N/3 — HH:MM UTC

### What's Hot Right Now (Sweep N)

- [🔥 Theme 1 one-liner](#sN-theme-1-slug)
- [🔥 Theme 2 one-liner](#sN-theme-2-slug)
- [🔥 Theme 3 one-liner](#sN-theme-3-slug)
- [🔥 Theme 4 one-liner](#sN-theme-4-slug)

### Deep Dive (Sweep N)

#### <a name="sN-theme-1-slug"></a>Theme 1 — [full title]
**Why it's hot:** [2–3 sentences]
**Signals:**
- [signal with link + data point]
- [another signal]
**Angle for a post:** [1–2 sentences]

#### <a name="sN-theme-2-slug"></a>Theme 2 — [full title]
(same structure)

(repeat for each theme)

### Raw Signals (Sweep N)

#### HackerNews
| Title | Score | Comments | URL | Why it matters |
|-------|-------|----------|-----|----------------|

#### GitHub Trending
| Repo | Stars Today | Description | URL | What it does |
|------|-------------|-------------|-----|--------------|

#### Google AI Blog
- **[Title]** ([Date]) — summary — [URL]

#### ArXiv Papers
- **[Title]** ([Authors]) — why it matters — [URL]
  <details><summary>Abstract</summary>[full abstract]</details>

#### X / Twitter Signals
- @[handle]: "[snippet]" — angle: [note]

#### Star History Notes
[observations]

---
```

Important: use `sN-...` prefixes (s1-, s2-, s3-) on anchor names so later sweeps in the same file don't collide.

### Step 10 — Commit and push

```bash
cd <YOUR_LOCAL_REPO_DIR>
git add content-curator/research-MMDDYY.md
git commit -m "research: sweep N/3 for MM/DD/YY"
git push origin main
```

If push fails, keep the file and log the failure — do not delete.

### Step 11 — Print run summary

```
Sweep complete — MM/DD/YY HH:MM UTC (sweep N/3)
File: content-curator/research-MMDDYY.md (appended)
Pushed: [yes | no — reason]
Items: HN=[N] GitHub=[N] Blog=[N] ArXiv=[N] Twitter=[N] StarHistory=[ok|no data]
Failures: [none | source: reason]
```
