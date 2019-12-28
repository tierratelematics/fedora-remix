# kde-box.ks
#
# Provides a minimal Linux box based on KDE desktop.

%include fedora-live-kde-base.ks

%packages --excludeWeakdeps

# Graphics
kamoso
kdegraphics-thumbnailers

# Multimedia
ffmpegthumbs
kio_mtp
vlc

%end
