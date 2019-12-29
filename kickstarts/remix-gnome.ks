# remix-gnome.ks
#
# Main kickstart for GNOME.

%include fedora-live-workstation.ks
%include remix-base.ks
%include mixins/desktop-gnome.ks

# languages
%include mixins/l10n/it_IT-gnome.ks
# %include mixins/l10n/it_IT-support.ks

%include mixins/l10n/en_US-support.ks

# features
#%include mixins/development-gnome.ks
#%include mixins/domain-gnome.ks
