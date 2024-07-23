export TARGET := iphone:clang:16.5:14.0
INSTALL_TARGET_PROCESSES = SpringBoard

TWEAK_NAME = Ren

Ren_FILES = Ren.m
Ren_CFLAGS = -fobjc-arc
Ren_PRIVATE_FRAMEWORKS = ShareSheet

SUBPROJECTS = RenPrefs

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
