#import "ArresVC.h"


@implementation ArresVC

- (NSArray *)specifiers {

	if(!_specifiers) _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	return _specifiers;

}


- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {

	NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName: kSuiteName];
	[prefs setObject:value forKey:specifier.properties[@"key"]];

	[super setPreferenceValue:value specifier:specifier];

	[NSDistributedNotificationCenter.defaultCenter postNotificationName:ArresNotificationArrivedNotification object:nil];

}

@end
