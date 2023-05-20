/*--- I needed a respring tweak so, shake your device to respring :bThisIsHowItIs: ---*/

@import UIKit;
@import CydiaSubstrate;
#import <spawn.h>
#import <rootless.h>

#define rootlessPathC(cPath) ROOT_PATH(cPath)
#define rootlessPathNS(path) ROOT_PATH_NS(path)


static void (*origMotionEnded)(UIWindow *, SEL, UIEventSubtype, UIEvent *);
static void overrideMotionEnded(UIWindow *self, SEL _cmd, UIEventSubtype motion, UIEvent *event) {

	origMotionEnded(self, _cmd, motion, event);
	if(event.type != UIEventSubtypeMotionShake) return;

	pid_t pid;
	const char* args[] = {"killall", "backboardd", NULL};
	posix_spawn(&pid, rootlessPathC("/usr/bin/killall"), NULL, NULL, (char* const *)args, NULL);

}

__attribute__((constructor)) static void init(void) {

	MSHookMessageEx(NSClassFromString(@"UIWindow"), @selector(motionEnded:withEvent:), (IMP) &overrideMotionEnded, (IMP *) &origMotionEnded);

}
