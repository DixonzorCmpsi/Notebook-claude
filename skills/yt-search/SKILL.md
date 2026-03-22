---
name: yt-search
description: Search YouTube for videos. Free — no API key required. Use when the user wants to find YouTube videos, tutorials, or other video content, or says "find videos about X", "search YouTube for", "look up on YouTube".
user-invocable: true
argument-hint: <search query> [count]
---

# YouTube Search

Free YouTube search via yt-dlp — no API key, no credits, no cost.

## Setup

Requires yt-dlp (installed once):

```bash
pip install yt-dlp
```

The search script is at `scripts/yt_search.py` inside this skill directory.

## Running a Search

```bash
python ~/.claude/skills/yt-search/scripts/yt_search.py "QUERY" --limit 20
```

**Options:**

| Flag | Default | Description |
|------|---------|-------------|
| `--limit N` | 20 | Max results (1–50) |
| `--after YYYYMMDD` | — | Only videos uploaded after this date |
| `--json` | — | Output as JSON instead of table |

**Examples:**

```bash
# Basic search
python ~/.claude/skills/yt-search/scripts/yt_search.py "claude code skills" --limit 20

# Last month only
python ~/.claude/skills/yt-search/scripts/yt_search.py "AI agent harness" --limit 20 --after 20250201

# JSON output for piping / programmatic use
python ~/.claude/skills/yt-search/scripts/yt_search.py "agentic AI" --limit 10 --json
```

## Output

Each result includes:
- `title` — video title
- `channel` — channel name
- `views` / `views_text` — view count
- `duration` — video length
- `published` — upload date (when available)
- `url` — full YouTube URL

## Multi-Query Workflow (Deduplicated)

When covering a topic from multiple angles, run 2–3 searches and deduplicate by video ID:

```bash
python ~/.claude/skills/yt-search/scripts/yt_search.py "AI agent harness problem" --limit 20 --json
python ~/.claude/skills/yt-search/scripts/yt_search.py "agentic AI security 2025" --limit 20 --json
python ~/.claude/skills/yt-search/scripts/yt_search.py "agent control problem" --limit 20 --json
```

Merge results, deduplicate on `video_id`, sort by `views` descending, take top 20.

## Getting Transcripts (Optional)

yt-dlp can also pull captions from videos that have them:

```bash
# Auto-generated captions (saves as .vtt file)
yt-dlp --write-auto-subs --sub-format vtt --skip-download "VIDEO_URL" -o "%(title)s"
```

## Notes

- yt-dlp uses YouTube's public metadata — no login required
- `--after` filtering may not work in flat-playlist/search mode; filter results by `published` date in post-processing if needed
- Rate limiting is rare for searches; if hit, wait 60 seconds and retry
