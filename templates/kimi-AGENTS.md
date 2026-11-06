## TaleWeaver downstream checkout

When working in a TaleWeaver checkout that contains `AGENTS.local.md`, read that file before any task and follow it together with the upstream `AGENTS.md`. Also read `.local/meta/LOCAL_WORKFLOW.md`, `.local/meta/LOCAL_FEATURES.md`, and the device-specific `HANDOFF.local.md` before changing code or Git state.

These rules apply on every code branch. Never merge `local/meta` into application branches, never commit local-only instruction files or handoffs, and never push to `upstream`.

If the checkout is identified as TaleWeaver but `.local/meta` or `AGENTS.local.md` is missing, stop before development and follow `.local/meta/BOOTSTRAP.md` when available, or `origin/local/meta:BOOTSTRAP.md` through Git.
