ARCHS = arm64
TARGET := iphone:clang:latest:latest
INSTALL_TARGET_PROCESSES = StarPlus

TWEAK_NAME = FixStar+

FixStar+_FILES = Tweak.m
FixStar+_CFLAGS = -fobjc-arc

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
