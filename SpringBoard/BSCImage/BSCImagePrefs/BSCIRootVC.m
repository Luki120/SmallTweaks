#import "BSCIRootVC.h"

static const char *bsc_image_changed = "me.luki.bscimageprefs/bscImageChanged";

#define kBSCITintColor [UIColor colorWithRed:0.93 green:0.54 blue:0.78 alpha: 1.0]

@implementation BSCIRootVC

- (NSArray *)specifiers {

	if(!_specifiers) _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	return _specifiers;

}


- (id)init {

	self = [super init];
	if(!self) return nil;

	int register_token = 0;
	notify_register_dispatch(bsc_image_changed, &register_token, dispatch_get_main_queue(), ^(int _) {
		[NSDistributedNotificationCenter.defaultCenter postNotificationName:BSCImageApplyImageNotification object:nil];
	});

	static dispatch_once_t token;
	dispatch_once(&token, ^{ registerBSCImageTintCellClass(); });

	return self;

}


- (id)readPreferenceValue:(PSSpecifier *)specifier {

	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile: kPath]];
	return settings[specifier.properties[@"key"]] ?: specifier.properties[@"default"];

}


- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {

	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile: kPath]];
	[settings setObject:value forKey:specifier.properties[@"key"]];
	[settings writeToFile:kPath atomically:YES];

	[NSDistributedNotificationCenter.defaultCenter postNotificationName:BSCImageApplyImageNotification object:nil];

	[super setPreferenceValue:value specifier:specifier];

}


- (void)launchSourceCode {

	[UIApplication.sharedApplication openURL:[NSURL URLWithString: @"https://github.com/Luki120/SmallTweaks/tree/main/SpringBoard/BSCImage"] options:@{} completionHandler:nil];

}


static void bscImage_setTitle(PSTableCell *self, SEL _cmd, NSString *title) {

	struct objc_super superSetTitle = {
		self,
		[self superclass]
	};

	id (*superCall)(struct objc_super *, SEL, NSString *) = (void *)objc_msgSendSuper;
	superCall(&superSetTitle, _cmd, title);

	self.titleLabel.textColor = kBSCITintColor;
	self.titleLabel.highlightedTextColor = kBSCITintColor;

}

static void registerBSCImageTintCellClass() {

	Class BSCImageTintCellClass = objc_allocateClassPair([PSTableCell class], "BSCImageTintCell", 0);
	Method method = class_getInstanceMethod([PSTableCell class], @selector(setTitle:));
	const char *typeEncoding = method_getTypeEncoding(method);
	class_addMethod(BSCImageTintCellClass, @selector(setTitle:), (IMP) bscImage_setTitle, typeEncoding);

	objc_registerClassPair(BSCImageTintCellClass);

}

@end
