# YouTube Research → NotebookLM Workflow

This project automates YouTube research using Claude Code + NotebookLM.

## What This Does

1. **Search YouTube** (`/yt-search`) — find videos on any topic using TranscriptAPI
2. **Upload to NotebookLM** (`/notebooklm`) — push video URLs as sources
3. **Analyze & Deliver** — NotebookLM handles analysis, Claude Code receives results

All heavy analysis (RAG, synthesis, infographics, podcasts, slide decks) runs inside NotebookLM at zero token cost.

## One-Time Setup

### 1. TranscriptAPI Key (for yt-search)
If `$TRANSCRIPT_API_KEY` is not set, the `/yt-search` skill will walk you through registration (100 free credits, no card).

### 2. NotebookLM Login
Run this once in a terminal — it opens Chrome to authenticate your Google account:
```bash
notebooklm login
```

## Skills Available

| Skill | Trigger | What it does |
|-------|---------|--------------|
| `/yt-search` | `/yt-search claude code skills` | Search YouTube, get titles/URLs/views/duration |
| `/notebooklm` | `/notebooklm` or plain language | Full NotebookLM control |

## Example Prompts

### Full Pipeline (one shot)
```
Search YouTube for "claude code skills", grab the top 15 videos, create a new
NotebookLM notebook called "Claude Code Research", upload all the video URLs as
sources, then ask NotebookLM what the top 5 Claude Code skills are based on the
videos. Finally generate an infographic in a handwritten blueprint style summarizing
the findings and save it to this project folder.
```

### Step by step
```
/yt-search claude code skills 20
```
Then:
```
Create a new NotebookLM notebook called "Claude Code Research" and add all those
video URLs as sources.
```
Then:
```
Based on those videos, ask NotebookLM what the most commonly taught Claude Code
skills are. Then generate a mind map.
```

## NotebookLM Deliverables

Ask for any of these after sources are loaded:
- **Audio overview** (podcast-style) → `notebooklm generate audio`
- **Infographic** → `notebooklm generate infographic`
- **Slide deck** (downloads as .pptx) → `notebooklm generate slide-deck`
- **Mind map** → `notebooklm generate mind-map`
- **Quiz / Flashcards** → `notebooklm generate quiz`
- **Chat/Q&A** → just ask questions in plain language

## Notes

- NotebookLM supports up to 50 sources per notebook
- Source processing takes 30 sec – 10 min depending on video length
- Audio generation: ~10-20 min; Video: ~15-45 min
- Use `notebooklm list` to see your notebooks
