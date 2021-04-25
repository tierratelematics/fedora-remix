FLAVOR=remix-gnome
RELEASEVER=34
DEVICE=/dev/null # Override from command line for safety
USE_PODMAN=yes

ODIR=results
BUILDER_IMG=fedora-spin-builder

default: images

podman-builder:
	podman build . -t $(BUILDER_IMG)

podman-clean:
	podman images -f "reference=$(BUILDER_IMG)" -q | xargs podman rmi -f

podman-kill-builder:
	podman rm -f fedora-remix-builder

test: $(ODIR)/$(FLAVOR)/images/boot-efi.iso
	qemu-kvm -m 2560 -cdrom $(ODIR)/$(FLAVOR)/images/boot-efi.iso

ifneq ($(USE_PODMAN), yes)

images: $(ODIR)/$(FLAVOR)/images/boot-efi.iso $(ODIR)/$(FLAVOR)/images/boot.iso

$(ODIR)/$(FLAVOR)/images/boot-efi.iso: $(ODIR)/$(FLAVOR)/images/boot.iso
	cat $(ODIR)/$(FLAVOR)/images/boot.iso $(ODIR)/$(FLAVOR)/images/efiboot.img > $(ODIR)/$(FLAVOR)/images/boot-efi.iso

$(ODIR)/$(FLAVOR)/images/boot.iso: $(ODIR)/$(FLAVOR)-flattened.ks
	cd $(ODIR); livemedia-creator --resultdir=$(FLAVOR) --make-iso --no-virt --project=Fedora --releasever=$(RELEASEVER) --ks=$(FLAVOR)-flattened.ks

$(ODIR)/$(FLAVOR)-flattened.ks: $(wildcard kickstarts/*.ks) | ${ODIR}
	ksflatten --config kickstarts/$(FLAVOR).ks --output $(ODIR)/$(FLAVOR)-flattened.ks

$(ODIR):
	mkdir -p $(ODIR)

clean:
	rm -fr $(ODIR)/*

disk-efi: $(ODIR)/$(FLAVOR)/images/boot-efi.iso
	livecd-iso-to-disk --format --reset-mbr --efi $(ODIR)/$(FLAVOR)/images/boot-efi.iso $(DEVICE)

disk-bios: $(ODIR)/$(FLAVOR)/images/boot.iso
	livecd-iso-to-disk --format --reset-mbr --msdos $(ODIR)/$(FLAVOR)/images/boot.iso $(DEVICE)

.PHONY: default clean test podman-builder podman-clean podman-kill-builder images disk-efi disk-bios

else

# If we are running with podman execute any target with the podman builder

%:
	podman run --privileged -v /dev:/dev \
		-v "$(CURDIR):/spin/" -it --rm --name fedora-remix-builder $(BUILDER_IMG) \
		DEVICE=$(DEVICE) USE_PODMAN=no $@

.PHONY: %

endif
