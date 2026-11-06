# Local Workflow Bootstrap

Use this guide on a new development device or to repair the local-only setup on an existing checkout. No game database, sessions, generated assets, or other machine's handoff is needed for development.

## What bootstrap does

The scripts are idempotent and non-destructive. They:

- validate the expected `origin` and `upstream` repositories;
- add `upstream` when missing and fetch both remotes;
- set `main` to track `upstream/main`;
- create or update tracking for `local/integration` and `local/meta`;
- switch a clean code checkout to `local/integration`;
- add only local entries to `.git/info/exclude`;
- create `AGENTS.local.md`, `HANDOFF.local.md`, and the project-scoped `.kimi-code/AGENTS.md` from templates only when absent.

They do not install application dependencies, change secrets, copy game data, overwrite existing local files, clean untracked artifacts, write outside the project, commit, or push. Tracked uncommitted changes stop the script before any setup changes.

## Prerequisites

Install Git, Python 3.12, Node.js, and the agent you use. The project supports Python 3.11 through 3.13, but 3.12 is the established local environment.

## New Windows device

Clone the owner's fork and materialize the meta branch:

```powershell
git clone https://github.com/nametopher-wq/taleweaver.git
cd taleweaver
git worktree add --track -b local/meta .local/meta origin/local/meta
powershell -ExecutionPolicy Bypass -File .\.local\meta\bootstrap.ps1
```

Git Bash on Windows may use the Unix commands below instead.

## New Linux, macOS, or Git Bash device

```bash
git clone https://github.com/nametopher-wq/taleweaver.git
cd taleweaver
git worktree add --track -b local/meta .local/meta origin/local/meta
bash .local/meta/bootstrap.sh
```

The initial `worktree add` is required only on a fresh clone. Do not repeat it when `.local/meta` already exists.

## Existing initialized checkout

Update the meta worktree and rerun the appropriate script from the code checkout:

```bash
git -C .local/meta pull --ff-only
bash .local/meta/bootstrap.sh
```

On Windows PowerShell:

```powershell
git -C .local/meta pull --ff-only
powershell -ExecutionPolicy Bypass -File .\.local\meta\bootstrap.ps1
```

Existing `AGENTS.local.md` and `HANDOFF.local.md` are preserved. The duplicate exclusion entries are not added on subsequent runs.

## After bootstrap

1. Read the generated `AGENTS.local.md` and complete the machine-specific `HANDOFF.local.md`.
2. Install the project's Python and frontend dependencies using the standard project setup. No `requirements.txt` export needs to be copied from another device.
3. Apply Alembic migrations when required by the code checkout.
4. Configure `.env`, Provider Vault credentials, and any desired non-secret provider/model settings. Never commit these values.
5. Keep agent instructions project-scoped. Bootstrap creates the untracked `.kimi-code/AGENTS.md`, which Kimi Code discovers automatically only in this project. No global or user-level instruction file is changed or required.
   - Other agents: use their project-scoped local instruction mechanism to read `AGENTS.local.md`; do not modify global instructions or the tracked upstream `AGENTS.md` for this purpose.
6. Start a new agent session so the project instructions are loaded.
7. Read `LOCAL_WORKFLOW.md` before creating or updating branches.

No game environment needs to be transferred for development. Existing sessions, databases, adventures, and generated media are only needed if the device must reproduce a specific runtime environment.

## Routine meta updates

When another device adds workflow or feature documentation:

```bash
git -C .local/meta pull --ff-only
```

Do not merge `local/meta` into application branches. Its updates are independent of upstream synchronization.

## Recovery checks

```bash
git status --short --branch
git worktree list
git remote -v
git branch -vv
```

Expected state:

- the main code checkout is on `local/integration` for normal local use;
- `.local/meta` is on `local/meta`;
- `main` tracks `upstream/main`;
- integration and meta track their `origin` counterparts;
- `AGENTS.local.md`, `HANDOFF.local.md`, `.kimi-code/`, and `.local/` do not appear as untracked code files;
- no global agent instruction file is needed or modified.

If the meta worktree is missing but `.local/meta` contains unexpected files, stop and inspect them instead of deleting or overwriting the directory.
