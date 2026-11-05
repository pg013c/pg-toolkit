Prepare a daily digest of the most important news from the home country and the world and post it to Slack.

## Settings

- Language of the message: Polish.
- Home country: Poland.
- Home country sources: PAP, Rzeczpospolita, Gazeta Wyborcza, Onet, Interia, Money.pl, Bankier.pl, TVN24, Polsat News, Notes from Poland.
- Webhook variable: `SLACK_WEBHOOK_NEWS` in `~/.config/daily-news/webhooks.env`.

## 1. Collect the news

Use web search (WebSearch, WebFetch) to find the most important news of the last ~24 hours (today's date is in the session context).

- Home country: the sources from Settings.
- World: Reuters, AP News, BBC News, The Guardian, Financial Times, Politico Europe, Deutsche Welle.

Pick 5–7 items for each section: politics, economy and finance, society, security and other major events. Sport and culture only when the event is really big. Skip clickbait, gossip and repeats of the same story (one topic = one item, the most reliable source). Write neutrally and factually, with no political commentary. Every link must point to a specific article, not a home page. Never make up links: use only addresses you actually found.

## 2. Write the message (Slack mrkdwn)

Write the message in the language from Settings. Format:

```text
*📰 News digest — <weekday>, <date>*

*<home country flag> <home country>*
• *<short title>* — <1–2 sentences: what happened and why it matters>. <URL|Source: site name>
• ...

*🌍 World*
• *<short title>* — <1–2 sentences>. <URL|Source: site name>
• ...
```

Translate the headings into the message language. Links use Slack's format `<https://address|text>`. No Markdown headings (`#`) and no `**double asterisks**`: only `*single*` ones for bold. Keep the whole message under 3500 characters.

## 3. Post it to Slack

The webhook URL is a secret: never print it, log it or put it in the summary.

1. Save the message to a temporary file, for example `$TMPDIR/daily-news.txt` (with the Write tool, or a heredoc with a quoted `'EOF'`).
2. Send it with this command, which builds valid JSON and never shows the URL:

```bash
set -a; . ~/.config/daily-news/webhooks.env; set +a
python3 -c 'import json,sys; print(json.dumps({"text": open(sys.argv[1], encoding="utf-8").read(), "unfurl_links": False, "unfurl_media": False}))' "$TMPDIR/daily-news.txt" | curl -sS -X POST -H 'Content-Type: application/json' --data-binary @- "$SLACK_WEBHOOK_NEWS"; echo
```

3. Slack answers `ok`. On any other answer, fix the message (shorten it or repair the formatting) and try again, at most twice. Never post the same digest twice once a try has returned `ok`.

## 4. Summary

End with a short summary: whether the post succeeded (Slack's answer), how many items were sent in each section, any problems. Never include the webhook URL.
