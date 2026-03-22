# Full Pipeline (One Shot)

Paste this into Claude Code to run the entire workflow in a single prompt.
Replace the bracketed values with your own.

---

```
Search YouTube for "[YOUR TOPIC]", grab the top [10-20] videos. Then create a
new NotebookLM notebook called "[YOUR NOTEBOOK NAME]" and upload all the video
URLs as sources. Wait for processing to complete. Then ask NotebookLM what the
top 5 insights are based on those videos. Finally, generate [a slide deck /
an infographic / an audio podcast] summarizing the findings and save it to
this project folder.
```

---

## Tips

- **Be specific on the topic** — the more specific the query, the better
  the source quality. Try 3 different search terms if one doesn't return
  enough relevant results.

- **Add your own context** — before generating, you can add a text source
  with your own framing, notes, or angle. NotebookLM will weave it in:

  ```
  Also add this as a text source titled "My Context":
  [paste your notes here]
  ```

- **Limit sources if you want faster results** — 5-10 focused sources
  often outperform 20 loosely-related ones.

- **Deliverable options** — replace the last line with any of:
  - `generate a slide deck in detailed format`
  - `generate an infographic in portrait orientation`
  - `generate an audio overview as a deep-dive podcast`
  - `generate a mind map`
  - `generate quiz questions`
  - `generate a study guide report`
