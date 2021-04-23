# Fedora Remix

## Purpose

This repository contains the build scripts for a [Fedora Remix][01] that aims
to offer a complete GNU/Linux desktop, fully ready for real-life
home/development/office usage, minimizing the post installation phase that is
still difficult or error prone on most distros.

We have taken care of:

* multimedia support
* font configurations
* tools and software selection
* little desktop tweaks
* Active Directory integration

It's quite easy to toggle features by including or excluding "mixin" files.

You can build a LiveCD and try the software, and then install it in your PC
if you want.

## Why Fedora?

Fedora is a feature-rich operating system which offers a complete suite of
sofware for many purposes. It is flexible enough to get a custom version by
using the installer ([see here for more details][02]). The build process can
be described through Kickstart files and can be modified to get new variants.

### Official kickstarts

You can get the official Fedora kickstarts from:
[https://pagure.io/fedora-kickstarts](https://pagure.io/fedora-kickstarts)

## How to build the LiveCD

A Fedora system matching the target release version is required to build the
images. The build system support using a podman container, so that another
Linux host can be used.

Required dependencies are: `podman`, `qemu-kvm`, `make`. You will need root
privileges for most things.

This usually means:

```
# dnf install podman qemu-kvm make
```

To build, selinux must be set off. This means either disabling at runtime:

```
# setenforce 0
```

Or it might require to (since Fedora 34+) adding a kernel option:

```
enforcing=0
```

GNU `make` is used to control the build process. For example:

Prepare the podman image used to build:

```
# make podman-builder
```

Start clean:

```
# make clean
```

Build the ISO files:

```
# make
```

Test the live system in a virtual machine:

```
# make test
```

Write the result to a USB drive:

```
# make DEVICE=/dev/sdX disk-efi # or "disk-bios" for legacy BIOS mode
```

Clean up the build machine completely:

```
# make clean podman-clean
```

By default podman is used to run the build steps but the make target can also
be run directly:

```
# make USE_PODMAN=no images
```

### Customizing the build

By editing `remix-*.ks` individual customizations can be excluded,
localization can be changed. By default everything is included.

We are happy to accept PRs for additional languages and extra features.

### Useful manual build commands

[See a detailed description][03] of how to build the live media.

To run these, you will also need:

```
# dnf install lorax-lmc-novirt vim-minimal pykickstart livecd-tools
```

In a nutshell, you have to create a single Kickstart file from the base code:

```
# ksflatten --config kickstarts/remix-gnome.ks --output fedora-kickstarts.ks
```

Then you can build the ISO image using the kickstart just obtained:

```
# livemedia-creator --resultdir=results/remix-gnome --make-iso --no-virt \
   --project=Fedora --releasever=31 --ks=fedora-kickstarts.ks
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

### Joining an Active Directory domain

You can join a newly installed host to the domain using the following command:

```
# domainctl join
```

You will be prompted for credential of an administrator.

### Assinging the workstation

You can assign the worksation to an user using the following command:

```
# domainctl assign
```

You will be prompted for a domain username.

## Change Log

All notable changes to this project will be documented in the [`CHANGELOG.md`](CHANGELOG.md) file.

The format is based on [Keep a Changelog][04].

[01]: https://fedoraproject.org/wiki/Remix
[02]: https://en.wikipedia.org/wiki/Anaconda_(installer)
[03]: https://fedoraproject.org/wiki/Livemedia-creator-_How_to_create_and_use_a_Live_CD
[04]: http://keepachangelog.com/
