# fedora-kickstarts

## Purpose

This project is a [Fedora Remix][01] and aims to offer a complete system for
development usage with Active Directory domain support. You can build a LiveCD
and try the software, and then install it in your PC if you want.

## Why Fedora?

Fedora is a feature-rich operating system which offers a complete suite of
sofware for many purposes. It is flexible enough to get a custom version by
using the installer ([see here for more details][02]).  The build process can
be described through Kickstart files and can be modified to get new variants.

### Official kickstarts

You can get the official Fedora kickstarts from:
[https://pagure.io/fedora-kickstarts](https://pagure.io/fedora-kickstarts)

## How to build the LiveCD

A Fedora system matching the target release version is required to build the
images. This is tipically virtualized with docker, so that another Linux host
can be used.

Required dependencies are: docker qemu-kvm make. Your user must be able to run
docker and qemu-kvm.

This usually means:

```
# dnf install docker qemu-kvm make
# gpasswd -a $USER -g docker
# gpasswd -a $USER -g kvm
```

GNU `make` is used to control the build process. For example:

Start clean:

```
$ make clean
```

Build the ISO files:

```
$ make
```

Test the live system in a virtual machine:

```
$ make test
```

Write the result to a USB drive:

```
$ make DEVICE=/dev/sdX disk-efi # or "disk-bios" for legacy BIOS mode
```

Clean up the build machine completely:

```
$ make clean docker-clean
```

By default docker is used to run the build steps but the make target can also
be run directly, but root is probably required:

```
# make USE_DOCKER=no images
```

### Useful manual build commands

[See a detailed description][03] of how to build the live media.

To run these, you will also need:

```
# dnf install lorax-lmc-novirt vim-minimal pykickstart livecd-tools
```

In a nutshell, you have to choose a version (eg: KDE with language support) and
then create a single Kickstart file from the base code:

```
 # ksflatten --config kickstarts/kde-tierra.ks --output fedora-tierra.ks
```

Then you can build the ISO image using the kickstart just obtained:

```
 # livemedia-creator --resultdir=result-kde --make-iso --no-virt \
   --project=Fedora --releasever=30 --ks=fedora-tierra.ks
```

You can create a bootable USB/SD device (legacy BIOS) using the iso image:

```
# livecd-iso-to-disk --format --reset-mbr --msdos result/images/boot.iso /dev/sdX
```

In order to get an EFI bootable media:

```
# cp result/images/boot.iso boot-efi.iso
# cat result/images/efiboot.img >> boot-efi.iso
# livecd-iso-to-disk --format --reset-mbr --efi boot-efi.iso /dev/sdX
```

## Post install tasks

### Joining the domain

You can join a newly installed host to the Tierra domain using the following command:

```
 # tierractl join
```

You will be prompted for credential of an administrator.

### Assinging the workstation

You can assign the worksation to an user using the following command:

```
 # tierractl assign
```

You will be prompted for a domain username.

## Change Log

All notable changes to this project will be documented in the [`CHANGELOG.md`](CHANGELOG.md) file.

The format is based on [Keep a Changelog][04].

[01]: https://fedoraproject.org/wiki/Remix
[02]: https://en.wikipedia.org/wiki/Anaconda_(installer)
[03]: https://fedoraproject.org/wiki/Livemedia-creator-_How_to_create_and_use_a_Live_CD
[04]: http://keepachangelog.com/
