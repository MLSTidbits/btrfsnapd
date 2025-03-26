#!/bin/env make -f

PACKAGE = btrfs-snapshots-manager
VERSION = $(shell cat VERSION)

MAINTAINER = $(shell git config user.name) <$(shell git config user.email)>

INSTALL = btrfs-progs, bash (>= 4.4), coreutils, systemd
BUILD = debhelper, git-changelog, make (>= 4.1), dpkg-dev, bash (>= 4.4)

HOMEPAGE = https:\/\/github.com\/MichaelSchaecher\/btrfs-snapshots-manager

ARCH = amd64

PACKAGE_DIR = package/$(PACKAGE)_$(VERSION)_$(ARCH)

export PACKAGE_DIR

# Phony targets
.PHONY: all debian clean help

# Default target
all: debian

debian:

	@echo "Building package $(PACKAGE) version $(VERSION)"

	@mkdir -p $(PACKAGE_DIR)
	@cp -a app/* $(PACKAGE_DIR)

	@sed -i "s/Version:/Version: $(VERSION)/" $(PACKAGE_DIR)/DEBIAN/control
	@sed -i "s/Maintainer:/Maintainer: $(MAINTAINER)/" $(PACKAGE_DIR)/DEBIAN/control
	@sed -i "s/Homepage:/Homepage: $(HOMEPAGE)/" $(PACKAGE_DIR)/DEBIAN/control
	@sed -i "s/Architecture:/Architecture: $(ARCH)/" $(PACKAGE_DIR)/DEBIAN/control

	@sed -i "s/Depends:/Depends: $(INSTALL)/" $(PACKAGE_DIR)/DEBIAN/control
	@sed -i "s/Build-Depends:/Build-Depends: $(BUILD)/" $(PACKAGE_DIR)/DEBIAN/control

# For some reason the INSTALL variable is being added to BUILD variable at the beginning of the line
# so we need to remove the that part of the line
	@sed -i "s/Build-Depends: $(BUILD) $(INSTALL)/Build-Depends: $(BUILD)/" $(PACKAGE_DIR)/DEBIAN/control

	@cat ./DESCRIPTION >> $(PACKAGE_DIR)/DEBIAN/control

	@help/size

	@git-changelog $(PACKAGE_DIR)/DEBIAN/changelog
	@git-changelog $(PACKAGE_DIR)/usr/share/doc/$(PACKAGE)/changelog
	@gzip -d $(PACKAGE_DIR)/DEBIAN/changelog.gz

	@dpkg-deb --root-owner-group --build $(PACKAGE_DIR) package/$(PACKAGE)_$(VERSION)_$(ARCH).deb

install:

	@dpkg -i package/$(PACKAGE)_$(VERSION)_$(ARCH).deb

clean:
	@rm -Rvf ./package

help:
	@echo "Usage: make [target] <variables>"
	@echo ""
	@echo "Targets:"
	@echo "  all       - Build the debian package and install it"
	@echo "  debian    - Build the debian package"
	@echo "  install   - Install the debian package"
	@echo "  clean     - Clean up build files"
	@echo "  help      - Display this help message"
	@echo ""
