# YouTube Research → NotebookLM Workflow

Search YouTube from Claude Code, push results to NotebookLM, and get back podcasts, slide decks, infographics, and more — at zero token cost.

## What This Does

```
Claude Code
  └── /yt-search "your topic" 20
        └── YouTube (via TranscriptAPI)
              └── 20 video URLs
                    └── NotebookLM notebook
                          └── Analysis + deliverable (slides, podcast, etc.)
                                └── Saved to your project folder
```

All heavy lifting — transcription, RAG, synthesis, generation — runs inside NotebookLM for free. Claude Code only spends tokens on the search query and the handoff.

---

## Prerequisites

| Requirement | Version | Install |
|-------------|---------|---------|
| [Claude Code](https://claude.ai/download) | Latest | `npm install -g @anthropic-ai/claude-code` |
| [Python](https://python.org) | 3.10+ | python.org |
| [Node.js](https://nodejs.org) | 18+ | nodejs.org |
| Google account | — | For NotebookLM |
| TranscriptAPI account | — | Free (100 credits) — set up automatically on first use |

---

## Quick Start

```bash
git clone https://github.com/DixonzorCmpsi/Notebook-claude.git
cd Notebook-claude

# Mac/Linux
# macOS users: Ensure Python 3.10+ is installed (e.g. `brew install python`) 
# and Homebrew is on your PATH (e.g. `export PATH="/opt/homebrew/bin:$PATH"`)
bash setup.sh

# Windows (PowerShell)
.\setup.ps1
```

Then two manual steps:

```bash
# 1. Authenticate with NotebookLM (opens browser once, saves session)
notebooklm login

# 2. Open Claude Code in this folder
claude
```

Your `TRANSCRIPT_API_KEY` for YouTube search will be set up automatically the first time you use `/yt-search` — the skill will walk you through a 30-second email registration.

---

## How to Use

### Option 1: Full pipeline in one prompt

Open Claude Code (`claude`) in this folder and paste any prompt from [`prompts/`](prompts/). Example:

> Search YouTube for "AI agent frameworks 2025", grab the top 15 videos, create a NotebookLM notebook called "Agent Frameworks Research", upload all the video URLs, then generate an infographic summarizing the top frameworks and save it here.

### Option 2: Step by step

**Step 1 — Search YouTube:**
```
/yt-search claude code skills 20
```
Returns: title, channel, views, duration, URL for each result.

**Step 2 — Push to NotebookLM:**
```
Create a new NotebookLM notebook called "Claude Code Skills" and add all those video URLs as sources.
```

**Step 3 — Analyze and generate:**
```
Based on those videos, what are the top 5 Claude Code skills? Then generate a slide deck and download it as a .pptx file.
```

---

## Available Deliverables

Ask for any of these once sources are loaded in NotebookLM:

| Deliverable | Prompt example | Output | Wait time |
|-------------|---------------|--------|-----------|
| Slide deck | `generate a slide deck in detailed format` | .pptx / .pdf | 10-30 min |
| Podcast | `create an audio overview as a deep-dive` | .mp3 | 10-20 min |
| Infographic | `generate an infographic in portrait style` | .png | 10-30 min |
| Mind map | `generate a mind map` | .json | instant |
| Report | `generate a study guide report` | .md | 5-15 min |
| Quiz | `generate quiz questions` | .json / .md | 5-15 min |
| Flashcards | `generate flashcards` | .json / .md | 5-15 min |

---

## Skills Installed

| Skill | Trigger | What it does |
|-------|---------|--------------|
| `yt-search` | `/yt-search [query] [count]` | Searches YouTube via TranscriptAPI, returns ranked video list |
| `notebooklm` | `/notebooklm` or plain language | Full NotebookLM control — create, add sources, generate, download |

Skills are installed globally to `~/.claude/skills/` by the setup script and available in any Claude Code project.

---

## Repo Structure

```
.
├── README.md
├── CLAUDE.md                          # Loaded by Claude Code in this folder
├── setup.sh                           # Mac/Linux setup
├── setup.ps1                          # Windows setup
├── .gitignore
├── .claude/
│   ├── settings.local.json            # Your local permissions (gitignored)
│   └── settings.local.json.template   # Checked in — copy of safe defaults
├── skills/
│   ├── yt-search/
│   │   ├── SKILL.md                   # YouTube search skill
│   │   └── scripts/
│   │       └── tapi-auth.js           # TranscriptAPI auth (Node, no deps)
│   └── notebooklm/
│       └── SKILL.md                   # NotebookLM skill (reference snapshot)
└── prompts/
    ├── full-pipeline.md               # Generic one-shot template
    └── ai-harness-research.md         # Example: AI agent harness deck
```

---

## Troubleshooting

**`notebooklm` not found after setup:**
Restart your terminal. Python's `Scripts/` directory may not be on PATH until you do. If you use Homebrew Python, you may need to add `export PATH="/opt/homebrew/bin:$PATH"` to your `~/.zshrc`.

**NotebookLM auth errors:**
Run `notebooklm login` again. Sessions expire after a few weeks.

**TranscriptAPI "invalid key" or "no credits":**
Run `node ~/.claude/skills/yt-search/scripts/tapi-auth.js status` to check, or sign up at [transcriptapi.com](https://transcriptapi.com) for more credits.

**Slide deck generation timed out:**
NotebookLM generation can take up to 30 minutes. The CLI times out at 5 minutes but the job keeps running. Check back with:
```bash
notebooklm artifact list --json
notebooklm download slide-deck ./output.pptx --format pptx
```

**NotebookLM source limit:**
Free accounts support 50 sources per notebook. Cap your searches at 45 to leave room for text sources.

**Windows: `setup.ps1` blocked by execution policy:**
```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

---

## Updating

```bash
# Pull latest skill updates
git pull

# Re-run setup to apply
bash setup.sh        # Mac/Linux
.\setup.ps1          # Windows

# Update notebooklm-py (use --break-system-packages if on Homebrew Python 3.12+)
pip install --upgrade notebooklm-py || pip install --upgrade --break-system-packages notebooklm-py
notebooklm skill install
```

---

## Credits

- **YouTube search** — [TranscriptAPI.com](https://transcriptapi.com) · [ZeroPointRepo/youtube-skills](https://github.com/ZeroPointRepo/youtube-skills)
- **NotebookLM automation** — [notebooklm-py](https://github.com/teng-lin/notebooklm-py) by teng-lin
- **Agent runtime** — [Claude Code](https://claude.ai/download) by Anthropic
chmod +x setup.sh if needed for permissions.

