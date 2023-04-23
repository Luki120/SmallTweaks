/*--- Netflix like volume HUD ---*/

@import libhooker.libblackjack;
#import "View/IslaView.h"


static IslaView *islaView;

static void (*origVDL)(UIViewController *, SEL);
static void overrideVDL(UIViewController *self, SEL _cmd) {

	origVDL(self, _cmd);
	for(UIView *subview in self.view.subviews) {
		if(subview == islaView) continue;
		subview.hidden = YES;
	}

	if(!islaView) islaView = [IslaView new];
	islaView.alpha = 0;
	islaView.transform = CGAffineTransformMakeTranslation(0, -20);
	if(![islaView isDescendantOfView: self.view]) [self.view addSubview: islaView];

	[NSLayoutConstraint activateConstraints:@[
		[islaView.centerXAnchor constraintEqualToAnchor: self.view.centerXAnchor],
		[islaView.topAnchor constraintEqualToAnchor: self.view.topAnchor constant: 20],
		[islaView.widthAnchor constraintEqualToConstant: 265],
		[islaView.heightAnchor constraintEqualToConstant: 30]
	]];

}

static void (*origVWA)(UIViewController *, SEL, BOOL);
static void overrideVWA(UIViewController *self, SEL _cmd, BOOL animated) {

	origVWA(self, _cmd, animated);

	[UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{

		islaView.transform = CGAffineTransformMakeTranslation(0, 0);
		islaView.alpha = 1;

	} completion:nil];

}

__attribute__((constructor)) static void init(void) {

	Class VolumeHUDVC;

	if(@available(iOS 15.0, *))
		VolumeHUDVC = NSClassFromString(@"SBElasticHUDViewController");

	else VolumeHUDVC = NSClassFromString(@"SBVolumeHUDViewController");

	LBHookMessage(VolumeHUDVC, @selector(viewDidLoad), &overrideVDL, &origVDL);
	LBHookMessage(VolumeHUDVC, @selector(viewWillAppear:), &overrideVWA, &origVWA);

}
