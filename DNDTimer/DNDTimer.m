/*--- Set a custom duration for DND when toggling the cc module,
made as a bounty, and before the publicly available alternative ---*/

#import "Utilities/Utilities.h"

static NSNotificationName const DNDTimerDidResumeTimerNotification = @"DNDTimerDidResumeTimerNotification";

static void (*origHandlePressGesture)(CCUIButtonModuleView *, SEL, id);
static void overrideHandlePressGesture(CCUIButtonModuleView *self, SEL _cmd, id gesture) {

	__block id observer;

	UIViewController *ancestor = [self _viewControllerForAncestor];
	if(![ancestor isKindOfClass:NSClassFromString(@"DNDUIControlCenterModule")]) return origHandlePressGesture(self, _cmd, gesture);

	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"DNDTimer" message:@"Select the time you wish for DND to be active. It has to be inputted in minutes." preferredStyle:UIAlertControllerStyleAlert];	

	overrideUserInterfaceStyle(alertController);

	UIAlertAction *setDNDTimerAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

		activateDND();
		dndTimer = [NSTimer scheduledTimerWithTimeInterval:alertController.textFields.firstObject.text.doubleValue * 60 target:self selector:@selector(stock_deactivateDND) userInfo:nil repeats:NO];
		saveUserDefaults();

		[NSNotificationCenter.defaultCenter removeObserver: observer];

	}];
	setDNDTimerAction.enabled = NO;

	UIAlertAction *resetDNDTimerAction = [UIAlertAction actionWithTitle:@"Reset Timer" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {

		[dndTimer invalidate];
		dndTimer = nil;
		tearDownDND();

		[NSNotificationCenter.defaultCenter removeObserver: observer];

	}];

	addTextFieldWithConfigurationHandlerForAlertController(alertController, ^(UITextField *textField) {

		configureTextFieldForTextField(textField);

		observer = [NSNotificationCenter.defaultCenter addObserverForName:UITextFieldTextDidChangeNotification object:textField queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
			setDNDTimerAction.enabled = textField.text.integerValue != 0;
		}];	

	});

	[alertController addAction: setDNDTimerAction];
	[alertController addAction: resetDNDTimerAction];

	[[RootWindow keyWindow].rootViewController presentViewController:alertController animated:YES completion:^{

		createTapRecognizerForAlertController(alertController, self, @selector(stock_didTapView));

	}];

}

static void new_stock_didTapView(CCUIButtonModuleView *self, SEL _cmd) { dismissVCAnimated(); }
static void new_stock_deactivateDND(CCUIButtonModuleView *self, SEL _cmd) { tearDownDND(); }

static void (*origSetSelected)(FlipConvert_PlaceHolder *, SEL, BOOL);
static void overrideSetSelected(FlipConvert_PlaceHolder *self, SEL _cmd, BOOL selected) {

	if(![self.flipConvert_id isEqualToString:@"com.a3tweaks.switch.do-not-disturb"]) return origSetSelected(self, _cmd, selected);

	if(!selected) {

		__block id observer;

		UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"DNDTimer" message:@"Select the time you wish for DND to be active. Time has to be inputted in minutes." preferredStyle:UIAlertControllerStyleAlert];

		overrideUserInterfaceStyle(alertController);

		UIAlertAction *setDNDTimerAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

			origSetSelected(self, _cmd, selected); // the method enables/disables DND by itself so no need to do it myself :TimPog:
			dndTimer = [NSTimer scheduledTimerWithTimeInterval:alertController.textFields.firstObject.text.doubleValue * 60 target:self selector:@selector(flipConvert_deactivateDND) userInfo:nil repeats:NO];
			saveUserDefaults();

			[NSNotificationCenter.defaultCenter removeObserver: observer];

		}];

		UIAlertAction *resetDNDTimerAction = [UIAlertAction actionWithTitle:@"Reset Timer" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {

			[dndTimer invalidate];
			dndTimer = nil;

			[NSNotificationCenter.defaultCenter removeObserver: observer];

		}];

		addTextFieldWithConfigurationHandlerForAlertController(alertController, ^(UITextField *textField) {

			configureTextFieldForTextField(textField);

			observer = [NSNotificationCenter.defaultCenter addObserverForName:UITextFieldTextDidChangeNotification object:textField queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
				setDNDTimerAction.enabled = textField.text.integerValue != 0;
			}];

		});

		[alertController addAction: setDNDTimerAction];
		[alertController addAction: resetDNDTimerAction];

		[[RootWindow keyWindow].rootViewController presentViewController:alertController animated:YES completion:^{

			createTapRecognizerForAlertController(alertController, self, @selector(flipConvert_didTapView));

		}];

	}

	else if(!selected) origSetSelected(self, _cmd, selected); // we need to call this so the toggle doesn't get stuck in the selected state

}

static void new_flipConvert_didTapView(FlipConvert_PlaceHolder *self, SEL _cmd) { dismissVCAnimated(); }
static void new_flipConvert_deactivateDND(FlipConvert_PlaceHolder *self, SEL _cmd) { [self setSelected: NO]; }

static id observer;
static id sbObserver;

static void appDidFinishLaunching() {

	sbObserver = [NSNotificationCenter.defaultCenter addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {

		observer = [NSNotificationCenter.defaultCenter addObserverForName:DNDTimerDidResumeTimerNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
			tearDownDND();
			[NSNotificationCenter.defaultCenter removeObserver: observer];
		}];

		[NSNotificationCenter.defaultCenter removeObserver: sbObserver];

	}];

}

static void resumeTimer() {

	timerDate = [NSUserDefaults.standardUserDefaults objectForKey:@"dndTimerValue"];
	NSTimeInterval timeInterval = [timerDate timeIntervalSinceNow];

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, timeInterval * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

		[NSNotificationCenter.defaultCenter postNotificationName:DNDTimerDidResumeTimerNotification object:nil];

	});

}

@class SBBacklightController;

static void (*origTurnOnScreenFullyWithBacklightSource)(SBBacklightController *, SEL, NSInteger);
static void overrideTurnOnScreenFullyWithBacklightSource(SBBacklightController *self, SEL _cmd, NSInteger source) {

	origTurnOnScreenFullyWithBacklightSource(self, _cmd, source);
	resumeTimer();

}

__attribute__((constructor)) static void init() {

	appDidFinishLaunching();
	resumeTimer();

	if(!kIsFlipConvertInstalled) {

		MSHookMessageEx(NSClassFromString(@"CCUIButtonModuleView"), @selector(_handlePressGesture:), (IMP) &overrideHandlePressGesture, (IMP *) &origHandlePressGesture);

		class_addMethod(kClass(@"CCUIButtonModuleView"), @selector(stock_didTapView), (IMP) &new_stock_didTapView, "v@:");
		class_addMethod(kClass(@"CCUIButtonModuleView"), @selector(stock_deactivateDND), (IMP) &new_stock_deactivateDND, "v@:");

	}

	else {

		MSHookMessageEx(NSClassFromString(@"FlipConvert_PlaceHolder"), @selector(setSelected:), (IMP) &overrideSetSelected, (IMP *) &origSetSelected);

		class_addMethod(kClass(@"FlipConvert_PlaceHolder"), @selector(flipConvert_didTapView), (IMP) &new_flipConvert_didTapView, "v@:");
		class_addMethod(kClass(@"FlipConvert_PlaceHolder"), @selector(flipConvert_deactivateDND), (IMP) &new_flipConvert_deactivateDND, "v@:");

	}

	MSHookMessageEx(NSClassFromString(@"SBBacklightController"), @selector(turnOnScreenFullyWithBacklightSource:), (IMP) &overrideTurnOnScreenFullyWithBacklightSource, (IMP *) &origTurnOnScreenFullyWithBacklightSource);

}
