# nonfree.ks
#
# Adds extra repos for software that the Fedora Project doesn't want to ship.

# Extra repositories
repo --name=fedora-cisco-openh264 --metalink=https://mirrors.fedoraproject.org/metalink?repo=fedora-cisco-openh264-$releasever&arch=$basearch
repo --name=rpmfusion-free --metalink=https://mirrors.rpmfusion.org/metalink?repo=free-fedora-$releasever&arch=$basearch
repo --name=rpmfusion-free-updates --metalink=https://mirrors.rpmfusion.org/metalink?repo=free-fedora-updates-released-$releasever&arch=$basearch
repo --name=rpmfusion-nonfree --metalink=https://mirrors.rpmfusion.org/metalink?repo=nonfree-fedora-$releasever&arch=$basearch
repo --name=rpmfusion-nonfree-updates --metalink=https://mirrors.rpmfusion.org/metalink?repo=nonfree-fedora-updates-released-$releasever&arch=$basearch
repo --name=rpmfusion-free-tainted --metalink=https://mirrors.rpmfusion.org/metalink?repo=free-fedora-tainted-$releasever&arch=$basearch
repo --name=rpmfusion-nonfree-tainted --metalink=https://mirrors.rpmfusion.org/metalink?repo=nonfree-fedora-tainted-$releasever&arch=$basearch

%packages

fedora-workstation-repositories

# RPM Fusion repositories
rpmfusion-free-release
rpmfusion-free-release-tainted
rpmfusion-nonfree-release
rpmfusion-nonfree-release-tainted

# Appstream data
rpmfusion-*-appstream-data

# Multimedia
gstreamer1-libav
gstreamer1-vaapi
gstreamer1-plugins-bad-free
gstreamer1-plugins-bad-freeworld
gstreamer1-plugins-good
gstreamer1-plugins-ugly
gstreamer1-plugins-ugly-free
libdvdcss

# Tools
exfat-utils
fuse-exfat
unrar

%end

%post

echo ""
echo "POST nonfree **************************************"
echo ""

# Enable Cisco Open H.264 repository
dnf config-manager --set-enabled fedora-cisco-openh264

cat > /usr/local/sbin/firstboot_flathub.sh << 'FLATHUB_EOF'
#!/bin/bash
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
FLATHUB_EOF

chmod +x /usr/local/sbin/firstboot_flathub.sh

%end
