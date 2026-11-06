# TaleWeaver — Local Machine Handoff

> Untracked device-specific state. Do not commit or copy into upstream PRs.
> Portable rules and feature history live in `.local/meta/`.

## Required reading

- `.local/meta/LOCAL_WORKFLOW.md`
- `.local/meta/LOCAL_FEATURES.md`
- `.local/meta/LOCAL_CHANGELOG.md`
- The code checkout's `AGENTS.md` and applicable `.claude/rules/`

## Machine

- Device name: `<name>`
- OS: `<operating-system>`
- Workspace: `<absolute-path>`
- Python: `<version-and-environment>`
- Node.js: `<version>`
- Last updated: `<YYYY-MM-DD>`

## Current checkout

- Active code branch: `local/integration`
- Upstream base: `<commit>`
- Integration commit: `<commit>`
- Active feature order: see `LOCAL_FEATURES.md`
- Existing local work or blockers: `<none-or-description>`

## Run and verify

- Normal application start: use the project's run script with pulling disabled.
- Dependency setup: `<environment-specific-command-or-notes>`
- Test command: `<environment-specific-command-or-notes>`
- Database state: `<fresh-local-db-or-upgrade-notes>`

## Local provider configuration

- Custom OpenAI base URL: `<non-secret-url-if-used>`
- Text model preferences: `<non-secret-model-notes>`
- Image model preferences: `<non-secret-model-notes>`
- Credentials: stored only in the approved local secret store; never recorded here.

## Known local issues and artifacts

- `<issue-or-none>`
- `<untracked-artifact-or-none>`

## Last verification

- Date: `<YYYY-MM-DD>`
- Tests: `<results>`
- Lint/build: `<results>`
- Explicitly not verified: `<items>`
