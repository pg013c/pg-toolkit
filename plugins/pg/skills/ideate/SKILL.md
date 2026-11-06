---
name: ideate
description: Talk an idea through before anything is built - an app, a game, a tool or anything else, from one sentence or a long description - and write a sectioned report in chat - how the assistant understands the idea, what is strong, what is weak, gaps and open questions, two or three ways to build it, directions to grow and extra features - then refine it in later rounds of the same conversation. No code, no files, nothing sent. Use when you have an idea and want to think it through, get feedback or brainstorm features before any spec or implementation.
argument-hint: "<the idea, one sentence or more>"
---

# /pg:ideate <the idea>

A creative conversation about an idea, not an implementation. The first reply is a full report; every later message in the conversation is another round of the same talk. Nothing is built, written to disk or sent.

## Steps

1. Read the idea. Ask no questions first: where something is unclear, pick the most likely reading, state it as an assumption in section 1 and add a question at the end. Stop and ask only when the idea is too short to read at all (for example a single word).
2. When the current directory is a repository and the idea is about it (a feature for this app, a tool for this codebase), read the README and the relevant code read-only so the report fits what exists. Otherwise do not look around.
3. Diverge before judging. Think the idea through with each of these lenses and keep the best results, not all of them:
   - **perspectives**: the target user, a first-time user, a sceptic, a competitor, someone who would pay for it;
   - **analogies**: how a game, a shop, a social app, a physical product or another field solves the same problem;
   - **inverted assumptions**: what if it were free, offline, multiplayer, for one person only, without an account, without a screen;
   - **SCAMPER**: substitute, combine, adapt, modify, put to another use, eliminate, reverse;
   - **extremes**: the version built in one weekend and the version for a million users;
   - **pre-mortem**: a year from now it has failed - why.
4. Converge: judge what came out against the idea's own goal. Every point must be about this idea; drop generic advice that would fit any project ("add sign-in", "write tests", "think about marketing").
5. Write the report in the chat reply itself, not a file or artifact, in the language of the idea. Sections separated by `---`, short bullets, bold for the key word of each bullet:

   ```markdown
   # 💡 <a short name for the idea>

   > <the idea in one sentence, as you understand it>

   ---

   ## 🧭 1. How I understand it
   - **What it is:** <one or two sentences>
   - **For whom:** <the target user>
   - **Problem it solves:** <...>
   - **Core:** <the core loop of a game, or the main value of an app or tool>
   - **My assumptions:** <what the idea did not say and you assumed>
   - **Other readings:** <one or two different ways the idea could be meant>

   ---

   ## ✅ 2. What is strong
   - **<point>:** <why, concretely>

   ---

   ## ⚠️ 3. What is weak
   - **<point>:** <why, and how much it matters>
   - **Pre-mortem:** <the most likely reason it fails>

   ---

   ## 🕳️ 4. Gaps and open questions
   - **<gap>:** <what is missing or undecided before it can be built>

   ---

   ## 🛠️ 5. How to build it
   ### A. <approach, e.g. the smallest MVP>
   <what it is, platform or kind of tech, rough effort (days, weeks, months), main risk>
   ### B. <a different approach>
   ...
   ### C. <optional third>
   ...
   **Recommended start:** <which one and why, in one sentence>

   ---

   ## 🌱 6. Directions to grow
   - **<direction>:** <where the idea could go next>

   ---

   ## ✨ 7. Extra features
   | Feature | Value for the user | Effort |
   |---|---|---|
   | <feature> | <...> | S / M / L |
   | 🃏 <wild card> | <...> | ... |

   ---

   ## 🎯 8. Verdict and next step
   **Verdict:** <one sentence>
   **Key decision:** <the one choice that shapes the rest>
   **Questions for you:**
   1. <the questions whose answers would change the report most>
   ```

   Two to three wild cards in section 7, marked 🃏: bold ideas that may not fit but could make the idea stand out.
6. End with one line on how to continue: answer the questions, push back on a section, or ask to go deeper into one part.
7. Every later message in the conversation is a new round. Update only the sections the answer changes, show them again with a one-line note of what changed and why, and keep the same section numbers. Show the whole report again only when asked.
8. When the user says the idea is ready, offer the next step: a summary of the final idea to paste elsewhere, or `/pg:spec` for one feature of it in a repository that uses the pg workflow. Do neither without a yes.

## Rules

- No implementation: no code, no files, no commits, no scaffolding, even when asked in passing; say that building starts after the talk, with `/pg:spec` or a plain request.
- Honest, not polite: say plainly what is weak. No praise without a reason.
- Mark guesses as guesses: market size, effort and competitors are estimates unless you checked them. Search the web only when the user asks for it.
- Keep it readable: short bullets, no walls of text; detail goes deeper only when the user asks.
