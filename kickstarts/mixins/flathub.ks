# flathub.ks
#
# Add flathub flatpak remote

%post

echo ""
echo "POST flathub ************************************"
echo ""

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

%end
