/*--- Controls the blur intensity of the stock CC,
original code idea from NoBlurCC by ETHN -> https://github.com/nahtedetihw ---*/

@import UIKit;
@import CydiaSubstrate;
#import "Common/Common.h"

static BOOL magicValue;
static CGFloat alpha;


@interface MTMaterialView : UIView
@property (assign, nonatomic) double weighting;
@property (assign, nonatomic) BOOL zoomEnabled;
@property (assign, nonatomic) BOOL shouldCrossfade;
- (void)unleashTheRabbit;
- (UIViewController *)_viewControllerForAncestor;
@end


static void loadShit(void) {

	NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName: kSuiteName];

	magicValue = [prefs objectForKey: @"magicValue"] ? [prefs boolForKey: @"magicValue"] : NO;
	alpha = [prefs objectForKey: @"alpha"] ? [prefs floatForKey: @"alpha"] : 0.85f;

}

static void new_unleashTheRabbit(MTMaterialView *self, SEL _cmd) {

	loadShit();
	if(!magicValue) return;

	self.weighting = 1;
	self.zoomEnabled = NO;
	self.shouldCrossfade = YES;

}

static void (*origSetWeighting)(MTMaterialView *, SEL, CGFloat);
static void overrideSetWeighting(MTMaterialView *self, SEL _cmd, CGFloat weighting) {

	UIViewController *ancestor = [self _viewControllerForAncestor];
	if(![ancestor isKindOfClass:NSClassFromString(@"CCUIModularControlCenterOverlayViewController")])
		return origSetWeighting(self, _cmd, weighting);

	origSetWeighting(self, _cmd, magicValue ? alpha * weighting : weighting);

}

static void (*origDMTS)(MTMaterialView *, SEL);
static void overrideDMTS(MTMaterialView *self, SEL _cmd) {

	origDMTS(self, _cmd);

	UIViewController *ancestor = [self _viewControllerForAncestor];
	if(![ancestor isKindOfClass:NSClassFromString(@"CCUIModularControlCenterOverlayViewController")]) return;

	[self unleashTheRabbit];

	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(unleashTheRabbit) name:StealthCCDidApplyCustomBlurNotification object:nil];

}

__attribute__((constructor)) static void init(void) {

	MSHookMessageEx(NSClassFromString(@"MTMaterialView"), @selector(setWeighting:), (IMP) &overrideSetWeighting, (IMP *) &origSetWeighting);
	MSHookMessageEx(NSClassFromString(@"MTMaterialView"), @selector(didMoveToSuperview), (IMP) &overrideDMTS, (IMP *) &origDMTS);

	class_addMethod(NSClassFromString(@"MTMaterialView"), @selector(unleashTheRabbit), (IMP) &new_unleashTheRabbit, "v@:");

}
