/*--- Get an alert confirmation before liking an Instagram post or following a user ---*/

@import UIKit;
@import CydiaSubstrate;


@interface IGUFIButtonBarView : UIView
@end


@interface IGFeedPhotoView : UIView
@end


@interface IGFollowButton : UIButton
@end


@interface IGFollowController : UIViewController
@end


@interface IGMedia : NSObject
@end


#define kClass(string) NSClassFromString(string)

static BOOL hasLiked;
static NSInteger followState;

static UIViewController *getRootVC() {

	UIViewController *rootVC = nil;
	NSSet *connectedScenes = [UIApplication sharedApplication].connectedScenes;

	for(UIScene *scene in connectedScenes) {
		if(scene.activationState != UISceneActivationStateForegroundActive
			|| ![scene isKindOfClass:[UIWindowScene class]]) return nil;

		UIWindowScene *windowScene = (UIWindowScene *)scene;
		for(UIWindow *window in windowScene.windows) {
			rootVC = window.rootViewController;
			break;
		}

	}

	return rootVC;

}

static void presentIGConfirmAlertController(NSString *message, void(^handler)(UIAlertAction *confirmAction)) {

	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"IGConfirm" message:message preferredStyle:UIAlertControllerStyleActionSheet];

	UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler: handler];
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Oops" style:UIAlertActionStyleCancel handler:nil];

	[alertController addAction: confirmAction];
	[alertController addAction: cancelAction];

	[getRootVC() presentViewController:alertController animated:YES completion:nil];

}

static BOOL (*origHasLiked)(IGMedia *, SEL);
static BOOL overrideHasLiked(IGMedia *self, SEL _cmd) {

	hasLiked = origHasLiked(self, _cmd);
	return hasLiked;

}

static NSInteger (*origButtonState)(IGFollowButton *, SEL);
static NSInteger overrideButtonState(IGFollowButton *self, SEL _cmd) {

	followState = origButtonState(self, _cmd);
	return followState;

}

static void (*origDidPressFollowButton)(IGFollowController *, SEL);
static void overrideDidPressFollowButton(IGFollowController *self, SEL _cmd) {

	/*--- 

	2 == not following, 
	3 == following and not in your close friends, 
	4 == requested, 
	6 == not following back lol,
	8 == following and in your close friends

	---*/

	if(followState == 2 || followState == 6)

		presentIGConfirmAlertController(@"Are you sure you want to follow this user?", ^(UIAlertAction *_) {
			origDidPressFollowButton(self, _cmd);
		});

	else origDidPressFollowButton(self, _cmd);


}

static void (*origOnLikeButtonPressed)(IGUFIButtonBarView *, SEL, id);
static void overrideOnLikeButtonPressed(IGUFIButtonBarView *self, SEL _cmd, id pressed) {

	if(hasLiked) return origOnLikeButtonPressed(self, _cmd, pressed);

	presentIGConfirmAlertController(@"Are you sure you want to like this post?", ^(UIAlertAction *_) {
		origOnLikeButtonPressed(self, _cmd, pressed);
	});

}

static void (*origOnDoubleTap)(IGFeedPhotoView *, SEL, id);
static void overrideOnDoubleTap(IGFeedPhotoView *self, SEL _cmd, id tapped) {

	if(hasLiked) return origOnDoubleTap(self, _cmd, tapped);

	presentIGConfirmAlertController(@"Are you sure you want to like this post?", ^(UIAlertAction *_) {
		origOnDoubleTap(self, _cmd, tapped);
	});

}

__attribute__((constructor)) static void init() {

	MSHookMessageEx(kClass(@"IGMedia"), @selector(hasLiked), (IMP) &overrideHasLiked, (IMP *) &origHasLiked);
	MSHookMessageEx(kClass(@"IGFollowButton"), @selector(buttonState), (IMP) &overrideButtonState, (IMP *) &origButtonState);
	MSHookMessageEx(kClass(@"IGFollowController"), @selector(_didPressFollowButton), (IMP) &overrideDidPressFollowButton, (IMP *) &origDidPressFollowButton);
	MSHookMessageEx(kClass(@"IGUFIButtonBarView"), @selector(_onLikeButtonPressed:), (IMP) &overrideOnLikeButtonPressed, (IMP *) &origOnLikeButtonPressed);
	MSHookMessageEx(kClass(@"IGFeedPhotoView"), @selector(_onDoubleTap:), (IMP) &overrideOnDoubleTap, (IMP *) &origOnDoubleTap);

}
