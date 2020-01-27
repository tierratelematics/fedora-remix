# desktop-gnome.ks
#
# Customization for GNOME desktop.

%include desktop-base.ks

%packages

# desktop
gnome-shell-extension-dash-to-dock
gnome-tweaks

# networking
firewall-config
NetworkManager-l2tp-gnome
transmission-gtk

# multimedia
gthumb
gimp
inkscape
vlc
brasero
brasero-nautilus

seahorse
seahorse-nautilus

# tools
gparted

%end

%post

echo ""
echo "POST desktop-gnome ************************************"
echo ""

# Set default fonts for GNOME environment
cat > /etc/dconf/db/local.d/01-remix-gnome-fonts << EOF_FONTS
# Remix global font settings

[org/gnome/Characters]
font='Noto Sans 50'

[org/gnome/desktop/interface]
document-font-name='Noto Sans 11'
font-name='Noto Sans 11'
monospace-font-name='Noto Sans Mono Condensed 11'

[org/gnome/desktop/wm/preferences]
titlebar-font='Noto Sans 11'

[org/gnome/settings-daemon/plugins/xsettings]
antialiasing='rgba'
hinting='full'
EOF_FONTS

# Enable dash-to-dock, app & places menus
cat > /etc/dconf/db/local.d/01-remix-gnome-extensions << EOF_EXTENSIONS
# Remix global gnome extensions

[org/gnome/shell]
enabled-extensions=['dash-to-dock@micxgx.gmail.com', 'apps-menu@gnome-shell-extensions.gcampax.github.com', 'places-menu@gnome-shell-extensions.gcampax.github.com']

EOF_EXTENSIONS

# Update configuration
dbus-launch --exit-with-session dconf update

%end
