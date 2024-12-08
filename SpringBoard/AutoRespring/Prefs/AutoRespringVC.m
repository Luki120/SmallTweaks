#import "AutoRespringVC.h"

#define kAutoRespringTintColor [UIColor colorWithRed:0.64 green:0.79 blue:1.0 alpha: 1.0]

@implementation AutoRespringVC

- (NSArray *)specifiers {
	if(!_specifiers) _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	return _specifiers;
}


- (id)init {
	self = [super init];
	if(!self) return nil;

	[UISwitch appearanceWhenContainedInInstancesOfClasses:@[[self class]]].onTintColor = kAutoRespringTintColor;

	return self;
}


- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {

	NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName: kSuiteName];
	[prefs setObject:value forKey:specifier.properties[@"key"]];

	[super setPreferenceValue:value specifier:specifier];

	[NSDistributedNotificationCenter.defaultCenter postNotificationName:AutoRespringDidEnableTweakNotification object:nil];

}

@end
