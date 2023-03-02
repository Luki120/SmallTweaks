/*--- Bring back the old iOS 9 keypad buttons ---*/

@import UIKit;
@import libKitten;
@import CydiaSubstrate;

extern CFArrayRef CPBitmapCreateImagesFromData(CFDataRef cpbitmap, void *, int, void *);


@interface TPNumberPadButton : UIButton
@property (nonatomic, strong) UIView *circleView;
@end


static void (*origDMTW)(TPNumberPadButton *, SEL );
static void overrideDMTW(TPNumberPadButton *self, SEL _cmd) {

	origDMTW(self, _cmd);

	self.circleView.alpha = 0;
	self.circleView.backgroundColor = UIColor.clearColor;

	NSData *lsWallpaperData = [NSData dataWithContentsOfFile:@"/var/mobile/Library/SpringBoard/LockBackground.cpbitmap"];
	CFDataRef lsWallpaperDataRef = (__bridge CFDataRef)lsWallpaperData;
	CFArrayRef imageArray = CPBitmapCreateImagesFromData(lsWallpaperDataRef, NULL, 1, NULL);
	UIImage *wallpaperImage = [UIImage imageWithCGImage:(CGImageRef)CFArrayGetValueAtIndex(imageArray, 0)];
	CFRelease(imageArray);

	UIColor *primaryWallColor = [libKitten primaryColor: wallpaperImage];

	CAShapeLayer *ringLayer = [CAShapeLayer new];
	ringLayer.path = [UIBezierPath bezierPathWithOvalInRect: self.circleView.frame].CGPath;
	ringLayer.lineWidth = 2;
	ringLayer.fillColor = UIColor.clearColor.CGColor;
	ringLayer.strokeColor = primaryWallColor.CGColor;
	[self.layer insertSublayer:ringLayer atIndex:0];

}

static BOOL overrideUsesButtonSaturationFilters(TPNumberPadButton *self, SEL _cmd) { return NO; }

__attribute__((constructor)) static void init() {

	MSHookMessageEx(NSClassFromString(@"TPNumberPadButton"), @selector(didMoveToWindow), (IMP) &overrideDMTW, (IMP *) &origDMTW);
	MSHookMessageEx(objc_getMetaClass("TPNumberPadButton"), @selector(usesButtonSaturationFilters), (IMP) &overrideUsesButtonSaturationFilters, (IMP *) NULL);

}
