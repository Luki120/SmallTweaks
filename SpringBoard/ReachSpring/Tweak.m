/*--- Trigger respring with the reachability gesture ---*/

@import AudioToolbox.AudioServices;
@import CydiaSubstrate;
@import Foundation;
#import <spawn.h>


@class SBReachabilityManager;

static void (*origUpdateReachabilityModeActive)(SBReachabilityManager *, SEL, BOOL);
static void overrideUpdateReachabilityModeActive(SBReachabilityManager *self, SEL _cmd, BOOL active) {

	origUpdateReachabilityModeActive(self, _cmd, active);
	if(!active) return;

	AudioServicesPlaySystemSound(1520);

	pid_t pid;
	const char *args[] = {"killall", "backboardd", NULL, NULL};
	posix_spawn(&pid, "usr/bin/killall", NULL, NULL, (char *const *)args, NULL);

}

__attribute__((constructor)) static void init() {

	MSHookMessageEx(NSClassFromString(@"SBReachabilityManager"), @selector(_updateReachabilityModeActive:), (IMP) &overrideUpdateReachabilityModeActive, (IMP *) &origUpdateReachabilityModeActive);

}
