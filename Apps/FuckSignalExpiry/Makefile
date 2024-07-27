TARGET := iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = Signal

TWEAK_NAME = FuckSignalExpiry

FuckSignalExpiry_FILES = Tweak.m
FuckSignalExpiry_CFLAGS = -fobjc-arc

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
