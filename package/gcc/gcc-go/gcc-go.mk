################################################################################
#
# gcc-go (host "go" and "gofmt" tools)
#
################################################################################

GCC_GO_VERSION = $(GCC_VERSION)
GCC_GO_SITE = $(GCC_SITE)
GCC_GO_SOURCE = $(GCC_SOURCE)

HOST_GCC_GO_GNU_NAME = native-$(TARGET_VENDOR)-$(TARGET_OS)-unknown
HOST_GCC_GO_STAGING_DIR = $(HOST_DIR)/$(HOST_GCC_GO_GNU_NAME)

HOST_GCC_GO_DL_SUBDIR = gcc

HOST_GCC_GO_EXCLUDES = $(HOST_GCC_EXCLUDES)

HOST_GCC_GO_POST_PATCH_HOOKS += HOST_GCC_APPLY_PATCHES

# gcc doesn't support in-tree build, so we create a 'build'
# subdirectory in the gcc sources, and build from there.
HOST_GCC_GO_SUBDIR = build

HOST_GCC_GO_PRE_CONFIGURE_HOOKS += HOST_GCC_CONFIGURE_SYMLINK

HOST_GCC_GO_CONF_OPTS = \
	--enable-ld=default \
	--enable-languages=go \
	--disable-bootstrap \
	--disable-multilib \
	--disable-decimal-float \
	--with-pkgversion="Buildroot $(BR2_VERSION_FULL)" \
	--with-bugurl="http://bugs.buildroot.net/" \
	--disable-libsanitizer \
	--without-isl --without-cloog \
	--disable-libgomp \
	--without-zstd

ifeq ($(BR2_TOOLCHAIN_GOLD_LINKER),y)
HOST_GCC_GO_CONF_OPTS += --enable-gold
endif

define  HOST_GCC_GO_CONFIGURE_CMDS
	(cd $(HOST_GCC_GO_SRCDIR) && rm -rf config.cache; \
		MAKEINFO=missing \
		./configure \
		--prefix="$(HOST_GCC_GO_STAGING_DIR)" \
		--enable-static \
		$(QUIET) $(HOST_GCC_GO_CONF_OPTS) \
	)
endef

HOST_GCC_GO_INSTALL_OPTS = install-gotools install-target-libgo

# GCC creates both an empty lib directory and a lib32/lib64 directory.
# Rename the lib32/lib64 directory to lib and replace with symlink.
define HOST_GCC_GO_FIXUP_LIBDIR
	if [ -d $(HOST_GCC_GO_STAGING_DIR)/lib32 ] && [ ! -L $(HOST_GCC_GO_STAGING_DIR)/lib32 ]; then \
	  rmdir $(HOST_GCC_GO_STAGING_DIR)/lib; \
	  mv $(HOST_GCC_GO_STAGING_DIR)/lib32 $(HOST_GCC_GO_STAGING_DIR)/lib; \
	  ln -sf lib $(HOST_GCC_GO_STAGING_DIR)/lib32; \
	fi
	if [ -d $(HOST_GCC_GO_STAGING_DIR)/lib64 ] && [ ! -L $(HOST_GCC_GO_STAGING_DIR)/lib64 ]; then \
	  rmdir $(HOST_GCC_GO_STAGING_DIR)/lib; \
	  mv $(HOST_GCC_GO_STAGING_DIR)/lib64 $(HOST_GCC_GO_STAGING_DIR)/lib; \
	  ln -sf lib $(HOST_GCC_GO_STAGING_DIR)/lib64; \
	fi
endef
HOST_GCC_GO_POST_INSTALL_HOOKS += HOST_GCC_GO_FIXUP_LIBDIR

define HOST_GCC_GO_INSTALL_SYMLINKS
	ln -sf ../$(HOST_GCC_GO_GNU_NAME)/bin/go $(HOST_DIR)/bin/
	ln -sf ../$(HOST_GCC_GO_GNU_NAME)/bin/gofmt $(HOST_DIR)/bin/
endef
HOST_GCC_GO_POST_INSTALL_HOOKS += HOST_GCC_GO_INSTALL_SYMLINKS

$(eval $(host-autotools-package))
