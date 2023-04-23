TARGET := iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = SpringBoard

BUNDLE_NAME = Zira

Zira_FILES = $(wildcard **/*.m)
Zira_CFLAGS = -fobjc-arc
Zira_LIBRARIES = gcuniversal
Zira_INSTALL_PATH = /Library/ControlCenter/Bundles/
Zira_BUNDLE_EXTENSION = bundle
Zira_PRIVATE_FRAMEWORKS = ControlCenterUIKit Preferences

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/bundle.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
