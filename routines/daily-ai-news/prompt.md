Prepare a daily digest of news from the AI world and post it to Slack.

## Settings

- Language of the message: Polish.
- Webhook variable: `SLACK_WEBHOOK_AI` in `~/.config/daily-news/webhooks.env`.

## 1. Collect the news

Use web search (WebSearch, WebFetch) to find the most important AI news of the last ~24 hours (today's date is in the session context). Look at, among others:

- announcements and blogs of the labs: Anthropic, OpenAI, Google DeepMind / Google AI, Meta AI, Mistral, xAI, Microsoft, NVIDIA, Hugging Face,
- news sites and newsletters: Hacker News (front page, AI threads), The Verge (AI), TechCrunch (AI), Ars Technica, The Decoder, Simon Willison's Weblog, Latent Space,
- research papers (arXiv, Papers with Code) when they are widely discussed,
- new YouTube videos from channels such as AI Explained, Two Minute Papers, Matthew Berman, Fireship, Latent Space.

Pick the 8–12 most interesting items: new models and products, notable updates to developer tools (Claude Code, Cursor, Codex and the like), research, regulation, major industry events. Skip small funding rounds, clickbait and repeats of the same story (one topic = one item, best source). Every link must point to a specific article or video, not a home page. Never make up links: use only addresses you actually found.

## 2. Write the message (Slack mrkdwn)

Write the message in the language from Settings. Format:

```text
*🤖 AI digest — <weekday>, <date>*

• *<short title>* — <1–2 sentences: what happened and why it matters>. <URL|Source: site name>
• ...

*🎬 Worth watching*
• *<title>* — <1 sentence>. <URL|YouTube: channel name>
```

Add the "Worth watching" section only when there are videos, and translate the headings into the message language. Links use Slack's format `<https://address|text>`. No Markdown headings (`#`) and no `**double asterisks**`: only `*single*` ones for bold. Keep the whole message under 3500 characters.

## 3. Post it to Slack

The webhook URL is a secret: never print it, log it or put it in the summary.

1. Save the message to a temporary file, for example `$TMPDIR/daily-ai-news.txt` (with the Write tool, or a heredoc with a quoted `'EOF'`).
2. Send it with this command, which builds valid JSON and never shows the URL:

```bash
set -a; . ~/.config/daily-news/webhooks.env; set +a
python3 -c 'import json,sys; print(json.dumps({"text": open(sys.argv[1], encoding="utf-8").read(), "unfurl_links": False, "unfurl_media": False}))' "$TMPDIR/daily-ai-news.txt" | curl -sS -X POST -H 'Content-Type: application/json' --data-binary @- "$SLACK_WEBHOOK_AI"; echo
```

3. Slack answers `ok`. On any other answer, fix the message (shorten it or repair the formatting) and try again, at most twice. Never post the same digest twice once a try has returned `ok`.

## 4. Summary

End with a short summary: whether the post succeeded (Slack's answer), how many items were sent, any problems. Never include the webhook URL.
