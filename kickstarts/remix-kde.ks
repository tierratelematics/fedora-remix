# remix-kde.ks
#
# Main kickstart for KDE.

%include kde-desktop.ks
%include remix-base.ks

# languages
%include mixins/l10n/it_IT-kde.ks
# %include mixins/l10n/it_IT-support.ks

%include mixins/l10n/en_US-support.ks

# features
%include mixins/domain-kde.ks
