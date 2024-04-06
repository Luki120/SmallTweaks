#import "SeleneVC.h"

#define kSeleneTintColor [UIColor colorWithRed:0.55 green:0.86 blue:0.66 alpha:1.0];

@implementation SeleneVC

- (NSArray *)specifiers {

	if(!_specifiers) _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	return _specifiers;

}


- (id)init {

	self = [super init];
	if(!self) return nil;

	static dispatch_once_t token;
	dispatch_once(&token, ^{ registerSeleneTintCellClass(); });	

	return self;

}


- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {

	NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName: kSuiteName];
	[prefs setObject:value forKey:specifier.properties[@"key"]];	

	[super setPreferenceValue:value specifier:specifier];

	[NSDistributedNotificationCenter.defaultCenter postNotificationName:SeleneDidCreateTapGestureNotification object:nil];

}

static void selene_setTitle(PSTableCell *self, SEL _cmd, NSString *title) {

	struct objc_super superSetTitle = {
		self,
		[self superclass]
	};

	id (*superCall)(struct objc_super *, SEL, NSString *) = (void *)objc_msgSendSuper;
	superCall(&superSetTitle, _cmd, title);

	self.titleLabel.textColor = kSeleneTintColor;
	self.titleLabel.highlightedTextColor = kSeleneTintColor;

}

static void registerSeleneTintCellClass(void) {

	Class SeleneTintCellClass = objc_allocateClassPair([PSTableCell class], "SeleneTintCell", 0);
	Method method = class_getInstanceMethod([PSTableCell class], @selector(setTitle:));
	const char *typeEncoding = method_getTypeEncoding(method);
	class_addMethod(SeleneTintCellClass, @selector(setTitle:), (IMP) selene_setTitle, typeEncoding);

	objc_registerClassPair(SeleneTintCellClass);

}

@end


@implementation SeleneLinksVC

- (NSArray *)specifiers {

	if(!_specifiers) _specifiers = [self loadSpecifiersFromPlistName:@"SeleneLinks" target:self];
	return _specifiers;

}


- (void)launchDiscord { [self launchURL: [NSURL URLWithString: @"https://discord.gg/jbE3avwSHs"]]; }
- (void)launchPayPal { [self launchURL: [NSURL URLWithString: @"https://paypal.me/Luki120"]]; }
- (void)launchGitHub { [self launchURL: [NSURL URLWithString: @"https://github.com/Luki120/SmallTweaks/tree/main/Selene"]]; }
- (void)launchMarie { [self launchURL: [NSURL URLWithString: @"https://luki120.github.io/depictions/web/?p=me.luki.marie"]]; }
- (void)launchMeredith { [self launchURL: [NSURL URLWithString: @"https://repo.twickd.com/get/com.twickd.luki120.meredith"]]; }

- (void)launchURL:(NSURL *)url { [UIApplication.sharedApplication openURL:url options:@{} completionHandler:nil]; }

@end
