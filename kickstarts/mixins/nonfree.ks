# nonfree.ks
#
# Adds extra repos for software that the Fedora Project doesn't want to ship.

# Extra repositories
repo --name=rpmfusion-free --mirrorlist=http://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-$releasever&arch=$basearch
repo --name=rpmfusion-free-updates --mirrorlist=http://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-updates-released-$releasever&arch=$basearch
repo --name=rpmfusion-nonfree --mirrorlist=http://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-$releasever&arch=$basearch
repo --name=rpmfusion-nonfree-updates --mirrorlist=http://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-updates-released-$releasever&arch=$basearch
repo --name=rpmfusion-free-release-tainted --metalink=https://mirrors.rpmfusion.org/metalink?repo=free-fedora-tainted-$releasever&arch=$basearch
repo --name=adobe --baseurl=http://linuxdownload.adobe.com/linux/$basearch/

%packages --excludeWeakdeps

# RPM Fusion repositories
rpmfusion-free-release
rpmfusion-free-release-tainted
rpmfusion-nonfree-release
rpmfusion-nonfree-release-tainted

# Appstream data
rpmfusion-*-appstream-data

# Multimedia
gstreamer*-libav
gstreamer*-vaapi
gstreamer*-plugins-bad-free
gstreamer*-plugins-bad-freeworld
gstreamer*-plugins-good
gstreamer*-plugins-ugly
gstreamer*-plugins-ugly-free
libdvdcss
flash-plugin

# Tools
exfat-utils
fuse-exfat
unrar

%end


%post

echo ""
echo "POST nonfree **************************************"
echo ""

# A reduced version of Remi repository
cat > /etc/yum.repos.d/remix.repo << REMI_REPO_EOF
[remix-remi]
name=Remix Remi - Fedora \$releasever - \$basearch
#baseurl=http://rpms.famillecollet.com/fedora/\$releasever/remi/\$basearch/
mirrorlist=http://rpms.famillecollet.com/fedora/\$releasever/remi/mirror
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-remi
timeout=5
exclude=gd
includepkgs=libdvd*,remi-release*
REMI_REPO_EOF

# Adobe repo does not offer a release rpm
cat > /etc/yum.repos.d/adobe-linux-x86_64.repo << ADOBE_REPO_EOF
[adobe-linux-x86_64]
name=Adobe Systems Incorporated
baseurl=http://linuxdownload.adobe.com/linux/x86_64/
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-adobe-linux
ADOBE_REPO_EOF

cat > /etc/pki/rpm-gpg/RPM-GPG-KEY-adobe-linux << ADOBE_KEY_EOF
-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.2.6 (GNU/Linux)

mQGiBEXlsbkRBACdGA0PaNHSYxn9K5SPo5e7mEsVpl37Xm7F2m1nTIMLq2v/IT8Z
bhLhVXTCR9amFRR4qV+AN6SJeXEYeMrZW/7TiMkULfkoThrtTF/spUK5/HvTGgqh
iGVbBQfqx65mboeXNQwLGXSBCtA7zA2PM/E0oLwpEuJidAodsQLKNQIKWwCgxDq8
wz0/jcqyIULCYasHmz56dFsD/2Ye27k52I1TRT3EvBIjOkmNfic8rkkoJfuTFRFM
Ivb+jot1Y6JltCHjqgwGmBi3hPJjOxti0yO1s82m9RKBKzKNGl4/yp4QI6mftK0x
F0U8RW5kD7oKD5jYGU6ZZuivZ9SpBg7PdEFXzTTYXwrBD3/W0AkXB/mGSlO4cA9f
GsUuA/97tCsspIJKTuKLrt82heu9BUk7Uq56fB2HGjrwAlPgKAR9ajuXjdNwfEOS
928kKP544YE5U3pL1J4INEjgzeAiKjtK7npxOVj7clXvO8bi1D3IjJe1NtF2gGbt
+gmi38fDqj8iox43ihNbiib3od8GFu30wmr0uJCQC2cEF+paw7RFQWRvYmUgU3lz
dGVtcyBJbmNvcnBvcmF0ZWQgKExpbnV4IFJQTSBTaWduaW5nIEtleSkgPHNlY3Vy
ZUBhZG9iZS5jb20+iF4EExECAB4FAkXlsbkCGwMGCwkIBwMCAxUCAwMWAgECHgEC
F4AACgkQOmm9JPZ3fGe6bgCfRyDO0U8iQM5kHs6kesgio556JPUAoJw5ta+DACp2
SbHaG7wwEVOZQBdeuQINBEXlsb4QCACPQRsfdoPMxwACfGh9hc6toEctrLNbzmz0
W6tDKBWmbUm5c0RMKSBOHWBQtVhtS6XI2eIPB8XPKoz0uXaeqSYoZaG/vol1mUVz
ovVQa16yOHjzwK9VaQ1OxwF2UQ77amI1mT06FBuvu9xw/qyzCQiEqv6mXHp3yw8p
yU4n99Jc+B5M3Qs2Ppx8DRu31uM+jW6WIxP5uFWwFty1zftqTFrfbU6DXsJsAdto
FnzcbUaweK7Ibd03jdLzibkztrXKb4VasW92RlkCucJU2CaYXpW8CCBJnZ+hzvJp
RMp1YKBCcgWCm743pjpRtY5aPMl+5hBAuBsAJ+odLNM2LlWeWbzjAAMFB/44U5sJ
WDveeN1drH+WCCMNO83Ixv3i8YAxJgtArQZ36MHauRrAQQLjzjC78YHzeydixoeM
iBPvCpqz+kggxl2Nk2YyLIzzuP4BkZuusb46QvEO3FVHGeMNJnF7phbyg5/wE8gS
/KjlbiAQ8sDQ/ddDQbJfpgxQT5dBou3lcjrD7L5xJokDFJUoQ3w9N0Wnk96YgtFY
rdw0qXm/s5bnes4udSmwheGsKyvaP0r+ahfznQGJlNOxsqNWLGESyA79lnf3Hs79
8Tr3n4rqBkecRVdHzLFtzI+mRmwRtQETMr7SL6vRD4c1Vq7aZMuRQ0kgeDP38v7z
D+Er8IEvnKgfHdMIiEkEGBECAAkFAkXlsb4CGwwACgkQOmm9JPZ3fGcL8QCgwyz3
RWeAGeteAaS6ksAkKtLti/IAoKU5fzzgfcGUfIuyWqPIUAu906XA
=QO07
-----END PGP PUBLIC KEY BLOCK-----
ADOBE_KEY_EOF

rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-adobe-linux

%end
