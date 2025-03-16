#!/bin/env make -f

APP_NAME = btrfs-snapshots-manager
VERSION = $(shell cat VERSION)

DESCRIPTION = "Btrfs snapshots manager"

MAINTAINER = $(shell git config user.name) <$(shell git config user.email)>

# Set priority of the package for deb package manager
# optional, low, standard, important, required
PRIORITY = optional

# dpkg Section option
SECTION = utils

# Architecture (amd64, i386, armhf, arm64, ... all)
AARCH = all

ROOT_DIR = $(shell pwd)

# Source path
SOURCE_PATH = src

# Build path
BUILD_PATH = build/$(APP_NAME)-$(VERSION)

BUILD_ETC = $(BUILD_PATH)/etc
BUILD_BIN = $(BUILD_PATH)/usr/bin
BUILD_DOC = $(BUILD_PATH)/usr/share/doc/$(APP_NAME)
BUILD_SYSTEMD = $(BUILD_PATH)/usr/lib/systemd/system
BUILD_CHANGELOG = $(BUILD_DOC)/changelog.DEBIAN

export BUILD_PATH BUILD_DOC BUILD_CHANGELOG

# Phony targets
.PHONY: install clean build

# Default target
all: build install

debian:
	make build

	@echo "Building debian package"

	@mkdir -pv $(BUILD_PATH)/DEBIAN
	@cp -vf src/debian/* $(BUILD_PATH)/DEBIAN/

# Set the permissions for prerm script
	@chmod 755 $(BUILD_PATH)/DEBIAN/postinst $(BUILD_PATH)/DEBIAN/prerm

# Define control file
	@sed -i "s/Version:/Version: $(VERSION)/" $(BUILD_PATH)/DEBIAN/control
	@sed -i "s/Maintainer:/Maintainer: $(MAINTAINER)/" $(BUILD_PATH)/DEBIAN/control
	@sed -i "s/Architecture:/Architecture: $(AARCH)/" $(BUILD_PATH)/DEBIAN/control

# Debian changelog
	@git-changelog $(BUILD_CHANGELOG)
	@git-changelog $(BUILD_PATH)/DEBIAN/changelog
	@gzip -d $(BUILD_PATH)/DEBIAN/changelog.gz

# Build the package
	@dpkg-deb --root-owner-group --build $(BUILD_PATH) build/$(APP_NAME)_$(VERSION)_all.deb

# Install the bash script
build:

	@echo "Building $(APP_NAME) $(VERSION)"
	@mkdir -pv $(BUILD_BIN) $(BUILD_DOC) $(BUILD_ETC)/apt/apt.conf.d $(BUILD_SYSTEMD)

	@cp -vf $(SOURCE_PATH)/$(APP_NAME) $(BUILD_BIN)/$(APP_NAME)
	@cp -vf ./VERSION $(BUILD_DOC)/version
	@cp -vf ./COPYING $(BUILD_DOC)/copyright
	@cp -vf $(SOURCE_PATH)/$(APP_NAME).conf $(BUILD_ETC)/$(APP_NAME).conf
	@cp -vf $(SOURCE_PATH)/$(APP_NAME).service $(BUILD_SYSTEMD)/$(APP_NAME).service
	@cp -vf $(SOURCE_PATH)/$(APP_NAME).timer $(BUILD_SYSTEMD)/$(APP_NAME).timer
	@cp -vf $(SOURCE_PATH)/50_$(APP_NAME) $(BUILD_ETC)/apt/apt.conf.d/50_$(APP_NAME)

# Set the permissions
	@chmod 755 $(BUILD_BIN)/$(APP_NAME)
	@chmod 644 $(BUILD_DOC)/*

install:

	@cp -rvf $(BUILD_PATH)/* /

uninstall:
	@rm -vf /usr/bin/$(APP_NAME) \
		/usr/share/doc/$(APP_NAME) \
		/usr/lib/systemd/system/$(APP_NAME).* \
		/etc/$(APP_NAME).conf \

clean:
	@rm -Rvf ./build

help:
	@echo "Usage: make [target] <variables>"
	@echo ""
	@echo "Targets:"
	@echo "  all       - Build and install the btrfs-snapshots-manager application"
	@echo "  build     - Build the btrfs-snapshots-manager application"
	@echo "  install   - Install the btrfs-snapshots-manager application"
	@echo "  uninstall - Uninstall the btrfs-snapshots-manager application"
	@echo "  clean     - Clean up build files"
	@echo "  help      - Display this help message"
	@echo ""
