---
name: workshop
description: Design a workshop or training that changes how people work, not just what they have heard - audience and outcomes, a pre-survey that collects participants' own tasks, a timed agenda, modules with hands-on exercises on those tasks, a facilitator guide, materials, a feedback survey with a recommendation score, and a follow-up plan to check the change stuck. Writes a folder of markdown files and can hand the slides to /pg:deck. Use for internal workshops, client trainings, onboarding sessions or course modules, on any subject.
argument-hint: "<subject> [--for <audience>] [--length <hours or days>] [--out <dir>]"
---

# /pg:workshop <subject> [--for <audience>] [--length <hours or days>] [--out <dir>]

## Steps

1. Interview, one question at a time, each with your recommended answer, until these are settled:
   - who attends (role, level, how many);
   - what they should be able to do afterwards: three to five outcomes written as observable actions;
   - the format (on site, live online, self-paced) and the length, with start and end times;
   - the tools participants have;
   - constraints: data or code they may not use, security rules;
   - whether a pre-survey can be sent, and how far ahead;
   - how success will be measured.
   `--for` and `--length` count as settled unless they are ambiguous (for "1 day", propose 09:00 to 17:00). Merge items into one question when the answer is obvious; aim for four to seven questions.
2. Write the plan in the output folder (`--out`, else `docs/workshops/<slug>/`):
   - `program.md`: the audience, outcomes, prerequisites, format and length; a timed agenda (start and end per block, breaks included, hands-on at least a third of the time excluding breaks, with the hands-on total stated; for a single team, a closing block that drafts a team agreement); per module its outcome, the key ideas (at most three), the exercise, and how the facilitator checks it worked.
   - `exercises.md`: per exercise the goal, the duration (fitting its block), the starting material, step-by-step instructions for participants, a worked example, the expected result, common mistakes, and a harder variant for fast participants. Exercises use the participants' own tasks from the pre-survey wherever possible; until those answers exist, use invented, generic tasks and mark where a participant's task will replace them. When participants' code may not be used with the tools, run the exercises on a sandbox repository and add getting written approval to the facilitator's preparation.
   - `facilitator.md`: preparation checklist (accounts, access, rooms, materials), timing cues per block, questions to ask the room, what to cut when running late, and how to handle the common objections to the subject.
   - `surveys.md`: a pre-survey (role, current practice, the three tasks that take them the most time, consent to use one of them as an exercise, what they want to get out of it) and a feedback survey (outcome by outcome: can you do this now, 1 to 5; how likely are you to recommend it, 0 to 10, with how to compute the score; what to keep, what to change).
   - `follow-up.md`: what participants do in the weeks after (a small task per week), the check-in, and how the outcome is measured against the starting point.
   Before showing it, check that the block times add up to the length and that the hands-on total is right.
3. Show the agenda and the outcomes in chat with the folder path, and offer the next steps: slides for the modules with `/pg:deck <folder>/program.md`, a shorter or longer variant, or a version for another audience.
4. When the folder is inside the repository, offer the commit `docs(workshop): <slug>` and make it only after a yes.

## Rules

- Outcomes are things participants do, checked in the room, not topics covered.
- Every module has practice; a module that is only talk is shortened or merged.
- Times add up to the length given, breaks included.
- Nothing confidential from a client or employer in the materials; examples are invented or taken from the participants' own submissions with their consent.
