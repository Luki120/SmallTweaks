/* --- Removes the annoying parental advisory
label in Netflix which pops everytime you watch
your tv show or movie, annoying af ---*/

@import Foundation;
@import CydiaSubstrate;


@class NFUIPlaybackAdvisoryController;

static void fuckOffTimer(NFUIPlaybackAdvisoryController *self, SEL _cmd) {}

__attribute__((constructor)) static void init() {

    MSHookMessageEx(NSClassFromString(@"NFUIPlaybackAdvisoryController"), @selector(setupTimer), (IMP) &fuckOffTimer, (IMP *) NULL);

}
