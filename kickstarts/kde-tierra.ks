# kde-tierra.ks
#
# Provides a workstation based on KDE with MS Active Directory support.

# IT language
#%include l10n/kde-desktop-it_IT.ks
# EN language
%include kde-desktop.ks

%packages --excludeWeakdeps

# AD integration
adcli
krb5-workstation
libsss_sudo
oddjob
oddjob-mkhomedir
realmd
samba-common-tools
smb4k
sssd
sssd-ad

# printer AD integration
samba-krb5-printing
samba-winbind
samba-winbind-clients
pam_krb5
krb5-workstation
kio-extras

# Development
git
gitflow

# Networking
plasma-nm-openconnect

# Security
keepassxc

%end


%post

echo ""
echo "POST TIERRA ******************************************"
echo ""

# Configure Kerberos
cat > /etc/krb5.toptierra << KRB5_CONF_EOF
includedir /etc/krb5.conf.d/

[libdefaults]
 forwardable = true
 proxiable = true
 dns_lookup_realm = true
 dns_lookup_kdc = true
 default_realm = TOPTIERRA.IT

[realms]
 TOPTIERRA.IT = {
    kdc = toptierra.it
    default_domain = toptierra.it
 }

[domain_realm]
 toptierra.it = TOPTIERRA.IT
 .toptierra.it = TOPTIERRA.IT
KRB5_CONF_EOF

# Configure Polkit
cat > /etc/polkit-1/rules.d/40-toptierra.rules << POLKIT_RULES_EOF
/* -*- mode: js; js-indent-level: 4; indent-tabs-mode: nil -*- */

// Default rules for TOPTIERRA domain.
//
polkit.addAdminRule(function(action, subject) {
    return ["unix-user:tierra.user"];
});
POLKIT_RULES_EOF

# Configure Samba
cat > /etc/samba/smb.toptierra << SAMBA_CONF_EOF
[global]
    workgroup = TOPTIERRA
    realm = TOPTIERRA.IT
    server string = %h Linux Host
    client signing = auto
    server signing = auto
    security = ads
    encrypt passwords = yes
    kerberos method = secrets and keytab
    dedicated keytab file = /etc/krb5.keytab
    lock directory = /tmp
    printing = cups
    printcap name = cups
    client max protocol = SMB3
    client min protocol = SMB2
    min protocol = SMB2
SAMBA_CONF_EOF

# SSSD configuration file for Tierra domain
cat > /etc/sssd/sssd.toptierra << SSSD_CONF_EOF
[sssd]
domains = toptierra.it
config_file_version = 2
services = nss, pam, sudo

[pam]
offline_credentials_expiration = 30

[domain/toptierra.it]
ad_domain = toptierra.it
krb5_realm = TOPTIERRA.IT
krb5_store_password_if_offline = True
cache_credentials = True
account_cache_expiration = 30
id_provider = ad
chpass_provider = ad
default_shell = /bin/bash
use_fully_qualified_names = False
fallback_homedir = /home/%u
access_provider = simple
simple_allow_users = tierra.user@toptierra.it
simple_allow_groups = domain admins
enumerate = True
ldap_id_mapping = True
ldap_schema = ad
ldap_idmap_range_min = 5000
ldap_idmap_range_max = 55000
ldap_idmap_range_size = 5000
SSSD_CONF_EOF

# Revoke access to sssd config file from other than root user
chmod go-rwx /etc/sssd/sssd.toptierra

# Add domain users to sudoers group
cat > /etc/sudoers.d/toptierra << SUDOERS_EOF
%domain\\ users  ALL=(ALL) ALL
SUDOERS_EOF

cat > /usr/local/sbin/backup_for_upgrade.sh << 'BACKUPSCRIPT_EOF'
#!/bin/bash
##script for backup specific path of pc

USER="<username>" #insert username
DATE=`date '+%Y%m%d_%H%M%S'`
HOSTNAME=`hostname | awk -F"." '{print $1}'`
MOUNTPOINT_DEST="/mnt" #insert USB_DRIVE
DEST="$MOUNTPOINT_DEST/BACKUP_TO_UPGRADE-${HOSTNAME}-$DATE"
PATH_LOG="${DEST}/LOG"
DEST_BACKUP="$DEST/BACKUP"
LOG_FILE="${PATH_LOG}/backup_for_upgrade-${HOSTNAME}-${DATE}.log"
PATH_TO_BACKUP=("/usr/local" "/home/$USER" "/etc" "/root") #insert folder to backup

mkdir -p ${DEST}
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

mkdir -p ${PATH_LOG}
mkdir -p ${DEST_BACKUP}

exec 3>&1 1>>${LOG_FILE} 2>&1

#create installed package list
id > "$DEST/id-$DATE.txt"
dnf list installed > "$DEST/dnf_list_installed-$DATE.txt"
rpm -qa > "$DEST/rpm-qa-$DATE.txt"
flatpak list > "$DEST/flatpak_list-$DATE.txt"
snap list > "$DEST/snap_list-$DATE.txt"
cat /home/${USER}/.bash_history > "$DEST/history_${USER}-$DATE.txt"

#create backup
for path in "${PATH_TO_BACKUP[@]}"
do 
        echo -e "\nBackup of ${path}:"
        tar cjvpf ${DEST_BACKUP}/`basename ${path}`-$DATE.tar.bz2 ${path} >> "${PATH_LOG}/`basename ${path}`-$DATE.log"
done
BACKUPSCRIPT_EOF

# domain join and pc assign script
cat > /usr/sbin/tierractl <<  TIERRACTL_EOF
#!/bin/bash
set -e

shortusage() {
    echo -e '\nSYNTAX

    tierractl [join | assign]

    Manipulates the host configuration: joins the Tierra domain or assigns an user to it.'
}

if (( \$# > 1 )); then
    shortusage
    echo -e '\nERROR: only one command must be specified.'
    exit 1
fi

INPUT_CMD="\$1"
case \$INPUT_CMD in
    join)
        read -p 'Domain username: ' domain_user
        realm join --user=\$domain_user toptierra.it
        echo 'Configuring SSSD service...'
        systemctl stop sssd
        rm --force --recursive /var/lib/sss/db/*
        mv /etc/sssd/sssd.conf /etc/sssd/sssd.conf."\$(date +"%Y%m%d-%H%M%S")"
        cp --force /etc/sssd/sssd.toptierra /etc/sssd/sssd.conf
        systemctl start sssd
        echo 'Configuring Kerberos service...'
        mv /etc/krb5.conf /etc/krb5.conf."\$(date +"%Y%m%d-%H%M%S")"
        cp --force /etc/krb5.toptierra /etc/krb5.conf
        echo 'Configuring Samba service...'
        mv /etc/samba/smb.conf /etc/samba/smb.conf."\$(date +"%Y%m%d-%H%M%S")"
        cp --force /etc/samba/smb.toptierra /etc/samba/smb.conf
        echo 'Configuring CUPS service...'
        cupsctl DefaultAuthType=Negotiate
        echo 'Done.'
        ;;
    assign)
        read -p 'Host assignee username: ' assignee_user
        echo 'Assigning user...'
        sed -i 's/^simple_allow_users.*toptierra.it$/simple_allow_users = '\$assignee_user'@toptierra.it/' \\
            /etc/sssd/sssd.conf
        sed -i 's/"unix-user:.*"/"unix-user:'\$assignee_user'"/' \\
            /etc/polkit-1/rules.d/40-toptierra.rules
        systemctl restart sssd
        echo 'Assignee '\$assignee_user' ids:'
        id \$assignee_user
        echo 'Adding '\$assignee_user' to wheel group...'
        usermod --append --groups wheel \$assignee_user
        echo 'Done.'
        ;;
    *)
        shortusage
        echo -e "\nERROR: unknown command \"\$INPUT_CMD\""
        exit 1
    ;;
esac
TIERRACTL_EOF

chmod ug+x /usr/sbin/tierractl

%end
