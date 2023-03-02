/*--- Gives the iOS 14+ status bar the look from the iOS 6 one, made as a bounty for the iOSNJB admin ---*/

@import UIKit;
@import CydiaSubstrate;


@interface _UIStatusBar : UIView
@end


@interface CCUIStatusBar : UIView
@end


@interface _UIStatusBarStringView : UILabel
@end

static NSString *stringView;
static _UIStatusBar *statusBar;

static void (*origUIStatusBarDMTW)(_UIStatusBar *, SEL);
static void overrideUIStatusBarDMTW(_UIStatusBar *self, SEL _cmd) {

	origUIStatusBarDMTW(self, _cmd);

	statusBar = self;
	self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.55];

}

static void (*origSetText)(_UIStatusBarStringView *, SEL, NSString *);
static void overrideSetText(_UIStatusBarStringView *self, SEL _cmd, NSString *text) {

	stringView = text;
	origSetText(self, _cmd, text);

}

static void (*origApplyStyleAttributes)(_UIStatusBarStringView *, SEL, NSDictionary *);
static void overrideApplyStyleAttributes(_UIStatusBarStringView *self, SEL _cmd, NSDictionary *attributes) {

	origApplyStyleAttributes(self, _cmd, attributes);

	if([stringView containsString:@"2G"] 
		|| [stringView containsString:@"3G"] 
		|| [stringView containsString:@"4G"]
		|| [stringView containsString:@"LTE"] 
		|| [stringView containsString:@"5G"]
		|| [stringView containsString:@"E"]) self.font = [UIFont fontWithName:@"Helvetica Bold" size:12];

	else self.font = [UIFont fontWithName:@"Helvetica Bold" size:14];

}

static void (*origCCUIStatusBarDMTW)(CCUIStatusBar *, SEL);
static void overrideCCUIStatusBarDMTW(CCUIStatusBar *self, SEL _cmd) {

	origCCUIStatusBarDMTW(self, _cmd);
	statusBar.backgroundColor = nil;

}

__attribute__((constructor)) static void init() {

	MSHookMessageEx(NSClassFromString(@"_UIStatusBar"), @selector(didMoveToWindow), (IMP) &overrideUIStatusBarDMTW, (IMP *) &origUIStatusBarDMTW);
	MSHookMessageEx(NSClassFromString(@"_UIStatusBarStringView"), @selector(setText:), (IMP) &overrideSetText, (IMP *) &origSetText);
	MSHookMessageEx(NSClassFromString(@"_UIStatusBarStringView"), @selector(applyStyleAttributes:), (IMP) &overrideApplyStyleAttributes, (IMP *) &origApplyStyleAttributes);
	MSHookMessageEx(NSClassFromString(@"CCUIStatusBar"), @selector(didMoveToWindow), (IMP) &overrideCCUIStatusBarDMTW, (IMP *) &origCCUIStatusBarDMTW);

}
