TARGET := iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = SpringBoard

TWEAK_NAME = Selene

Selene_FILES = Selene.m
Selene_CFLAGS = -fobjc-arc
Selene_PRIVATE_FRAMEWORKS = AppSupport

SUBPROJECTS = SelenePrefs

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
