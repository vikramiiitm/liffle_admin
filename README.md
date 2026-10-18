# liffle_admin

The **Liffle admin console**: a separate web app for Liffle's staff (ADMIN-01). It is planned, not built yet.

- **What it will do:** find a person's account and see every setting that applies to them and why; safety (guardrail decision counts, a review queue, the rule editor); decisions (each classifier threshold with its test results, and a preview before a change); features and plans; builds and costs; reports and takedowns; the audit log; insights (how people use Liffle, without reading anything they wrote); staff and roles.
- **How it works:** it talks only to the backend's **admin API**, a separate process with its own sign-in for staff (Google account plus a passkey, STAFF-01). It never uses customer accounts or app tokens, never reads people's on-device data or what they wrote, and every action it takes is audited.
- **Why a separate repository:** its own deploys and its own secrets, so nothing about it can reach the public app (D-082).

Design: [`SETTINGS_AND_ADMIN_ARCHITECTURE.md`](https://github.com/vikramiiitm/liffle_backend/blob/main/docs/SETTINGS_AND_ADMIN_ARCHITECTURE.md) in `liffle_backend`. Order of work: the tracker in `liffle_backend/docs/WORK_TRACKER.md` (wave 2: STAFF-01, then ADMIN-01 a).
