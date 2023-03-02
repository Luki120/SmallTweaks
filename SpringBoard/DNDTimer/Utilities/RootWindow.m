#import "RootWindow.h"


@implementation RootWindow

+ (UIWindow *)keyWindow {

	UIWindow *rootWindow = nil;
	NSArray *windows = UIApplication.sharedApplication.windows;

	for(UIWindow *window in windows)

		if(window.isKeyWindow) {
			rootWindow = window;
			break;
		}

	return rootWindow;

}

@end
