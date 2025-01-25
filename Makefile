#!/bin/env make -f

APP_NAME = btrfs-snapshots-manager
VERSION = $(shell cat VERSION)

DESCRIPTION = Dynamic DNS client

MAINTAINER = $(shell git config user.name) <$(shell git config user.email)>

# Set priority of the package for deb package manager
# optional, low, standard, important, required
PRIORITY = optional

# dpkg Section option
SECTION = utils

# Architecture (amd64, i386, armhf, arm64, ... all)
AARCH = all

export APP_NAME VERSION DESCRIPTION APP_DEP AARCH PRIORITY SECTION MAINTAINER

ROOT_DIR = $(shell pwd)

export ROOT_DIR

# Source path
SOURCE_PATH = src

# Build path
BUILD_PATH = build/$(APP_NAME)-$(VERSION)

BUILD_BIN = $(BUILD_PATH)/usr/bin
BUILD_DOC = $(BUILD_PATH)/usr/share/doc/$(APP_NAME)
BUILD_MAN = $(BUILD_PATH)/usr/share/man/man8
BUILD_COMPLETION = $(BUILD_PATH)/usr/share/bash-completion/completions
BUILD_CHANGELOG = $(BUILD_DOC)/changelog.DEBIAN

export BUILD_PATH BUILD_DOC BUILD_CHANGELOG

# Install path
INSTALL_PATH = /usr


# Phony targets
.PHONY: install clean build

# Default target
all: build install

debian:
	make build

	@echo "Building debian package"

	@mkdir -pv $(BUILD_PATH)/DEBIAN

	@cp -vf src/debian/* $(BUILD_PATH)/DEBIAN/

	@chmod 755 $(BUILD_PATH)/DEBIAN/postinst $(BUILD_PATH)/DEBIAN/prerm

	@sed -i "s/Version:/Version: $(VERSION)/" $(BUILD_PATH)/DEBIAN/control

	@sed -i "s/Maintainer:/Maintainer: $(MAINTAINER)/" $(BUILD_PATH)/DEBIAN/control

	@git-changelog $(BUILD_CHANGELOG)
	@gzip -d $(BUILD_CHANGELOG) && mv $(BUILD_CHANGELOG) $(BUILD_PATH)/DEBIAN/changelog

	@dpkg-deb --root-owner-group --build $(BUILD_PATH) build/$(APP_NAME)_$(VERSION)_all.deb

# Install the bash script
build:

	@echo "Building $(APP_NAME) $(VERSION)"
	@mkdir -pv $(BUILD_BIN) $(BUILD_DOC)

	@cp -vf $(SOURCE_PATH)/$(APP_NAME) $(BUILD_BIN)/$(APP_NAME)
	@cp -vf ./VERSION $(BUILD_DOC)/version
	@cp -vf ./COPYING $(BUILD_DOC)/copyright

# Set the permissions
	@chmod 755 $(BUILD_BIN)/$(APP_NAME)
	@chmod 644 $(BUILD_DOC)/*

install:

	@cp -rvf $(BUILD_PATH)/* /

uninstall:
	@rm -vf $(INSTALL_PATH)/bin/$(APP_NAME) \
		$(INSTALL_PATH)/share/doc/$(APP_NAME)/* \
		$(INSTALL_PATH)/share/man/man8/$(APP_NAME).8.gz \
		$(INSTALL_PATH)/share/bash-completion/completions/$(APP_NAME)

clean:
	@rm -Rvf ./build

help:
	@echo "Usage: make [target] <variables>"
	@echo ""
	@echo "Targets:"
	@echo "  all       - Build and install the ddns application"
	@echo "  build     - Build the ddns application"
	@echo "  install   - Install the ddns application"
	@echo "  uninstall - Uninstall the ddns application"
	@echo "  clean     - Clean up build files"
	@echo "  help      - Display this help message"
	@echo ""
