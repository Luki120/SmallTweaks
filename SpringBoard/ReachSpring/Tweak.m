/*--- Trigger respring with the reachability gesture ---*/

@import AudioToolbox.AudioServices;
@import CydiaSubstrate;
@import Foundation;
#import <spawn.h>
#import <rootless.h>
#import <FrontBoardServices/FBSSystemService.h>
#import <SpringBoardServices/SBSRelaunchAction.h>

@class SBReachabilityManager;

static void overrideUpdateReachabilityModeActive(SBReachabilityManager *self, SEL _cmd, BOOL active) {

	if(!active) return;

	AudioServicesPlaySystemSound(1520);

    SBSRelaunchAction *restartAction = [SBSRelaunchAction actionWithReason:@"RestartRenderServer" options:SBSRelaunchActionOptionsFadeToBlackTransition targetURL: nil];
    [[FBSSystemService sharedService] sendActions:[NSSet setWithObject:restartAction] withResult: nil];

}

__attribute__((constructor)) static void init(void) {

	MSHookMessageEx(NSClassFromString(@"SBReachabilityManager"), @selector(_updateReachabilityModeActive:), (IMP) &overrideUpdateReachabilityModeActive, (IMP *) NULL);

}
