# domain-kde.ks
#
# Provides a workstation based on GNOME with MS Active Directory support.

%include domain-base.ks

%packages

# Networking
NetworkManager-openconnect-gnome
NetworkManager-openvpn-gnome
evolution-ews

%end
