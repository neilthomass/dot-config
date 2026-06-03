# dotfiles

My macOS coding setup. From my past experience of internships + getting new computers setting up my configurations takes too long and turns into hassle. This project consolidates all the tools I use into one repo and makes setup frictionless.


```bash
git clone github.com/neilthomass/dot-config ~/dot-config
cd ~/dot-config
./install.sh
```

`install.sh` is idempotent and safe to re-run. It will:

1. Install [Homebrew](https://brew.sh) if it isn't already present.
2. `brew bundle` everything in the [`Brewfile`](./Brewfile).
3. Install [nvm](https://github.com/nvm-sh/nvm) and tmux's
   [TPM](https://github.com/tmux-plugins/tpm).
4. Symlink the config files below into place (backing up anything already there
   to `~/.dotfiles-backup/<timestamp>/`).
5. Generate `~/.gitconfig` from a template, prompting for name / email / signing key.

---

## Everything I use & why

Grouped by purpose. The authoritative install list is the [`Brewfile`](./Brewfile).

### Shell & prompt
- **[Starship](https://starship.rs)** — minimal, fast prompt. I keep it to just `directory + ❯` so the line stays clean.
- **[zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)** — Fish-style greyed-out suggestions from history as I type; tab/→ to accept.
- **[zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)** — colors commands as I type so typos/bad commands are obvious before I hit enter.
- **[thefuck](https://github.com/nvbn/thefuck)** — retypes the corrected version of the command I just botched.

### Terminal & multiplexing
- **[Ghostty](https://ghostty.org)** — primary terminal: GPU-accelerated, fast, Gruvbox Dark Hard. Auto-attaches the `main` tmux session on launch.
- **[tmux](https://github.com/tmux/tmux)** — persistent sessions + pane splits so my layout survives disconnects and terminal restarts.
- **[TPM](https://github.com/tmux-plugins/tpm)** — manages the tmux plugins declared in `tmux.conf`.

### Editors
- **[Zed](https://zed.dev)** — primary editor: fast, vim mode on, Gruvbox, clangd for C++.
- **[VS Code](https://code.visualstudio.com)** — secondary editor for extension-heavy work; settings synced via its own Settings Sync.
- **[Neovim](https://neovim.io)** — in-terminal edits and quick diffs without leaving the shell.

### Git & GitHub
- **[git](https://git-scm.com)** — version control, configured with SSH commit signing.
- **[gh](https://cli.github.com)** — GitHub from the terminal (PRs, issues, auth).
- **[lazygit](https://github.com/jesseduffield/lazygit)** — fast terminal UI for staging/committing/rebasing.
- **[git-lfs](https://git-lfs.com/)** — handles large binary assets in repos that use it.
- **[gitleaks](https://github.com/gitleaks/gitleaks)** — scans for secrets before they get committed.

### Languages & runtime managers
- **[mise](https://mise.jdx.dev)** — polyglot version manager; the main way I pin tool/runtime versions per project.
- **[node](https://nodejs.org)** + **[pnpm](https://pnpm.io)** — JS runtime and my package manager of choice (fast, disk-efficient).
- **[go](https://go.dev)** — Go toolchain.
- **[rustup](https://rustup.rs)** — Rust toolchain installer + updater.
- **[python@3.11](https://www.python.org)** + **[python-setuptools](https://pypi.org/project/setuptools/)** — Python runtime and build tooling.

### Build & native deps
- **[cmake](https://cmake.org)** — C/C++ build system generator.
- **[ccache](https://ccache.dev)** — caches compiles so rebuilds are fast.
- **[protobuf](https://protobuf.dev)** — `protoc` for generating code from `.proto` files.
- **[librdkafka](https://github.com/confluentinc/librdkafka)** — Kafka C library that native clients link against.
- **[zlib](https://zlib.net)** — compression lib needed when building things from source (wired into `PKG_CONFIG_PATH`).

### CLI workhorses
- **[jq](https://github.com/jqlang/jq)** / **[yq](https://github.com/mikefarah/yq)** — slice and query JSON / YAML on the command line.
- **[curl](https://curl.se)** / **[wget](https://www.gnu.org/software/wget/)** — HTTP requests and downloads.
- **[rsync](https://rsync.samba.org)** — efficient file copies/syncs.
- **[fswatch](https://github.com/emcrisostomo/fswatch)** / **[watchman](https://facebook.github.io/watchman/)** — watch the filesystem and trigger actions on change.
- **[mkcert](https://github.com/FiloSottile/mkcert)** — trusted local TLS certs for dev servers.

### Linting & formatting
- **[shellcheck](https://www.shellcheck.net)** — catches bugs in shell scripts.
- **[shfmt](https://github.com/mvdan/sh)** — formats shell scripts consistently.

### Window management & input
- **[AeroSpace](https://github.com/nikitabobko/AeroSpace)** — i3-style tiling WM with `alt`-based keybinds; how I arrange windows across workspaces.
- **[Karabiner-Elements](https://karabiner-elements.pqrs.org)** — remaps Caps Lock → Esc (tap) / Control (hold).

### System & cloud
- **[Stats](https://github.com/exelban/stats)** — menu-bar CPU/mem/network monitor.


## Notable settings

- **Caps Lock → Esc (tap) / Control (hold)** — configured in
  [Karabiner](./config/karabiner/karabiner.json). Ergonomic esc + control usage.
- **Gruvbox** theme everywhere — Ghostty (`Gruvbox Dark Hard`), Zed, and
  `LS_COLORS` in the shell.
- **Ghostty auto-attaches tmux** — every window joins the `main` session.
- **AeroSpace** uses i3-style `alt`-based bindings; see the config for the full map.
- **Vim mode** is on in Zed.