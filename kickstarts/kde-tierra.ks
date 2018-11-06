# kde-tierra.ks
#
# Provides a workstation based on KDE with MS Active Directory support.

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

# Development
git
gitflow

# Networking
plasma-nm-openconnect

%end


%post

echo ""
echo "POST TIERRA ******************************************"
echo ""

# Enable "domain users" group as administrators for print server
sed -i 's/^[[:blank:]]*SystemGroup /SystemGroup "domain users" /g' /etc/cups/cups-files.conf

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
realmd_tags = manages-system joined-with-adcli
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

cat > /usr/sbin/tierractl <<  TIERRACTL_EOF
#!/bin/bash
set -e

shortusage() {
    echo -e '\nSYNTAX

    tierractl [join|assign]
    
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
        echo 'Cleaning cache...'
        systemctl stop sssd
        rm /var/lib/sss/db/* -rf
        mv /etc/sssd/sssd.conf /etc/sssd/sssd.bak
        cp /etc/sssd/sssd.toptierra /etc/sssd/sssd.conf
        systemctl start sssd
        echo 'Done.'
        ;;
    assign)
        read -p 'Host assignee username: ' assignee_user
        echo 'Assigning user...'
        sed -i 's/^simple_allow_users.*toptierra.it$/simple_allow_users = '\$assignee_user'@toptierra.it/' \\
            /etc/sssd/sssd.conf
        systemctl restart sssd
        echo 'Assignee '\$assignee_user' ids:'
        id \$assignee_user
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
