# Local Integration Changelog

This file records meaningful changes to the owner's downstream integration. It is not an upstream changelog and does not duplicate every feature commit.

Record upstream bases, feature additions/removals, conflict resolutions, migrations, verification, and unresolved limitations. Git history remains authoritative for individual commits.

## Unreleased

No pending integration changes recorded.

## 2026-11-06

Upstream base: `dbe1c925fd2d0f3617e62a1c935a11ef5c276f8d`

Integration commit: `bf2ec6f8e3d263404838d45121198792b77dff19`

Added:

- Established the `main` / independent feature / `local/integration` downstream structure.
- Added `feature/custom-openai-image` at `bf2ec6f8` without the legacy branch's merge history or local handoff.
- Added this independent `local/meta` documentation and bootstrap branch.

Fixed:

- Scoped gateway image-model discovery to `custom_openai`, restoring upstream behavior and caching expectations for DeepSeek, Kimi, and MiniMax.

Verified:

- 190 targeted tests passed.
- Ruff check and format checks passed for all nine affected Python files.
- The isolated image feature and integration trees matched at `bf2ec6f8`.
- PowerShell bootstrap passed twice on the original checkout without changing local files or exclusions.
- Bash bootstrap passed on a clean GitHub clone and passed a second idempotence run; the test clone was removed.

Not verified:

- Live ZvenoAI image generation was not retested during branch extraction.

Git notes:

- `origin` points to the owner's fork; `upstream` points to the author's repository.
- The legacy `local/custom-openai-image` branch remains local-only at `d55e6df6` and is not part of the new integration.
