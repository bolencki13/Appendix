GO_EASY_ON_ME = 1
export THEOS_BUILD_DIR = deb
ARCHS = armv7 arm64
TARGET_CFLAGS = -fobjc-arc
SDKVERSION = 9.2

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = apdSettings
apdSettings_FILES = apdSettings.mm
apdSettings_INSTALL_PATH = /Library/PreferenceBundles
apdSettings_FRAMEWORKS = UIKit
apdSettings_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/apdSettings.plist$(ECHO_END)
