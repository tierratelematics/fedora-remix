FLAVOR=remix-gnome
RELEASEVER=31
DEVICE=/dev/null # Override from command line for safety
USE_DOCKER=yes

ODIR=results
BUILDER_IMG=fedora-spin-builder

default: images

docker-builder:
	docker build . -t $(BUILDER_IMG)

docker-clean:
	docker images -f "reference=$(BUILDER_IMG)" -q | xargs docker rmi -f

test: $(ODIR)/$(FLAVOR)/images/boot-efi.iso
	qemu-kvm -m 2560 -cdrom $(ODIR)/$(FLAVOR)/images/boot-efi.iso

ifneq ($(USE_DOCKER), yes)

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

.PHONY: default clean test docker-builder docker-clean images disk-efi disk-bios

else

# If we are running with docker execute any target with the docker builder

%:
	docker run --privileged --cap-add=ALL -v /dev:/dev -v /lib/modules:/lib/modules \
		-v "$(CURDIR):/spin/" -it --rm $(BUILDER_IMG) \
		DEVICE=$(DEVICE) USE_DOCKER=no $@

.PHONY: %

endif
