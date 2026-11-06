# TaleWeaver Local Meta

This orphan branch belongs to the owner's downstream fork. It is not merged into application code branches and is not intended for upstream PRs.

Contents:

- `LOCAL_WORKFLOW.md`: authoritative cross-branch downstream workflow.
- `LOCAL_FEATURES.md`: active feature registry and integration order.
- `LOCAL_CHANGELOG.md`: integration composition and verification history.
- `BOOTSTRAP.md`: new-device setup and recovery instructions.
- `bootstrap.ps1` / `bootstrap.sh`: idempotent local setup scripts.
- `templates/`: untracked per-device entry-point and handoff templates.

On an initialized checkout this branch is materialized at `.local/meta`. Start with `LOCAL_WORKFLOW.md`; on a new device start with `BOOTSTRAP.md`.
