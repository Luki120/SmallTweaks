/*--- Set an image with an optional blur as background
for BigSurCenter tweak. Made before it became an official feature
and also it's better than the og lol, custom blur intensity,
dark/light images and of course, changes apply on the fly ---*/

@import UIKit;
@import CydiaSubstrate;
@import gcUniversal.imagePickerUtils;
#import "Common/Common.h"


static BOOL giveMeThatImage;
static float alpha;

static UIImage *darkImage;
static UIImage *lightImage;
static UIImageView *bscImageView;

static NSString *const kDarkImage = @"darkImage";
static NSString *const kLightImage = @"lightImage";
static NSString *const kDefaults = @"me.luki.bscimageprefs";

#define kClass(string) NSClassFromString(string)
#define kUserInterfaceStyle UIScreen.mainScreen.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark


@interface _UIBackdropViewSettings : NSObject
+ (id)settingsForStyle:(NSInteger)arg1;
@end


@interface _UIBackdropView : UIView
- (id)initWithFrame:(CGRect)arg1 autosizesToFitSuperview:(BOOL)arg2 settings:(id)arg3;
@end


@interface SCContentViewController : UIViewController
@property (nonatomic, strong) UIView *backgroundView;
@end


static void loadP() {

	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: kPath];
	NSMutableDictionary *prefs = dict ? [dict mutableCopy] : [NSMutableDictionary dictionary];

	giveMeThatImage = prefs[@"giveMeThatImage"] ? [prefs[@"giveMeThatImage"] boolValue] : NO;
	alpha = prefs[@"alpha"] ? [prefs[@"alpha"] floatValue] : 0.85f;

}

static void new_setBSCImage(SCContentViewController *self, SEL _cmd) {

	loadP();

	[[self.backgroundView viewWithTag: 1337] removeFromSuperview];

	darkImage = [GcImagePickerUtils imageFromDefaults:kDefaults withKey: kDarkImage];
	lightImage = [GcImagePickerUtils imageFromDefaults:kDefaults withKey: kLightImage];

	if(!giveMeThatImage && bscImageView) return;

	bscImageView = [UIImageView new];
	bscImageView.tag = 1337;
	bscImageView.frame = self.backgroundView.bounds;
	bscImageView.image = kUserInterfaceStyle ? darkImage : lightImage;
	bscImageView.contentMode = UIViewContentModeScaleAspectFill;
	bscImageView.clipsToBounds = YES;
	bscImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.backgroundView addSubview: bscImageView];

	_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

	_UIBackdropView *blurView = [[_UIBackdropView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:settings];
	blurView.tag = 1337;
	blurView.alpha = alpha;
	[bscImageView addSubview: blurView];

}

static void (*origTCDC)(UIView *, SEL, UITraitCollection *);
static void overrideTCDC(UIView *self, SEL _cmd, UITraitCollection *previousTrait) {

	origTCDC(self, _cmd, previousTrait);
	bscImageView.image = kUserInterfaceStyle ? darkImage : lightImage;

}

static void (*origVDL)(SCContentViewController *, SEL);
static void overrideVDL(SCContentViewController *self, SEL _cmd) {

	origVDL(self, _cmd);
	new_setBSCImage(self, _cmd);

	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(setBSCImage) name:BSCImageApplyImageNotification object:nil];

}

__attribute__((constructor)) static void init() {

	MSHookMessageEx(kClass(@"SCContentViewController"), @selector(viewDidLoad), (IMP) &overrideVDL, (IMP *) &origVDL);
	MSHookMessageEx(kClass(@"SCContentViewController"), @selector(traitCollectionDidChange:), (IMP) &overrideTCDC, (IMP *) &origTCDC);

	class_addMethod(
		kClass(@"SCContentViewController"),
		@selector(setBSCImage),
		(IMP) &new_setBSCImage,
		"v@:"
	);

}
