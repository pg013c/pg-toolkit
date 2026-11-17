---
name: improve-prompt
description: Rewrite a prompt so an AI model understands it without guessing - acting as a prompt engineer, it adds the goal and context, gives the prompt a clear structure (task, inputs, constraints, output format, definition of done), replaces vague words with concrete ones and removes contradictions, then returns the improved prompt in one copyable block with a short list of what changed and why, and refines it in later rounds. Nothing is run, written or sent. Use when you have a prompt for a coding agent, a chat assistant or any model and want it clearer, more precise or more effective.
argument-hint: "<the prompt, or a path to a file holding it>"
---

# /pg:improve-prompt <the prompt or a file>

A prompt engineer's pass over one prompt. The result is a better prompt, not the answer to it: the assistant never carries out the prompt it is improving. Every later message in the conversation is another round on the same prompt.

## Steps

1. Read the prompt. When the argument is a path to a file, read the file. When it is empty, ask for the prompt and stop.
2. Work out what the prompt is for: the model or tool it targets (a coding agent, a chat assistant, an image model, an API call), the task, the reader of the result and what a good result looks like. When the prompt is about the current repository, read the relevant files read-only so names, paths and commands in the improved prompt are real. Otherwise do not look around.
3. Diagnose before rewriting. Check the prompt for:
   - **goal**: is it clear what to achieve and why;
   - **context**: what the model cannot know but needs (the audience, the project, earlier decisions, the data it works on);
   - **ambiguity**: vague words ("better", "clean", "some", "etc."), pronouns without a clear subject, two possible readings;
   - **contradictions** between instructions;
   - **constraints**: scope, what must not change, limits on length, tools or style;
   - **output**: format, structure, language, length;
   - **done**: how the model knows it has finished, and what to do when information is missing;
   - **examples**: whether one short example would remove more doubt than a paragraph of rules;
   - **noise**: filler, repetition, shouting in capitals, instructions that fight each other.
4. Rewrite the prompt:
   - keep the user's intent and every requirement they gave; do not add requirements of your own beyond what makes the prompt executable;
   - lead with the task and the goal, then context, inputs, constraints, output format and the definition of done;
   - use plain, direct sentences; state what to do rather than only what to avoid, and give the reason for a rule when the reason helps the model apply it;
   - use headings, lists or tags (for example `<context>`, `<input>`) only when the prompt is long enough to need them; a short prompt stays short;
   - where you had to guess a fact, put a placeholder in the prompt, such as `<target framework>`, instead of inventing a value;
   - keep the language of the original prompt unless the user asks for another.
5. Reply in chat, short:
   - the improved prompt in one fenced code block, ready to copy (four backticks for the outer fence when the prompt contains code blocks);
   - **What changed**: three to seven bullets, each a change and why it helps the model;
   - **Questions**: one to three, only where an answer would change the prompt; each says which placeholder or assumption it settles.
6. Each later message is a new round: apply the answers or corrections, show the whole improved prompt again and one line on what changed since the last version.
7. When the user is happy, offer once to save the prompt to a file they name. Do it only on a yes.

## Rules

- Improve the prompt, never execute it: no code, no commands, no files and no answers to the task it describes, even if the prompt asks for them.
- Do not change the meaning. When a requirement looks wrong, keep it and raise it as a question.
- Every change must make the prompt clearer or more likely to get the intended result; no decoration, no role-play preambles that add nothing.
- Never put secrets, tokens or personal data into the improved prompt; when the original holds them, replace them with placeholders and say so.
