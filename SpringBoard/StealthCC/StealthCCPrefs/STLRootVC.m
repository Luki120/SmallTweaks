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

	[UISlider appearanceWhenContainedInInstancesOfClasses:@[[self class]]].minimumTrackTintColor = kSTLCCTintColor;
	[UISwitch appearanceWhenContainedInInstancesOfClasses:@[[self class]]].onTintColor = kSTLCCTintColor;

	static dispatch_once_t token;
	dispatch_once(&token, ^{ registerStealthCCTintCellClass(); });	

	return self;

}


- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {

	NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName: kSuiteName];
	[prefs setObject:value forKey:specifier.properties[@"key"]];

	[super setPreferenceValue:value specifier:specifier];

	[NSDistributedNotificationCenter.defaultCenter postNotificationName:StealthCCDidApplyCustomBlurNotification object:nil];

}


- (void)launchSourceCode {

	[UIApplication.sharedApplication openURL:[NSURL URLWithString: @"https://github.com/Luki120/SmallTweaks/tree/main/SpringBoard/StealthCC"] options:@{} completionHandler:nil];

}

static void stealthCC_setTitle(PSTableCell *self, SEL _cmd, NSString *title) {

	struct objc_super superSetTitle = {
		self,
		[self superclass]
	};

	id (*superCall)(struct objc_super *, SEL, NSString *) = (void *)objc_msgSendSuper;
	superCall(&superSetTitle, _cmd, title);

	self.titleLabel.textColor = kSTLCCTintColor;
	self.titleLabel.highlightedTextColor = kSTLCCTintColor;

}

static void registerStealthCCTintCellClass(void) {

	Class StealthCCTintCellClass = objc_allocateClassPair([PSTableCell class], "STLCCTintCell", 0);
	Method method = class_getInstanceMethod([PSTableCell class], @selector(setTitle:));
	const char *typeEncoding = method_getTypeEncoding(method);
	class_addMethod(StealthCCTintCellClass, @selector(setTitle:), (IMP) stealthCC_setTitle, typeEncoding);

	objc_registerClassPair(StealthCCTintCellClass);

}

@end
