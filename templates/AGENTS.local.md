# TaleWeaver Local Agent Bootstrap

This is a local-only entry point. It must remain untracked in code branches and must never be copied into an upstream PR.

## Required startup for every task

1. Read `.local/meta/LOCAL_WORKFLOW.md`; it is authoritative across all code branches.
2. Read `.local/meta/LOCAL_FEATURES.md` before changing a feature or integration branch.
3. Read `HANDOFF.local.md` for this device's current state. Do not treat it as portable or commit it.
4. Read the code checkout's `AGENTS.md` and all applicable `.claude/rules/`; upstream engineering rules remain mandatory.
5. Run `git status --short --branch`, identify the current branch, and inspect existing work before editing.
6. Update the local registry and changelog in `.local/meta` whenever the work changes downstream state.

If `.local/meta` is unavailable, stop before development and follow the bootstrap instructions from `origin/local/meta`.

## Non-negotiable boundaries

- `main` mirrors upstream and receives no local commits.
- Develop each feature independently in `feature/<name>` from `main`, never from another feature or integration.
- `local/integration` only combines completed features; do not develop directly there.
- `local/meta` contains only downstream documentation and bootstrap tooling; never merge it into code branches.
- Never push to `upstream`. Push to `origin` or open an upstream PR only with explicit owner approval.
- Do not commit, rebase, reset, delete branches, or remove worktrees without the authorization required by the current session.
- Preserve user work and untracked artifacts. Never use automatic clean, `assume-unchanged`, or `skip-worktree` to conceal changes.
- Keep code, comments, UI text, and documentation in English unless the owner explicitly requests otherwise.
- Never commit secrets, `.env`, databases, Provider Vault data, machine-specific handoffs, or generated user assets.
