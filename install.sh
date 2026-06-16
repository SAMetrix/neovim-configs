#!/usr/bin/env bash
# ------------------------------------------------------------
# Neovim Config Installer
# Detects OS and architecture, installs core dependencies,
# backs up any existing ~/.config/nvim, and deploys this
# config in its place.
#
# Core dependencies installed:
#   neovim >= 0.11  (native vim.lsp API used by plugin/lsp.lua)
#   git             (manage.lua git-clones plugins at startup)
#   ripgrep         (telescope live_grep)
#   fd              (telescope find_files)
#   yazi            (file manager; required by mikavilpas/yazi.nvim)
#
# LSP servers are NOT installed by this script because they are
# language-specific. Install whichever ones you need separately.
# See plugin/lsp.lua for the full list with server names and
# the commands they expect on $PATH.
#
# A Nerd Font must be installed and configured in your terminal
# emulator for nvim-web-devicons icons to render correctly.
# Recommended: https://www.nerdfonts.com
# ------------------------------------------------------------

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVIM_CONFIG_DIR="$HOME/.config/nvim"
BACKUP_DIR="$HOME/config-backup"
DATE="$(date +%s)"

OS="$(uname -s)"
ARCH="$(uname -m)"

echo "Detected OS:   $OS"
echo "Detected Arch: $ARCH"

# ── Helpers ────────────────────────────────────────────────

gh_latest_version() {
    # Usage: gh_latest_version owner/repo
    curl -s "https://api.github.com/repos/$1/releases/latest" \
        | grep -Po '"tag_name": *"v\K[^"]*'
}

# ── Linux dependency installation ─────────────────────────

install_neovim_linux() {
    local ver arch tarball extract_dir
    ver="$(gh_latest_version neovim/neovim)"
    arch="$(uname -m)"   # x86_64 or aarch64 → matches release naming directly
    tarball="nvim-linux-${arch}.tar.gz"
    extract_dir="/tmp/nvim-linux-${arch}"

    echo "Downloading Neovim v${ver}..."
    curl -Lo "/tmp/${tarball}" \
        "https://github.com/neovim/neovim/releases/download/v${ver}/${tarball}"
    tar -xzf "/tmp/${tarball}" -C /tmp
    sudo cp -r "${extract_dir}/bin"  /usr/local/
    sudo cp -r "${extract_dir}/lib"  /usr/local/
    sudo cp -r "${extract_dir}/share" /usr/local/
    rm -rf "/tmp/${tarball}" "${extract_dir}"
    echo "Neovim $(nvim --version | head -1) installed."
}

install_yazi_linux() {
    local ver arch zip_name inner_dir
    ver="$(gh_latest_version sxyazi/yazi)"
    arch="$(uname -m | sed -e 's/x86_64/x86_64-unknown-linux-gnu/' \
                            -e 's/aarch64/aarch64-unknown-linux-gnu/')"
    zip_name="yazi-${arch}.zip"
    inner_dir="/tmp/yazi-extracted/yazi-${arch}"

    echo "Downloading Yazi v${ver}..."
    curl -Lo "/tmp/${zip_name}" \
        "https://github.com/sxyazi/yazi/releases/download/v${ver}/${zip_name}"
    mkdir -p /tmp/yazi-extracted
    unzip -o "/tmp/${zip_name}" -d /tmp/yazi-extracted
    sudo install "${inner_dir}/yazi" /usr/local/bin/yazi
    rm -rf "/tmp/${zip_name}" /tmp/yazi-extracted
    echo "Yazi $(yazi --version) installed."
}

# ── OS-specific installs ───────────────────────────────────

if [[ "$OS" == "Linux" ]]; then
    echo "Installing base packages via apt..."
    sudo apt update
    sudo apt install -y git curl ripgrep fd-find rsync unzip

    # On Debian/Ubuntu, fd ships as fdfind; create a symlink so telescope finds it.
    if command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
        sudo ln -sf "$(command -v fdfind)" /usr/local/bin/fd
        echo "Linked fdfind → /usr/local/bin/fd"
    fi

    echo "Installing Neovim from GitHub releases (apt version is often too old)..."
    install_neovim_linux

    echo "Installing Yazi from GitHub releases..."
    install_yazi_linux

elif [[ "$OS" == "Darwin" ]]; then
    echo "Installing dependencies via Homebrew..."
    if ! command -v brew &>/dev/null; then
        echo "Homebrew not found — installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Activate Homebrew for the current shell session.
    if [[ "$ARCH" == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi

    brew update
    brew install neovim git ripgrep fd yazi

else
    echo "Unsupported OS: $OS"
    exit 1
fi

# ── Backup existing Neovim config ─────────────────────────

if [[ -d "$NVIM_CONFIG_DIR" ]]; then
    echo "Existing config found at $NVIM_CONFIG_DIR"
    if [[ ! -d "$BACKUP_DIR" ]]; then
        echo "Creating backup directory at $BACKUP_DIR"
        mkdir -p "$BACKUP_DIR"
    fi
    BACKUP_PATH="$BACKUP_DIR/nvim.bak.$DATE"
    echo "Moving $NVIM_CONFIG_DIR → $BACKUP_PATH"
    mv "$NVIM_CONFIG_DIR" "$BACKUP_PATH"
    echo "Backup saved to $BACKUP_PATH"
fi

# ── Deploy config ──────────────────────────────────────────

echo "Creating $NVIM_CONFIG_DIR..."
mkdir -p "$NVIM_CONFIG_DIR"

echo "Copying config files to $NVIM_CONFIG_DIR..."
rsync -a --exclude='.git' --exclude='install.sh' "$SCRIPT_DIR/" "$NVIM_CONFIG_DIR/"
echo "Config deployed to $NVIM_CONFIG_DIR"

# ── Done ───────────────────────────────────────────────────

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Launch Neovim — plugins are auto-cloned to ~/.local/share/nvim/plugins"
echo "     on first startup. Wait for the initial clone pass to finish."
echo "  2. Install a Nerd Font and set it in your terminal emulator."
echo "     See: https://www.nerdfonts.com"
echo "  3. Install LSP servers for the languages you use. Examples:"
echo "       Lua:        brew install lua-language-server  (macOS)"
echo "                   sudo apt install lua-language-server  (Linux)"
echo "       TypeScript: npm install -g typescript-language-server typescript"
echo "       Go:         go install golang.org/x/tools/gopls@latest"
echo "       Python:     pip install pyright"
echo "     See plugin/lsp.lua for the full server list."
