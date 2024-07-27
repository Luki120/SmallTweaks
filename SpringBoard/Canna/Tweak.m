/*--- Changes the default lock & charging sounds to the iOS 6 (or custom) ones ---*/

@import AudioToolbox;
@import CydiaSubstrate;
#import <rootless.h>


@interface SBUIController: NSObject
- (BOOL)_powerSourceWantsToPlayChime;
@end


@class SBSleepWakeHardwareButtonInteraction;

#define jbRootPath(path) ROOT_PATH_NS(path)

static void createSystemSoundFromPath(NSString *path) {

	SystemSoundID sound = 0;
	AudioServicesDisposeSystemSoundID(sound);
	AudioServicesCreateSystemSoundID((__bridge CFURLRef) [NSURL fileURLWithPath: jbRootPath(path)], &sound);
	AudioServicesPlaySystemSound((SystemSoundID) sound);

}

static void (*origPlayChargingChimeIfAppropriate)(SBUIController *, SEL);
static void overridePlayChargingChimeIfAppropriate(SBUIController *self, SEL _cmd) {

	if(![self _powerSourceWantsToPlayChime]) return origPlayChargingChimeIfAppropriate(self, _cmd);
	createSystemSoundFromPath(@"/Library/Tweak Support/Canna/connect_power.caf");

}

static void overridePlayLockSound(SBSleepWakeHardwareButtonInteraction *self, SEL _cmd) {

	createSystemSoundFromPath(@"/Library/Tweak Support/Canna/lock.caf");

}

__attribute__((constructor)) static void init(void) {

	MSHookMessageEx(NSClassFromString(@"SBUIController"), @selector(playChargingChimeIfAppropriate), (IMP) &overridePlayChargingChimeIfAppropriate, (IMP *) &origPlayChargingChimeIfAppropriate);
	MSHookMessageEx(NSClassFromString(@"SBSleepWakeHardwareButtonInteraction"), @selector(_playLockSound), (IMP) &overridePlayLockSound, (IMP *) NULL);

}
