# Routines

Prompts for scheduled tasks in the Claude desktop app. Each one runs on its own every morning, searches the web and posts a digest to a Slack channel through an incoming webhook. They are not part of the `pg` plugin and need nothing from it.

| Routine | What it posts | Webhook variable |
|---|---|---|
| [`daily-ai-news`](daily-ai-news/prompt.md) | 8–12 AI news items from the last 24 hours, with links to the articles and YouTube videos | `SLACK_WEBHOOK_AI` |
| [`daily-news`](daily-news/prompt.md) | 5–7 items from the home country and 5–7 from the world, in two sections | `SLACK_WEBHOOK_NEWS` |

## Requirements

- The Claude desktop app with scheduled tasks (the "Scheduled" section in the sidebar).
- A Slack workspace where you can add an app.
- `curl` and `python3`; both ship with macOS.

## Install

### 1. Create the Slack webhooks

1. Create one channel per routine, for example `#auto-news-ai` and `#auto-news-general`.
2. On [api.slack.com/apps](https://api.slack.com/apps) choose **Create New App** → **From scratch**, name it and pick the workspace.
3. Open **Incoming Webhooks** and switch it **On**.
4. Choose **Add New Webhook to Workspace**, pick the first channel and copy the URL. Repeat for the second channel. One app can hold both webhooks.

The webhook decides the channel: the routine posts wherever its URL points.

### 2. Create the env file

The routines read the webhook URLs from `~/.config/daily-news/webhooks.env`. Anyone with a URL can post to its channel, so keep the file private and out of any repository:

```bash
mkdir -p ~/.config/daily-news && chmod 700 ~/.config/daily-news
```

```bash
cp routines/webhooks.env.example ~/.config/daily-news/webhooks.env && chmod 600 ~/.config/daily-news/webhooks.env
```

```bash
open -e ~/.config/daily-news/webhooks.env
```

Set both variables to your URLs:

| Variable | Used by | Value |
|---|---|---|
| `SLACK_WEBHOOK_AI` | `daily-ai-news` | webhook URL of the AI channel |
| `SLACK_WEBHOOK_NEWS` | `daily-news` | webhook URL of the general news channel |

To check that both are set without printing them:

```bash
grep -cE '^SLACK_WEBHOOK_(AI|NEWS)=https://hooks\.slack\.com/services/.+' ~/.config/daily-news/webhooks.env
```

It prints `2` when both are set.

### 3. Adjust the settings

Each prompt starts with a **Settings** section. Change it before you add the task:

- the language of the message (Polish by default),
- for `daily-news`: the home country and its news sources (Poland by default).

### 4. Add the scheduled tasks

In a Claude desktop session, ask:

> Create a scheduled task from `routines/daily-ai-news/prompt.md`, every day at 06:00, titled "Daily AI news".

and the same for `routines/daily-news/prompt.md`. Or add them by hand: **Scheduled** → new task, paste the whole prompt, set the schedule to every day at 06:00.

The app starts recurring tasks a few minutes after the set time to spread the load, so a 06:00 task runs at about 06:00–06:15.

Save the task in a permission mode that lets it search the web and run `curl` without asking (Auto works), or approve those tools the first time it runs. A task that stops to ask at 06:00 posts nothing until someone answers.

### 5. Test

Click **Run now** on each task. A digest should appear in its channel within a few minutes. If it does not, open the run from the task's Runs list: Slack's answer is in the last step, and anything but `ok` says what went wrong.

## Keep the Mac awake

A scheduled task runs only while the desktop app is open. If the app is closed when a task is due, the task runs the next time the app starts. To have the digest ready by 06:00:

- Leave the Claude app open overnight.
- Wake the Mac every day before the tasks. This needs your password:

```bash
sudo pmset repeat wakeorpoweron MTWRFSU 05:55:00
```

```bash
pmset -g sched
```

The second command should list `wakepoweron at 5:55AM every day`.

- Keep a laptop on power: on battery with the lid closed it may not wake.

## Change or remove

- Different channel: create a new webhook and replace its URL in the env file. The tasks need no change.
- Different time, language or sources: edit the task in **Scheduled**, or edit the prompt here and add the task again.
- Stop: pause or delete the task in **Scheduled**, and remove the webhook in the Slack app's settings.
