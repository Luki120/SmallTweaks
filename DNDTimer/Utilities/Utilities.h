@import CydiaSubstrate;
#import <dlfcn.h>
#import "RootWindow.h"


#define kClass(string) NSClassFromString(string)
#define kUserInterfaceStyle UIScreen.mainScreen.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark
#define kIsFlipConvertInstalled dlopen("/Library/MobileSubstrate/DynamicLibraries/z_FlipConvert.dylib", RTLD_LAZY)

static NSTimer *dndTimer;
static NSDate *timerDate;

@interface CCUIToggleModule : NSObject
- (void)setSelected:(BOOL)selected;
@end


@interface FlipConvert_PlaceHolder : CCUIToggleModule
@property (nonatomic, copy) NSString *flipConvert_id;
@end


@interface CCUIButtonModuleView : UIView
- (UIViewController *)_viewControllerForAncestor;
@end


@interface DNDModeAssertionDetails : NSObject
+ (id)userRequestedAssertionDetailsWithIdentifier:(id)arg1 modeIdentifier:(id)arg2 lifetime:(id)arg3;
@end


@interface DNDModeAssertionService : NSObject
+ (id)serviceForClientIdentifier:(id)arg1;
- (id)takeModeAssertionWithDetails:(id)arg1 error:(id *)arg2;
- (BOOL)invalidateAllActiveModeAssertionsWithError:(id *)arg1;
@end

/*--- do yourself a favor and become a giga chad by avoiding code duplication
as much as possible :frCoal: ---*/

static void activateDND() {

	DNDModeAssertionService *assertionService = (DNDModeAssertionService *)[kClass(@"DNDModeAssertionService") serviceForClientIdentifier:@"com.apple.donotdisturb.control-center.module"];
	DNDModeAssertionDetails *newAssertion = [NSClassFromString(@"DNDModeAssertionDetails") userRequestedAssertionDetailsWithIdentifier:@"com.apple.control-center.manual-toggle" modeIdentifier:@"com.apple.donotdisturb.mode.default" lifetime:nil];
	[assertionService takeModeAssertionWithDetails:newAssertion error:NULL];
	[NSNotificationCenter.defaultCenter postNotificationName:@"SBQuietModeStatusChangedNotification" object:nil];

}

static void tearDownDND() {

	DNDModeAssertionService *assertionService = (DNDModeAssertionService *)[kClass(@"DNDModeAssertionService") serviceForClientIdentifier:@"com.apple.donotdisturb.control-center.module"];
	[assertionService invalidateAllActiveModeAssertionsWithError:NULL];
	[NSNotificationCenter.defaultCenter postNotificationName:@"SBQuietModeStatusChangedNotification" object:nil];

}

static void saveUserDefaults() {

	timerDate = dndTimer.fireDate;
	[NSUserDefaults.standardUserDefaults setObject:timerDate forKey:@"dndTimerValue"];

}

static void overrideUserInterfaceStyle(UIAlertController *controller) {

	/*--- The CC forces light mode, so we have to manually set the styles smh ---*/	
	controller.overrideUserInterfaceStyle = kUserInterfaceStyle ? UIUserInterfaceStyleDark : UIUserInterfaceStyleLight;

}

static void addTextFieldWithConfigurationHandlerForAlertController(
	UIAlertController *controller,
	void(^handler)(UITextField *textField)) {

	[controller addTextFieldWithConfigurationHandler: handler];

}

static void configureTextFieldForTextField(UITextField *textField) {

	textField.placeholder = @"Example: 60";
	textField.keyboardType = UIKeyboardTypeNumberPad;

}

static void createTapRecognizerForAlertController(UIAlertController *controller, id self, SEL selector) {

	controller.view.superview.userInteractionEnabled = YES;

	UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action: selector];
	[controller.view.superview addGestureRecognizer: gestureRecognizer];

}

static void dismissVCAnimated() {

	[[RootWindow keyWindow].rootViewController dismissViewControllerAnimated:YES completion:nil];

}
