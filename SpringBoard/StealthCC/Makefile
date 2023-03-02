export TARGET := iphone:clang:latest:latest
INSTALL_TARGET_PROCESSES = SpringBoard

TWEAK_NAME = StealthCC

StealthCC_FILES = Tweak.m
StealthCC_CFLAGS = -fobjc-arc

SUBPROJECTS = StealthCCPrefs

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
