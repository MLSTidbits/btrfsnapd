.PHONY: all clean install _build/*

APPLICATION = $(shell basename $(shell pwd))
VERSION = $(shell cat doc/version)

BUILD_DIR = _build
SOURCE_DIR = src
DOC_DIR = doc
MAN_DIR = man

SOURCE_FILES = $(SOURCE_DIR)/$(APPLICATION) \
	$(SOURCE_DIR)/conf/$(APPLICATION).conf \
	$(SOURCE_DIR)/completion/$(APPLICATION)

DOC_FILES = $(DOC_DIR)/version \
	$(DOC_DIR)/copyright \
	README.md \
	CONTRIBUTING.md \
	CODE_OF_CONDUCT.md

all: _build/man _build/docs _build/src

_build/man:
	@mkdir -p $(BUILD_DIR)/$(MAN_DIR)
	@if ! command -v pandoc ; then \
		echo 'pandoc could not be found. Please install pandoc to build the manual page.'; \
		exit 1; \
	fi

	@for manpage in $(MAN_DIR)/*.md; do \
		output=$(BUILD_DIR)/$(MAN_DIR)/$$(basename "$${manpage%.md}"); \
		echo "\e[1;34mCV:\e[0m $$output"; \
		pandoc -s -t man -o "$$output" "$$manpage"; \
	done

_build/docs:
	@mkdir -p $(BUILD_DIR)/doc \

	@for f in $(DOC_FILES) ; do \
		output="$(BUILD_DIR)/doc/$$(basename "$$f")"; \
		echo "\e[1;34mCP:\e[0m $$output"; \
		install -Dm644 "$$f" "$$output"; \
	done

_build/src:
	@mkdir -p $(BUILD_DIR)/src

	@for srcfile in $(SOURCE_FILES); do \
		output=$(BUILD_DIR)/$(basename "$$srcfile"); \
		echo "\e[1;34mCP:\e[0m $$output"; \
		install -Dm755 "$$srcfile" "$$output"; \
	done

clean:
	@rm -rvf $(BUILD_DIR)

install:
# To install the application the user must have root privileges, so we use sudo to ensure the correct permissions
	@[ "$$(id -u)" -ne 0 ] && echo "Please run 'sudo make install' to install $(APPLICATION)." && exit 1

	@install -Dm755 $(SOURCE_DIR)/$(APPLICATION) /usr/bin/$(APPLICATION)

# Install the /etc configuration file if it doesn't exist
	@if [ ! -f /etc/default/grub_btrfsd ] && [ ! -f /etc/grub.d/41_grub_btrfsd ]; then \
		install -Dvm644 $(SOURCE_DIR)/conf/grub_btrfsd /etc/default/grub_btrfsd; \
		install -Dvm644 $(SOURCE_DIR)/conf/41_grub_btrfsd /etc/grub.d/41_grub_btrfsd; \
	fi

	for man in $(BUILD_DIR)/$(MAN_DIR)/$(APPLICATION).1 $(BUILD_DIR)/$(MAN_DIR)/$(APPLICATION).conf.5; do \
		if [ "$$man" == "$(BUILD_DIR)/$(MAN_DIR)/$(APPLICATION).1" ]; then \
			target="/usr/share/man/man8/$(APPLICATION).8"; \
		elif [ "$$man" == "$(BUILD_DIR)/$(MAN_DIR)/$(APPLICATION).conf.5" ]; then \
			target="/usr/share/man/man5/$(APPLICATION).conf.5"; \
		fi
		echo "\e[1;34mINSTALL:\e[0m $$target"; \
		install -Dvm644 "$$man" "$$target"; \
		gzip -9 "$$target"; \
	done

	@install -Dvm644 $(BUILD_DIR)/doc/* /usr/share/doc/$(APPLICATION)/

	@install -Dvm644 $(BUILD_DIR)/conf/$(APPLICATION).conf /etc/
	@install -Dvm644 $(BUILD_DIR)/conf/50$(APPLICATION) /etc/apt/preferences.d/
