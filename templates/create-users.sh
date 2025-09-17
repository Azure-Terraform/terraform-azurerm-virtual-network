#!/bin/bash

# create-users.sh - Clean script for creating users on Ubuntu systems
# This script creates users with proper security configurations for Ubuntu 24.04

set -euo pipefail

# Script configuration
SCRIPT_NAME="$(basename "$0")"
LOG_FILE="/var/log/user-creation.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging function
log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${timestamp} [${level}] ${message}" | tee -a "${LOG_FILE}"
}

log_info() {
    log "INFO" "$*"
    echo -e "${GREEN}[INFO]${NC} $*"
}

log_warn() {
    log "WARN" "$*"
    echo -e "${YELLOW}[WARN]${NC} $*"
}

log_error() {
    log "ERROR" "$*"
    echo -e "${RED}[ERROR]${NC} $*"
}

# Usage function
usage() {
    cat << EOF
Usage: $SCRIPT_NAME [OPTIONS] <username>

Create a new user with secure defaults on Ubuntu 24.04

OPTIONS:
    -h, --help          Show this help message
    -s, --sudo          Add user to sudo group
    -k, --ssh-key FILE  Add SSH public key from file
    -g, --groups GROUPS Comma-separated list of additional groups
    -d, --disable-pw    Disable password authentication (use with SSH key)
    --home-dir DIR      Custom home directory (default: /home/<username>)

EXAMPLES:
    $SCRIPT_NAME myuser
    $SCRIPT_NAME -s -k ~/.ssh/id_rsa.pub myuser
    $SCRIPT_NAME -s -g docker,www-data -k ./pubkey.pub myuser
    $SCRIPT_NAME -s -d -k ./pubkey.pub myuser

EOF
}

# Validate that we're running on Ubuntu
check_ubuntu() {
    if [[ ! -f /etc/os-release ]] || ! grep -q "Ubuntu" /etc/os-release; then
        log_error "This script is designed for Ubuntu systems"
        exit 1
    fi
    
    local version=$(grep VERSION_ID /etc/os-release | cut -d'"' -f2)
    log_info "Detected Ubuntu version: $version"
}

# Check if user already exists
user_exists() {
    local username="$1"
    id "$username" &>/dev/null
}

# Create user with secure defaults
create_user() {
    local username="$1"
    local home_dir="$2"
    
    if user_exists "$username"; then
        log_warn "User '$username' already exists"
        return 1
    fi
    
    log_info "Creating user: $username"
    
    # Create user with secure shell and home directory
    useradd \
        --create-home \
        --home-dir "$home_dir" \
        --shell /bin/bash \
        --comment "Created by $SCRIPT_NAME" \
        "$username"
    
    log_info "User '$username' created successfully"
}

# Add user to groups
add_to_groups() {
    local username="$1"
    local groups="$2"
    
    if [[ -n "$groups" ]]; then
        log_info "Adding user '$username' to groups: $groups"
        usermod -a -G "$groups" "$username"
    fi
}

# Add SSH key for user
add_ssh_key() {
    local username="$1"
    local ssh_key_file="$2"
    local home_dir="$3"
    
    if [[ ! -f "$ssh_key_file" ]]; then
        log_error "SSH key file not found: $ssh_key_file"
        return 1
    fi
    
    local ssh_dir="$home_dir/.ssh"
    local authorized_keys="$ssh_dir/authorized_keys"
    
    log_info "Setting up SSH key for user '$username'"
    
    # Create .ssh directory
    mkdir -p "$ssh_dir"
    chmod 700 "$ssh_dir"
    
    # Add SSH key
    cat "$ssh_key_file" >> "$authorized_keys"
    chmod 600 "$authorized_keys"
    
    # Set ownership
    chown -R "$username:$username" "$ssh_dir"
    
    log_info "SSH key added for user '$username'"
}

# Disable password authentication
disable_password() {
    local username="$1"
    
    log_info "Disabling password authentication for user '$username'"
    passwd -l "$username"
}

# Set secure password policy
set_password() {
    local username="$1"
    
    log_info "Setting up password for user '$username'"
    echo "Please set a secure password for user '$username':"
    passwd "$username"
}

# Main function
main() {
    local username=""
    local add_sudo=false
    local ssh_key_file=""
    local additional_groups=""
    local disable_pw=false
    local home_dir=""
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                usage
                exit 0
                ;;
            -s|--sudo)
                add_sudo=true
                shift
                ;;
            -k|--ssh-key)
                ssh_key_file="$2"
                shift 2
                ;;
            -g|--groups)
                additional_groups="$2"
                shift 2
                ;;
            -d|--disable-pw)
                disable_pw=true
                shift
                ;;
            --home-dir)
                home_dir="$2"
                shift 2
                ;;
            -*)
                log_error "Unknown option: $1"
                usage
                exit 1
                ;;
            *)
                if [[ -z "$username" ]]; then
                    username="$1"
                else
                    log_error "Multiple usernames specified"
                    usage
                    exit 1
                fi
                shift
                ;;
        esac
    done
    
    # Validate arguments
    if [[ -z "$username" ]]; then
        log_error "Username is required"
        usage
        exit 1
    fi
    
    if [[ "$disable_pw" == true && -z "$ssh_key_file" ]]; then
        log_error "SSH key is required when disabling password authentication"
        exit 1
    fi
    
    # Check if running as root
    if [[ $EUID -ne 0 ]]; then
        log_error "This script must be run as root"
        exit 1
    fi
    
    # Set default home directory
    if [[ -z "$home_dir" ]]; then
        home_dir="/home/$username"
    fi
    
    # Check Ubuntu version
    check_ubuntu
    
    log_info "Starting user creation process"
    log_info "Username: $username"
    log_info "Home directory: $home_dir"
    log_info "Add to sudo: $add_sudo"
    log_info "SSH key file: ${ssh_key_file:-"none"}"
    log_info "Additional groups: ${additional_groups:-"none"}"
    log_info "Disable password: $disable_pw"
    
    # Create the user
    create_user "$username" "$home_dir"
    
    # Add to sudo group if requested
    if [[ "$add_sudo" == true ]]; then
        add_to_groups "$username" "sudo"
    fi
    
    # Add to additional groups
    if [[ -n "$additional_groups" ]]; then
        add_to_groups "$username" "$additional_groups"
    fi
    
    # Add SSH key if provided
    if [[ -n "$ssh_key_file" ]]; then
        add_ssh_key "$username" "$ssh_key_file" "$home_dir"
    fi
    
    # Handle password settings
    if [[ "$disable_pw" == true ]]; then
        disable_password "$username"
    else
        set_password "$username"
    fi
    
    log_info "User creation completed successfully"
    log_info "User '$username' is ready to use"
    
    # Display user information
    echo
    echo "User Information:"
    id "$username"
    echo "Home directory: $home_dir"
    echo "Groups: $(groups "$username")"
}

# Run main function with all arguments
main "$@"