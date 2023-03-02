/*--- Pop to root in the Zoho Mail app when tapping a tab bar item ---*/

@import libhooker.libblackjack;
@import UIKit;


@interface MailListViewController : UIViewController <UITabBarControllerDelegate>
@end


static void (*origVDL)(MailListViewController *, SEL);
static void overrideVDL(MailListViewController *self, SEL _cmd) {

	/*--- lmao so it seems just assigning the delegate makes
	pop to root work, didn't have to override any delegate methods
	:KanyeWtf: :bThisIsHowItIs: ---*/
	origVDL(self, _cmd);
	self.tabBarController.delegate = self;

}

__attribute__((constructor)) static void init() {

	LBHookMessage(NSClassFromString(@"MailListViewController"), @selector(viewDidLoad), &overrideVDL, &origVDL);

}