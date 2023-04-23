#import "ZiraVC.h"


@implementation ZiraVC

- (NSArray *)specifiers {

	if(!_specifiers) _specifiers = [self loadSpecifiersFromPlistName:@"ZiraPrefs" target:self];
	return _specifiers;

}


- (id)init {

	self = [super init];
	if(!self) return nil;

	int register_token = 0;
	notify_register_dispatch("me.luki.ziraprefs/imageChanged", &register_token, dispatch_get_main_queue(), ^(int _) {
		[NSDistributedNotificationCenter.defaultCenter postNotificationName:ZiraApplyImageNotification object:nil];
	});

	return self;

}

@end
