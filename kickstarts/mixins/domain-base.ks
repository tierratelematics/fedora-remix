# domain-base.ks
#
# Provides MS Active Directory support.

%packages

# AD integration
@domain-client

# printer AD integration
samba-krb5-printing
samba-winbind
samba-winbind-clients
krb5-workstation

%end

services --enabled=sshd

%post
echo ""
echo "POST DOMAIN ******************************************"
echo ""

# Configure Kerberos
cat > /etc/krb5.conf.template << KRB5_CONF_EOF
includedir /etc/krb5.conf.d/

[libdefaults]
 forwardable = true
 proxiable = true
 dns_lookup_realm = true
 dns_lookup_kdc = true
 default_realm = __DOMAIN__

[realms]
 __DOMAIN__ = {
    kdc = __domain__
    default_domain = __domain__
 }

[domain_realm]
 __domain__ = __DOMAIN__
 .__domain__ = __DOMAIN__
KRB5_CONF_EOF

# Configure Polkit
cat > /etc/polkit-1/rules.d/40-domain.rules.template << POLKIT_RULES_EOF
/* -*- mode: js; js-indent-level: 4; indent-tabs-mode: nil -*- */

// Default rules for DOMAIN domain.
//
polkit.addAdminRule(function(action, subject) {
    return ["unix-user:__assignee_user__"];
});
POLKIT_RULES_EOF

# Configure Samba
cat > /etc/samba/smb.conf.template << SAMBA_CONF_EOF
[global]
    workgroup = __workgroup__
    realm = __DOMAIN__
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

# SSSD configuration file for Domain domain
cat > /etc/sssd/sssd.conf.template << SSSD_CONF_EOF
[sssd]
domains = __domain__
config_file_version = 2
services = nss, pam, sudo

[pam]
offline_credentials_expiration = 30

[domain/__domain__]
ad_domain = __domain__
krb5_realm = __DOMAIN__
krb5_store_password_if_offline = True
cache_credentials = True
account_cache_expiration = 30
id_provider = ad
chpass_provider = ad
default_shell = /bin/bash
use_fully_qualified_names = False
fallback_homedir = /home/%u
access_provider = simple
simple_allow_users = __assignee_user__@__domain__
simple_allow_groups = __admin_group__
enumerate = True
ldap_id_mapping = True
ldap_schema = ad
ldap_idmap_range_min = 5000
ldap_idmap_range_max = 55000
ldap_idmap_range_size = 5000
SSSD_CONF_EOF

# Revoke access to sssd config file from other than root user
chmod go-rwx /etc/sssd/sssd.conf.template

# Add domain users to sudoers group
cat > /etc/sudoers.d/domain.template << SUDOERS_EOF
%__admin_group__  ALL=(ALL) ALL
SUDOERS_EOF

# domain join and pc assign script
cat > /usr/sbin/domainctl <<  'DOMAINCTL_EOF'
#!/bin/bash
set -e

shortusage() {
    echo 'SYNTAX
    domainctl [join | assign]

join:   joins the machine to the domain
assign: enable a user on the machine
'
}

if (( $# > 1 )); then
    shortusage
    echo -e '\nERROR: only one command must be specified.'
    exit 1
fi

DATE="$(date +"%Y%m%d-%H%M%S")"

backup() {
    if [[ -f $1 ]]; then
        cp "$1" "$1.$DATE"
    fi
}

INPUT_CMD="$1"
case $INPUT_CMD in
    join)
        read -p 'Domain: ' domain
        domain=${domain,,}
        read -p 'Workgroup: ' workgroup
        read -p 'Domain admins group: ' admin_group
        read -p 'Your admin username: ' domain_user

        realm join --user=$domain_user $domain

        echo 'Configuring SSSD service...'
        systemctl stop sssd
        rm -rf /var/lib/sss/db
        mkdir /var/lib/sss/db
        backup /etc/sssd/sssd.conf
        sed -e "s/__domain__/$domain/g;
            s/__DOMAIN__/${domain^^}/g;
            s/__workgroup__/$workgroup/g;
            s/__admin_group__/$admin_group/g" </etc/sssd/sssd.conf.template >/etc/sssd/sssd.conf
        systemctl start sssd

        echo 'Configuring Kerberos service...'
        backup /etc/krb5.conf
        sed -e "s/__domain__/$domain/g;
            s/__DOMAIN__/${domain^^}/g" </etc/krb5.conf.template >/etc/krb5.conf

        echo 'Configuring sudo...'
        backup /etc/sudoers.d/domain
        sed -e "s/__admin_group__/${admin_group// /\\\\ }/g" </etc/sudoers.d/domain.template >/etc/sudoers.d/domain

        echo 'Configuring Samba service...'
        backup /etc/samba/smb.conf
        sed -e "s/__DOMAIN__/${domain^^}/g;
            s/__workgroup__/$workgroup/g" </etc/samba/smb.conf.template >/etc/samba/smb.conf

        echo 'Configuring CUPS service...'
        cupsctl DefaultAuthType=Negotiate
        ;;

    assign)
        read -p 'Host assignee username: ' assignee_user

        echo 'Assigning user...'
        backup /etc/sssd/sssd.conf
        sed -e "s/^simple_allow_users = [^@]\\+@/simple_allow_users = $assignee_user@/" -i /etc/sssd/sssd.conf
        systemctl restart sssd

        backup /etc/polkit-1/rules.d/40-domain.rules
        sed -e "s/unix-user:[^\"]\+/unix-user:$assignee_user/" </etc/polkit-1/rules.d/40-domain.rules.template >/etc/polkit-1/rules.d/40-domain.rules

        echo "Adding $assignee_user to wheel group..."
        usermod --append --groups wheel $assignee_user
        id $assignee_user
        ;;

    *)
        shortusage
        echo -e "\nERROR: unknown command \"$INPUT_CMD\""
        exit 1
    ;;
esac

echo 'Done.'

DOMAINCTL_EOF

chmod ug+x /usr/sbin/domainctl

%end
