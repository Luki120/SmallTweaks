@import UIKit;
@import CydiaSubstrate;


@interface SBFLockScreenDateView : UIView
@end


static void (*origDMTW)(SBFLockScreenDateView *, SEL);
static void overrideDMTW(SBFLockScreenDateView *self, SEL _cmd) {

	origDMTW(self, _cmd);

	for(UILabel *quartLabel in self.subviews) {

		if(![quartLabel isKindOfClass: [UILabel class]]) return;
		if([quartLabel.text containsString: @"Notification"]) [quartLabel removeFromSuperview];

	}

}

__attribute__((constructor)) static void init() {

	MSHookMessageEx(NSClassFromString(@"SBFLockScreenDateView"), @selector(didMoveToWindow), (IMP) &overrideDMTW, (IMP *) &origDMTW);

}
