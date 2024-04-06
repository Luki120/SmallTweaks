/*--- Temporarily disables tapping notifications for a 
custom amount of seconds to prevent accidental touches ---*/

@import UIKit;
@import CydiaSubstrate;
#import "Common/Common.h"


@interface BNContentViewControllerView : UIView
- (void)doShit;
@end


static float timeValue;

static void loadPrefs(void) {

	NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName: kSuiteName];
	timeValue = [prefs objectForKey:@"timeValue"] ? [prefs floatForKey:@"timeValue"] : 1.0f;

}

static void new_doShit(BNContentViewControllerView *self, SEL _cmd) {

	loadPrefs();

	self.userInteractionEnabled = NO;

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, timeValue * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

		self.userInteractionEnabled = YES;

	});

}

static void (*origLS)(BNContentViewControllerView *, SEL);
static void overrideLS(BNContentViewControllerView *self, SEL _cmd) {

	origLS(self, _cmd);
	[self doShit];

}

static void (*origSF)(BNContentViewControllerView *, SEL, CGRect);
static void overrideSF(BNContentViewControllerView *self, SEL _cmd, CGRect frame) {

	origSF(self, _cmd, frame);
	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(doShit) name:ArresNotificationArrivedNotification object:nil];

}

__attribute__((constructor)) static void init(void) {

	MSHookMessageEx(NSClassFromString(@"BNContentViewControllerView"), @selector(layoutSubviews), (IMP) &overrideLS, (IMP *) &origLS);
	MSHookMessageEx(NSClassFromString(@"BNContentViewControllerView"), @selector(setFrame:), (IMP) &overrideSF, (IMP *) &origSF);

	class_addMethod(
		NSClassFromString(@"BNContentViewControllerView"),
		@selector(doShit),
		(IMP) &new_doShit,
		"v@:"
	);

}
