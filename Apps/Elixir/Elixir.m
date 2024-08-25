/*--- Tweak count right on your settings app ---*/

@import CydiaSubstrate;
@import Preferences.PSSpecifier;
@import Preferences.PSListController;
#import <dlfcn.h>
#import "Common/Common.h"
#import "Factory/ElixirLabelFactory.h"


#define kClass(class) NSClassFromString(class)
#define kIsCurrentApp(string) [[[NSBundle mainBundle] bundleIdentifier] isEqualToString: string]
#define kOneSettings dlopen(jbRootPathC("/Library/MobileSubstrate/DynamicLibraries/OneSettings.dylib"), RTLD_LAZY)
#define kOrion dlopen(jbRootPathC("/Library/MobileSubstrate/DynamicLibraries/OrionSettings.dylib"), RTLD_LAZY)
#define kShuffle dlopen(jbRootPathC("/Library/MobileSubstrate/DynamicLibraries/shuffle.dylib"), RTLD_LAZY)


@interface PSUIPrefsListController : PSListController
@end


@interface OrionTweakSpecifiersController : PSListController
@end


@interface TSRootListController : UIViewController
@property (copy, nonatomic) NSString *title;
@end

// Orion

static void (*origOrionVDL)(OrionTweakSpecifiersController *, SEL);
static void overrideOrionVDL(OrionTweakSpecifiersController *self, SEL _cmd) {

	origOrionVDL(self, _cmd);

	[self.table addSubview: [ElixirLabelFactory makeElixirLabel]];
	[ElixirLabelFactory pinElixirLabelToTheTopCenteredOnTheXAxisOfView: self.table];

}

// OneSettings & Shuffle

static void (*origVDL)(PSListController *, SEL);
static void overrideVDL(PSListController *self, SEL _cmd) {

	origVDL(self, _cmd);

	// OneSettings & Shuffle have a search bar so no space at the top :smh:
	UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
	[footerView addSubview: [ElixirLabelFactory makeElixirLabel]];
	[ElixirLabelFactory centerElixirLabelOnBothAxesOfView: footerView];

	self.table.tableFooterView = footerView;

}

// TweakSettings

static void (*origTSVDL)(TSRootListController *, SEL);
static void overrideTSVDL(TSRootListController *self, SEL _cmd) {

	origTSVDL(self, _cmd);

	[ElixirLabelFactory makeElixirLabel];
	self.title = [ElixirLabelFactory tweakCountString];

}

// Stock

static void (*origPSUIPrefsListControllerVDL)(PSUIPrefsListController *, SEL);
static void overridePSUIPrefsListControllerVDL(PSUIPrefsListController *self, SEL _cmd) {

	origPSUIPrefsListControllerVDL(self, _cmd);

	PSSpecifier *emptySpecifier = [PSSpecifier emptyGroupSpecifier];

	[ElixirLabelFactory makeElixirLabel];

	NSString *elixirTweakCountLabel = [ElixirLabelFactory tweakCountString];
	PSSpecifier *elixirSpecifier = [PSSpecifier preferenceSpecifierNamed:elixirTweakCountLabel target:self set:nil get:nil detail:nil cell:PSStaticTextCell edit:nil];
	[elixirSpecifier setProperty:@YES forKey:@"enabled"];
	[self insertContiguousSpecifiers:@[emptySpecifier, elixirSpecifier] afterSpecifier:[self specifierForID:@"APPLE_ACCOUNT"]];

}

__attribute__((constructor)) static void init(void) {

	if(kOneSettings != nil)
		MSHookMessageEx(kClass(@"OSTweaksListController"), @selector(viewDidLoad), (IMP) &overrideVDL, (IMP *) &origVDL);

	else if(kOrion != nil)
		MSHookMessageEx(kClass(@"OrionTweakSpecifiersController"), @selector(viewDidLoad), (IMP) &overrideOrionVDL, (IMP *) &origOrionVDL);

	else if(kShuffle != nil)
		MSHookMessageEx(kClass(@"TweakPreferencesListController"), @selector(viewDidLoad), (IMP) &overrideVDL, (IMP *) &origVDL);

	else MSHookMessageEx(kClass(@"PSUIPrefsListController"), @selector(viewDidLoad), (IMP) &overridePSUIPrefsListControllerVDL, (IMP *) &origPSUIPrefsListControllerVDL);

	if(!kIsCurrentApp(@"com.creaturecoding.tweaksettings")) return;
	MSHookMessageEx(kClass(@"TSRootListController"), @selector(viewDidLoad), (IMP) &overrideTSVDL, (IMP *) &origTSVDL);

}
