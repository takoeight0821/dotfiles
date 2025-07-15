#!/usr/bin/env bash

# Dotfiles Setup Script
# This script creates symbolic links for dotfiles and handles backups

set -euo pipefail

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'
readonly RESET='\033[0m'

# Script configuration
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly BACKUP_DIR="${HOME}/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"
readonly CONFIG_DIR="${HOME}/.config"

# Options
DRY_RUN=false
FORCE=true
UNINSTALL=false
VERBOSE=false

# Print colored output
print_info() {
    echo -e "${BLUE}[INFO]${RESET} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${RESET} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${RESET} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${RESET} $1" >&2
}

# Show usage
usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Dotfiles setup script

OPTIONS:
    -h, --help      Show this help message
    -d, --dry-run   Show what would be done without making changes
    -f, --force     Force overwrite existing files without prompting (default)
    --no-force      Prompt before overwriting existing files
    -u, --uninstall Remove symlinks created by this script
    -v, --verbose   Show verbose output

EXAMPLES:
    $0              # Interactive installation
    $0 --dry-run    # Preview changes
    $0 --force      # Force installation
    $0 --uninstall  # Remove dotfiles
EOF
}

# Parse command line options
parse_options() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                usage
                exit 0
                ;;
            -d|--dry-run)
                DRY_RUN=true
                shift
                ;;
            -f|--force)
                FORCE=true
                shift
                ;;
            --no-force)
                FORCE=false
                shift
                ;;
            -u|--uninstall)
                UNINSTALL=true
                shift
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            *)
                print_error "Unknown option: $1"
                usage
                exit 1
                ;;
        esac
    done
}

# Create backup of existing file
backup_file() {
    local file="$1"

    if [[ ! -e "$file" ]]; then
        return 0
    fi

    if $DRY_RUN; then
        print_info "[DRY RUN] Would backup: $file"
        return 0
    fi

    # Create backup directory if needed
    mkdir -p "$BACKUP_DIR"

    # Calculate relative path for backup
    local relative_path="${file#$HOME/}"
    local backup_path="${BACKUP_DIR}/${relative_path}"
    local backup_dir_path="$(dirname "$backup_path")"

    # Create directory structure in backup
    mkdir -p "$backup_dir_path"

    # Copy file to backup
    cp -R "$file" "$backup_path"

    if $VERBOSE; then
        print_info "Backed up: $file -> $backup_path"
    fi
}

# Create symbolic link
create_symlink() {
    local source="$1"
    local target="$2"

    # Check if source exists
    if [[ ! -e "$source" ]]; then
        print_error "Source file does not exist: $source"
        return 1
    fi

    # Handle existing target
    if [[ -e "$target" ]] || [[ -L "$target" ]]; then
        if [[ -L "$target" ]] && [[ "$(readlink "$target")" == "$source" ]]; then
            if $VERBOSE; then
                print_info "Symlink already correct: $target"
            fi
            return 0
        fi

        if ! $FORCE && ! $DRY_RUN; then
            read -p "File exists: $target. Overwrite? [y/N] " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                print_warning "Skipped: $target"
                return 0
            fi
        fi

        # Backup existing file
        backup_file "$target"

        # Remove existing file
        if ! $DRY_RUN; then
            rm -rf "$target"
        fi
    fi

    # Create parent directory if needed
    local target_dir="$(dirname "$target")"
    if [[ ! -d "$target_dir" ]]; then
        if $DRY_RUN; then
            print_info "[DRY RUN] Would create directory: $target_dir"
        else
            mkdir -p "$target_dir"
        fi
    fi

    # Create symlink
    if $DRY_RUN; then
        print_info "[DRY RUN] Would create symlink: $target -> $source"
    else
        ln -s "$source" "$target"
        print_success "Created symlink: $target -> $source"
    fi
}

# Remove symbolic link
remove_symlink() {
    local target="$1"
    local expected_source="$2"

    if [[ -L "$target" ]]; then
        local actual_source="$(readlink "$target")"
        if [[ "$actual_source" == "$expected_source" ]]; then
            if $DRY_RUN; then
                print_info "[DRY RUN] Would remove symlink: $target"
            else
                rm "$target"
                print_success "Removed symlink: $target"
            fi
        else
            print_warning "Symlink points elsewhere, skipping: $target -> $actual_source"
        fi
    elif [[ -e "$target" ]]; then
        print_warning "Not a symlink, skipping: $target"
    fi
}

# Install dotfiles
install_dotfiles() {
    print_info "Installing dotfiles..."

    # Create necessary directories
    if ! $DRY_RUN; then
        mkdir -p "$CONFIG_DIR"
    fi

    # Install .zshrc
    create_symlink "${SCRIPT_DIR}/.zshrc" "${HOME}/.zshrc"

    # Install .config/zsh
    create_symlink "${SCRIPT_DIR}/.config/zsh" "${CONFIG_DIR}/zsh"

    # Install .config/mise
    create_symlink "${SCRIPT_DIR}/.config/mise" "${CONFIG_DIR}/mise"

    # Install .config/nvim
    create_symlink "${SCRIPT_DIR}/.config/nvim" "${CONFIG_DIR}/nvim"

    # Install .tmux.conf
    create_symlink "${SCRIPT_DIR}/.tmux.conf" "${HOME}/.tmux.conf"

    # Copy local.zsh template if it doesn't exist
    local local_zsh="${CONFIG_DIR}/zsh/99-local.zsh"
    local local_template="${SCRIPT_DIR}/.config/zsh/99-local.zsh.example"

    if [[ ! -e "$local_zsh" ]] && [[ -e "$local_template" ]]; then
        if $DRY_RUN; then
            print_info "[DRY RUN] Would copy template: $local_template -> $local_zsh"
        else
            cp "$local_template" "$local_zsh"
            print_success "Created local config from template: $local_zsh"
        fi
    fi

    # Future: Add more dotfiles here as they are added to the repository
    # create_symlink "${SCRIPT_DIR}/.gitconfig" "${HOME}/.gitconfig"

    if ! $DRY_RUN && [[ -d "$BACKUP_DIR" ]]; then
        print_info "Backups saved to: $BACKUP_DIR"
    fi
}

# Uninstall dotfiles
uninstall_dotfiles() {
    print_info "Uninstalling dotfiles..."

    # Remove symlinks
    remove_symlink "${HOME}/.zshrc" "${SCRIPT_DIR}/.zshrc"
    remove_symlink "${CONFIG_DIR}/zsh" "${SCRIPT_DIR}/.config/zsh"
    remove_symlink "${CONFIG_DIR}/mise" "${SCRIPT_DIR}/.config/mise"
    remove_symlink "${CONFIG_DIR}/nvim" "${SCRIPT_DIR}/.config/nvim"
    remove_symlink "${HOME}/.tmux.conf" "${SCRIPT_DIR}/.tmux.conf"

    # Future: Remove more dotfiles here as they are added
    # remove_symlink "${HOME}/.gitconfig" "${SCRIPT_DIR}/.gitconfig"

    print_warning "Local configuration preserved: ${CONFIG_DIR}/zsh/99-local.zsh"
}

# Main function
main() {
    parse_options "$@"

    if $DRY_RUN; then
        print_info "Running in dry-run mode - no changes will be made"
    fi

    if $UNINSTALL; then
        uninstall_dotfiles
    else
        install_dotfiles
    fi

    print_success "Done!"
}

# Run main function
main "$@"
