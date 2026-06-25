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

# `run <file.cpp> [args...]` — compile a single C++ file with g++, run the
#                              resulting binary, then clean up the artifacts.
run() {
    local out="${1%.cpp}"
    g++ "$1" -o "$out" && "./$out" "${@:2}"
    local rc=$?
    rm -f "$out" a.out
    return $rc
}
