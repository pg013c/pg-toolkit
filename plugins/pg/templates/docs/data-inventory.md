# Data inventory

Every kind of personal data the system holds (`PRIV-01`) and every third party that receives it (`PRIV-30`). Update it in the same commit as the code that adds, moves or shares a field.

## Personal data

| Data | Purpose | Legal basis | Stored in | Access | Retention | Deletion covered by |
|---|---|---|---|---|---|---|
| e.g. email address | sign-in, account notices | contract | `users.email` | app, support role | account life + 30 days | `tests/...::test_delete_account` |

## Processors and transfers

| Third party | Role | Data it receives | Location | Agreement | Transfer basis |
|---|---|---|---|---|---|
| e.g. hosting provider | hosting | all | EU | DPA signed YYYY-MM-DD | n/a |
