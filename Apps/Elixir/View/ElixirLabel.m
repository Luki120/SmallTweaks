#import "ElixirLabel.h"


@implementation ElixirLabel

- (id)init {

	self = [super init];
	if(!self) return nil;

	[self setupTweakCount];
	[self setupElixirLabel];

	return self;

}


- (void)setupTweakCount {

	NSString *bundlePath = @"/Library/PreferenceLoader/Preferences/";
	NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:bundlePath error:nil];
	self.elixirTweakCount = [directoryContent count];

	NSString *tweaksString = directoryContent.count > 1 ? @"Tweaks" : @"Tweak";
	self.tweakCountString = [NSString stringWithFormat:@"%ld %@", self.elixirTweakCount, tweaksString];

}


- (void)setupElixirLabel {

	self.font = [UIFont boldSystemFontOfSize: 18];
	self.text = self.tweakCountString;
	self.textColor = UIColor.labelColor;
	self.translatesAutoresizingMaskIntoConstraints = NO;

}

@end
