---
name: problem-to-app
description: Start from a problem or an area of life - childcare, couples' challenges, learning, a hobby, a small business chore - and propose three (or --count N) concrete products that could solve it, each in a different form (mobile app, web app, AI assistant, bot, browser extension, device or anything else), with who it is for, the pain it removes, how it works, a small MVP, how it earns money, likely competitors and the biggest risk, plus one recommended pick. Report in chat; later rounds give more, expand one or save one as a note. Nothing is built or sent. Use when you look for a project or business idea to build and monetise, and have a problem rather than an idea; to widen an existing idea, use /pg:brainstorm, to critique one, /pg:ideate.
argument-hint: "<the problem or area> [--count N]"
---

# /pg:problem-to-app <the problem or area> [--count N]

Goes from a problem to a few product ideas worth building. Few and worked out, not many and shallow: `--count` sets how many proposals the first round gives (default 3, at most 7).

## Steps

1. Read the problem. Ask no questions first: pick the most likely reading, state it with your assumptions in one or two lines at the top of the report, and name the people who have the problem. Stop and ask only when the input is too short to read at all.
2. Map the problem before proposing anything, briefly and in the report: two to four concrete situations where it hurts, who pays for it today (money, time, stress) and how people cope now.
3. Generate more candidates than needed, from different angles: different people with the problem, different moments in their day, different forms (mobile app, web app, AI assistant or agent, chat bot, browser extension, marketplace, device or hardware, a service with software behind it). Keep the strongest ones, so that each proposal uses a different form or serves a different group, and drop ideas that are generic or that a big existing product already does well.
4. Write the report in the chat reply itself, in the language of the input:

   ```markdown
   # 🧩 <the problem in a few words>

   > <the problem as you understand it> - for: <who> - assumptions: <...>

   **Where it hurts:** <situations, who pays for it, how people cope now>

   ## 1. <working name> - <form>
   - **For whom:** <...>
   - **Pain it removes:** <...>
   - **How it works:** <two or three sentences, with one example of use>
   - **MVP:** <what a first version for a weekend or a month includes>
   - **How it earns:** <model and a rough price point>
   - **Competitors:** <what exists, marked as a guess>
   - **Biggest risk:** <...>

   ## 2. ...

   ---

   ## ⭐ Recommendation
   <which proposal to try first and why, in two or three sentences, and the first step to test it>
   ```

5. End with one line on how to continue: "more", "expand #n", "other forms", "check #n on the web", or "save #n".
6. Later rounds in the same conversation:
   - **more**: new proposals from angles not used yet, numbered on from the last, with no repeats;
   - **expand #n**: one proposal in depth - main user flows, features of the MVP and later, monetisation options, how to reach the first users, what to validate first;
   - **other forms**: the best proposal again in two or three different forms;
   - **check #n on the web**: search for real competitors and prices when a web search tool is available, cite the sources and replace the guesses; without such a tool, say so;
   - **save #n**: hand the proposal to `/pg:idea-note`, which shows the note and saves it after a yes;
   - anything else: answer it in the same spirit.
7. When the user picks a proposal to build, offer `/pg:ideate` to think it through or `/pg:prd` for a build-ready specification; run neither without a yes.

## Rules

- Concrete, not generic: every proposal names a specific user, a specific moment and a specific way to earn.
- Mark guesses as guesses: markets, prices and competitors are not checked unless the user asks.
- Be honest about weak spots: a proposal with a big risk keeps it in the report.
- No implementation: no code, files or commits; saving goes only through `/pg:idea-note` on request.
- Nothing is sent or published anywhere.
