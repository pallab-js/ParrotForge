#!/bin/bash

# --- Fail-safe and Pre-checks ---
set -euo pipefail # Exit on error, unset variable, or pipe failure

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# --- System Update and Cleanup (Safer) ---
echo "Updating and upgrading the system..."
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
apt-get autoremove -y
apt-get autoclean

# --- Service Management ---
echo "Disabling non-essential services..."
# Disable services that are not always needed. User can re-enable if required.
systemctl disable bluetooth.service
systemctl disable cups.service # Printer service
systemctl disable anonsurf # Keep tor available but disable anonsurf

# --- Kernel and Swap Optimization ---
echo "Optimizing kernel and swap settings..."
# Use sed to add or update settings to avoid duplicates
sed -i '/vm.swappiness/d' /etc/sysctl.conf
sed -i '/vm.vfs_cache_pressure/d' /etc/sysctl.conf
echo "vm.swappiness=10" >> /etc/sysctl.conf
echo "vm.vfs_cache_pressure=50" >> /etc/sysctl.conf

# --- ZRAM Configuration (Dynamic Sizing) ---
echo "Installing and configuring zram..."
apt-get install -y zram-tools
# Calculate ZRAM size as 50% of RAM, capped at 4GB
mem_total_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
mem_total_mb=$((mem_total_kb / 1024))
zram_size=$((mem_total_mb / 2))
[ $zram_size -gt 4096 ] && zram_size=4096

cat > /etc/default/zramswap << EOL
# /etc/default/zramswap
# Configuration for zram-tools
ALGO=lz4
SIZE=${zram_size}
EOL
systemctl enable --now zramswap

# --- Preload for Faster Application Loading ---
echo "Installing and enabling preload..."
apt-get install -y preload
systemctl enable preload

# --- Boot Time Optimization ---
echo "Optimizing boot process..."
systemctl disable NetworkManager-wait-online.service
# Use sed to prevent duplicate GRUB_TIMEOUT entries
sed -i 's/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=2/' /etc/default/grub
update-grub

# --- Filesystem and I/O Optimization ---
echo "Applying filesystem optimizations..."
# Enable noatime to reduce disk writes
sed -i 's/relatime/noatime/g' /etc/fstab

# --- Safe Temporary File Cleanup ---
echo "Installing tmpreaper for safe temporary file cleanup..."
apt-get install -y tmpreaper
# Configuration will be in /etc/tmpreaper.conf, runs via cron daily

# --- XFCE Desktop Optimization (Example) ---
echo "Applying XFCE optimizations..."
# Disable desktop icons for a slight performance boost
xfconf-query -c xfce4-desktop -p /desktop-icons/style -s 0
# Disable window animations
xfconf-query -c xfwm4 -p /general/use_compositing -s false

# --- Apply all sysctl changes ---
sysctl -p

echo "Optimization complete for Parrot OS. A reboot is required to apply all changes."