# it_IT-base.ks
#
# Defines the basics for a workstation in italian.

%include it_IT-support.ks

lang it_IT.UTF-8 --addsupport=it_IT.UTF-8
keyboard --xlayouts=it --vckeymap=it
timezone Europe/Rome

%post

echo ""
echo "POST it_IT-base **************************************"
echo ""

# Set italian locale
cat >> /etc/rc.d/init.d/livesys << EOF_LIVESYS

# Force italian keyboard layout (rhb #982394)
localectl set-locale it_IT.UTF-8
localectl set-x11-keymap it
localectl set-keymap it

EOF_LIVESYS

%end
