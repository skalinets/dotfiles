#!/bin/bash
# Sporadic install then dotfiles-remove must leave $HOME exactly as it was, original files included.
set -euo pipefail
src=$(cd "$(dirname "$0")/.." && pwd)
chezmoi_bin=$(command -v chezmoi)
home=$(mktemp -d)
export HOME=$home XDG_CONFIG_HOME=$home/.config XDG_DATA_HOME=$home/.local/share XDG_CACHE_HOME=$home/.cache XDG_STATE_HOME=$home/.local/state
echo "# host bashrc marker" > "$HOME/.bashrc"
printf '[user]\n\tname = Host User\n' > "$HOME/.gitconfig"
snapshot() { (cd "$HOME" && find . -mindepth 1 | sort; cat .bashrc .gitconfig) ; }
before=$(snapshot)

mkdir -p "$HOME/.local/bin" "$HOME/.local/share"
cp "$chezmoi_bin" "$HOME/.local/bin/chezmoi"
git clone -q "$src" "$HOME/.local/share/chezmoi"
# Test the working tree, including uncommitted changes
rsync -a --exclude .git "$src/" "$HOME/.local/share/chezmoi/"
"$HOME/.local/bin/chezmoi" init --apply --force </dev/null

managed=$("$HOME/.local/bin/chezmoi" managed --include=files | grep -v '^.local/bin/dotfiles-remove$' | sort)
expected=$(grep -v '^$' "$src/.chezmoitemplates/sporadic-files" | sort)
if [ "$managed" != "$expected" ]; then
  echo "Sporadic managed files differ from .chezmoitemplates/sporadic-files:" >&2
  diff <(echo "$expected") <(echo "$managed") >&2 || true
  exit 1
fi
grep -q 'Managed by chezmoi' "$HOME/.bashrc"

"$HOME/.local/bin/dotfiles-remove"
after=$(snapshot)
if [ "$before" != "$after" ]; then
  echo "HOME differs after dotfiles-remove:" >&2
  diff <(echo "$before") <(echo "$after") >&2 || true
  exit 1
fi
rm -rf "$home"
echo "Roundtrip restored HOME exactly."
