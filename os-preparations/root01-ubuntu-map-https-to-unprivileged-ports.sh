##!/bin/bash

# Exit on error, print commands, treat unset variables as errors, and ensure pipeline fails on error
set -eu -o pipefail

# Check if the script is running with sudo privileges
if [ "$EUID" -ne 0 ]; then
    echo "This script requires sudo privileges. Please run with sudo."
    exit 1
fi

# Map the ports for IPv4
iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 1081
iptables -t nat -A PREROUTING -p tcp --dport 443 -j REDIRECT --to-port 1082

# Map the ports for IPv6
ip6tables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 1081
ip6tables -t nat -A PREROUTING -p tcp --dport 443 -j REDIRECT --to-port 1082

# Prepare and install iptables-persistent. The next two commands instructs debconf to use current rules as starting
# point. This avoids the manual input interruption in automated install process.
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections
apt-get install iptables-persistent -y

# Check the current rules
# iptables -t nat -L

# Remove the rules with this commands
iptables -t nat -D PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 1081
iptables -t nat -D PREROUTING -p tcp --dport 443 -j REDIRECT --to-port 1082
ip6tables -t nat -D PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 1081
ip6tables -t nat -D PREROUTING -p tcp --dport 443 -j REDIRECT --to-port 1082
