GO_EASY_ON_ME = 1
export THEOS_BUILD_DIR = deb
ARCHS = armv7 arm64
TARGET_CFLAGS = -fobjc-arc
SDKVERSION = 9.2

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Appendix
Appendix_FILES = Tweak.xm
Appendix_FRAMEWORKS = UIKit CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += apdsettings
include $(THEOS_MAKE_PATH)/aggregate.mk
