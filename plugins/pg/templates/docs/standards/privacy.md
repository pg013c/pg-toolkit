# Privacy and compliance standards

Engineering rules that keep personal data handling defensible under the GDPR and, for AI features, the EU AI Act. They are not legal advice: decisions with legal weight are recorded in an ADR and confirmed by whoever owns compliance.

## Knowing what we hold

- **PRIV-01** Every personal data field is listed in `docs/data-inventory.md`: what it is, why we need it, where it is stored, who can access it, how long it is kept.
- **PRIV-02** Each purpose of processing has a stated legal basis (consent, contract, legal obligation, legitimate interest). A new purpose for existing data needs a new basis.
- **PRIV-03** Special categories (health, biometrics, beliefs, sexual orientation and similar) and data about children are collected only with an ADR that names the basis and the extra safeguards.

## Collecting and keeping

- **PRIV-10** Collect the minimum. A field is not added "in case we need it later".
- **PRIV-11** Every store of personal data has a retention period enforced by code (a scheduled job or TTL), not by a promise.
- **PRIV-12** Consent, when it is the basis, is specific, recorded with time and version of the text, and as easy to withdraw as to give.
- **PRIV-13** Personal data never reaches logs, analytics events, error trackers, URLs or test fixtures. Test data is synthetic.

## Rights of the person

- **PRIV-20** A person's data can be exported in a machine-readable format and deleted, including from search indexes, caches and third-party processors. Backups age out within a stated period.
- **PRIV-21** Deletion is tested: a test proves the data is gone from every store in the inventory.

## Sharing

- **PRIV-30** Every third party that receives personal data (hosting, email, analytics, AI providers) is listed in the inventory with its role and a data processing agreement.
- **PRIV-31** Transfers outside the EEA rely on an adequacy decision or standard contractual clauses, recorded in the inventory.
- **PRIV-32** Third-party scripts and trackers that set non-essential cookies load only after consent.

## Security of processing

- **PRIV-40** Personal data is encrypted in transit and at rest; access is limited to roles that need it and is logged.
- **PRIV-41** A suspected breach has a written path: who decides, and how the authority is notified within 72 hours when required.

## AI features

- **PRIV-50** The risk category of each AI feature under the AI Act is recorded in an ADR. Prohibited practices are never built; high-risk uses get the required documentation, human oversight and logging before release.
- **PRIV-51** People are told when they interact with an AI system or see AI-generated content, where the AI Act or honesty requires it.
- **PRIV-52** Automated decisions with legal or similarly significant effects on a person have a human review path and an explanation the person can get.
