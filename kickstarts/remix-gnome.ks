# remix-gnome.ks
#
# Main kickstart for GNOME.

%include fedora-live-workstation.ks
%include mixins/desktop-gnome.ks

# main localization
%include mixins/l10n/it_IT-gnome.ks
# %include mixins/l10n/es_ES-gnome.ks

# other supported languages
%include mixins/l10n/en_US-support.ks
# %include mixins/l10n/it_IT-support.ks
# %include mixins/l10n/es_ES-support.ks

# features
%include mixins/nonfree.ks
%include mixins/printing.ks

%include mixins/development-gnome.ks
%include mixins/domain-gnome.ks
%include mixins/teams.ks
%include mixins/vpn.ks
