################################################################################
#
# mender
#
################################################################################

MENDER_VERSION = 2.3.0
MENDER_SITE = https://github.com/mendersoftware/mender/archive
MENDER_SOURCE = $(MENDER_VERSION).tar.gz
MENDER_LICENSE = Apache-2.0, BSD-2-Clause, BSD-3-Clause, ISC, MIT, OLDAP-2.8

# Vendor license paths generated with:
#    awk '{print $2}' LIC_FILES_CHKSUM.sha256 | grep vendor
MENDER_LICENSE_FILES = \
	LICENSE \
	LIC_FILES_CHKSUM.sha256 \
	vendor/github.com/mendersoftware/mendertesting/LICENSE \
	vendor/github.com/mendersoftware/mender-artifact/LICENSE \
	vendor/github.com/pkg/errors/LICENSE \
	vendor/github.com/pmezard/go-difflib/LICENSE \
	vendor/golang.org/x/crypto/LICENSE \
	vendor/golang.org/x/sys/LICENSE \
	vendor/golang.org/x/net/LICENSE \
	vendor/github.com/bmatsuo/lmdb-go/LICENSE.md \
	vendor/golang.org/x/text/LICENSE \
	vendor/github.com/remyoudompheng/go-liblzma/LICENSE \
	vendor/github.com/davecgh/go-spew/LICENSE \
	vendor/github.com/sirupsen/logrus/LICENSE \
	vendor/github.com/stretchr/testify/LICENSE \
	vendor/github.com/stretchr/testify/LICENCE.txt \
	vendor/github.com/stretchr/objx/LICENSE.md \
	vendor/github.com/ungerik/go-sysfs/LICENSE \
	vendor/github.com/urfave/cli/LICENSE \
	vendor/github.com/bmatsuo/lmdb-go/LICENSE.mdb.md

MENDER_DEPENDENCIES = xz

MENDER_SUBDIR = src/github.com/mendersoftware/mender

define MENDER_EXTRACT_CMDS
	mkdir -p $(@D)/$(MENDER_SUBDIR)
	$(ZCAT) $(MENDER_DL_DIR)/$(MENDER_SOURCE) | \
	$(TAR) --strip-components=$(MENDER_STRIP_COMPONENTS) \
		-C $(@D)/$(MENDER_SUBDIR) \
		$(TAR_OPTIONS) -
	$(SED) "s/Version string$$/Version string = \"$(MENDER_VERSION)\"/" \
		$(@D)/$(MENDER_SUBDIR)/conf/version.go
endef

MENDER_UPDATE_MODULES_FILES = \
	directory \
	script \
	single-file \
	$(if $(BR2_PACKAGE_DOCKER_CLI),docker) \
	$(if $(BR2_PACKAGE_RPM),rpm)

define MENDER_INSTALL_CONFIG_FILES
	$(INSTALL) -d -m 755 $(TARGET_DIR)/etc/mender/scripts
	echo -n "3" > $(TARGET_DIR)/etc/mender/scripts/version

	$(INSTALL) -D -m 0644 $(MENDER_PKGDIR)/mender.conf \
		$(TARGET_DIR)/etc/mender/mender.conf
	$(INSTALL) -D -m 0644 $(MENDER_PKGDIR)/server.crt \
		$(TARGET_DIR)/etc/mender/server.crt

	$(INSTALL) -D -m 0755 $(@D)/$(MENDER_SUBDIR)/support/mender-device-identity \
		$(TARGET_DIR)/usr/share/mender/identity/mender-device-identity
	$(foreach f,hostinfo network os rootfs-type, \
		$(INSTALL) -D -m 0755 $(@D)/$(MENDER_SUBDIR)/support/mender-inventory-$(f) \
			$(TARGET_DIR)/usr/share/mender/inventory/mender-inventory-$(f)
	)

	$(INSTALL) -D -m 0755 $(MENDER_PKGDIR)/artifact_info \
			$(TARGET_DIR)/etc/mender/artifact_info

	$(INSTALL) -D -m 0755 $(MENDER_PKGDIR)/device_type \
			$(TARGET_DIR)/etc/mender/device_type

	mkdir -p $(TARGET_DIR)/var/lib
	ln -snf /var/run/mender $(TARGET_DIR)/var/lib/mender
	$(foreach f,$(MENDER_UPDATE_MODULES_FILES), \
		$(INSTALL) -D -m 0755 $(@D)/$(MENDER_SUBDIR)/support/modules/$(notdir $(f)) \
			$(TARGET_DIR)/usr/share/mender/modules/v3/$(notdir $(f))
	)
endef

MENDER_POST_INSTALL_TARGET_HOOKS += MENDER_INSTALL_CONFIG_FILES

define MENDER_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 $(MENDER_PKGDIR)/mender-client.service \
		$(TARGET_DIR)/usr/lib/systemd/system/mender-client.service
endef

define MENDER_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 $(MENDER_PKGDIR)/S42mender \
		$(TARGET_DIR)/etc/init.d/S42mender
endef

$(eval $(golang-package))
