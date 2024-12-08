export TARGET := iphone:clang:16.5:14.0
INSTALL_TARGET_PROCESSES = SpringBoard

TWEAK_NAME = AutoRespring

AutoRespring_FILES = Tweak.m
AutoRespring_CFLAGS = -fobjc-arc

SUBPROJECTS = Prefs

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
