ARCHS = arm64 armv7

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = RedditCollapse
RedditCollapse_FILES = Tweak.xm
RedditCollapse_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Reddit"
