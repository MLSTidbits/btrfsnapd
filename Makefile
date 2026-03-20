.PHONY: all clean install _pandoc _out

APPLICATION = $(basename $(shell pwd))
VERSION = $(shell cat doc/version)

BUILD_DIR = _build
SOURCE_DIR = src
DOC_DIR = doc
MAN_DIR = man

all: _pandoc _out

_pandoc:
	@echo "Building manual page..."
	@mkdir -p $(BUILD_DIR)/$(MAN_DIR)
	@if ! command -v pandoc ; then \
		echo 'pandoc could not be found. Please install pandoc to build the manual page.'; \
		exit 1; \
	fi

	@for manpage in $(MAN_DIR)/*.md; do \
		output=$(BUILD_DIR)/$(MAN_DIR)/$$(basename "$${manpage%.md}"); \
		echo "Converting $$manpage to $$output..."; \
		pandoc -s -t man -o "$$output" "$$manpage"; \
	done

#	pandoc -s -t man -o $(BUILD_DIR)/$(MAN_DIR)/$(APPLICATION).1 $(MAN_DIR)/$(APPLICATION).1.md


_out:
	mkdir -p $(BUILD_DIR)/doc \

	@cp -rv $(SOURCE_DIR)/* $(BUILD_DIR)/

	@cp -v $(DOC_DIR)/version $(DOC_DIR)/copyright README.md CONTRIBUTING.md CODE_OF_CONDUCT.md \
		$(BUILD_DIR)/$(DOC_DIR)/

clean:
	rm -rvf $(BUILD_DIR)

install:
	@install -Dm755 $(SOURCE_DIR)/$(APPLICATION) /usr/bin/$(APPLICATION)

# Install the /etc configuration file if it doesn't exist
	@if [ ! -f /etc/default/grub_btrfsd ] && [ ! -f /etc/grub.d/41_grub_btrfsd ]; then \
		echo "Installing default configuration file"; \
		install -Dm644 $(SOURCE_DIR)/conf/grub_btrfsd /etc/default/grub_btrfsd; \
		install -Dm644 $(SOURCE_DIR)/conf/41_grub_btrfsd /etc/grub.d/41_grub_btrfsd; \
	fi

	@install -Dm644 $(BUILD_DIR)/$(MAN_DIR)/$(APPLICATION).1 /usr/share/man/man1/$(APPLICATION).8
	@gzip -9 /usr/share/man/man1/$(APPLICATION).8

	@install -Dm644 $(BUILD_DIR)/$(MAN_DIR)/$(APPLICATION).conf.5 /usr/share/man/man5/$(APPLICATION).conf.5
	@gzip -9 /usr/share/man/man5/$(APPLICATION).conf.5

	@install -Dm644 $(DOC_DIR)/version $(DOC_DIR)/copyright README.md CONTRIBUTING.md CODE_OF_CONDUCT.md \
		/usr/share/doc/$(APPLICATION)/

	@install -Dm644 $(BUILD_DIR)/conf/$(APPLICATION).conf /etc/
	@install -Dm644 $(BUILD_DIR)/conf/50$(APPLICATION) /etc/apt/preferences.d/
