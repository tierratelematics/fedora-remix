# development.ks
#
# Development support base.

repo --name=vscode --baseurl=https://packages.microsoft.com/yumrepos/vscode

%packages

@development-tools
# editors
code
vim-enhanced

# compiling
automake
kernel-devel
pkgconfig

# tools
tesseract
smem
strace
telnet

%end

%post

echo ""
echo "POST development-base ************************************"
echo ""

cat > /etc/sysctl.d/10-remix-inotify.conf << INOTIFY_EOF
# remix - increase max inotify watches
fs.inotify.max_user_watches=524288
INOTIFY_EOF

rpm --import https://packages.microsoft.com/keys/microsoft.asc
cat  > /etc/yum.repos.d/vscode.repo << EOF
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

%end
