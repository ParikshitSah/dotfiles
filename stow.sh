#!/usr/bin/env bash

# Stow script for managing dotfiles across Linux and macOS
# Enhanced with colors and ASCII art!
# Updated: 2025-04-05 (ASCII Art Update)

# --- Configuration ---
# Directory where this script and the dotfile packages live
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Packages that have the same target structure relative to $HOME on both OSes
# (or use ~/.config consistently)
COMMON_PACKAGES="ghostty starship tmux vim zshrc"

# Package that needs OS-specific target path for stow
VSCODE_PACKAGE="vscode"

# --- Colors ---
RESET='\033[0m'
BOLD='\033[1m'
# Regular Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
# Bold Colors
BOLD_RED='\033[1;31m'
BOLD_GREEN='\033[1;32m'
BOLD_YELLOW='\033[1;33m'
BOLD_BLUE='\033[1;34m'
BOLD_MAGENTA='\033[1;35m'
BOLD_CYAN='\033[1;36m'

# --- ASCII Art ---
# Font: Standard blocks (User provided) - "Stow Setup" (Implied)
print_ascii_art() {
  echo -e "${BOLD_CYAN}"
  # Replaced with user-provided art


echo '███████╗████████╗ ██████╗ ██╗    ██╗    ███████╗███████╗████████╗██╗   ██╗██████╗'
echo '██╔════╝╚══██╔══╝██╔═══██╗██║    ██║    ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗'
echo '███████╗   ██║   ██║   ██║██║ █╗ ██║    ███████╗█████╗     ██║   ██║   ██║██████╔╝'
echo '╚════██║   ██║   ██║   ██║██║███╗██║    ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝'
echo '███████║   ██║   ╚██████╔╝╚███╔███╔╝    ███████║███████╗   ██║   ╚██████╔╝██║'
echo '╚══════╝   ╚═╝    ╚═════╝  ╚══╝╚══╝     ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝'
echo -e "${RESET}"
}

# --- Helper Functions ---
print_separator() {
  echo -e "${BOLD_BLUE}----------------------------------------${RESET}"
}

print_info() {
  echo -e "${CYAN}[INFO]${RESET} $1"
}

print_action_required() {
  echo -e "${BOLD_YELLOW}[ACTION REQUIRED]${RESET} $1"
}

print_success() {
  echo -e "${BOLD_GREEN}[SUCCESS]${RESET} $1"
}

print_error() {
  echo -e "${BOLD_RED}[ERROR]${RESET} $1"
}

# --- Execution ---

clear # Optional: Clear the screen before showing the art
print_ascii_art
echo ""
print_separator
print_info "Starting dotfiles stow process..."
print_info "Dotfiles directory: ${BOLD}$DOTFILES_DIR${RESET}"
print_separator
echo ""

print_info "Changing directory to ${BOLD}$DOTFILES_DIR${RESET}"
cd "$DOTFILES_DIR" || { print_error "Failed to change directory to $DOTFILES_DIR"; exit 1; }
echo ""

# Stow common packages
print_separator
print_info "Stowing common packages: ${BOLD}$COMMON_PACKAGES${RESET}"
print_separator
stow $COMMON_PACKAGES
print_success "Common packages stowed."
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
    print_info "Vim PlugInstall command executed. ${YELLOW}Please check Vim for any errors if needed.${RESET}"
  else
    print_info "${YELLOW}Vim command not found. Skipping automatic plugin installation.${RESET}"
    print_action_required "Install Vim and ensure 'vim-plug' is correctly set up in your .vimrc, then run ':PlugInstall' manually inside Vim."
  fi
  echo ""
fi

# Check if tmux was stowed and add note
if [[ "$COMMON_PACKAGES" == *tmux* ]]; then
  print_action_required "For Tmux (.tmux.conf): If using TPM (Tmux Plugin Manager), start tmux and press 'prefix + I' (capital i) to install plugins."
  print_info "  > Note: 'prefix' is typically '${BOLD}Ctrl+b${RESET}' or '${BOLD}Ctrl+a${RESET}'."
  echo ""
fi

# Stow OS-specific packages
print_separator
print_info "Stowing OS-specific packages..."
print_separator
OS_NAME=$(uname)

if [[ "$OS_NAME" == "Darwin" ]]; then
    print_info "[${BOLD_MAGENTA}macOS${RESET} Detected]"
    VSCODE_TARGET_DIR="$HOME/Library/Application Support/Code/User"

elif [[ "$OS_NAME" == "Linux" ]]; then
    print_info "[${BOLD_MAGENTA}Linux${RESET} Detected]"
    VSCODE_TARGET_DIR="$HOME/.config/Code/User"
else
    print_error "Unsupported OS: $OS_NAME"
    exit 1
fi

# --- VS Code Stow (OS Specific) ---
if [[ -n "$VSCODE_TARGET_DIR" ]]; then
  print_info "VS Code target directory: ${BOLD}$VSCODE_TARGET_DIR${RESET}"
  mkdir -p "$VSCODE_TARGET_DIR" # Ensure target directory exists
  print_info "Stowing ${BOLD}$VSCODE_PACKAGE${RESET} to ${BOLD}$VSCODE_TARGET_DIR${RESET}..."
  stow -t "$VSCODE_TARGET_DIR" --restow "$VSCODE_PACKAGE"
  print_success "VS Code package stowed."
else
  print_info "${YELLOW}Skipping VS Code stow (could not determine target directory).${RESET}"
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
    print_info "  > Open VS Code, press '${BOLD}Cmd+Shift+P${RESET}' (macOS) or '${BOLD}Ctrl+Shift+P${RESET}' (Linux),"
    print_info "  > type '${BOLD}Shell Command${RESET}', and select '${BOLD}Shell Command: Install 'code' command in PATH${RESET}'."
    print_info "  > ${YELLOW}You may need to restart your terminal after doing this.${RESET}"
    echo ""
else
    # 'code' command exists, now check for the extensions file
    if [ -f "$VSCODE_EXTENSIONS_FILE" ]; then
        print_info "'${BOLD}code${RESET}' command found and ${BOLD}$VSCODE_EXTENSIONS_FILE${RESET} exists."
        print_info "Attempting to install VS Code extensions listed in the file..."
        cat "$VSCODE_EXTENSIONS_FILE" | xargs -L 1 code --install-extension
        print_info "Extension installation process initiated. ${YELLOW}Check VS Code for progress/errors.${RESET}"
        echo ""
    else
        print_info "'${BOLD}code${RESET}' command found, but Extensions file not found at ${BOLD}$VSCODE_EXTENSIONS_FILE${RESET}"
        print_info "${YELLOW}Skipping automatic extension installation.${RESET}"
        echo ""
    fi
fi

# --- Finalization ---
print_separator
print_success "Dotfiles stow process complete!"
print_separator
echo "" # Extra newline at the end

exit 0
