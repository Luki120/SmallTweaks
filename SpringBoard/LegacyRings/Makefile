TARGET := iphone:clang:latest:latest
INSTALL_TARGET_PROCESSES = SpringBoard

TWEAK_NAME = LegacyRings

LegacyRings_FILES = Tweak.m
LegacyRings_CFLAGS = -fobjc-arc
LegacyRings_LIBRARIES = kitten
LegacyRings_PRIVATE_FRAMEWORKS = AppSupport

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
