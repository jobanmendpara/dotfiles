#!/usr/bin/env bash

# ============================================================================
# Dotfiles Installation Script v1.0
# ============================================================================

set -euo pipefail # Exit on error, undefined vars, pipe failures

# ============================================================================
# CONFIGURATION
# ============================================================================

SCRIPT_VERSION="1.0.0"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
LOG_FILE="$HOME/.dotfiles_install.log"
CONFIG_FILE="${DOTFILES_CONFIG:-$HOME/.dotfiles.conf}"

# Load config if exists
[ -f "$CONFIG_FILE" ] && source "$CONFIG_FILE"

# Versions
NVM_VERSION="${NVM_VERSION:-v0.39.7}"

# Colors
COLOR_RESET='\033[0m'
COLOR_GREEN='\033[0;32m'
COLOR_BLUE='\033[0;34m'
COLOR_YELLOW='\033[0;33m'
COLOR_RED='\033[0;31m'
COLOR_CYAN='\033[0;36m'
COLOR_BOLD='\033[1m'

# Options (set defaults)
DRY_RUN=false
FORCE=false
VERBOSE=false
NO_BACKUP=false
NO_SERVICES=false
ONLY=""
ROLLBACK=false
RESTOW=false

# Stow packages - define which directories to stow
STOW_PACKAGES=(
  "aerospace"
  "borders"
  "git"
  "homebrew"
  "karabiner"
  "lazygit"
  "ni"
  "nvim"
  "opencode"
  "sketchybar"
  "wezterm"
  "yazi"
  "zsh"
)

# Stow options
STOW_OPTIONS="--verbose=1"
[ "$VERBOSE" = true ] && STOW_OPTIONS="--verbose=2"

# ============================================================================
# LOGGING SETUP
# ============================================================================

# Setup logging (only if not in dry-run mode)
if [ "$DRY_RUN" = false ]; then
  exec 1> >(tee -a "$LOG_FILE")
  exec 2>&1
fi

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

print_info() {
  echo -e "${COLOR_BLUE}[INFO]${COLOR_RESET} $1"
}

print_success() {
  echo -e "${COLOR_GREEN}[✓]${COLOR_RESET} $1"
}

print_warning() {
  echo -e "${COLOR_YELLOW}[!]${COLOR_RESET} $1"
}

print_error() {
  echo -e "${COLOR_RED}[✗]${COLOR_RESET} $1" >&2
}

print_debug() {
  if [ "$VERBOSE" = true ]; then
    echo -e "${COLOR_CYAN}[DEBUG]${COLOR_RESET} $1"
  fi
}

print_dry_run() {
  echo -e "${COLOR_CYAN}[DRY-RUN]${COLOR_RESET} $1"
}

print_header() {
  local text="$1"
  local width=60
  local text_length=${#text}

  # Ensure minimum width
  if [ $text_length -gt $((width - 4)) ]; then
    width=$((text_length + 4))
  fi

  # Calculate padding
  local padding=$(((width - text_length - 2) / 2))
  local border=$(printf '═%.0s' $(seq 1 $width))

  echo
  echo -e "${COLOR_BOLD}${border}${COLOR_RESET}"
  printf "${COLOR_BOLD}║%*s%s%*s║${COLOR_RESET}\n" \
    $padding "" "$text" $((width - text_length - padding - 2)) ""
  echo -e "${COLOR_BOLD}${border}${COLOR_RESET}"
  echo
}

confirm() {
  local message="${1:-Continue?}"
  if [ "$FORCE" = true ]; then
    return 0
  fi

  read -rp "$(echo -e "${COLOR_YELLOW}$message [y/N]:${COLOR_RESET} ")" -n 1 reply
  echo
  [[ $reply =~ ^[Yy]$ ]]
}

# ============================================================================
# HELP & VERSION
# ============================================================================

show_help() {
  cat <<EOF
${COLOR_BOLD}Dotfiles Installation Script v${SCRIPT_VERSION}${COLOR_RESET}
${COLOR_BOLD}Using GNU Stow for dotfile management${COLOR_RESET}

${COLOR_BOLD}USAGE:${COLOR_RESET}
  ${0##*/} [OPTIONS]

${COLOR_BOLD}OPTIONS:${COLOR_RESET}
  -h, --help          Show this help message
  -v, --version       Show version information
  -n, --dry-run       Preview changes without making them
  -f, --force         Skip confirmation prompts
  -V, --verbose       Enable verbose output
  --no-backup         Skip backing up existing files
  --no-services       Don't start services after installation
  --restow            Force restow (unlink then relink)
  --adopt             Adopt existing files into dotfiles repo
  --only [PART]       Install only specific part:
                      brew, packages, stow, zap, nvm,
                      macos, services, all
  --packages [LIST]   Stow only specific packages (comma-separated)
                      Example: --packages "zsh,git,nvim"

${COLOR_BOLD}STOW PACKAGES:${COLOR_RESET}
  Available packages: ${STOW_PACKAGES[*]}

${COLOR_BOLD}EXAMPLES:${COLOR_RESET}
  ${0##*/} --dry-run                    # Preview all changes
  ${0##*/} --only stow                  # Only create symlinks via stow
  ${0##*/} --packages "zsh,git"         # Stow only zsh and git
  ${0##*/} --restow                     # Recreate all symlinks
  ${0##*/} --adopt                      # Import existing configs

${COLOR_BOLD}CONFIGURATION:${COLOR_RESET}
  Config file: $CONFIG_FILE
  Dotfiles dir: $DOTFILES_DIR

${COLOR_BOLD}MORE INFO:${COLOR_RESET}
  https://github.com/jobanmendpara/dotfiles
  GNU Stow:

 https://www.gnu.org/software/stow/

EOF
}

show_version() {
  echo "Dotfiles Installation Script v${SCRIPT_VERSION}"
  echo "Using GNU Stow for symlink management"
}

# ============================================================================
# ERROR HANDLING
# ============================================================================

cleanup() {
  local exit_code=$?
  if [ $exit_code -ne 0 ] && [ "$DRY_RUN" = false ]; then
    echo
    print_error "Installation failed! (Exit code: $exit_code)"
    if [ -d "$BACKUP_DIR" ] && [ "$(ls -A "$BACKUP_DIR" 2>/dev/null)" ]; then
      print_info "Backups saved to: $BACKUP_DIR"
    fi
    print_info "Check the log file: $LOG_FILE"
  fi
}

trap cleanup EXIT

# ============================================================================
# PREREQUISITE CHECKS
# ============================================================================

check_prerequisites() {
  print_info "Checking prerequisites..."

  local missing=()
  local warnings=()

  # Check OS
  if [[ "$OSTYPE" == "darwin"* ]]; then
    print_debug "Detected macOS"
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    print_debug "Detected Linux"
    warnings+=("This script is optimized for macOS, some features may not work")
  else
    warnings+=("Unsupported OS: $OSTYPE")
  fi

  # Check required commands
  local required_cmds=(curl git)
  for cmd in "${required_cmds[@]}"; do
    if ! command -v "$cmd" &>/dev/null; then
      missing+=("$cmd")
    else
      print_debug "Found: $cmd"
    fi
  done

  # Check dotfiles directory
  if [ ! -d "$DOTFILES_DIR" ]; then
    print_error "Dotfiles directory not found: $DOTFILES_DIR"
    print_info "Please clone your dotfiles repo first"
    exit 1
  fi

  # Report issues
  if [ ${#missing[@]} -gt 0 ]; then
    print_error "Missing required tools: ${missing[*]}"
    print_info "Please install them first"
    exit 1
  fi

  if [ ${#warnings[@]} -gt 0 ]; then
    for warning in "${warnings[@]}"; do
      print_warning "$warning"
    done
    [ "$FORCE" = false ] && ! confirm "Continue anyway?" && exit 1
  fi

  print_success "Prerequisites check passed"
}

check_stow() {
  if ! command -v stow &>/dev/null; then
    print_warning "GNU Stow not found. It will be installed via Homebrew"
    return 1
  fi

  print_debug "Found stow: $(stow --version | head -1)"
  return 0
}

# ============================================================================
# BACKUP FUNCTIONS
# ============================================================================

backup_stow_targets() {
  if [ "$NO_BACKUP" = true ]; then
    print_debug "Skipping backups"
    return 0
  fi

  print_info "Backing up existing files that would be replaced..."

  local backup_needed=false

  for package in "${STOW_PACKAGES[@]}"; do
    local package_dir="$DOTFILES_DIR/$package"

    # Skip if package directory doesn't exist
    [ ! -d "$package_dir" ] && continue

    # Use stow's simulation mode to see what would be changed
    if stow -n -d "$DOTFILES_DIR" -t "$HOME" "$package" 2>&1 | grep -q "existing"; then
      backup_needed=true

      # Find files that would be replaced
      find "$package_dir" -type f -o -type l | while read -r file; do
        local relative_path="${file#$package_dir/}"
        local target="$HOME/$relative_path"

        if [ -e "$target" ] && [ ! -L "$target" ]; then
          local backup_path="$BACKUP_DIR/$(dirname "$relative_path")"

          if [ "$DRY_RUN" = true ]; then
            print_dry_run "Would backup: $target"
          else
            mkdir -p "$backup_path"
            cp -RPL "$target" "$backup_path/" 2>/dev/null || true
            print_debug "Backed up: $target"
          fi
        fi
      done
    fi
  done

  if [ "$backup_needed" = true ]; then
    print_success "Backups created in: $BACKUP_DIR"
  else
    print_info "No backups needed (no conflicts found)"
  fi
}

# ============================================================================
# INSTALLATION FUNCTIONS
# ============================================================================

install_homebrew() {
  print_header "Homebrew"

  if ! command -v brew &>/dev/null; then
    print_info "Installing Homebrew..."

    if [ "$DRY_RUN" = true ]; then
      print_dry_run "Would install Homebrew"
    else
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

      # Add to PATH for current session
      if [[ $(uname -m) == 'arm64' ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      else
        eval "$(/usr/local/bin/brew shellenv)"
      fi
    fi
    print_success "Homebrew installed"
  else
    print_info "Homebrew already installed"
    print_debug "Version: $(brew --version | head -1)"
  fi
}

install_packages() {
  print_header "Homebrew Packages"

  if ! command -v brew &>/dev/null; then
    print_warning "Homebrew not found, skipping packages"
    return 0
  fi

  # Ensure stow is installed
  if ! command -v stow &>/dev/null; then
    print_info "Installing GNU Stow..."
    if [ "$DRY_RUN" = true ]; then
      print_dry_run "Would install: brew install stow"
    else
      brew install stow
    fi
    print_success "GNU Stow installed"
  fi

  if [ ! -f "$DOTFILES_DIR/homebrew/Brewfile" ]; then
    print_warning "Brewfile not found, only installed stow"
    return 0
  fi

  print_info "Installing packages from Brewfile..."

  if [ "$DRY_RUN" = true ]; then
    print_dry_run "Would install packages from Brewfile"
    [ "$VERBOSE" = true ] && cat

    "$DOTFILES_DIR/homebrew/Brewfile"
  else
    brew bundle --file="$DOTFILES_DIR/homebrew/Brewfile" --no-upgrade
  fi

  print_success "Packages installed"
}

install_zap() {
  print_header "Zap Plugin Manager"

  local zap_dir="${XDG_DATA_HOME:-$HOME/.local/share}/zap"

  if [ -d "$zap_dir" ]; then
    print_info "Zap already installed"
    return 0
  fi

  print_info "Installing Zap plugin manager..."

  if [ "$DRY_RUN" = true ]; then
    print_dry_run "Would install Zap to: $zap_dir"
  else
    zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1 --keep-zshrc
  fi

  print_success "Zap installed"
}

install_nvm() {
  print_header "Node Version Manager"

  if [ -d "$HOME/.nvm" ]; then
    print_info "NVM already installed"
    return 0
  fi

  print_info "Installing NVM..."

  if [ "$DRY_RUN" = true ]; then
    print_dry_run "Would install NVM version $NVM_VERSION"
  else
    curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash
  fi

  print_success "NVM installed"
}

setup_stow() {
  print_header "GNU Stow Symlinks"

  # Check if stow is available
  if ! command -v stow &>/dev/null; then
    print_error "GNU Stow not found. Please install it first"
    print_info "Run: brew install stow"
    return 1
  fi

  cd "$DOTFILES_DIR"

  # Backup existing files
  backup_stow_targets

  local stowed=0
  local skipped=0
  local failed=0

  # Determine which packages to stow
  local packages_to_stow=("${STOW_PACKAGES[@]}")
  if [ -n "$CUSTOM_PACKAGES" ]; then
    IFS=',' read -ra packages_to_stow <<<"$CUSTOM_PACKAGES"
  fi

  print_info "Stowing packages: ${packages_to_stow[*]}"

  for package in "${packages_to_stow[@]}"; do
    # Trim whitespace
    package=$(echo "$package" | xargs)

    if [ ! -d "$DOTFILES_DIR/$package" ]; then
      print_debug "Package directory not found: $package"
      ((skipped++))
      continue
    fi

    print_debug "Processing package: $package"

    local stow_cmd="stow"

    # Build stow command
    if [ "$DRY_RUN" = true ]; then
      stow_cmd="stow --no --verbose=2"
    fi

    if [ "$RESTOW" = true ]; then
      stow_cmd="$stow_cmd --restow"
    fi

    if [ "$ADOPT" = true ]; then
      stow_cmd="$stow_cmd --adopt"
    fi

    # Execute stow
    if [ "$DRY_RUN" = true ]; then
      print_dry_run "Would execute: $stow_cmd -d $DOTFILES_DIR -t $HOME $package"
      $stow_cmd -d "$DOTFILES_DIR" -t "$HOME" "$package" 2>&1 | while read -r line; do
        print_debug "  $line"
      done
    else
      if $stow_cmd $STOW_OPTIONS -d "$DOTFILES_DIR" -t "$HOME" "$package" 2>&1 |
        { [ "$VERBOSE" = true ] && cat || cat >/dev/null; }; then
        print_success "Stowed: $package"
        ((stowed++))
      else
        print_warning "Failed to stow: $package"
        ((failed++))
      fi
    fi
  done

  # Report results
  echo
  print_success "Stow results: $stowed stowed, $skipped skipped, $failed failed"

  if [ "$failed" -gt 0 ]; then
    print_warning "Some packages failed to stow. Try running with --adopt to adopt existing files"
    print_info "Or use --restow to force re-linking"
  fi
}

unstow_all() {
  print_header "Unstowing All Packages"

  if ! confirm "This will remove all symlinks. Continue?"; then
    return 0
  fi

  cd "$DOTFILES_DIR"

  for package in "${STOW_PACKAGES[@]}"; do
    if [ -d "$DOTFILES_DIR/$package" ]; then
      print_info "Unstowing: $package"
      stow --delete -d "$DOTFILES_DIR" -t "$HOME" "$package" 2>/dev/null || true
    fi
  done

  print_success "All packages unstowed"
}

setup_macos_defaults() {
  if [[ "$OSTYPE" != "darwin"* ]]; then
    print_debug "Skipping macOS defaults (not on macOS)"
    return 0
  fi

  print_header "macOS Defaults"

  if ! confirm "Apply macOS system preferences?"; then
    print_info "Skipped macOS defaults"
    return 0
  fi

  local settings=(
    "com.apple.dock autohide - bool true"
    "com.apple.dock autohide-delay -float 900"
    "com.apple.dock autohide-time-modifier -float 0.5"
    "com.apple.dock tilesize -int 36"
    "com.apple.dock show-recents -bool false"
    "NSGlobalDomain ApplePressAndHoldEnabled -bool false"
    "NSGlobalDomain KeyRepeat -int 2"
    "NSGlobalDomain InitialKeyRepeat -int 15"
    "NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false"
    "com.apple.finder ShowPathbar -bool true"
    "com.apple.finder ShowStatusBar -bool true"
  )

  for setting in "${settings[@]}"; do
    if [ "$DRY_RUN" = true ]; then
      print_dry_run "Would set: defaults write $setting"
    else
      defaults write $setting
      print_debug "Set: $setting"
    fi
  done

  if [ "$DRY_RUN" = false ]; then
    killall Dock 2>/dev/null || true
  fi

  print_success "macOS defaults applied"
  print_warning "Some changes require logout/restart to take effect"
}

start_services() {
  if [[ "$OSTYPE" != "darwin"* ]] || [ "$NO_SERVICES" = true ]; then
    return 0
  fi

  if ! command -v brew &>/dev/null; then
    print_debug "Homebrew not found, skipping services"
    return 0
  fi

  print_header "Services"

  local services=(sketchybar borders aerospace)
  local started=()
  local failed=()

  for service in "${services[@]}"; do
    if command -v "$service" &>/dev/null; then
      if [ "$DRY_RUN" = true ]; then
        print_dry_run "Would start service: $service"
      else
        if brew services start "$service" 2>/dev/null; then
          started+=("$service")
          print_debug "Started service: $service"
        else
          failed+=("$service")
        fi
      fi
    else
      print_debug "Service not installed: $service"
    fi
  done

  # Report results
  if [ ${#started[@]} -gt 0 ]; then
    print_success "Started services: ${started[*]}"
  fi

  if [ ${#failed[@]} -gt 0 ]; then
    print_warning "Failed to start: ${failed[*]}"
  fi
}

# ============================================================================
# VERIFICATION
# ============================================================================

verify_installation() {
  print_header "Verification"

  local issues=()
  local verified=()

  # Check if stow packages are properly linked
  for package in "${STOW_PACKAGES[@]}"; do
    if [ -d "$DOTFILES_DIR/$package" ]; then
      # Check if at least one file from this package is linked
      local sample_file=$(find "$DOTFILES_DIR/$package" -type f | head -1)
      if [ -n "$sample_file" ]; then
        local relative_path="${sample_file#$DOTFILES_DIR/$package/}"
        local target="$HOME/$relative_path"
        if [ -L "$target" ]; then
          verified+=("Package stowed: $package")
        else
          issues+=("Package not properly stowed: $package")
        fi
      fi
    fi
  done

  # Check installed commands
  local expected_cmds=(brew stow git zsh)
  for cmd in "${expected_cmds[@]}"; do
    if command -v "$cmd" &>/dev/null; then

      verified+=("Command: $cmd")
    else
      issues+=("Missing command: $cmd")
    fi
  done

  # Report results
  if [ "$VERBOSE" = true ] && [ ${#verified[@]} -gt 0 ]; then
    print_success "Verified:"
    printf '  ✓ %s\n' "${verified[@]}"
  fi

  if [ ${#issues[@]} -gt 0 ]; then
    print_warning "Issues found:"
    printf '  ✗ %s\n' "${issues[@]}"
    return 1
  else
    print_success "Installation verified successfully"
    return 0
  fi
}

# ============================================================================
# MAIN EXECUTION
# ============================================================================

parse_arguments() {
  while [[ $# -gt 0 ]]; do
    case $1 in
    -h | --help)
      show_help
      exit 0
      ;;
    -v | --version)
      show_version
      exit 0
      ;;
    -n | --dry-run)
      DRY_RUN=true
      shift
      ;;
    -f | --force)
      FORCE=true
      shift
      ;;
    -V | --verbose)
      VERBOSE=true
      STOW_OPTIONS="--verbose=2"
      shift

      ;;
    --no-backup)
      NO_BACKUP=true
      shift
      ;;
    --no-services)
      NO_SERVICES=true
      shift
      ;;
    --restow)
      RESTOW=true
      shift
      ;;
    --adopt)
      ADOPT=true
      shift
      ;;
    --unstow)
      unstow_all
      exit 0
      ;;
    --only)
      ONLY="${2:-}"
      if [ -z "$ONLY" ]; then
        print_error "Option --only requires an argument"
        exit 1
      fi
      shift 2
      ;;
    --packages)
      CUSTOM_PACKAGES="${2:-}"
      if [ -z "$CUSTOM_PACKAGES" ]; then
        print_error "Option --packages requires an argument"
        exit 1
      fi
      shift 2
      ;;
    *)
      print_error "Unknown option: $1"
      show_help
      exit 1
      ;;
    esac
  done
}

print_configuration() {
  print_header "Configuration"

  echo "  Dotfiles directory: $DOTFILES_DIR"
  echo "  Backup directory:   $BACKUP_DIR"
  echo "  Log file:          $LOG_FILE"
  echo
  echo "  Options:"
  echo "    Dry run:     $DRY_RUN"
  echo "    Force:       $FORCE"
  echo "    Verbose:     $VERBOSE

"
  echo "    No backup:   $NO_BACKUP"
  echo "    No services: $NO_SERVICES"
  echo "    Restow:      $RESTOW"
  echo "    Adopt:       $ADOPT"
  [ -n "$ONLY" ] && echo "    Only:        $ONLY"
  [ -n "$CUSTOM_PACKAGES" ] && echo "    Packages:    $CUSTOM_PACKAGES"
  echo
}

main() {
  # Show banner
  echo
  echo -e "${COLOR_BOLD}╔════════════════════════════════════════════════════╗${COLOR_RESET}"
  echo -e "${COLOR_BOLD}║     Dotfiles Installation Script v${SCRIPT_VERSION}          ║${COLOR_RESET}"
  echo -e "${COLOR_BOLD}║              Using GNU Stow                       ║${COLOR_RESET}"
  echo -e "${COLOR_BOLD}╚════════════════════════════════════════════════════╝${COLOR_RESET}"

  # Configuration summary
  [ "$VERBOSE" = true ] && print_configuration

  # Prerequisites
  check_prerequisites

  # Confirmation
  if [ "$DRY_RUN" = false ] && [ "$FORCE" = false ]; then
    print_warning "This will modify your system configuration

"
    if ! confirm "Continue with installation?"; then
      print_info "Installation cancelled"
      exit 0
    fi
  fi

  # Track what we need to do
  local tasks=()

  case "${ONLY:-all}" in
  brew) tasks=(install_homebrew) ;;
  packages) tasks=(install_packages) ;;
  stow) tasks=(setup_stow) ;;
  zap) tasks=(install_zap) ;;
  nvm) tasks=(install_nvm) ;;
  macos) tasks=(setup_macos_defaults) ;;
  services) tasks=(start_services) ;;
  all | "")
    tasks=(
      install_homebrew
      install_packages
      install_zap
      install_nvm
      setup_stow
      setup_macos_defaults
      start_services
    )
    ;;
  *)
    print_error "Unknown installation target: $ONLY"
    print_info "Valid options: brew, packages, stow, zap, nvm, macos, services, all"
    exit 1
    ;;
  esac

  # Execute tasks
  for task in "${tasks[@]}"; do
    $task
  done

  # Verification (skip in dry-run mode)
  if [ "$DRY_RUN" = false ] && [ "${ONLY:-all}" = "all" ]; then
    verify_installation || true

  fi

  # Summary
  echo
  echo -e "${COLOR_BOLD}════════════════════════════════════════════════════${COLOR_RESET}"

  if [ "$DRY_RUN" = true ]; then
    print_info "DRY RUN COMPLETE (no changes made)"
    print_info "Remove --dry-run flag to apply changes"
  else
    print_success "Installation Complete!"

    if [ -d "$BACKUP_DIR" ] && [ "$(ls -A "$BACKUP_DIR" 2>/dev/null)" ]; then
      print_info "Backups saved to: $BACKUP_DIR"
    fi

    print_info "Log file: $LOG_FILE"

    echo
    print_info "Next steps:"
    echo "  1. Restart your terminal or run: source ~/.zshrc"
    echo "  2. Install Node.js: nvm install --lts"
    echo "  3. Configure Git: git config --global user.name 'Your Name'"
    echo "  4. Review stowed packages: stow -d $DOTFILES_DIR -t $HOME --verbose=1 <package>"

    if [[ "$OSTYPE" == "darwin"* ]]; then
      echo "  5. Open Karabiner-Elements and enable your configuration"
      echo "  6. Start AeroSpace if not already running"
    fi

    echo
    print_info "Useful stow commands:"
    echo "  Restow package:  stow -R -d $DOTFILES_DIR <package>"
    echo "  Unstow package:  stow -D -d $DOTFILES_DIR <package>"
    echo "  Adopt files:     stow --adopt -d $DOTFILES_DIR <package>"
  fi

  echo -e "${COLOR_BOLD}════════════════════════════════════════════════════${COLOR_RESET}"
}

# ============================================================================
# SCRIPT ENTRY POINT
# ============================================================================

# Global variables that might be set by arguments
ADOPT=false
CUSTOM_PACKAGES=""

# Parse command line arguments
parse_arguments "$@"

# Run main installation
main

# Exit successfully
exit 0
