TARGET := iphone:clang:latest:latest
INSTALL_TARGET_PROCESSES = SpringBoard

TWEAK_NAME = ReachSpring

ReachSpring_FILES = Tweak.m
ReachSpring_CFLAGS = -fobjc-arc
ReachSpring_FRAMEWORKS = FrontBoardServices SpringBoardServices

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
