#import "KaiaToggle.h"


@implementation KaiaToggle {

	NSUserDefaults *defaults;

}


- (id)init {

	self = [super init];
	if(!self) return nil;

	defaults = [NSUserDefaults standardUserDefaults];

	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(setToggleState) name:KaiaDidRetrieveToggleStateNotification object:nil];

	return self;

}


- (BOOL)isSelected { return [defaults boolForKey: @"kaiaToggleSelected"]; }
- (void)setSelected:(BOOL)selected {

	[defaults setBool:selected forKey: @"kaiaToggleSelected"];

	[self setToggleState];
	[super setSelected: selected];

}


- (void)setToggleState {

	NSDictionary *userInfo = @{ @"kaiaToggleSelected": [NSNumber numberWithBool: [defaults boolForKey: @"kaiaToggleSelected"]] };
	[NSDistributedNotificationCenter.defaultCenter postNotificationName:KaiaDidSelectToggleNotification object:nil userInfo:userInfo];

}


- (UIImage *)iconGlyph { return [UIImage systemImageNamed: @"eye"]; }
- (UIImage *)selectedIconGlyph { return [UIImage systemImageNamed: @"eye.slash"]; }
- (UIColor *)selectedColor { return UIColor.systemPurpleColor; }

@end
