#!/bin/ksh

# Debian Bootstrap Script
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
sudo
doas
meson

# Window manager related
picom

# Fonts

# Utilities
feh
lxappearance
scrot

# Web browsers
chromium

# Terminal
alacritty

# Additional tools
rofi
ranger
fastfetch

EOF

# Install packages from dependencies.txt
echo "Installing dependencies listed in dependencies.txt..."
sed -e 's/#.*$//' -e '/^$/d' dependencies.txt | while read p; do
    echo "Installing $p..."
    apt install -y $p
done

# Create basic X11 configuration
echo "Setting up basic X11 configuration..."
if [ ! -f /etc/X11/xorg.conf ]; then
    echo "Creating default xorg.conf..."
    # This just creates a very minimal config - most modern systems autodetect settings
    cat > /etc/X11/xorg.conf << 'EOF'
Section "ServerLayout"
    Identifier     "Default Layout"
    Screen         0 "Screen0" 0 0
    InputDevice    "Mouse0" "CorePointer"
    InputDevice    "Keyboard0" "CoreKeyboard"
EndSection

Section "InputDevice"
    Identifier     "Keyboard0"
    Driver         "kbd"
    Option         "XkbLayout" "us"
EndSection

Section "InputDevice"
    Identifier     "Mouse0"
    Driver         "mouse"
    Option         "Protocol" "auto"
    Option         "Device" "/dev/input/mice"
    Option         "ZAxisMapping" "4 5 6 7"
EndSection

Section "Monitor"
    Identifier     "Monitor0"
    Option         "DPMS" "true"
EndSection

Section "Device"
    Identifier     "Card0"
    Driver         "modesetting"
EndSection

Section "Screen"
    Identifier     "Screen0"
    Device         "Card0"
    Monitor        "Monitor0"
    DefaultDepth    24
    SubSection     "Display"
        Depth       24
    EndSubSection
EndSection
EOF
fi

# Set up a window manager
echo "Choose a window manager to install:"
echo "1) dwm"
echo "2) bspwm"
echo "3) None (Skip window manager installation)"
read -p "Enter choice [1-3]: " wm_choice

case $wm_choice in
    1)
        window_manager="dwm"
        ;;
    2)
        window_manager="bspwm"
        ;;
    *)
        window_manager="none"
        ;;
esac

if [ "$window_manager" = "dwm" ]; then
    echo "Setting up dwm..."
    
    # Install build dependencies if not already installed
    apt install -y libx11-dev libxinerama-dev libxft-dev libxrandr-dev
    
    # Create directory for dwm
    mkdir -p /opt/suckless
    cd /opt/suckless
    
    # Clone dwm
    if [ ! -d dwm ]; then
        git clone https://git.suckless.org/dwm
    else
        echo "dwm directory already exists, skipping clone"
    fi
    
    # Compile and install dwm
    cd dwm
    make clean install
    
    # Create a basic .xinitrc
    cat > /etc/skel/.xinitrc << 'EOF'
#!/bin/sh

# Load resources
if [ -f "$HOME/.Xresources" ]; then
    xrdb -merge "$HOME/.Xresources"
fi

# Start compositor
picom -b &

# Set background
if command -v nitrogen > /dev/null; then
    nitrogen --restore &
elif command -v feh > /dev/null; then
    feh --bg-fill /usr/share/backgrounds/default.jpg &
fi

# Start notification daemon
if command -v dunst > /dev/null; then
    dunst &
fi

# Start terminal daemon
if command -v urxvtd > /dev/null; then
    urxvtd -q -o -f &
fi

# Launch window manager
exec dwm
EOF
elif [ "$window_manager" = "bspwm" ]; then
    echo "Setting up bspwm..."
    
    # Install bspwm and sxhkd
    apt install -y bspwm sxhkd
    
    # Get the target user
    if [ -n "$SUDO_USER" ] && [ "$SUDO_USER" != "root" ]; then
        TARGET_USER=$SUDO_USER
    else
        echo "Enter the username to configure bspwm for:"
        read TARGET_USER
    fi
    
    # Create config directories in the user's home
    mkdir -p /home/$TARGET_USER/.config/bspwm
    mkdir -p /home/$TARGET_USER/.config/sxhkd
    
    # Create bspwm config
    cat > /home/$TARGET_USER/.config/bspwm/bspwmrc << 'EOF'
#! /bin/sh
bspc monitor -d 1 2 3 4 5
bspc config border_width         4
bspc config window_gap          15
bspc config split_ratio          0.52
bspc config borderless_monocle   true
bspc config gapless_monocle      false
bspc config focused_border_color "#ECEFF4"
bspc config normal_border_color "#4c566a"
bspc config border_radius 10
bspc config pointer_modifier mod4
bspc config pointer_action1 move
bspc config pointer_action2 resize_side
bspc config pointer_action3 resize_corner
bspc config automatic_scheme spiral
# autostart programs
killall sxhkd
sxhkd &
killall picom
picom &
xrandr --output Virtual-1 --mode "1920x1080"
feh --bg-scale $HOME/background/wall.png
xset r rate 250 50
polybar&
termite
EOF
    chmod +x /home/$TARGET_USER/.config/bspwm/bspwmrc
    
    # Create sxhkd config
    cat > /home/$TARGET_USER/.config/sxhkd/sxhkdrc << 'EOF'
#
# wm independent hotkeys
#
# terminal emulator
super + Return
	st
super + l
	slock
#screenshots	
print 
	flameshot gui
# program launcher
super + space
	dmenu_run
	#dmenu_run -nb '#f7f9ef' -sf '#666666' -sb '#ae95c7' -nf '#bbbbbb'
	
# make sxhkd reload its configuration files:
super + Escape
	pkill -USR1 -x sxhkd
#
# bspwm hotkeys
#
# quit/restart bspwm
super + {_,shift +}r
	bspc {quit,wm -r}
# close and kill
super + q
	bspc node -{c,k}
# alternate between the tiled and monocle layout
super + m
	bspc desktop -l next
# send the newest marked node to the newest preselected node
super + y
	bspc node newest.marked.local -n newest.!automatic.local
# swap the current node and the biggest window
super + g
	bspc node -s biggest.window
#
# state/flags
#
# set the window state
super + {t,shift + t,s,f}
	bspc node -t {tiled,pseudo_tiled,floating,fullscreen}
# set the node flags
super + ctrl + {m,x,y,z}
	bspc node -g {hidden,locked,sticky,private}
# Unhide window
super + ctrl + shift + m
    bspc node $(bspc query -N -n .hidden | tail -n1) -g hidden=off
#
# focus/swap
#
# focus the node in the given direction
super + {_,shift + }{h,j,k,l}
	bspc node -{f,s} {west,south,north,east}
# focus the node for the given path jump
super + {p,b,comma,period}
	bspc node -f @{parent,brother,first,second}
# focus the next/previous window in the current desktop
super + {_,shift + }c
	bspc node -f {next,prev}.local.!hidden.window
# focus the next/previous desktop in the current monitor
super + bracket{left,right}
	bspc desktop -f {prev,next}.local
# focus the last node/desktop
super + {grave,Tab}
	bspc {node,desktop} -f last
# focus the older or newer node in the focus history
super + {o,i}
	bspc wm -h off; \
	bspc node {older,newer} -f; \
	bspc wm -h on
# focus or send to the given desktop
super + {_,shift + }{1-9,0}
	bspc {desktop -f,node -d} '^{1-9,10}'
#
# preselect
#
# preselect the direction
super + ctrl + {h,j,k,l}
	bspc node -p {west,south,north,east}
# preselect the ratio
super + ctrl + {1-9}
	bspc node -o 0.{1-9}
# cancel the preselection for the focused node
super + ctrl + space
	bspc node -p cancel
# cancel the preselection for the focused desktop
super + ctrl + shift + space
	bspc query -N -d | xargs -I id -n 1 bspc node id -p cancel
#
# move/resize
#
# expand a window by moving one of its side outward
#super + ctrl + shift + l
#	bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}
# contract a window by moving one of its side inward
#super + alt + shift + {h,j,k,l}
#	bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}
super + control + shift + {h,j,k,l}
  bspc node -z {left -20 0 || bspc node -z right -20 0, \
                bottom 0 20 || bspc node -z top 0 20,\
                top 0 -20 || bspc node -z bottom 0 -20,\
                right 20 0 || bspc node -z left 20 0}
# move a floating window
super + {Left,Down,Up,Right}
	bspc node -v {-20 0,0 20,0 -20,20 0}
EOF
    
    # Set proper ownership
    chown -R $TARGET_USER:$TARGET_USER /home/$TARGET_USER/.config
    
    # Create the background directory
    mkdir -p /home/$TARGET_USER/background
    chown $TARGET_USER:$TARGET_USER /home/$TARGET_USER/background
    
    # Add packages needed for this specific config
    apt install -y st slock flameshot polybar termite
    
    # Create .xinitrc for bspwm
    cat > /etc/skel/.xinitrc << 'EOF'
#!/bin/sh

# Load resources
if [ -f "$HOME/.Xresources" ]; then
    xrdb -merge "$HOME/.Xresources"
fi

# Start bspwm
exec bspwm
EOF
else
    echo "Skipping window manager installation..."
    
    # Create a basic .xinitrc
    cat > /etc/skel/.xinitrc << 'EOF'
#!/bin/sh

# Load resources
if [ -f "$HOME/.Xresources" ]; then
    xrdb -merge "$HOME/.Xresources"
fi

# Start a terminal
urxvt &

# Start a basic window manager if available
if command -v openbox > /dev/null; then
    exec openbox
elif command -v fluxbox > /dev/null; then
    exec fluxbox
elif command -v twm > /dev/null; then
    exec twm
fi
EOF
fi

    chmod +x /etc/skel/.xinitrc
    echo "Basic dwm configuration set up in /etc/skel/.xinitrc"
    
    # Copy .xinitrc to current user's home if not root
    if [ -n "$SUDO_USER" ]; then
        cp /etc/skel/.xinitrc /home/$SUDO_USER/
        chown $SUDO_USER:$SUDO_USER /home/$SUDO_USER/.xinitrc
        echo "Copied .xinitrc to /home/$SUDO_USER/"
    fi
fi

# Set up additional configurations
echo "Setting up additional configurations..."

# Create default user directories
if command -v xdg-user-dirs-update > /dev/null; then
    if [ -n "$SUDO_USER" ]; then
        su - $SUDO_USER -c "xdg-user-dirs-update"
        echo "Created default user directories for $SUDO_USER"
    fi
fi

# Set up doas configuration
echo "Setting up doas configuration..."
if command -v doas > /dev/null; then
    # Create doas.conf file
    if [ ! -f /etc/doas.conf ]; then
        # If run with sudo, use that user, otherwise ask for a username
        if [ -n "$SUDO_USER" ] && [ "$SUDO_USER" != "root" ]; then
            DOAS_USER=$SUDO_USER
        else
            echo "Enter the username for doas configuration:"
            read DOAS_USER
        fi
        
        # Create doas.conf with appropriate permissions
        echo "permit nopass $DOAS_USER as root" > /etc/doas.conf
        chmod 600 /etc/doas.conf
        echo "doas configured for user $DOAS_USER"
    else
        echo "/etc/doas.conf already exists, not overwriting"
    fi
else
    echo "Warning: doas command not found. Please make sure it's installed."
    apt install -y doas
    
    if command -v doas > /dev/null; then
        # If run with sudo, use that user, otherwise ask for a username
        if [ -n "$SUDO_USER" ] && [ "$SUDO_USER" != "root" ]; then
            DOAS_USER=$SUDO_USER
        else
            echo "Enter the username for doas configuration:"
            read DOAS_USER
        fi
        
        # Create doas.conf with appropriate permissions
        echo "permit nopass $DOAS_USER as root" > /etc/doas.conf
        chmod 600 /etc/doas.conf
        echo "doas configured for user $DOAS_USER"
    else
        echo "Failed to install doas. Please install it manually."
    fi
fi

echo "Cleaning up..."
apt autoremove -y
apt clean

echo "Debian bootstrap completed successfully!"
echo "You may need to reboot your system for all changes to take effect."
