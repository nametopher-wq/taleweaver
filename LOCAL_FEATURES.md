# Local Feature Registry

This registry is the source of truth for active downstream features and their integration order. Update it whenever a feature's branch, status, commits, dependencies, PR, verification, or integration membership changes.

## Current integration

- Integration branch: `local/integration`
- Upstream base: `e2e87d1ad560e5110acef65d0c1f4cf44847713e`
- Integration commit: `d5289b2e579feab162486210da1d4e673fda282e`
- Last recorded verification: 2026-11-19

Active feature order:

1. `feature/custom-openai-image`

## Active features

### custom-openai-image

- Branch: `feature/custom-openai-image`
- Class: `upstream-candidate`
- Status: active in local integration; no upstream PR opened
- Dependencies: none
- Integration order: 1
- Upstream base: `e2e87d1ad560e5110acef65d0c1f4cf44847713e`
- Initial extraction commit: `8a2bf284`
- Current feature commit: `2f9d0469d812978c5f571a2c46f8347f665c3934`
- Database migrations: none in the feature; upstream migrations applied through `cfa8f8fd4b9e`
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
- Effective-key policy preservation through the manifest image pipeline.
- User-facing image gateway description in `README.md`.

Verification recorded on 2026-11-19:

- 280 targeted tests passed across custom provider, media, model discovery, config API, key policy, and lifecycle suites.
- Ruff check and format checks passed for all ten affected Python files.
- The isolated feature tree at `2f9d0469` and integration tree at `d5289b2e` matched.
- Full backend suite: 2346 passed, 1 skipped, 12 unrelated upstream failures. The two environment-dependent Kimi tests passed with the default Moonshot base URL restored.
- Frontend: 103 tests and the production build passed. Upstream lint still reports 32 errors and 56 warnings outside this feature.
- Real backend health and authenticated settings calls returned 200; custom image provider registration was confirmed.
- Mocked custom `/images` dispatch, authorization, URL fallback, and empty-effective-key policy preservation passed.
- Database backup, migration to `cfa8f8fd4b9e`, integrity, row counts, and semantic preservation of server settings were verified.

Known limitations:

- Gemini image models that do not support the gateway's `/images` contract require chat completions; that fallback is not implemented.
- Live ZvenoAI image generation was not retested during synchronization.
- Provider credentials and endpoint configuration remain in local application state and are not part of the feature branch.
- Poetry dev-dependency installation could not reach PyPI; runtime dependencies were unchanged and `poetry install --only main` succeeded.

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
