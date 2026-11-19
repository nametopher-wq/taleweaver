# Local Integration Changelog

This file records meaningful changes to the owner's downstream integration. It is not an upstream changelog and does not duplicate every feature commit.

Record upstream bases, feature additions/removals, conflict resolutions, migrations, verification, and unresolved limitations. Git history remains authoritative for individual commits.

## Unreleased

No pending integration changes recorded.

## 2026-11-19

Upstream base: `e2e87d1ad560e5110acef65d0c1f4cf44847713e`

Integration commit: `d5289b2e579feab162486210da1d4e673fda282e`

Feature commit: `2f9d0469d812978c5f571a2c46f8347f665c3934`

Added:

- Synchronized 155 upstream commits and recomposed the integration with the isolated custom image feature.
- Preserved custom image generation through upstream server-wide settings and personal API-key policies.
- Preserved blocked effective-key policies even when no usable key is stored, with a regression test through `t2i_config`.
- Applied 14 upstream migration files through Alembic head `cfa8f8fd4b9e`.

Verified:

- 280 targeted backend tests passed; Ruff check and format checks passed for all ten feature Python files.
- Full backend suite: 2346 passed, 1 skipped, 12 unrelated upstream failures. Two Kimi failures were environment-dependent and passed with the default Moonshot base URL restored.
- Frontend: 103 tests and production build passed.
- Real backend health and authenticated settings calls returned 200 and exposed the custom image provider correctly.
- Mocked custom `/images` generation, authorization, URL fallback, and key-policy preservation passed.
- Database integrity and row counts were preserved; all migrated server settings semantically matched the source admin settings.
- Pre-migration backup: `data/backups/taleweaver-pre-sync-20261119-090900.db`.
- Incident backup before removing test contamination: `data/backups/taleweaver-post-test-contamination-20261119-091219.db`.
- Full Poetry dev installation succeeded through the TLS-inspecting proxy using Windows trust store; 52 smoke tests passed in both Python environments.

Known upstream issues not changed by the local feature:

- Full-suite failures cover five Play-Agent tests, one NPC persona format test, one prose test, and three skill-bundle checksum tests; the two Kimi tests also require an unpolluted default endpoint environment.
- Frontend lint reports 32 errors and 56 warnings outside the feature.
- The committed skill bundle already has a `package.json` checksum mismatch in upstream.
- `tests/test_dynamic_challenges.py` imports the default engine/session directly; full test runs need explicit `DATABASE_URL` and `DATA_DIR` isolation to avoid writes to the application database.

Not verified:

- Live ZvenoAI image generation was not retested.

Git notes:

- `main`, `feature/custom-openai-image`, `local/integration`, and `local/meta` were pushed to `origin` on 2026-11-19. Nothing was pushed to `upstream`.

## 2026-11-06

Upstream base: `dbe1c925fd2d0f3617e62a1c935a11ef5c276f8d`

Integration commit: `bf2ec6f8e3d263404838d45121198792b77dff19`

Added:

- Established the `main` / independent feature / `local/integration` downstream structure.
- Added `feature/custom-openai-image` at `bf2ec6f8` without the legacy branch's merge history or local handoff.
- Added this independent `local/meta` documentation and bootstrap branch.

Fixed:

- Scoped gateway image-model discovery to `custom_openai`, restoring upstream behavior and caching expectations for DeepSeek, Kimi, and MiniMax.
- Replaced global agent instructions with the project-scoped untracked `.kimi-code/AGENTS.md`; bootstrap now creates it without changing files outside the project.

Verified:

- 190 targeted tests passed.
- Ruff check and format checks passed for all nine affected Python files.
- The isolated image feature and integration trees matched at `bf2ec6f8`.
- PowerShell bootstrap passed twice on the original checkout without changing local files or exclusions.
- Bash bootstrap passed on a clean GitHub clone and passed a second idempotence run; the test clone was removed.
- Project-scoped agent instructions were discovered by Kimi Code on both checkouts; no global `AGENTS.md` remained or was created during bootstrap.

Not verified:

- Live ZvenoAI image generation was not retested during branch extraction.

Git notes:

- `origin` points to the owner's fork; `upstream` points to the author's repository.
- The legacy `local/custom-openai-image` branch remains local-only at `d55e6df6` and is not part of the new integration.
