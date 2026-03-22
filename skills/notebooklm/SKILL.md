<!--
  SNAPSHOT: notebooklm-py v0.3.4 (2026-03-22)
  This file is a reference copy. setup.sh / setup.ps1 run `notebooklm skill install`
  which installs the authoritative version tied to your installed notebooklm-py package.
  To update: pip install --upgrade notebooklm-py && notebooklm skill install
-->
---
name: notebooklm
description: Complete API for Google NotebookLM - full programmatic access including features not in the web UI. Create notebooks, add sources, generate all artifact types, download in multiple formats. Activates on explicit /notebooklm or intent like "create a podcast about X"
---
<!-- notebooklm-py v0.3.4 -->


# NotebookLM Automation

Complete programmatic access to Google NotebookLM—including capabilities not exposed in the web UI. Create notebooks, add sources (URLs, YouTube, PDFs, audio, video, images), chat with content, generate all artifact types, and download results in multiple formats.

## Installation

**From PyPI (Recommended):**
```bash
pip install notebooklm-py
```

After installation, install the Claude Code skill:
```bash
notebooklm skill install
```

## Prerequisites

**IMPORTANT:** Before using any command, you MUST authenticate:

```bash
notebooklm login          # Opens browser for Google OAuth
notebooklm list           # Verify authentication works
```

If commands fail with authentication errors, re-run `notebooklm login`.

## When This Skill Activates

**Explicit:** User says "/notebooklm", "use notebooklm", or mentions the tool by name

**Intent detection:** Recognize requests like:
- "Create a podcast about [topic]"
- "Summarize these URLs/documents"
- "Generate a quiz from my research"
- "Turn this into an audio overview"
- "Create flashcards for studying"
- "Generate a video explainer"
- "Make an infographic"
- "Create a mind map of the concepts"
- "Download the quiz as markdown"
- "Add these sources to NotebookLM"

## Quick Reference

| Task | Command |
|------|---------|
| Authenticate | `notebooklm login` |
| List notebooks | `notebooklm list` |
| Create notebook | `notebooklm create "Title"` |
| Set context | `notebooklm use <notebook_id>` |
| Add URL source | `notebooklm source add "https://..."` |
| Add YouTube | `notebooklm source add "https://youtube.com/..."` |
| Add inline text | `notebooklm source add "My notes" --title "Title"` |
| List sources | `notebooklm source list --json` |
| Wait for source | `notebooklm source wait <source_id>` |
| Chat | `notebooklm ask "question"` |
| Generate podcast | `notebooklm generate audio "instructions"` |
| Generate slide deck | `notebooklm generate slide-deck "instructions" --format detailed` |
| Generate infographic | `notebooklm generate infographic` |
| Generate mind map | `notebooklm generate mind-map` |
| Generate quiz | `notebooklm generate quiz` |
| Generate flashcards | `notebooklm generate flashcards` |
| Check artifacts | `notebooklm artifact list --json` |
| Download as PPTX | `notebooklm download slide-deck ./slides.pptx --format pptx` |
| Download audio | `notebooklm download audio ./podcast.mp3` |
| Download infographic | `notebooklm download infographic ./image.png` |

## Generation Types

| Type | Command | Download format |
|------|---------|----------------|
| Podcast | `generate audio` | .mp3 |
| Video | `generate video` | .mp4 |
| Slide Deck | `generate slide-deck` | .pdf / .pptx |
| Infographic | `generate infographic` | .png |
| Report | `generate report` | .md |
| Mind Map | `generate mind-map` | .json |
| Quiz | `generate quiz` | .json/.md/.html |
| Flashcards | `generate flashcards` | .json/.md/.html |

## Processing Times

| Operation | Typical time |
|-----------|-------------|
| Source processing | 30s - 10 min |
| Mind-map, report | instant - 5 min |
| Quiz, flashcards | 5 - 15 min |
| Audio (podcast) | 10 - 20 min |
| Slide deck, infographic | 10 - 30 min |
| Video | 15 - 45 min |

## Error Handling

| Error | Action |
|-------|--------|
| Auth/cookie error | `notebooklm login` |
| Rate limit | Wait 5-10 min, retry |
| Generation failed | Check `artifact list`, retry later |
| Download fails | Check artifact status first |

Always use `--json` flag for machine-readable output in automated workflows.
