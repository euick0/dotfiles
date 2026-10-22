#!/bin/sh
# Installs the tools these configs need. Runs once per machine (chezmoi tracks it).
set -eu
has() { command -v "$1" >/dev/null 2>&1; }
if [ "$(id -u)" -eq 0 ]; then SUDO=""; else SUDO="sudo"; fi

if has brew; then
  brew install git neovim tmux starship ripgrep fd
elif has apt-get; then
  $SUDO apt-get update
  $SUDO apt-get install -y git curl tmux ripgrep fd-find build-essential unzip
elif has dnf; then
  $SUDO dnf install -y git curl tmux ripgrep fd-find gcc make unzip neovim
elif has pacman; then
  $SUDO pacman -Sy --needed --noconfirm git curl tmux ripgrep fd base-devel unzip neovim starship
fi

BIN="$HOME/.local/bin"
mkdir -p "$BIN"
# Debian/Ubuntu ship fd as 'fdfind'
if has fdfind && ! has fd; then ln -sf "$(command -v fdfind)" "$BIN/fd"; fi

# Neovim 0.11.2+ (distro packages are often too old)
if ! { has nvim && nvim --headless -u NONE -c 'if has("nvim-0.11.2")|qa|else|cq|endif' 2>/dev/null; }; then
  if [ "$(uname -s)" = "Linux" ]; then
    case "$(uname -m)" in
    aarch64 | arm64) ARCH=arm64 ;;
    *) ARCH=x86_64 ;;
    esac
    curl -fsSL "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-$ARCH.tar.gz" |
      tar -xz -C "$HOME/.local"
    ln -sf "$HOME/.local/nvim-linux-$ARCH/bin/nvim" "$BIN/nvim"
  fi
fi

if ! has starship; then
  curl -sS https://starship.rs/install.sh | sh -s -- -y -b "$BIN"
fi

# tmux plugins
if [ -x "$HOME/.tmux/plugins/tpm/bin/install_plugins" ]; then
  "$HOME/.tmux/plugins/tpm/bin/install_plugins" || true
fi
