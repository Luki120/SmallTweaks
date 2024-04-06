/*--- Sample CC toggle to launch Netflix app ---*/

@import Foundation;
@import CydiaSubstrate;
#import "Common/Constants.h"


@class PrysmMainPageViewController;

static void (*origVDL)(PrysmMainPageViewController *, SEL);
static void overrideVDL(PrysmMainPageViewController *self, SEL _cmd) {

	origVDL(self, _cmd);

	/*--- dismissControlCenter is a method from Prysm,
	so no need to make the implementation ourselves :weAreNotTheSame: ---*/
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(dismissControlCenter) name:NetflixToggleDidDismissPrysmCCNotification object:nil];

}

__attribute__((constructor)) static void init(void) {

	if(![[NSFileManager defaultManager] fileExistsAtPath: kPrysm]) return;
	MSHookMessageEx(NSClassFromString(@"PrysmMainPageViewController"), @selector(viewDidLoad), (IMP) &overrideVDL, (IMP *) &origVDL);

}
