# remix-kde.ks
#
# Main kickstart for KDE.

%include kde-desktop.ks
%include remix-base.ks
%include mixins/desktop-kde.ks

# languages
%include mixins/l10n/it_IT-kde.ks
# %include mixins/l10n/it_IT-support.ks

%include mixins/l10n/en_US-support.ks

# features
%include mixins/development-kde.ks
%include mixins/domain-kde.ks
