#import "ZiraContentModuleVC.h"


@implementation ZiraContentModuleVC {

	UIImageView *imageView;

}

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle {

	self = [super initWithNibName:nibName bundle:bundle];
	if(!self) return nil;
	if(imageView) return nil;

	imageView = [UIImageView new];
	imageView.image = [GcImagePickerUtils imageFromDefaults:@"me.luki.ziraprefs" withKey:@"ziraImage"];
	imageView.contentMode = UIViewContentModeScaleAspectFill;
	imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview: imageView]; 

	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(updateImage) name:ZiraApplyImageNotification object:nil];

	return self;

}


- (void)viewDidLayoutSubviews {

	[super viewDidLayoutSubviews];

	imageView.frame = self.view.bounds;
	imageView.clipsToBounds = YES;

	UIView *materialView = imageView.superview.superview.subviews.firstObject;
	if(![materialView isKindOfClass: NSClassFromString(@"MTMaterialView")]) return;

	imageView.layer.cornerCurve = kCACornerCurveContinuous;
	imageView.layer.cornerRadius = materialView.layer.cornerRadius;

}


- (void)updateImage {

	imageView.image = [GcImagePickerUtils imageFromDefaults:@"me.luki.ziraprefs" withKey:@"ziraImage"];

}


- (BOOL)_canShowWhileLocked { return YES; }
- (BOOL)shouldBeginTransitionToExpandedContentModule { return NO; }

@end
