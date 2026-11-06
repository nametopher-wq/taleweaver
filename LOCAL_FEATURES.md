# Local Feature Registry

This registry is the source of truth for active downstream features and their integration order. Update it whenever a feature's branch, status, commits, dependencies, PR, verification, or integration membership changes.

## Current integration

- Integration branch: `local/integration`
- Upstream base: `dbe1c925fd2d0f3617e62a1c935a11ef5c276f8d`
- Integration commit: `bf2ec6f8e3d263404838d45121198792b77dff19`
- Last recorded verification: 2026-11-06

Active feature order:

1. `feature/custom-openai-image`

## Active features

### custom-openai-image

- Branch: `feature/custom-openai-image`
- Class: `upstream-candidate`
- Status: active in local integration; no upstream PR opened
- Dependencies: none
- Integration order: 1
- Upstream base: `dbe1c925fd2d0f3617e62a1c935a11ef5c276f8d`
- Initial extraction commit: `8a2bf284`
- Current feature commit: `bf2ec6f8e3d263404838d45121198792b77dff19`
- Database migrations: none
- Feature flag: none

Purpose:

- Add an OpenAI-compatible custom image provider.
- Reuse the configured custom OpenAI API key and resolve the base URL from the global custom endpoint or supported per-pass fallbacks.
- Fetch separately listed image models only for the custom gateway.
- Preserve upstream text-side custom OpenAI behavior and other providers' discovery behavior.

Scope:

- Image provider configuration and model presets.
- Image generation dispatch and request support.
- Asset, preview, manifest visual, and test-vision call sites.
- Custom gateway model discovery and its regression tests.
- User-facing image gateway description in `README.md`.

Verification recorded on 2026-11-06:

- 190 targeted tests passed across custom provider, media, model discovery, config API, and related image suites.
- Ruff check and format checks passed for all nine affected Python files.
- The isolated feature and integration trees matched at `bf2ec6f8`.
- Live ZvenoAI image generation was not retested during branch extraction.

Known limitations:

- Gemini image models that do not support the gateway's `/images` contract require chat completions; that fallback is not implemented.
- Provider credentials and endpoint configuration remain in local application state and are not part of the feature branch.

PR: none.

## Feature template

Copy this section when registering a new feature and remove unused optional rows.

### <feature-name>

- Branch: `feature/<feature-name>`
- Class: `upstream-candidate` or `local-only`
- Status: planned, in development, active, PR open, upstreamed, or retired
- Dependencies: must be `none` unless explicitly approved
- Integration order: not assigned until integrated
- Upstream base: `<full-commit>`
- Current feature commit: `<full-commit>`
- Database migrations: none or explicit migration impact
- Feature flag: none or name/default

Purpose:

- <User-visible and engine behavior.>

Scope:

- <Owned modules, schemas, prompts, UI, documentation, and tests.>

Verification:

- <Isolated tests, integration tests, lint, build, and real scenario.>
- <Explicitly unverified behavior.>

Known limitations:

- <Limitations or `none`.>

PR: none or URL.

## Upstreamed and retired features

None recorded yet. Move accepted features here with their upstream implementation commit and the integration change that removed the redundant local patch.
