FROM fedora:36

RUN dnf install -y lorax-lmc-novirt vim-minimal pykickstart livecd-tools make && dnf clean all
RUN echo '%_install_langs C:en:en_US:en_US.UTF-8:it:it_IT:it_IT.UTF-8:es:es_ES:es_ES.UTF-8' > /etc/rpm/macros.image-language-conf

RUN mv /usr/bin/fallocate /usr/bin/fallocate.real
ADD fallocate_btrfs_workaround.sh /usr/bin/fallocate

RUN mkdir /spin
WORKDIR /spin

ENTRYPOINT [ "make" ]
