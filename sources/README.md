# sources/

Drop any local files here before running a research session.
Claude will automatically detect and upload everything in this folder to NotebookLM alongside the YouTube sources.

## Supported formats

| Format | Extensions |
|--------|-----------|
| PDF | `.pdf` |
| Markdown | `.md` |
| Plain text | `.txt` |
| Word document | `.docx` |
| Audio | `.mp3`, `.wav`, `.m4a`, `.aac`, `.flac`, `.ogg` |
| Video | `.mp4`, `.mov`, `.avi`, `.mkv`, `.webm` |
| Image | `.jpg`, `.jpeg`, `.png`, `.gif`, `.webp`, `.heic` |

## Examples

- Your own DSL / language spec (`dsl-spec.md`)
- Research papers (`paper.pdf`)
- Meeting notes, blog drafts, design docs (`.txt`, `.md`)
- Audio interviews (`.mp3`)
- Whiteboard photos (`.jpg`)

## Notes

- Files stay in this folder — they are not deleted after upload
- Add `.gitignore` entries for anything sensitive you don't want committed
- This folder itself (`sources/README.md`) is always safe to commit
