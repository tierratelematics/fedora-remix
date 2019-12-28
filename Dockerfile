FROM fedora:31

RUN dnf install -y lorax-lmc-novirt vim-minimal pykickstart livecd-tools make && dnf clean all

RUN mkdir /spin
WORKDIR /spin

ENTRYPOINT [ "make" ]
