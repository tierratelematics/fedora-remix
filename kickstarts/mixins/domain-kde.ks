# domain-kde.ks
#
# Provides a workstation based on KDE with MS Active Directory support.

%include domain-base.ks

%packages --excludeWeakdeps

# Networking
plasma-nm-openconnect

# Security
keepassxc

%end
