/*--- Lock your device by double tapping on HS ---*/


@import UIKit;
@import CydiaSubstrate;
@import AudioToolbox.AudioServices;


@interface SBHomeScreenViewController : UIViewController
@end


@interface SpringBoard : UIApplication
- (void)_simulateLockButtonPress;
@end


static void (*origVDL)(SBHomeScreenViewController *, SEL);
static void overrideVDL(SBHomeScreenViewController *self, SEL _cmd) {

	origVDL(self, _cmd);

	UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hs_didDoubleTapHS)];
	gestureRecognizer.numberOfTapsRequired = 2;
	[self.view addGestureRecognizer: gestureRecognizer];

}

static void new_hs_didDoubleTapHS(SBHomeScreenViewController *self, SEL _cmd) {

	AudioServicesPlaySystemSound(1521);

	// https://github.com/schneelittchen/Puck
	SpringBoard *sb = (SpringBoard *)[NSClassFromString(@"SpringBoard") sharedApplication];
	[sb _simulateLockButtonPress];

}

__attribute__((constructor)) static void init() {

	MSHookMessageEx(NSClassFromString(@"SBHomeScreenViewController"), @selector(viewDidLoad), (IMP) &overrideVDL, (IMP *) &origVDL);

	class_addMethod(
		NSClassFromString(@"SBHomeScreenViewController"),
		@selector(hs_didDoubleTapHS),
		(IMP) &new_hs_didDoubleTapHS,
		"v@:"
	);

}
