#!/bin/sh
set -eu

repo_dir=$(CDPATH= cd "$(dirname "$0")" && pwd -P)
agent_dir=$(omp config path)
case "$agent_dir" in
    /*) ;;
    *) printf 'Expected an absolute OMP agent directory, got: %s\n' "$agent_dir" >&2; exit 1 ;;
esac

# Check all sources and destinations before changing any active configuration.
for relative in config.yml agents/frontend.md agents/designer.md agents/writer.md; do
    [ -f "$repo_dir/$relative" ] || { printf 'Missing source: %s\n' "$relative" >&2; exit 1; }
    if [ -d "$agent_dir/$relative" ] && [ ! -L "$agent_dir/$relative" ]; then
        printf 'Refusing to replace a directory: %s\n' "$agent_dir/$relative" >&2
        exit 1
    fi
done

mkdir -p "$agent_dir/agents"
backup_dir=
for relative in config.yml agents/frontend.md agents/designer.md agents/writer.md; do
    source=$repo_dir/$relative
    target=$agent_dir/$relative
    if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
        printf 'Already linked: %s\n' "$target"
        continue
    fi
    saved=
    if [ -e "$target" ] || [ -L "$target" ]; then
        if [ -z "$backup_dir" ]; then
            backup_dir=$(mktemp -d "$agent_dir/config-backup.XXXXXX")
            printf 'Backing up existing configuration to: %s\n' "$backup_dir"
        fi
        saved=$backup_dir/$relative
        mkdir -p "$(dirname "$saved")"
        mv "$target" "$saved"
    fi
    if ! ln -s "$source" "$target"; then
        if [ -n "$saved" ]; then mv "$saved" "$target"; fi
        exit 1
    fi
    printf 'Linked: %s -> %s\n' "$target" "$source"
done

printf '\nConfiguration linked for OMP directory: %s\n' "$agent_dir"
printf 'Credentials, sessions, and caches remain local. Keep this checkout in place.\n'
