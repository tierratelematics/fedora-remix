FROM fedora:30

RUN dnf install -y lorax-lmc-novirt vim-minimal pykickstart livecd-tools make && dnf clean all

RUN mkdir /spin
WORKDIR /spin

COPY Makefile .
COPY kickstarts kickstarts
ENTRYPOINT [ "make" ]
