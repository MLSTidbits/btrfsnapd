#!/bin/env make -f

PACKAGE = btrfs-snapshot
VERSION = $(shell bash scripts/set-version)

MAINTAINER = $(shell git config user.name) <$(shell git config user.email)>

INSTALL = btrfs-progs, bash (>= 4.4), coreutils, systemd
CONFLICTS = timeshift

BUILD = debhelper, git-changelog, make (>= 4.1), dpkg-dev, bash (>= 4.4)

HOMEPAGE = https://github.com/MichaelSchaecher/$(PACKAGE)

ARCH = amd64

WORKING_DIR = $(shell pwd)

PACKAGE_DIR = package

export PACKAGE VERSION MAINTAINER INSTALL CONFLICTS BUILD HOMEPAGE ARCH WORKING_DIR PACKAGE_DIR

# Phony targets
.PHONY: all debian clean help

# Default target
all: debian

debian:

	@echo "Building package $(PACKAGE) version $(VERSION)"

	@scripts/set-control
	@scripts/sum

	@dpkg-changelog $(PACKAGE_DIR)/DEBIAN/changelog
	@dpkg-changelog $(PACKAGE_DIR)/usr/share/doc/$(PACKAGE)/changelog
	@gzip -d $(PACKAGE_DIR)/DEBIAN/changelog.DEBIAN.gz
	@mv -vf $(PACKAGE_DIR)/DEBIAN/changelog.DEBIAN $(PACKAGE_DIR)/DEBIAN/changelog

	@scripts/mkdeb

install:

	@cp -av $(PACKAGE_DIR)/etc /
	@cp -av $(PACKAGE_DIR)/usr /

clean:
	@rm -vf $(PACKAGE_DIR)/DEBIAN/control \
		$(PACKAGE_DIR)/DEBIAN/changelog \
		$(PACKAGE_DIR)/DEBIAN/md5sums \
		$(PACKAGE_DIR)/usr/share/doc/$(PACKAGE)/*.gz \


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
