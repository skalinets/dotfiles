# Shared by every profile, sourced from both bash and zsh. Keep it POSIX-ish and fast.

case ":$PATH:" in *":$HOME/.local/bin:"*) ;; *) export PATH="$HOME/.local/bin:$PATH" ;; esac

if command -v nvim >/dev/null 2>&1; then export EDITOR=nvim
elif command -v vim >/dev/null 2>&1; then export EDITOR=vim
else export EDITOR=vi
fi
export VISUAL="$EDITOR"
export LANG="${LANG:-en_US.UTF-8}"

alias ll='ls -alF'
alias la='ls -A'
alias ..='cd ..'
alias ...='cd ../..'
alias g=git
alias gs='git status -sb'
alias gl='git lg -20'

# Turn off mouse tracking left on by a dropped SSH session
_reset_mouse() { printf '\033[?1000l\033[?1002l\033[?1003l\033[?1006l'; }
alias fixterm=_reset_mouse

# One line when the dotfiles checkout is behind origin. Fetches in the background at most daily.
_dotfiles_check() {
  _src="${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi"
  [ -d "$_src/.git" ] || return 0
  if [ -z "$(find "$_src/.git/FETCH_HEAD" -mmin -1440 2>/dev/null)" ]; then
    (git -C "$_src" fetch -q >/dev/null 2>&1 &)
  fi
  _behind=$(git -C "$_src" rev-list --count 'HEAD..@{u}' 2>/dev/null) || return 0
  [ "${_behind:-0}" -gt 0 ] && echo "dotfiles: $_behind commit(s) behind origin, run: chezmoi update"
  unset _src _behind
  return 0
}
case $- in *i*) _dotfiles_check ;; esac
