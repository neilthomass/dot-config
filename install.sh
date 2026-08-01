#!/usr/bin/env bash
#
# install.sh — bootstrap my macOS coding setup from scratch.
#
#   1. Install Homebrew (if missing)
#   2. Install everything in the Brewfile
#   3. Install nvm + tmux's plugin manager (TPM)
#   4. Symlink config files into place (backing up anything already there)
#   5. Generate ~/.gitconfig from a template (prompts for identity)
#   6. Apply macOS system defaults (fast key repeat, etc.)
#
# Safe to re-run: it's idempotent and backs up existing files before linking.

set -euo pipefail

# Repo root = directory this script lives in.
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

bold() { printf "\033[1m%s\033[0m\n" "$1"; }
info() { printf "  \033[36m›\033[0m %s\n" "$1"; }
ok()   { printf "  \033[32m✓\033[0m %s\n" "$1"; }

# ─────────────────────────────────────────────────────────────
#  1. Homebrew
# ─────────────────────────────────────────────────────────────
bold "==> Homebrew"
if ! command -v brew >/dev/null 2>&1; then
    info "Homebrew not found — installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
# Make brew available on PATH for the rest of this script (Apple Silicon path).
if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi
ok "Homebrew ready ($(brew --version | head -1))"

# ─────────────────────────────────────────────────────────────
#  2. Brewfile
# ─────────────────────────────────────────────────────────────
bold "==> Installing packages from Brewfile"
# aerospace lives in a third-party tap. Newer Homebrew refuses to load untrusted
# taps unless we opt out of the trust check, which otherwise aborts the bundle.
export HOMEBREW_NO_REQUIRE_TAP_TRUST=1
brew bundle --file="$DOTFILES/Brewfile"
ok "Brew packages installed"

# ─────────────────────────────────────────────────────────────
#  3. nvm + TPM
# ─────────────────────────────────────────────────────────────
bold "==> Extra tooling"
if [ ! -s "$HOME/.nvm/nvm.sh" ]; then
    info "Installing nvm..."
    PROFILE=/dev/null bash -c \
      "$(curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh)"
    ok "nvm installed"
else
    ok "nvm already present"
fi

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    info "Installing tmux plugin manager (TPM)..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    ok "TPM installed — press prefix + I inside tmux to fetch plugins"
else
    ok "TPM already present"
fi

# ─────────────────────────────────────────────────────────────
#  4. Symlink configs
# ─────────────────────────────────────────────────────────────
bold "==> Linking config files"

# link <repo-relative-source> <absolute-destination>
link() {
    local src="$DOTFILES/$1" dest="$2"
    mkdir -p "$(dirname "$dest")"
    # Already correctly linked? nothing to do.
    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
        ok "$dest"
        return
    fi
    # Back up anything currently there (file, dir, or stale symlink).
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        mkdir -p "$BACKUP_DIR$(dirname "$dest")"
        mv "$dest" "$BACKUP_DIR$dest"
        info "backed up existing $dest"
    fi
    ln -s "$src" "$dest"
    ok "$dest → $src"
}

link shell/zshrc                  "$HOME/.zshrc"
link shell/zprofile               "$HOME/.zprofile"
link tmux/tmux.conf               "$HOME/.tmux.conf"
link aerospace/aerospace.toml     "$HOME/.aerospace.toml"
link config/starship.toml         "$HOME/.config/starship.toml"
link config/ghostty/config        "$HOME/.config/ghostty/config"
link config/zed/settings.json     "$HOME/.config/zed/settings.json"
link config/karabiner/karabiner.json "$HOME/.config/karabiner/karabiner.json"
# clangd reads its user config from the platform preferences dir on macOS,
# NOT ~/.config/clangd — a file placed there is silently ignored.
link clangd/config.yaml           "$HOME/Library/Preferences/clangd/config.yaml"

# ─────────────────────────────────────────────────────────────
#  5. ~/.gitconfig from template (identity kept out of the repo)
# ─────────────────────────────────────────────────────────────
bold "==> Git config"
if [ -f "$HOME/.gitconfig" ]; then
    ok "~/.gitconfig already exists — leaving it untouched"
else
    read -r -p "  Git name: " git_name
    read -r -p "  Git email: " git_email
    read -r -p "  SSH signing key path [$HOME/.ssh/id_ed25519.pub]: " git_key
    git_key="${git_key:-$HOME/.ssh/id_ed25519.pub}"
    sed -e "s|__GIT_NAME__|$git_name|" \
        -e "s|__GIT_EMAIL__|$git_email|" \
        -e "s|__GIT_SIGNINGKEY__|$git_key|" \
        "$DOTFILES/git/gitconfig.template" > "$HOME/.gitconfig"
    ok "wrote ~/.gitconfig"
fi

# ─────────────────────────────────────────────────────────────
#  6. macOS system defaults
# ─────────────────────────────────────────────────────────────
bold "==> macOS defaults"
# Fast delete / key repeat: hold a key (e.g. backspace) and it repeats at the
# fastest rate macOS allows. KeyRepeat is the repeat interval (1 = fastest);
# InitialKeyRepeat is the delay before repeating kicks in (lower = snappier).
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 15
ok "fast key repeat enabled (KeyRepeat=1) — log out/in for it to take effect"

echo
bold "All done!"
echo "  • Restart your shell (or: exec zsh) to pick up the new config."
echo "  • Backups (if any) are in: $BACKUP_DIR"
echo "  • Grant Accessibility/Input-Monitoring permissions to AeroSpace"
echo "    and Karabiner-Elements in System Settings → Privacy & Security."
