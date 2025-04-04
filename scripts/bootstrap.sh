#!/bin/ksh

# This script installs a set of packages on a Debian system

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root."
  exit 1
fi

echo "This script is designed for Debian and may not work on other distributions."

# Update package lists
echo "Updating package lists..."
apt update

# Create a dependencies file
cat > dependencies.txt << 'EOF'
# Basic development tools
build-essential
git
curl
wget
vim
htop

# X11 related packages
xorg
xserver-xorg
x11-utils
x11-xserver-utils
xinit

# Libraries and dependencies
libx11-dev
libxinerama-dev
libxft-dev
libxrandr-dev
fontconfig
fontconfig-dev
libfreetype6-dev
libglib2.0-dev
libgtk-3-dev
libwebkit2gtk-4.0-dev
libimlib2-dev
gcc
doas
meson
libsystemd-dev
gnutls-dev

# Window manager related
picom
polybar

# Fonts

# Utilities
feh
lxappearance
scrot

# Web browsers
chromium

# Terminal
# alacritty

# Additional tools
# rofi
# ranger
 fastfetch

EOF

# Install packages from dependencies.txt
echo "Installing dependencies listed in dependencies.txt..."
sed -e 's/#.*$//' -e '/^$/d' dependencies.txt | while read p; do
    echo "Installing $p..."
    apt install -y $p
done

echo "Cleaning up..."
apt autoremove -y
apt clean

echo "Debian bootstrap completed successfully!"
echo "You may need to reboot your system for all changes to take effect."
