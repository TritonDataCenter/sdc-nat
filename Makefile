#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

#
# Copyright (c) 2019, Joyent, Inc.
# Copyright 2022 MNX Cloud, Inc.
#

NAME:=nat
NPM = npm

ENGBLD_USE_BUILDIMAGE	= true
ENGBLD_REQUIRE		:= $(shell git submodule update --init deps/eng)
include ./deps/eng/tools/mk/Makefile.defs
TOP ?= $(error Unable to access eng.git submodule Makefiles.)

BUILD_PLATFORM  = 20210826T002459Z

RELEASE_TARBALL:=$(NAME)-pkg-$(STAMP).tar.gz
RELSTAGEDIR:=/tmp/$(NAME)-$(STAMP)

# triton-origin-x86_64-21.4.0
BASE_IMAGE_UUID = 502eeef2-8267-489f-b19c-a206906f57ef
BUILDIMAGE_NAME = $(NAME)
BUILDIMAGE_DESC	= Triton per-user NAT zone

#
# Targets
#
.PHONY: all
all: $(SMF_MANIFESTS) | sdc-scripts

sdc-scripts: deps/sdc-scripts/.git

.PHONY: test
test:
	true

.PHONY: git-hooks
git-hooks:
	[[ -e .git/hooks/pre-commit ]] || ln -s ../../tools/pre-commit.sh .git/hooks/pre-commit


#
# Packaging targets
#

.PHONY: release
release: all
	@echo "Building $(RELEASE_TARBALL)"
	# boot
	mkdir -p $(RELSTAGEDIR)/root/opt/smartdc/boot
	cp -R $(TOP)/deps/sdc-scripts/* $(RELSTAGEDIR)/root/opt/smartdc/boot/
	cp -R $(TOP)/boot/* $(RELSTAGEDIR)/root/opt/smartdc/boot/
	mkdir -p $(RELSTAGEDIR)/root/opt/smartdc/$(NAME)/
	# other bits
	cp -r \
		$(TOP)/package.json \
		$(TOP)/bin \
		$(RELSTAGEDIR)/root/opt/smartdc/$(NAME)
	# Tar
	(cd $(RELSTAGEDIR) && $(TAR) -I pigz -cf $(TOP)/$(RELEASE_TARBALL) root)
	@rm -rf $(RELSTAGEDIR)

.PHONY: publish
publish: release
	mkdir -p $(ENGBLD_BITS_DIR)/$(NAME)
	cp $(TOP)/$(RELEASE_TARBALL) $(ENGBLD_BITS_DIR)/$(NAME)/$(RELEASE_TARBALL)


include ./deps/eng/tools/mk/Makefile.deps
include ./deps/eng/tools/mk/Makefile.targ
