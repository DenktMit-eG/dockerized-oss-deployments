#!/bin/bash

# Exit on error, print commands, treat unset variables as errors, and ensure pipeline fails on error
set -eu -o pipefail

# Check if the script is running with sudo privileges
if [ "$EUID" -ne 0 ]; then
    echo "This script requires sudo privileges. Please run with sudo."
    exit 1
fi

# Check if the correct number of arguments is provided
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <username> <password> [<comment>] [group1 group2 ...]"
    exit 1
fi

# Define variables from script arguments
USERNAME="$1"
PASSWORD="$2"
COMMENT="${3:-Podman User}"
GROUPID="users"
HOMEDIR="/home/$USERNAME"
SHELL="/bin/bash"
EXTRAGROUPS=("${@:4}")  # Additional groups starting from the fourth argument

# Function to check username conformity
check_username_conformity() {
    local username=$1
    if [[ ! $username =~ ^[a-zA-Z][a-zA-Z0-9_-]{0,31}$ ]]; then
        echo "Invalid username: $username"
        echo "Username must start with a letter and can only contain letters, digits, underscores, or hyphens."
        echo "It must be between 1 and 32 characters long."
        exit 1
    fi
}

# Ensure the username conforms to the standards
check_username_conformity "$USERNAME"

# Ensure the user doesn't already exist
if id -u "$USERNAME" >/dev/null 2>&1; then
    echo "User $USERNAME already exists. Exiting."
    exit 1
fi

# Create the new user without specifying user ID
useradd -m -d "$HOMEDIR" -s "$SHELL" -g "$GROUPID" "${EXTRAGROUPS[@]/#/-G}" -c "$COMMENT" "$USERNAME"

# Set the password for the new user
echo "$USERNAME:$PASSWORD" | chpasswd

# Confirm creation
echo "User $USERNAME created successfully."
