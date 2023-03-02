export TARGET := iphone:clang:latest:latest
INSTALL_TARGET_PROCESSES = SpringBoard

TWEAK_NAME = BSCImage

BSCImage_FILES = Tweak.m
BSCImage_CFLAGS = -fobjc-arc
BSCImage_LIBRARIES = gcuniversal

SUBPROJECTS = BSCImagePrefs

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
