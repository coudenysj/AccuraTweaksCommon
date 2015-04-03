TARGET = iphone:clang:latest:8.1
ARCHS = arm64 armv7
#enable ARC
ADDITIONAL_OBJCFLAGS = -fobjc-arc
include theos/makefiles/common.mk

LIBRARY_NAME = libatcommon
libatcommon_FILES = $(wildcard *.m) $(wildcard *.mm)
libatcommon_FRAMEWORKS = CoreGraphics UIKit QuartzCore
#libatcommon_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/library.mk
SUBPROJECTS += libatcommonprefs
include $(THEOS_MAKE_PATH)/aggregate.mk

internal-stage::
	mkdir -p $(THEOS)/include/ATCommon
	#rsync -ra *.h $(THEOS_STAGING_DIR)/usr/include/ATCommon //no header distrubition with the cydia package right now
	rsync -ra  *.h $(THEOS)/include/ATCommon/

after-libatcommon-all::
	cp $(THEOS_OBJ_DIR)/libatcommon.dylib $(THEOS)/lib/libatcommon.dylib

after-install::
	install.exec "killall Preferences" || true #prevent compilation failure cuz no process found
