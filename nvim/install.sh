#!/bin/sh
set -eu

source_dir=$(CDPATH= cd "$(dirname "$0")" && pwd -P)
config_home=${XDG_CONFIG_HOME:-"$HOME/.config"}
target=$config_home/nvim

[ -f "$source_dir/init.lua" ] || { printf 'Missing init.lua in %s\n' "$source_dir" >&2; exit 1; }
if [ -L "$target" ] && [ "$(readlink "$target")" = "$source_dir" ]; then
    printf 'Already linked: %s -> %s\n' "$target" "$source_dir"
    exit 0
fi

mkdir -p "$config_home"
backup=
if [ -e "$target" ] || [ -L "$target" ]; then
    backup=$(mktemp -d "$config_home/nvim-backup.XXXXXX")
    mv "$target" "$backup/nvim"
    printf 'Previous configuration preserved at: %s/nvim\n' "$backup"
fi
if ! ln -s "$source_dir" "$target"; then
    if [ -n "$backup" ]; then mv "$backup/nvim" "$target"; fi
    exit 1
fi
printf 'Linked: %s -> %s\n' "$target" "$source_dir"
printf 'Plugin data, caches, and state remain outside this repository.\n'
