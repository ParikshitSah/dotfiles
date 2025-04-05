#!/usr/bin/env bash

# Stow script for managing dotfiles across Linux and macOS
# Updated: 2025-04-05

# --- Configuration ---
# Directory where this script and the dotfile packages live
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Packages that have the same target structure relative to $HOME on both OSes
# (or use ~/.config consistently)
COMMON_PACKAGES="ghostty starship tmux vim zshrc"

# Package that needs OS-specific target path for stow
VSCODE_PACKAGE="vscode"

# --- Helper Functions ---
print_separator() {
  echo "----------------------------------------"
}

print_info() {
  echo "[INFO] $1"
}

print_action_required() {
  echo "[ACTION REQUIRED] $1"
}

# --- Execution ---

print_separator
print_info "Starting dotfiles stow process..."
print_info "Dotfiles directory: $DOTFILES_DIR"
print_separator

echo ""
print_info "Changing directory to $DOTFILES_DIR"
cd "$DOTFILES_DIR" || { echo "[ERROR] Failed to change directory to $DOTFILES_DIR"; exit 1; }
echo ""

# Stow common packages
print_separator
print_info "Stowing common packages: $COMMON_PACKAGES"
print_separator
stow $COMMON_PACKAGES
print_info "Common packages stowed."
echo ""

# --- Post-Stow Actions/Notes for Common Packages ---
print_separator
print_info "Post-Stow Setup for Common Packages:"
print_separator

# Check if vim was stowed and run PlugInstall
if [[ "$COMMON_PACKAGES" == *vim* ]]; then
  if command -v vim &> /dev/null; then
    print_info "Vim found. Attempting to automatically install Vim plugins using PlugInstall..."
    # Run PlugInstall and quit Vim automatically
    vim +PlugInstall +qall
    print_info "Vim PlugInstall command executed. Please check Vim for any errors if needed."
  else
    print_info "Vim command not found. Skipping automatic plugin installation."
    print_action_required "Install Vim and ensure 'vim-plug' is correctly set up in your .vimrc, then run ':PlugInstall' manually inside Vim."
  fi
  echo ""
fi

# Check if tmux was stowed and add note
if [[ "$COMMON_PACKAGES" == *tmux* ]]; then
  print_action_required "For Tmux (.tmux.conf): If using TPM (Tmux Plugin Manager), start tmux and press 'prefix + I' (capital i) to install plugins."
  print_info "  > Note: 'prefix' is typically 'Ctrl+b' or 'Ctrl+a'."
  echo ""
fi

# Stow OS-specific packages
print_separator
print_info "Stowing OS-specific packages..."
print_separator
OS_NAME=$(uname)

if [[ "$OS_NAME" == "Darwin" ]]; then
    print_info "[macOS Detected]"
    VSCODE_TARGET_DIR="$HOME/Library/Application Support/Code/User"

elif [[ "$OS_NAME" == "Linux" ]]; then
    print_info "[Linux Detected]"
    VSCODE_TARGET_DIR="$HOME/.config/Code/User"
else
    echo "[ERROR] Unsupported OS: $OS_NAME"
    exit 1
fi

# --- VS Code Stow (OS Specific) ---
if [[ -n "$VSCODE_TARGET_DIR" ]]; then
  print_info "VS Code target directory: $VSCODE_TARGET_DIR"
  mkdir -p "$VSCODE_TARGET_DIR" # Ensure target directory exists
  print_info "Stowing $VSCODE_PACKAGE to $VSCODE_TARGET_DIR..."
  stow -t "$VSCODE_TARGET_DIR" --restow "$VSCODE_PACKAGE"
  print_info "VS Code package stowed."
else
  print_info "Skipping VS Code stow (could not determine target directory)."
fi
echo ""


# --- Post-Stow Actions / Setup Information ---

# Install VS Code Extensions
print_separator
print_info "Checking for VS Code extensions setup..."
print_separator

VSCODE_EXTENSIONS_FILE="$DOTFILES_DIR/$VSCODE_PACKAGE/extensions.txt"

# Check if 'code' command exists before attempting install
if ! command -v code &> /dev/null; then
    print_action_required "VS Code 'code' command not found in your PATH."
    print_info "  > To install extensions automatically, you need to add it."
    print_info "  > Open VS Code, press 'Cmd+Shift+P' (macOS) or 'Ctrl+Shift+P' (Linux),"
    print_info "  > type 'Shell Command', and select 'Shell Command: Install 'code' command in PATH'."
    print_info "  > You may need to restart your terminal after doing this."
    echo ""
else
    # 'code' command exists, now check for the extensions file
    if [ -f "$VSCODE_EXTENSIONS_FILE" ]; then
        print_info "'code' command found and $VSCODE_EXTENSIONS_FILE exists."
        print_info "Attempting to install VS Code extensions listed in the file..."
        cat "$VSCODE_EXTENSIONS_FILE" | xargs -L 1 code --install-extension
        print_info "Extension installation process initiated. Check VS Code for progress/errors."
        echo ""
    else
        print_info "'code' command found, but Extensions file not found at $VSCODE_EXTENSIONS_FILE"
        print_info "Skipping automatic extension installation."
        echo ""
    fi
fi

# --- Finalization ---
print_separator
print_info "Dotfiles stow process complete."
print_separator

exit 0
