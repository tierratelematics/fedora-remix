# it_IT-kde.ks
#
# Provides italian localization for the KDE desktop.

%include it_IT-base.ks

%packages --excludeWeakdeps

kde-l10n-Italian

%end

%post

echo ""
echo "POST it_IT-kde **********************************"
echo ""

# Defaults for user configuration
mkdir -p /etc/skel/.config/KDE

# Plasma locale settings
cat > /etc/skel/.config/plasma-localerc << PLASMALOCALE_EOF
[Formats]
LANG=it_IT.UTF-8

[Translations]
LANGUAGE=it
PLASMALOCALE_EOF

# KDE user locale settings
cat >> /etc/skel/.config/kdeglobals << GLOBALS_EOF
[Locale]
Country=it

[Translations]
LANGUAGE=it
GLOBALS_EOF

# KDE Sonnet locale settings
cat > /etc/skel/.config/KDE/Sonnet.conf << SONNET_EOF
[General]
autodetectLanguage=true
defaultLanguage=it_IT
SONNET_EOF

%end
