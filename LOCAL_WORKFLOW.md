# TaleWeaver Local Downstream Workflow

This document is the authoritative workflow for the owner's downstream fork. It applies to every code branch, worktree, device, and agent. It is local-fork documentation, not an upstream proposal.

Upstream project rules remain mandatory. Always read the code checkout's `AGENTS.md` and the applicable `.claude/rules/`. This document adds downstream ownership rules; it never relaxes upstream engineering, security, testing, or documentation requirements.

## 1. Goals

- Track the actively developed upstream project instead of becoming an independent fork.
- Keep every local feature additive, deterministic, independently testable, and as small as possible.
- Allow any feature to remain local or become a clean upstream PR without including other local work.
- Make the local integration composition reproducible from an upstream base and an ordered feature list.
- Keep local-only workflow, provider notes, and machine state out of upstream PRs.

## 2. Repository topology

### Remotes

- `upstream`: `https://github.com/jschm42/taleweaver.git`. Fetch only; never push or open a PR without explicit owner approval.
- `origin`: `https://github.com/nametopher-wq/taleweaver.git`. The owner's fork and the only remote used for local backups and collaboration.

### Branches

- `main`: clean mirror of `upstream/main`; no local commits and no direct development. Update by fast-forward only and keep its tracking set to `upstream/main`.
- `feature/<name>`: one independent feature, based on `main`, including only that feature's code, tests, and upstream-appropriate documentation.
- `local/integration`: the owner's runnable composition of `main` and active features. Do not develop features directly here.
- `local/meta`: independent orphan branch containing this workflow, the feature registry, the local changelog, templates, and bootstrap tooling. Never merge it into a code branch.
- Legacy backup branches are not active development branches. Delete or archive them only with owner approval.

The working layout materializes `local/meta` at `.local/meta` through a separate Git worktree. The main checkout can therefore switch code branches without losing access to local documentation.

## 3. Required agent startup

Before changing files or Git state:

1. Read the root `AGENTS.local.md` when present.
2. Read `.local/meta/LOCAL_WORKFLOW.md` and `.local/meta/LOCAL_FEATURES.md`.
3. Read the root `HANDOFF.local.md` for machine-specific state. Never treat it as portable documentation.
4. Read the code checkout's `AGENTS.md` and applicable rules.
5. Run `git status --short --branch`, identify the current branch, and inspect existing changes before editing. Do not assume the workspace is clean.
6. Confirm the requested task and target branch. Develop in a feature branch, not in `main` or `local/integration`.
7. Update `.local/meta` documentation in the same task whenever feature state, integration composition, PR state, verification state, or workflow changes.

If `.local/meta` is missing, stop before development and follow `BOOTSTRAP.md` from `origin/local/meta`. If the root `AGENTS.local.md` is missing, do not hide changes to the tracked `AGENTS.md`; restore the local bootstrap instead.

## 4. Feature independence contract

Every feature must satisfy all of these rules:

- Branch from `main`, never from another feature or from `local/integration`.
- Work and pass tests with no other local feature applied.
- Do not import or call another local feature's implementation.
- Do not rely on another feature's configuration, provider, side effects, database migration, or activation order.
- Keep shared changes minimal and additive. If two features need a new shared abstraction, make that abstraction an explicit separate feature or an upstream change.
- Do not include unrelated fixes, refactors, formatting, dependency updates, or documentation edits.
- Keep runtime behavior deterministic. Server-side state and rule enforcement remain authoritative; external model output must not bypass deterministic guardrails.
- Avoid feature flags unless they provide real operational value. When a flag exists, document its default and test both enabled and disabled behavior.
- Treat database migrations as integration-affecting dependencies, not as freely composable isolated patches.

Changing disjoint files is not required. Two independent features may need additive edits to the same upstream registry or schema. Independence means clean branch composition and no semantic dependency. If merge order changes behavior, the features are not independent.

## 5. Feature lifecycle

### Discovery and classification

1. Check current upstream code, issues, and PRs before duplicating existing or planned work.
2. Find the closest existing upstream analogue and trace all of its consumers, as required by `AGENTS.md`.
3. Classify the feature as `upstream-candidate` or `local-only`; either class follows the same engineering and isolation rules.
4. Record the planned feature in `LOCAL_FEATURES.md` with its base, scope, dependencies, migrations, and verification requirements.

### Implementation

1. Create `feature/<name>` from the current clean `main` with owner authorization.
2. Keep commits focused and use the existing `feat:`, `fix:`, `docs:`, `test:`, and related conventions.
3. Put domain logic in the appropriate module instead of growing oversized upstream files.
4. Update all upstream-required generation, manifest, editor, validation, documentation, autocomplete, and test consumers that the feature affects.
5. Update `LOCAL_FEATURES.md` with current commits and status. Record significant integration changes in `LOCAL_CHANGELOG.md`.
6. Run the feature's checks against the isolated feature tree before merging it into integration.

### Integration

1. Confirm the feature is complete and its isolated checks pass.
2. Merge the feature into `local/integration`; do not cherry-pick by default.
3. Run the relevant checks again on the combined tree.
4. Record the integration base, feature commit, verification, and any unresolved limitations in the local registry/changelog.
5. Push to `origin` only after explicit owner confirmation.

Use `git cherry-pick` only for a deliberate backport or exceptional case. Do not rebase shared integration history. Rebuild or rewrite branches only with explicit owner approval and a recorded recovery reference.

## 6. Upstream synchronization

Do not synchronize implicitly through application startup. Use `run.ps1 -NoPull` for normal local starts.

With owner authorization:

1. Fetch `upstream` and `origin`.
2. Inspect upstream changes, especially migrations, dependencies, and files touched by active features.
3. Fast-forward `main` to `upstream/main`; never commit local work to it.
4. Update each active feature independently and run its isolated checks.
5. Retire features whose accepted implementation is now present upstream.
6. Rebuild or update `local/integration` from the new base and active features in the order recorded in `LOCAL_FEATURES.md`.
7. Run integration checks and update the registry/changelog.
8. Apply Alembic migrations and dependency updates deliberately, with a database backup where existing data matters.

Prefer frequent small synchronizations. Do not hide unresolved conflicts with broad rewrites, destructive resets, or blind acceptance of either side.

## 7. Upstream PR lifecycle

An upstream candidate must contain no local handoff, provider secrets, personal endpoint preferences, unrelated features, or integration-only changes.

1. Update the isolated feature on the current upstream base and run its checks.
2. Review `git diff upstream/main...feature/<name>` and confirm that every file belongs to the feature.
3. Push the feature to `origin` and open the PR only with owner approval.
4. Record the PR URL and status in `LOCAL_FEATURES.md`.
5. Continue running the feature locally through integration while the PR is open, updating it as needed.
6. After acceptance, verify that upstream contains equivalent behavior. Squash merges and review changes may produce a different SHA.
7. Remove the redundant local feature from the next integration composition, record the upstream commit, and run integration checks.
8. Archive or delete the old feature branch only with owner approval.

## 8. Verification and documentation

Follow the code checkout's `AGENTS.md` for mandatory propagation, linting, testing, and documentation. At minimum:

- Run targeted tests for the changed area and all mandatory lifecycle/game-loop suites that apply.
- Test each feature alone and the final integration composition.
- Exercise real application or service calls for the user scenario; mocks must replace external network and paid model calls in automated tests.
- Run Ruff check and format checks for every modified Python file.
- Run applicable frontend tests, lint, and build for frontend changes.
- Update upstream-facing documentation only inside the feature that owns the behavior.
- Update local registry/changelog for downstream state. Do not use upstream `docs/status-updates/` for local-only notes.
- State explicitly what was not verified, especially live provider calls and database upgrades.

## 9. Database and runtime state

- Prefer existing state, JSON fields, or namespaced extension data over new local schema when that is a sound design.
- Never change an already-applied migration's identity or `down_revision` as if it were an unapplied branch change.
- Coordinate multiple migration heads explicitly and test both a fresh database and an upgrade path.
- Back up data before applying a feature migration to a database that matters.
- Do not commit `.env`, Provider Vault data, databases, API keys, local adventures, generated assets, or machine-specific dependency directories.

## 10. Local changelog and recovery tags

Git history is authoritative for individual feature commits. `LOCAL_CHANGELOG.md` records integration-level composition changes, upstream bases, accepted PR removals, migrations, verification, and known limitations.

Known-good integration snapshots may be tagged as `local/YYYY-MM-DD` or `local/YYYY-MM-DD.N`. Tags are pushed only to `origin` and only with owner approval. Do not change the application's version solely for local integration tags.

## 11. Multi-device rule

Everything portable belongs in `origin`: code branches, `local/meta`, and optional recovery tags. Each device owns only dependencies, secrets, application data, `.git/info/exclude`, `AGENTS.local.md`, `HANDOFF.local.md`, and untracked project-scoped agent instructions such as `.kimi-code/AGENTS.md`. Never require global agent instructions for this workflow.

Use `BOOTSTRAP.md` on a new device. Do not copy another machine's `HANDOFF.local.md`, virtual environments, or secrets into Git. Update the meta worktree with `git -C .local/meta pull --ff-only`.

## 12. Safety boundaries

- Never commit directly to `main`.
- Never develop directly in `local/integration` or `local/meta` for application features.
- Never push to `upstream`.
- Never commit, rebase, reset, force-push, delete branches, or remove worktrees without the owner authorization required by the current session.
- Never use `assume-unchanged` or `skip-worktree` to conceal local edits to tracked upstream files.
- Never overwrite existing local bootstrap files; bootstrap must be idempotent and non-destructive.
- Preserve user work and unrelated untracked artifacts. Do not clean the workspace automatically.
