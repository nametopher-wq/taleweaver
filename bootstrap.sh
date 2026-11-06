#!/usr/bin/env bash
set -euo pipefail

upstream_url="https://github.com/jschm42/taleweaver.git"
origin_url="https://github.com/nametopher-wq/taleweaver.git"
integration_branch="local/integration"
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
common_dir=$(git rev-parse --git-common-dir)
common_dir=$(CDPATH= cd -- "$common_dir" && pwd)
root=$(dirname "$common_dir")

if [ ! -f "$root/AGENTS.md" ]; then
    printf 'Error: run this bootstrap from a TaleWeaver code checkout.\n' >&2
    exit 1
fi

if [ -n "$(git -C "$root" status --porcelain --untracked-files=no)" ]; then
    printf 'Error: tracked changes found. Commit or move them before bootstrap.\n' >&2
    exit 1
fi

if ! git -C "$root" remote get-url origin >/dev/null 2>&1; then
    printf 'Error: origin is missing. Clone the owner fork first.\n' >&2
    exit 1
fi

actual_origin=$(git -C "$root" remote get-url origin)
if [ "$actual_origin" != "$origin_url" ] && [ "$actual_origin" != "${origin_url%.git}" ]; then
    printf 'Error: unexpected origin URL: %s\n' "$actual_origin" >&2
    exit 1
fi

if git -C "$root" remote get-url upstream >/dev/null 2>&1; then
    actual_upstream=$(git -C "$root" remote get-url upstream)
    if [ "$actual_upstream" != "$upstream_url" ] && [ "$actual_upstream" != "${upstream_url%.git}" ]; then
        printf 'Error: unexpected upstream URL: %s\n' "$actual_upstream" >&2
        exit 1
    fi
else
    git -C "$root" remote add upstream "$upstream_url"
fi

git -C "$root" fetch upstream
git -C "$root" fetch origin

ensure_tracking_branch() {
    branch=$1
    remote_ref=$2
    if git -C "$root" show-ref --verify --quiet "refs/heads/$branch"; then
        git -C "$root" branch "--set-upstream-to=$remote_ref" "$branch" >/dev/null
    else
        git -C "$root" branch --track "$branch" "$remote_ref" >/dev/null
    fi
}

ensure_tracking_branch main upstream/main
ensure_tracking_branch "$integration_branch" origin/local/integration
if git -C "$root" show-ref --verify --quiet refs/remotes/origin/local/meta; then
    ensure_tracking_branch local/meta origin/local/meta
fi

current_branch=$(git -C "$root" branch --show-current)
if [ "$current_branch" != "$integration_branch" ]; then
    git -C "$root" switch "$integration_branch"
fi

exclude_file="$common_dir/info/exclude"
add_exclude() {
    pattern=$1
    if ! grep -Fqx -- "$pattern" "$exclude_file"; then
        printf '%s\n' "$pattern" >>"$exclude_file"
    fi
}

add_exclude '/AGENTS.local.md'
add_exclude '/HANDOFF.local.md'
add_exclude '/.local/'

copy_if_missing() {
    source=$1
    destination=$2
    if [ ! -e "$destination" ]; then
        cp "$source" "$destination"
        printf 'Created %s\n' "$destination"
    fi
}

copy_if_missing "$script_dir/templates/AGENTS.local.md" "$root/AGENTS.local.md"
copy_if_missing "$script_dir/templates/HANDOFF.local.md" "$root/HANDOFF.local.md"

printf '\nBootstrap complete.\n'
printf 'Code branch: %s\n' "$(git -C "$root" branch --show-current)"
printf 'Next: install project dependencies, configure local secrets, and point your agent to AGENTS.local.md.\n'
