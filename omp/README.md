# OMP configuration

Shared OMP model roles, UI settings, and the `frontend`, `designer`, and `writer` agent definitions. This directory is public. Authentication, sessions, caches, and other runtime state stay in each machine's OMP directory and are not linked into this repository. Do not add credentials to shared configuration.

## Install on macOS or Ubuntu

Install OMP and Git first, and authenticate model providers separately on each machine.

```sh
mkdir -p ~/Developer
cd ~/Developer
git clone git@github.com:cynicalight/dotfiles.git
cd dotfiles
sh omp/install.sh
```

If already cloned, use the existing checkout. The installer uses the active directory reported by `omp config path`. For a named profile, run `OMP_PROFILE=work sh omp/install.sh` with the desired profile name.

Existing files or links are backed up under `<active-agent-dir>/config-backup.XXXXXX/`. Only `config.yml` and the three listed agent files are symlinked; other OMP files are untouched. Correct existing links are left unchanged. Keep this checkout in place.

Persistent OMP settings changes write through the `config.yml` symlink into this repository. Project or session overrides can still take precedence over shared settings. Check `/agents` or start a new session if the visible agent list has not refreshed.

## Sync

Before editing shared configuration on either machine:

```sh
cd ~/Developer/dotfiles
git pull --ff-only
```

After editing, review the changes for secrets and unrelated work, then stage the intended files:

```sh
git diff -- omp/
git add omp/config.yml omp/agents/frontend.md omp/agents/designer.md omp/agents/writer.md
git commit -m "Update OMP configuration"
git push
```

Pull on the other machine; no reinstall is needed for already-linked files. Run `sh omp/install.sh` again when the installer adds a new file. Git does not sync automatically. Preserve local changes and resolve divergence explicitly rather than force-pushing or discarding work.

`omp/.gitignore` is an allowlist: add an explicit exception before tracking another portable configuration file. Keep machine-specific overrides outside the repository and launch OMP with `--config /absolute/path/to/local.yml` when needed.

## Migration and recovery

This directory replaces the separate `cynicalight/omp-config` repository. Run this installer to move existing links to `dotfiles/omp/`; the old checkout is not deleted. Future OMP commits and pulls belong in `~/Developer/dotfiles`.

To restore a previous local configuration, use the backup directory printed by the installer. Confirm a destination is still the symlink created by the installer before removing that link and moving the corresponding backup into place. Backed-up symlinks still depend on their original checkout, so keep old checkouts until they are no longer needed.
