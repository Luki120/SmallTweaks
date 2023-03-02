#import "STLRootVC.h"

#define kSTLCCTintColor [UIColor colorWithRed:0.61 green:0.82 blue:0.88 alpha: 1.0]

@implementation STLRootVC

- (NSArray *)specifiers {

	if(!_specifiers) _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	return _specifiers;

}


- (id)init {

	self = [super init];
	if(!self) return nil;

	static dispatch_once_t token;
	dispatch_once(&token, ^{ registerStealthCCTintCellClass(); });	

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

	[NSDistributedNotificationCenter.defaultCenter postNotificationName:StealthCCDidApplyCustomBlurNotification object:nil];

	[super setPreferenceValue:value specifier:specifier];

}


- (void)launchSourceCode {

	[UIApplication.sharedApplication openURL:[NSURL URLWithString: @"https://github.com/Luki120/SmallTweaks/tree/main/StealthCC"] options:@{} completionHandler:nil];

}

static void stealthcc_setTitle(PSTableCell *self, SEL _cmd, NSString *title) {

	struct objc_super superSetTitle = {
		self,
		[self superclass]
	};

	id (*superCall)(struct objc_super *, SEL, NSString *) = (void *)objc_msgSendSuper;
	superCall(&superSetTitle, _cmd, title);

	self.titleLabel.textColor = kSTLCCTintColor;
	self.titleLabel.highlightedTextColor = kSTLCCTintColor;

}

static void registerStealthCCTintCellClass() {

	Class StealthCCTintCellClass = objc_allocateClassPair([PSTableCell class], "STLCCTintCell", 0);
	Method method = class_getInstanceMethod([PSTableCell class], @selector(setTitle:));
	const char *typeEncoding = method_getTypeEncoding(method);
	class_addMethod(StealthCCTintCellClass, @selector(setTitle:), (IMP) stealthcc_setTitle, typeEncoding);

	objc_registerClassPair(StealthCCTintCellClass);

}

@end
