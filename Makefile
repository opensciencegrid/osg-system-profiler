# Makefile for osg-system-profiler


# ------------------------------------------------------------------------------
# Release information: Update for each release
# ------------------------------------------------------------------------------

PACKAGE := osg-system-profiler
VERSION := 1.4.0


# ------------------------------------------------------------------------------
# Other configuration: May need to change for a release
# ------------------------------------------------------------------------------

BIN_DIR := usr/bin
BIN_FILES := osg-system-profiler osg-system-profiler-viewer \
	     osg-installed-versions
LIBEXEC_DIR := usr/libexec/$(PACKAGE)
LIBEXEC_FILES := gratia-pbs-lsf-config-check

DIST_FILES := $(BIN_FILES) $(LIBEXEC_FILES) Makefile


# ------------------------------------------------------------------------------
# Internal variables: Do not change for a release
# ------------------------------------------------------------------------------

DIST_DIR_PREFIX := dist_dir_
TARBALL_DIR := $(PACKAGE)-$(VERSION)
TARBALL_NAME := $(PACKAGE)-$(VERSION).tar.gz
UPSTREAM := /p/vdt/public/html/upstream
UPSTREAM_DIR := $(UPSTREAM)/$(PACKAGE)/$(VERSION)


# ------------------------------------------------------------------------------

.PHONY: _default distclean install dist upstream

_default:
	@echo "There is no default target; choose one of the following:"
	@echo "make install [DESTDIR=path]   -- install files to path"
	@echo "make dist                     -- make a distribution source tarball"
	@echo "make upstream [UPSTREAM=path] -- install source tarball to upstream cache rooted at path"


distclean:
	rm -f *.tar.gz
ifneq ($(strip $(DIST_DIR_PREFIX)),) # avoid evil
	rm -fr $(DIST_DIR_PREFIX)*
endif

install:
	mkdir -p $(DESTDIR)/$(BIN_DIR)
	install -p -m 0755 $(BIN_FILES) $(DESTDIR)/$(BIN_DIR)
	mkdir -p $(DESTDIR)/$(LIBEXEC_DIR)
	install -p -m 0755 $(LIBEXEC_FILES) $(DESTDIR)/$(LIBEXEC_DIR)


dist: $(TARBALL_NAME)
$(TARBALL_NAME): $(DIST_FILES)
	$(eval TEMP_DIR := $(shell mktemp -d -p . $(DIST_DIR_PREFIX)XXXXXXXXXX))
	mkdir -p $(TEMP_DIR)/$(TARBALL_DIR)
	cp -p $(DIST_FILES) $(TEMP_DIR)/$(TARBALL_DIR)/
	tar czf $(TARBALL_NAME) -C $(TEMP_DIR) $(TARBALL_DIR)
	rm -rf $(TEMP_DIR)


upstream: $(TARBALL_NAME)
ifeq ($(shell ls -1d $(UPSTREAM) 2>/dev/null),)
	@echo "Must have existing upstream cache directory at '$(UPSTREAM)'"
else ifneq ($(shell ls -1 $(UPSTREAM_DIR)/$(TARBALL_NAME) 2>/dev/null),)
	@echo "Source tarball already installed at '$(UPSTREAM_DIR)/$(TARBALL_NAME)'"
	@echo "Remove installed source tarball or increment release version"
else
	mkdir -p $(UPSTREAM_DIR)
	install -p -m 0644 $(TARBALL_NAME) $(UPSTREAM_DIR)/$(TARBALL_NAME)
endif
