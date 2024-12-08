/*--- Automatically respring your device every 15 seconds, made as a bounty ---*/

#import <spawn.h>
#import "Headers/Common.h"
@import UIKit.UIApplication;


static id<NSObject> observer;
static id<NSObject> prefsObserver;
static NSTimer *_timer;

static BOOL enableAutoRespring;

static void loadShit(void) {
	NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName: kSuiteName];
	enableAutoRespring = [prefs objectForKey: @"enableAutoRespring"] ? [prefs boolForKey: @"enableAutoRespring"] : NO;
}

static void killBackboard(void) {
	pid_t pid;
	const char* args[] = { "killall", "backboardd", NULL };
	posix_spawn(&pid, ROOT_PATH("/usr/bin/killall"), NULL, NULL, (char* const *)args, NULL);
}

static void setAutoRespring(void) {
	loadShit();

	if(!enableAutoRespring) {
		[_timer invalidate];
		_timer = nil;
		return;
	}

	_timer = [NSTimer scheduledTimerWithTimeInterval:15 repeats:NO block:^(NSTimer *timer) { killBackboard(); }];
}

static void appDidFinishLaunching(void) {
	observer = [NSNotificationCenter.defaultCenter addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
		setAutoRespring();

		prefsObserver = [NSDistributedNotificationCenter.defaultCenter addObserverForName:AutoRespringDidEnableTweakNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
			setAutoRespring();
		}];

		[NSNotificationCenter.defaultCenter removeObserver: observer];
	}];
}

__attribute__((constructor)) static void init(void) {
	loadShit();
	appDidFinishLaunching();
}
