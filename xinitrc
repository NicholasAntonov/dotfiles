# Load the resources
xrdb -merge ~/.Xresources

# Set up icon tray
stalonetray &

# Ugly hack to remap capslock to super_l
xmodmap -e "remove Lock = Caps_Lock"
xmodmap -e "add mod3 = Caps_Lock"
xmodmap ~/.xmodmap

# Set wallpaper
feh --bg-scale ~/.wallpapers/blurry-shapes.jpg &

# Start composition manager (shadows and chrome rendering)
xcompmgr -n &

# Start notification client
dunst &

# Fire up apps
xscreensaver -no-splash &

if [ -x /usr/bin/nm-applet ] ; then
   nm-applet --sm-disable &
fi

exec xmonad

