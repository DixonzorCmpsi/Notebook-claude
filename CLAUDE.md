# YouTube Research → NotebookLM Workflow

## Onboarding

When a user opens this project without a specific request, greet them and ask these questions — one message, conversational:

1. **What topic** do you want to research? (e.g. "AI agent frameworks", "prompt engineering 2025", "open source LLMs")
2. **How many videos** — quick scan (5–10) or deep dive (15–20)?
3. **What deliverable** do you want at the end?
   - Slide deck (downloads as .pptx)
   - Infographic (downloads as .png)
   - Podcast / audio overview (downloads as .mp3)
   - Mind map (downloads as .json)
   - Report / study guide (downloads as .md)
   - Just the analysis — no file, chat only
4. **Any extra context?** — a specific angle, audience, framing, or your own notes you want woven into the output. Optional.
5. **Local files** — automatically check the `sources/` folder for any files. If files are present, tell the user what was found and confirm they should be included. If the folder is empty, mention they can drop PDFs, markdown docs, text files, etc. in `sources/` before running.

Once you have their answers, run the full pipeline without further prompting.

---

## Pipeline

### Step 1 — Search YouTube

```bash
python ~/.claude/skills/yt-search/scripts/yt_search.py "QUERY" --limit N --json
```

- Run 2–3 search queries for better coverage, deduplicate by video ID, sort by views descending
- Show the user the final video list (title, channel, views, duration, URL) before proceeding
- Ask if they want to swap anything out or continue

### Step 2 — Create NotebookLM notebook

```bash
notebooklm create "NOTEBOOK TITLE"
notebooklm use <notebook_id>
```

Add all video URLs as sources:
```bash
notebooklm source add "https://youtube.com/watch?v=VIDEO_ID"
```

If the user provided extra context text, add it as a text source:
```bash
notebooklm source add "USER CONTEXT TEXT" --title "My Context"
```

**Add any files found in `sources/`** (skip `sources/README.md`):
```bash
# Check what's in sources/
ls sources/

# Add each file — NotebookLM auto-detects type from extension
notebooklm source add ./sources/my-doc.pdf
notebooklm source add ./sources/dsl-spec.md
notebooklm source add ./sources/notes.txt
# etc.
```

Supported: `.pdf`, `.md`, `.txt`, `.docx`, `.mp3`, `.mp4`, `.jpg`, `.png`, and more.
Tell the user which files were added before proceeding.

Poll until all sources are ready:
```bash
notebooklm source list --json   # check all status == "ready"
```

### Step 3 — Generate deliverable

```bash
notebooklm generate slide-deck "BRIEF" --format detailed --no-wait --json
```

Poll for completion, then download to the project folder:
```bash
notebooklm download slide-deck ./output.pptx --format pptx --force --json
```

---

## Deliverable Commands

| Deliverable | Generate | Download |
|-------------|---------|---------|
| Slide deck | `generate slide-deck "brief" --format detailed` | `download slide-deck ./out.pptx --format pptx` |
| Infographic | `generate infographic --orientation portrait` | `download infographic ./out.png` |
| Podcast | `generate audio "focus on X" --format deep-dive` | `download audio ./out.mp3` |
| Mind map | `generate mind-map` | `download mind-map ./out.json` |
| Report | `generate report --format study-guide` | `download report ./out.md` |
| Quiz | `generate quiz` | `download quiz ./out.md --format markdown` |

Always use `--json` flag for machine-readable output. Use `--no-wait` then poll `artifact list --json` for long-running jobs.

---

## Skills

| Skill | How to invoke |
|-------|--------------|
| `/yt-search` | `python ~/.claude/skills/yt-search/scripts/yt_search.py "query" --limit 20` |
| `/notebooklm` | `notebooklm <command>` — see quick reference in the notebooklm skill |

---

## Notes

- NotebookLM supports up to 50 sources per notebook
- Source processing: 30 sec – 10 min per source
- Slide deck / infographic generation: 10–30 min (poll, don't wait inline)
- Use `notebooklm list` to see existing notebooks
- Use `--json` on all commands for reliable parsing
- If generation times out, the job is still running on Google's servers — poll `artifact list --json` and download when status is `completed`
