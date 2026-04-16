TARGET := iphone:clang:latest:15.0
INSTALL_TARGET_PROCESSES = ToolBox

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = ToolBox
ToolBox_FILES = $(wildcard *.swift)
ToolBox_FRAMEWORKS = UIKit SwiftUI
ToolBox_CFLAGS = -fobjc-arc
ToolBox_SWIFTFLAGS = -sdk $(SYSROOT)

include $(THEOS)/makefiles/application.mk
