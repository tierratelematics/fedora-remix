# desktop.ks
#
# Common customizations for a desktop workstation.

%packages

# Unwanted stuff
-abrt*
-fedora-release-notes
-fpaste
-rsyslog
-sendmail

# Multimedia
alsa-plugins-pulseaudio
mozilla-openh264
pulseaudio
pulseaudio-module-*
-pulseaudio-module-bluetooth # prefer RPMFusion version to pulseaudio-module-bluetooth
pulseaudio-utils

# Fonts
google-noto-sans-fonts
google-noto-sans-mono-fonts
google-noto-serif-fonts
liberation-s*-fonts
wine-fonts

# Tools
@networkmanager-submodules
htop
vim-enhanced
unar
tmate

%end


%post

echo ""
echo "POST desktop-base ************************************"
echo ""

# Link Wine fonts to system folder
ln -s /usr/share/wine/fonts /usr/share/fonts/wine

# Antialiasing by default.
# Set Noto fonts as preferred family.
cat > /etc/fonts/local.conf << EOF_FONTS
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>

<!-- Settins for better font rendering -->
<match target="font">
	<edit mode="assign" name="rgba"><const>rgb</const></edit>
	<edit mode="assign" name="hinting"><bool>true</bool></edit>
	<edit mode="assign" name="hintstyle"><const>hintfull</const></edit>
	<edit mode="assign" name="antialias"><bool>true</bool></edit>
	<edit mode="assign" name="lcdfilter"><const>lcddefault</const></edit>
</match>

<!-- Local default fonts -->
<!-- Serif faces -->
	<alias>
		<family>serif</family>
		<prefer>
			<family>Noto Serif</family>
			<family>DejaVu Serif</family>
			<family>Liberation Serif</family>
            <family>Times New Roman</family>
			<family>Nimbus Roman No9 L</family>
			<family>Times</family>
		</prefer>
	</alias>
<!-- Sans-serif faces -->
	<alias>
		<family>sans-serif</family>
		<prefer>
			<family>Noto Sans</family>
			<family>DejaVu Sans</family>
			<family>Liberation Sans</family>
            <family>Arial</family>
			<family>Nimbus Sans L</family>
			<family>Helvetica</family>
		</prefer>
	</alias>
<!-- Monospace faces -->
	<alias>
		<family>monospace</family>
		<prefer>
			<family>Noto Sans Mono Condensed</family>
			<family>DejaVu Sans Mono</family>
			<family>Liberation Mono</family>
            <family>Courier New</family>
			<family>Andale Mono</family>
			<family>Nimbus Mono L</family>
		</prefer>
	</alias>
</fontconfig>
EOF_FONTS

# Set a colored prompt
cat > /etc/profile.d/color-prompt.sh << EOF_PROMPT
## Colored prompt
if [ -n "\$PS1" ]; then
	if [[ "\$TERM" == *256color ]]; then
		if [ \${UID} -eq 0 ]; then
			PS1='\[\e[91m\]\u@\h \[\e[93m\]\W\[\e[0m\]\\$ '
		else
			PS1='\[\e[92m\]\u@\h \[\e[93m\]\W\[\e[0m\]\\$ '
		fi
	else
		if [ \${UID} -eq 0 ]; then
			PS1='\[\e[31m\]\u@\h \[\e[33m\]\W\[\e[0m\]\\$ '
		else
			PS1='\[\e[32m\]\u@\h \[\e[33m\]\W\[\e[0m\]\\$ '
		fi
	fi
fi
EOF_PROMPT

cat > /usr/sbin/backup_for_upgrade.sh << 'BACKUPSCRIPT_EOF'
#!/bin/bash

if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

USER="$(logname)"
MOUNTPOINT_DEST="/home"
DEST="/home/backup-$USER@$HOSTNAME-$(date '+%Y%m%d_%H%M%S')"
PATHS_TO_BACKUP=(
    usr/local
    etc
    root
)

mkdir -p "$DEST"
cd $DEST
umask 0066

echo "Saving lists of installed packages"
id > id.txt
dnf list installed > dnf_list_installed.txt
rpm -qa > rpm-qa.txt
flatpak list > flatpak_list.txt
snap list > snap_list.txt

# backup folders
for path in "${PATHS_TO_BACKUP[@]}"
do
    echo "Backing up $path"
    tar cjpf "backup-$(echo $path | tr / _).tar.bz2" -C / "$path"
done

echo "All done. Files are in $DEST"

BACKUPSCRIPT_EOF

chmod +x /usr/sbin/backup_for_upgrade.sh

%end
