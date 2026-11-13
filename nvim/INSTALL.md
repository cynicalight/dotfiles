# LazyVim in dotfiles

This directory preserves the Mac Neovim configuration: Lua plugin/config files, filetype overrides, `lazyvim.json`, `lazy-lock.json`, and the custom spelling word list. The original license and README are retained. The original nested Git repository and local `.claude` metadata are not imported; the Mac backup preserves them.

## Install

Install Neovim and Git first, then run from the dotfiles checkout:

```sh
cd ~/Developer/dotfiles
sh nvim/install.sh
nvim
```

The installer links `${XDG_CONFIG_HOME:-$HOME/.config}/nvim` to this directory. An existing configuration directory or link is moved into a printed `nvim-backup.XXXXXX/nvim` path first. Running the installer again with the same checkout leaves the correct link unchanged. Keep the checkout in place. This targets the default `nvim` application name; a custom `NVIM_APPNAME` requires a corresponding separate setup.

Lazy.nvim manages plugins under Neovim's data directory, not in this repository. Keep the lockfile tracked for reproducible plugin versions; use `:Lazy restore` when you explicitly want to align installed plugins to it. Migration does not run a plugin update, reinstall, or change the existing plugin specs.

The configuration was migrated from macOS with Neovim 0.12.2. Other platforms still need their own external tools (language servers, formatters, clipboard tools, etc.); copying this directory does not install them. The Python provider currently points to `/usr/bin/python3`, as in the original configuration.

The compiled custom spelling dictionary is generated locally and ignored. If needed, rebuild it in Neovim:

```vim
:mkspell! ~/.config/nvim/spell/en.utf-8.add
```

## Sync

```sh
cd ~/Developer/dotfiles
git pull --ff-only
# Review and stage only intended configuration changes.
git diff -- nvim/
git add nvim/
git commit -m "Update Neovim configuration"
git push
```

Review diffs before publishing: this is a public repository. Credentials and runtime/plugin data do not belong here. Other machines can pull the configuration without installing it; run the installer only on machines where you want to activate it.

## Restore the previous Mac configuration

Use the backup directory printed during installation. Confirm the active `nvim` path is still this installer's symlink, remove only that link, then move the backed-up `nvim` directory into its original location. The backup retains the previous standalone Git history and other local metadata.
