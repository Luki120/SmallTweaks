/*--- Tweak count right on your settings app ---*/

@import CydiaSubstrate;
@import Preferences.PSSpecifier;
@import Preferences.PSListController;
#import <dlfcn.h>
#import "Factory/ElixirLabelFactory.h"


#define kClass(class) NSClassFromString(class)
#define kIsCurrentApp(string) [[[NSBundle mainBundle] bundleIdentifier] isEqual: string]
#define kOrion dlopen("/Library/MobileSubstrate/DynamicLibraries/OrionSettings.dylib", RTLD_LAZY)
#define kShuffle dlopen("/Library/MobileSubstrate/DynamicLibraries/shuffle.dylib", RTLD_LAZY)


@interface PSUIPrefsListController : PSListController
@end


@interface TSRootListController : UIViewController
@property (copy, nonatomic) NSString *title;
@end


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

__attribute__((constructor)) static void init() {

	if(kOrion != nil)

		MSHookMessageEx(kClass(@"OrionTweakSpecifiersController"), @selector(viewDidLoad), (IMP) &overrideTweaksVDL, (IMP *) &origTweaksVDL);

	else if(kShuffle != nil)

		MSHookMessageEx(kClass(@"TweakSpecifiersController"), @selector(viewDidLoad), (IMP) &overrideTweaksVDL, (IMP *) &origTweaksVDL);

	else MSHookMessageEx(kClass(@"PSUIPrefsListController"), @selector(viewDidLoad), (IMP) &overrideVDL, (IMP *) &origVDL);

	if(!kIsCurrentApp(@"com.creaturecoding.tweaksettings")) return;
	MSHookMessageEx(kClass(@"TSRootListController"), @selector(viewDidLoad), (IMP) &overrideTSVDL, (IMP *) &origTSVDL);

}
