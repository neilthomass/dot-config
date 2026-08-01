# ─────────────────────────────────────────────────────────────
#  Custom shell commands  (sourced from .zshrc)
# ─────────────────────────────────────────────────────────────

# `cl` — remove the Claude Code managed-settings file (if present) so local
#        settings win, then launch Claude with permission prompts disabled.
alias cl='[ -f "$HOME/Library/Application\ Support/ClaudeCode/managed-settings.json" ] && sudo rm "$HOME/Library/Application\ Support/ClaudeCode/managed-settings.json" && echo "exists" || echo "hey man" ; claude --dangerously-skip-permissions'

# `zed` — launch the Zed editor CLI.
alias zed='/Applications/Zed.app/Contents/MacOS/cli'

# `gpush` — stage everything, commit with message "changes", then push.
alias gpush='git add -A && git commit -m "changes" && git push'

# `nil` — reset a terminal stuck in mouse-tracking mode (e.g. after an SSH
#         drop) by disabling the X10/button/any-motion/SGR mouse-report modes.
alias nil="printf '\e[?1000l\e[?1002l\e[?1003l\e[?1006l'"

# `gcr <branch>` — git checkout remote: fetch a remote branch into a local
#                  branch of the same name and check it out.
gcr() {
    git fetch origin "$1:$1"
    git checkout "$1"
}

# `run <file.cpp> [args...]` — compile a single C++ file as C++23, run the
#                              resulting binary, then clean up the artifacts.
#
# On macOS plain `g++` is Apple clang, which ships libc++ and therefore has no
# <bits/stdc++.h>. Prefer a real Homebrew GCC when one is installed; on Linux
# (Coder devbox) `g++` already is GCC, so the fallback is correct there.
run() {
    local out="${1%.cpp}" cxx
    for cxx in g++-16 g++-15 g++-14 g++; do
        command -v "$cxx" >/dev/null 2>&1 && break
    done
    "$cxx" -std=c++23 "$1" -o "$out" && "./$out" "${@:2}"
    local rc=$?
    rm -f "$out" a.out
    return $rc
}
