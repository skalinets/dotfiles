# dotfiles

Shell, git, tmux and vim config for macOS and Linux, managed with [chezmoi](https://chezmoi.io). The repo is public and holds no secrets or private hostnames. CI fails on either.

## Profiles

| Profile | For | Gets |
|---|---|---|
| `sporadic` | a box you visit briefly | portable bash/zsh rc, git, tmux, vim. No sudo, no packages, no framework |
| `personal` | your own Macs | oh-my-zsh + powerlevel10k, full tmux, nvim config, MacPorts packages, `~/.agents` |

`chezmoi init` asks for the profile once. Without a terminal it picks `sporadic`.

## Install

Sporadic, user space only:

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin init --apply --force --promptChoice profile=sporadic skalinets
```

Remove it again. This restores the host's original files and deletes chezmoi:

```sh
~/.local/bin/dotfiles-remove
```

Personal Mac (needs Xcode Command Line Tools; init asks for the private nvim and agent-config repo URLs, empty skips):

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin init --apply skalinets
```

This installs MacPorts, the ports and App Store apps in `.chezmoidata/packages.yaml`, and clones the nvim config and `~/.agents` when their URLs were given at init. GUI apps are listed in [APPS.md](APPS.md) and installed by hand.

## Daily use

- `chezmoi update` pulls and applies. A new shell prints one line when the local copy is behind.
- `chezmoi edit ~/.zshrc` or `chezmoi re-add`, then commit and push from `chezmoi cd`.

## Machine-local files

These are sourced or included when present and are never committed:

`~/.zshrc.local`, `~/.bashrc.local`, `~/.gitconfig.local`, `~/.ssh/config.local`, `~/.tmux.conf.local`

Host entries, private hostnames, work identities, kubeconfig paths and tokens belong there.

## CI

Every push runs gitleaks, a private-info grep (`ci/check-private.sh`), the sporadic profile on Ubuntu and Debian, and the personal profile on macOS. Each job either passes or fails.
