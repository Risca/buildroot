################################################################################
#
# bb_env
#
################################################################################

BB_ENV_VERSION = 1.0.0
BB_ENV_SITE = $(call github,risca,bb_env,v$(BB_ENV_VERSION))
BB_ENV_DEPENDENCIES = gnutls

define BB_ENV_BUILD_CMDS
	$(TARGET_CC) $(@D)/bb_env.c -o $(@D)/bb_env `$(PKG_CONFIG_HOST_BINARY) --cflags --libs gnutls`
endef

define BB_ENV_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/bb_env $(TARGET_DIR)/usr/sbin/bb_printenv
	ln -sf bb_printenv $(TARGET_DIR)/usr/sbin/bb_setenv
	ln -sf bb_printenv $(TARGET_DIR)/usr/sbin/fw_printenv
	ln -sf bb_printenv $(TARGET_DIR)/usr/sbin/fw_setenv
endef

$(eval $(generic-package))
