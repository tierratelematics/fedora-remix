# es_ES-base.ks
#
# Defines the basics for a workstation in spanish.

%include es_ES-support.ks

lang es_ES.UTF-8 --addsupport=es_ES.UTF-8
keyboard --xlayouts=es --vckeymap=es
timezone Europe/Madrid

%post

echo ""
echo "POST es_ES-base **************************************"
echo ""

# Set spanish locale
cat >> /etc/rc.d/init.d/livesys << EOF_LIVESYS

# Force spanish keyboard layout (rhb #982394)
localectl set-locale es_ES.UTF-8
localectl set-x11-keymap es
localectl set-keymap es

EOF_LIVESYS

%end
