export TARGET := iphone:clang:latest:latest
INSTALL_TARGET_PROCESSES = SpringBoard

TWEAK_NAME = Arizona

Arizona_FILES = Arizona.m
Arizona_CFLAGS = -fobjc-arc

SUBPROJECTS = ArizonaPrefs

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
