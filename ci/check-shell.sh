#!/bin/bash
# Fails when an interactive shell prints anything to stderr or exits non-zero after chezmoi apply.
set -euo pipefail
for sh in "$@"; do
  err=$("$sh" -ic true 2>&1 >/dev/null </dev/null) || { echo "$sh -i exited non-zero: $err" >&2; exit 1; }
  # Without a TTY bash always reports missing job control. That line says nothing about the config.
  err=$(printf '%s\n' "$err" | grep -vE 'no job control in this shell|cannot set terminal process group|Inappropriate ioctl' || true)
  if [ -n "$err" ]; then echo "$sh -i wrote to stderr:" >&2; echo "$err" >&2; exit 1; fi
  echo "$sh: clean start"
done
git config --list >/dev/null
echo "git config parses"
