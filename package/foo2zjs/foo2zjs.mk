################################################################################
#
# foo2zjs
#
################################################################################

FOO2ZJS_VERSION = e04290de6b7a30d588f3411fd9834618e09f7b9b
FOO2ZJS_SITE = $(call github,koenkooi,foo2zjs,$(FOO2ZJS_VERSION))
FOO2ZJS_LICENSE = GPL-2.0-or-later, PROPRIETARY (firmware)
FOO2ZJS_LICENSE_FILES = COPYING
FOO2ZJS_DEPENDENCIES = cups
#FOO2ZJS_DEPENDENCIES = host-cups-filter

define FOO2ZJS_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define FOO2ZJS_INSTALL_TARGET_CMDS
	$(MAKE1) DESTDIR="$(TARGET_DIR)" -C $(@D) install
	$(INSTALL) -m 644 -D $(@D)/hplj10xx.rules $(TARGET_DIR)/etc/udev/rules.d/11-hplj10xx.rules
	$(INSTALL) -m 755 -D -t $(TARGET_DIR)/etc/hotplug/usb/ $(@D)/hplj1000
	ln -sf hplj1000 $(TARGET_DIR)/etc/hotplug/usb/hplj1005
	ln -sf hplj1000 $(TARGET_DIR)/etc/hotplug/usb/hplj1018
	ln -sf hplj1000 $(TARGET_DIR)/etc/hotplug/usb/hplj1020
	ln -sf hplj1000 $(TARGET_DIR)/etc/hotplug/usb/hpljP1005
	ln -sf hplj1000 $(TARGET_DIR)/etc/hotplug/usb/hpljP1006
	ln -sf hplj1000 $(TARGET_DIR)/etc/hotplug/usb/hpljP1007
	ln -sf hplj1000 $(TARGET_DIR)/etc/hotplug/usb/hpljP1008
	ln -sf hplj1000 $(TARGET_DIR)/etc/hotplug/usb/hpljP1505
        $(INSTALL) -m 644 $(FOO2ZJS_PKGDIR)/foo2zjs.usermap $(TARGET_DIR)/etc/hotplug/usb/
endef

$(eval $(generic-package))
