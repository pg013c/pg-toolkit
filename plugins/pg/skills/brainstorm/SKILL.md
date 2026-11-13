---
name: brainstorm
description: Generate as many ideas as possible around a starting idea - an app, a game, a tool, a feature or anything else - new features, variants, related products, directions to grow, other markets and uses, ways to earn, integrations and wild cards. Quantity first, no judging; several subagents each take a different creative lens, the results are merged into numbered clusters in chat, and later rounds ask for more, expand one idea, deepen a cluster or combine ideas. No code, nothing sent. Use when you want a wide list of ideas related to yours, not a critique; for strengths, weaknesses and ways to build, use /pg:ideate.
argument-hint: "<the idea, one sentence or more> [--count N]"
---

# /pg:brainstorm <the idea> [--count N]

Divergent thinking only: widen the field around the user's idea and judge as little as possible. The first reply is a numbered list of ideas in clusters; every later message in the conversation is another round. `--count` sets the target number of ideas for the first round (default 50).

## Steps

1. Read the idea. Ask no questions first: pick the most likely reading and state it, with your assumptions, in one or two lines at the top of the report. Stop and ask only when the idea is too short to read at all (for example a single word).
2. When the current directory is a repository and the idea is about it, read the README and the relevant code read-only, so the ideas build on what exists and do not repeat what is already there. Otherwise do not look around.
3. Diverge in parallel. Start one subagent per lens, each with the idea, your reading of it, what exists (from step 2), the target count divided by the number of lenses, and the rule to give one line per idea - a short name and one sentence - with no judging. Lenses:
   - **people**: other users, personas, roles, groups, a child, an expert, a company;
   - **SCAMPER**: substitute, combine, adapt, modify, put to another use, eliminate, reverse;
   - **analogies**: how games, shops, social apps, physical products, nature or another field solve the same thing;
   - **inverted assumptions**: free, offline, multiplayer, for one person, without an account, without a screen, without the core feature;
   - **scale and time**: the weekend version, the million-user version, the version in five years, the daily habit;
   - **technology**: AI, sensors, voice, automation, data the product already has, APIs it could use;
   - **business**: ways to earn, partners, adjacent markets, a B2B version, a platform others build on;
   - **community and growth**: sharing, collaboration, content made by users, word of mouth.
   When subagents are not available, go through the lenses yourself, one at a time, and finish each before the next.
4. Merge: drop duplicates and near-duplicates, keep the most concrete wording, and group what is left into 5 to 8 clusters that fit this idea (for example "Core features", "Related products", "Directions to grow", "Other users and markets", "Ways to earn"), plus a final "🃏 Wild cards" cluster for bold ideas that may not fit. Number the ideas through the whole list, so they can be referred to later. Drop generic advice that would fit any project ("add sign-in", "write tests").
5. Write the report in the chat reply itself, not a file or artifact, in the language of the idea:

   ```markdown
   # 🌪️ <a short name for the idea>

   > <the idea in one sentence, as you understand it> - assumptions: <...>

   ## <cluster>
   1. **<idea name>** - <one sentence>
   2. ...

   ## <next cluster>
   ...

   ## 🃏 Wild cards
   ...

   ---

   ## ⭐ Worth a closer look
   - **#<n> <name>:** <why, in one sentence>
   ```

   "Worth a closer look" has 5 to 7 picks and is the only judging in the report.
6. End with one line on how to continue: "more", "expand #n", "more like <cluster>", "combine #a and #b", or "save".
7. Later rounds in the same conversation:
   - **more**: a new batch from the lenses that gave the least so far, with no repeats of earlier ideas, numbered on from the last;
   - **expand #n**: 8 to 12 sub-ideas of one idea, numbered `n.1`, `n.2`, ...;
   - **more like <cluster>**: a new batch for that cluster only;
   - **combine #a and #b**: 3 to 5 hybrids;
   - anything else: answer it as a brainstorm, still listing ideas rather than judging them.
   Show only the new ideas; show the whole list again only when asked.
8. When the user is done, offer the next step: a markdown file with the whole list in the current directory, `/pg:ideate` for one picked idea, or `/pg:spec` for one feature in a repository that uses the pg workflow. Do none of them without a yes.

## Rules

- Quantity first: do not reject, rank or criticise ideas during the brainstorm, beyond "Worth a closer look".
- Every idea is about this idea: concrete, one line, no filler.
- No implementation: no code, no scaffolding, no commits; a file only on the user's yes in step 8.
- Mark guesses as guesses: markets and competitors are not checked unless the user asks for a web search.
- Nothing is sent or published anywhere.
