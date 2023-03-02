#import "NetflixToggle.h"


@implementation NetflixToggle

- (void)setSelected:(BOOL)selected {

	[super setSelected: selected];
	[UIApplication.sharedApplication launchApplicationWithIdentifier:@"com.netflix.Netflix" suspended:0];

	if(![[NSFileManager defaultManager] fileExistsAtPath: kPrysm]) return;
	[NSNotificationCenter.defaultCenter postNotificationName:NetflixToggleDidDismissPrysmCCNotification object:nil];

}


- (UIColor *)selectedColor { return UIColor.clearColor; }
- (UIImage *)iconGlyph {

	return [UIImage imageNamed:@"NetflixToggle" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];

}

@end
