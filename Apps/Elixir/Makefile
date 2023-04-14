TARGET := iphone:clang:latest:latest
INSTALL_TARGET_PROCESSES = Preferences

TWEAK_NAME = Elixir

Elixir_FILES = $(wildcard **/*.m) $(wildcard *.m)
Elixir_CFLAGS = -fobjc-arc
Elixir_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
