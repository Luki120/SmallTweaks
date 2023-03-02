/* --- Removes the cc labels and fade out when you toggle
a module, e.g "Low Power: On" ---*/

@import UIKit;
@import CydiaSubstrate;


@interface CCUIStatusLabel : UILabel
@end


@interface CCUIStatusLabelViewController : UIViewController
@end


static void overrideDelegateWBSU(CCUIStatusLabelViewController *self, SEL _cmd) {}

static void(*origDMTW)(CCUIStatusLabel *, SEL);
static void overrideDMTW(CCUIStatusLabel *self, SEL _cmd) {

	origDMTW(self, _cmd);
	self.hidden = YES;

}

__attribute__((constructor)) static void init() {

	MSHookMessageEx(NSClassFromString(@"CCUIStatusLabel"), @selector(didMoveToWindow), (IMP) &overrideDMTW, (IMP *) &origDMTW);
	MSHookMessageEx(NSClassFromString(@"CCUIStatusLabelViewController"), @selector(_notifyDelegateWillBeginStatusUpdates), (IMP) &overrideDelegateWBSU, (IMP *) NULL);

}
