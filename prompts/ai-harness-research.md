# AI Agent Harness Problem — Research Prompt

This is the prompt that produced the `ai-harness-problem.pptx` in this repo.
Use it as a template for similar deep-research → slide deck workflows.

---

```
Use the yt-search skill to search YouTube for videos about the "AI agent harness problem"
published in the last month. Run these three searches and combine the results, keeping only
unique videos, capped at 20 total. Rank by views descending:

  1. "AI agent harness problem"
  2. "AI agent security harness"
  3. "agentic AI control problem 2025"

Show me the final list — title, channel, views, duration, URL — before proceeding.

Then create a new NotebookLM notebook called "AI Agent Harness Problem".

Add all the YouTube video URLs as sources.

Also add this text as a source titled "My Context — DSL & OpenCode":

---
The AI agent harness problem refers to the challenge of constraining, controlling, and
securing AI agents so their actions are predictable, auditable, and safe. The core tension
is that agents need enough freedom to be useful but enough constraint to be trustworthy.

OpenCode, OpenFang, and OpenClaw represent a new wave of open-source AI agent runtimes
that are closer to solving this problem than most people realize. OpenCode in particular
has an architecture that is already almost-secure by design — its permissioned tool
system, hooks, and CLAUDE.md scoping give it the bones of a real harness.

The creator of this presentation (Dixon) is actively building a DSL (domain-specific
language) on top of OpenCode that makes agent actions deterministic — meaning every
action an agent can take is declared, typed, and bounded at the language level before
the agent ever runs. This is the missing layer that turns OpenCode from "almost secure"
into "actually secure." The DSL effectively becomes the harness, codifying what an agent
is allowed to do the same way a type system codifies what a program can compute.

This work is ongoing and early stage but represents a meaningful attempt at a bottom-up
solution to the harness problem — one that doesn't require replacing the agent runtime,
just constraining it with a declarative action vocabulary.
---

Wait for all sources to finish processing (poll status until complete).

Then ask NotebookLM to generate a slide deck with the following brief:

  Title: "The AI Agent Harness Problem: Why Your Agents Are Running Wild (And How We Fix It)"

  Narrative arc and required slides:
  1. HOOK — Open with a punchy, slightly alarming framing. Agents are getting powerful
     fast. Nobody agrees on how to control them. This is a bigger deal than it sounds.

  2. WHAT IS THE HARNESS PROBLEM — Define it clearly but make it feel visceral. Use an
     analogy (a car with no seatbelts, a power tool with no guard, etc.). The harness is
     the layer between "agent has capability" and "agent has permission to use it."

  3. WHY IT'S HARD — Agents are non-deterministic by nature. Prompts aren't contracts.
     Permissioning is an afterthought in most frameworks. Show the gap.

  4. HOW BAD COULD IT GET — Real threat surface: prompt injection, tool misuse, runaway
     loops, supply chain in agent skills. Make the audience feel it.

  5. THE OPEN SOURCE CONTENDERS — Spotlight OpenCode, OpenFang, and OpenClaw as three
     open-source runtimes making genuine progress. Compare their approaches to the harness
     problem. Who's closest? What's still missing?

  6. OPENCODE'S ALMOST-SECURE ARCHITECTURE — Deep dive on why OpenCode is the most
     promising foundation: permissioned tools, hooks, scoped CLAUDE.md, settings layering.
     It's the one that's closest to a real harness already baked in.

  7. THE MISSING LAYER — A harness isn't just permissions. You need determinism.
     You need to be able to declare what an agent CAN do before it runs, not just
     hope the prompt keeps it in line.

  8. DSL AS THE SOLUTION — Introduce the idea of a domain-specific language built on top
     of OpenCode that makes every agent action declared, typed, and bounded at the language
     level. The DSL IS the harness. This is Dixon's ongoing work.

  9. WHAT THIS UNLOCKS — If we solve the harness problem, agents go from "impressive demos"
     to "trusted infrastructure." Show the vision: auditable, composable, safe agents.

  10. CALL TO ACTION — The harness problem is open. The work is happening in the open.
      OpenCode, OpenFang, OpenClaw, and DSL experiments like this one are the frontier.
      Get involved.

  Tone: Engaging, slightly irreverent, smart but not academic. Think TED talk meets
  hacker conference. Use strong visual metaphors. Every slide should have a punchy
  headline that works as a standalone statement.

Once the slide deck is generated, download it as a .pptx file and save it to the current
project folder as "ai-harness-problem.pptx".
```
