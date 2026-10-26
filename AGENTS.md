# Agent instructions for liffle_admin

**Start with `START_HERE.md` in the backend repository** (`docs/START_HERE.md` in `vikramiiitm/liffle_backend`; locally `../liffle_backend/docs/`): what exists, how to run it, what is proven, and what comes next.

## What this repository is

The staff admin console (ADMIN-01, decision D-082). **Not built yet.** Nothing is started here before STAFF-01 (staff identity, permissions and the admin API in the backend) exists, because the console must never talk to anything but the admin API.

## Rules that are specific to this repository

- **Only the admin API.** No direct database access, no customer API, no provider keys, no shared secrets with the public app.
- **Staff sign-in only** (Google account plus a passkey; more second steps later). Short-lived tokens with the audience `liffle-admin`.
- **Permissions are checked by the admin API,** never only in the console. The console hides what a person may not do; the server refuses it.
- **Metadata only.** It never shows what people wrote, their app data or anything from their devices (D-045, D-081).
- **Every change goes through the settings platform** (SET-01): draft, preview against evaluation sets and past decision records, approval (two people for loosening safety once there are two staff), publish, roll back.
- Words follow `liffle_backend/docs/VOICE_AND_TONE.md` where staff-facing text allows; staff screens may name technical things, but clearly.

## How we work

Follow `liffle_backend/docs/WORKING_RULES.md` in every session without being reminded: autonomy, a security check on every slice, verify, commit, push and merge often (a cloud session works on the branch it is assigned, `claude/<name>`, and merges into `main`, WORKING_RULES §4), docs every step, honesty. Workspace skills live in `instacreate.in/.claude/skills/` (`liffle-dev-loop`, `liffle-security-check`, `liffle-architecture-review`, `liffle-status-report` and the others WORKING_RULES lists). The stack is chosen when ADMIN-01 starts and recorded as a decision.

Keep the shared `docs/FEATURES.md` (what Liffle can do, and how far) and `docs/GAPS.md` (every gap found, fixed or planned) current in the same commit as the work, as `liffle_backend/docs/WORKING_RULES.md` §8 says; `npm run docs:check` in `liffle_backend` fails when FEATURES.md falls behind the progress log. Before handing back, run `npm run docs:debt` in `liffle_backend`: it lists code in any repository that no doc has caught up with (docs are never more than two turns behind, §8). Commits of type feat, fix, refactor or perf carry `Security:`, `Scale:`, `Gaps:` and `Architecture:` lines (the commit hook refuses them otherwise), and every architecture review adds its entry to `liffle_backend/docs/REVIEWS.md`.
