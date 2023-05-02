/*--- Tweak count right on your settings app ---*/

@import CydiaSubstrate;
@import Preferences.PSSpecifier;
@import Preferences.PSListController;
#import <dlfcn.h>
#import "Factory/ElixirLabelFactory.h"


#define kClass(class) NSClassFromString(class)
#define kIsCurrentApp(string) [[[NSBundle mainBundle] bundleIdentifier] isEqual: string]
#define kOneSettings dlopen("/Library/MobileSubstrate/DynamicLibraries/OneSettings.dylib", RTLD_LAZY)
#define kOrion dlopen("/Library/MobileSubstrate/DynamicLibraries/OrionSettings.dylib", RTLD_LAZY)
#define kShuffle dlopen("/Library/MobileSubstrate/DynamicLibraries/shuffle.dylib", RTLD_LAZY)


@interface PSUIPrefsListController : PSListController
@end


@interface TSRootListController : UIViewController
@property (copy, nonatomic) NSString *title;
@end


@interface TweakSpecifiersController : PSListController
@end


static void (*origShuffleVDL)(TweakSpecifiersController *, SEL);
static void overrideShuffleVDL(TweakSpecifiersController *self, SEL _cmd) {

	origShuffleVDL(self, _cmd);

	// Shuffle has a search bar so no space at the top :woeIsFade:
	UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
	[footerView addSubview: [ElixirLabelFactory makeElixirLabel]];
	[ElixirLabelFactory centerElixirLabelOnBothAxesOfView: footerView];

	self.table.tableFooterView = footerView;

}

static void (*origTweaksVDL)(PSListController *, SEL);
static void overrideTweaksVDL(PSListController *self, SEL _cmd) {

	origTweaksVDL(self, _cmd);

	[self.table addSubview: [ElixirLabelFactory makeElixirLabel]];
	[ElixirLabelFactory pinElixirLabelToTheTopCenteredOnTheXAxisOfView: self.table];

}

static void (*origTSVDL)(TSRootListController *, SEL);
static void overrideTSVDL(TSRootListController *self, SEL _cmd) {

	origTSVDL(self, _cmd);

	[ElixirLabelFactory makeElixirLabel];
	self.title = [ElixirLabelFactory tweakCountString];

}

static void (*origVDL)(PSUIPrefsListController *, SEL);
static void overrideVDL(PSUIPrefsListController *self, SEL _cmd) {

	origVDL(self, _cmd);

	PSSpecifier *emptySpecifier = [PSSpecifier emptyGroupSpecifier];

	[ElixirLabelFactory makeElixirLabel];

	NSString *elixirTweakCountLabel = [ElixirLabelFactory tweakCountString];
	PSSpecifier *elixirSpecifier = [PSSpecifier preferenceSpecifierNamed:elixirTweakCountLabel target:self set:nil get:nil detail:nil cell:PSStaticTextCell edit:nil];
	[elixirSpecifier setProperty:@YES forKey:@"enabled"];
	[self insertContiguousSpecifiers:@[emptySpecifier, elixirSpecifier] afterSpecifier:[self specifierForID:@"APPLE_ACCOUNT"]];

}

__attribute__((constructor)) static void init(void) {

	if(kOneSettings != nil)
		MSHookMessageEx(kClass(@"OSTweaksListController"), @selector(viewDidLoad), (IMP) &overrideTweaksVDL, (IMP *) &origTweaksVDL);

	else if(kOrion != nil)
		MSHookMessageEx(kClass(@"OrionTweakSpecifiersController"), @selector(viewDidLoad), (IMP) &overrideTweaksVDL, (IMP *) &origTweaksVDL);

	else if(kShuffle != nil)
		MSHookMessageEx(kClass(@"TweakSpecifiersController"), @selector(viewDidLoad), (IMP) &overrideShuffleVDL, (IMP *) &origShuffleVDL);

	else MSHookMessageEx(kClass(@"PSUIPrefsListController"), @selector(viewDidLoad), (IMP) &overrideVDL, (IMP *) &origVDL);

	if(!kIsCurrentApp(@"com.creaturecoding.tweaksettings")) return;
	MSHookMessageEx(kClass(@"TSRootListController"), @selector(viewDidLoad), (IMP) &overrideTSVDL, (IMP *) &origTSVDL);

}
