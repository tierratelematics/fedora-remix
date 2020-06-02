# development.ks
#
# Development support base.

%packages

PackageKit-command-not-found
@development-tools
git

%end

%post

echo ""
echo "POST development-base ************************************"
echo ""

cat > /etc/sysctl.d/10-remix-inotify.conf << INOTIFY_EOF
# remix - increase max inotify watches
fs.inotify.max_user_watches=524288
INOTIFY_EOF
%end
