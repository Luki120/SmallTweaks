/*--- Record on the LS without authenticating for ⇝ iOS 14 + ---*/

@import CydiaSubstrate;
@import UIKit;


@class RPControlCenterMenuModuleViewController;

static void overrideAWCH(RPControlCenterMenuModuleViewController *self, SEL _cmd, void(^completionHandler)(BOOL)) {

	completionHandler(YES);

}

__attribute__((constructor)) static void init() {

	if(![[NSBundle mainBundle].bundleIdentifier isEqualToString: @"com.apple.springboard"]) return;

	NSBundle *moduleBundle = [NSBundle bundleWithPath:@"/System/Library/ControlCenter/Bundles/ReplayKitModule.bundle"];
	if(!moduleBundle.loaded) [moduleBundle load];
	MSHookMessageEx(NSClassFromString(@"RPControlCenterMenuModuleViewController"), @selector(authenticateWithCompletionHandler:), (IMP) &overrideAWCH, (IMP *) NULL);

}
