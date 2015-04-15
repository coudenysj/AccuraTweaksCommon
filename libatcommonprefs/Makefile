TARGET = iphone:clang:latest:8.1
ARCHS = arm64 armv7
#enable ARC
ADDITIONAL_OBJCFLAGS = -fobjc-arc
include theos/makefiles/common.mk

LIBRARY_NAME = libatcommonprefs
libatcommonprefs_FILES = $(wildcard *.m) $(wildcard *.mm)
libatcommonprefs_FRAMEWORKS = CoreGraphics UIKit QuartzCore
libatcommonprefs_PRIVATE_FRAMEWORKS = Preferences
libatcommonprefs_LIBRARIES = atcommon

include $(THEOS_MAKE_PATH)/library.mk

internal-stage::
	mkdir -p $(THEOS)/include/ATCommonPrefs
	#rsync -ra *.h $(THEOS_STAGING_DIR)/usr/include/ATCommonPrefs //no header distrubition with the cydia package right now
	rsync -ra *.h $(THEOS)/include/ATCommonPrefs/

after-libatcommonprefs-all::
	cp $(THEOS_OBJ_DIR)/libatcommonprefs.dylib $(THEOS)/lib/libatcommonprefs.dylib

after-install::
	install.exec "killall Preferences" || true #prevent compilation failure cuz no process found
