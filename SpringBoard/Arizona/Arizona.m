/*--- Move the stock clock, date & lock glyph on the fly ---*/

@import UIKit;
@import CydiaSubstrate;
#import "Common/Common.h"


@interface SBFLockScreenDateView : UIView
@end


@interface SBUIProudLockIconView : UIView
- (void)updateLockGlyphPosition;
@end


static BOOL yes;
static NSInteger position;

static BOOL alternatePosition;
static BOOL lockGlyphPosition;

static float coordinatesForX;
static float coordinatesForY;
static float lockCoordinatesForX;
static float lockCoordinatesForY;

#define kLatchKey jbRootPath(@"/Library/MobileSubstrate/DynamicLibraries/LatchKey.dylib")

static void loadWithoutAFuckingRespring() {

	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: kPath];
	NSMutableDictionary *prefs = dict ? [dict mutableCopy] : [NSMutableDictionary dictionary];

	yes = prefs[@"yes"] ? [prefs[@"yes"] boolValue] : NO;
	position = prefs[@"position"] ? [prefs[@"position"] integerValue] : 2;
	alternatePosition = prefs[@"alternatePosition"] ? [prefs[@"alternatePosition"] boolValue] : NO;
	lockGlyphPosition = prefs[@"lockGlyphPosition"] ? [prefs[@"lockGlyphPosition"] boolValue] : NO;
	coordinatesForX = prefs[@"coordinatesForX"] ? [prefs[@"coordinatesForX"] floatValue] : 0;
	coordinatesForY = prefs[@"coordinatesForY"] ? [prefs[@"coordinatesForY"] floatValue] : 0;
	lockCoordinatesForX = prefs[@"lockXValue"] ? [prefs[@"lockXValue"] floatValue] : 0;
	lockCoordinatesForY = prefs[@"lockYValue"] ? [prefs[@"lockYValue"] floatValue] : 0;

}

static void (*origSetAlignmentPercent)(SBFLockScreenDateView *, SEL, CGFloat);
static void overrideSetAlignmentPercent(SBFLockScreenDateView *self, SEL _cmd, CGFloat percent) {

	origSetAlignmentPercent(self, _cmd, percent);

	loadWithoutAFuckingRespring();

	if(!yes) return;

	switch(position) {
		case 0: origSetAlignmentPercent(self, _cmd, -1); break; // left
		case 1: origSetAlignmentPercent(self, _cmd, 0); break; // center
		case 2: origSetAlignmentPercent(self, _cmd, 1); break; // right
	}

}

static void (*origSetFrame)(SBFLockScreenDateView *, SEL, CGRect);
static void overrideSetFrame(SBFLockScreenDateView *self, SEL _cmd, CGRect frame) {

	origSetFrame(self, _cmd, frame);

	loadWithoutAFuckingRespring();

	if(!alternatePosition) return;

	CGRect newFrame = CGRectMake(coordinatesForX, coordinatesForY, frame.size.width, frame.size.height);
	origSetFrame(self, _cmd, newFrame);

}

static void new_updateLockGlyphPosition(SBUIProudLockIconView *self, SEL _cmd) {

	loadWithoutAFuckingRespring();

	if(lockGlyphPosition) self.frame = CGRectMake(lockCoordinatesForX, lockCoordinatesForY, self.frame.size.width, self.frame.size.height);
	else self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);

}

static void (*origDMTS)(SBUIProudLockIconView *, SEL);
static void overrideDMTS(SBUIProudLockIconView *self, SEL _cmd) {

	origDMTS(self, _cmd);
	[self updateLockGlyphPosition];

	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(updateLockGlyphPosition) name:ArizonaDidUpdateGlyphOriginNotification object:nil];

}

static void (*origLayoutSubviews)(SBUIProudLockIconView *, SEL);
static void overrideLayoutSubviews(SBUIProudLockIconView *self, SEL _cmd) {

	origLayoutSubviews(self, _cmd);
	[self updateLockGlyphPosition];

}


__attribute__((constructor)) static void init(void) {

	loadWithoutAFuckingRespring();

	MSHookMessageEx(NSClassFromString(@"SBFLockScreenDateView"), @selector(setAlignmentPercent:), (IMP) &overrideSetAlignmentPercent, (IMP *) &origSetAlignmentPercent);
	MSHookMessageEx(NSClassFromString(@"SBFLockScreenDateView"), @selector(setFrame:), (IMP) &overrideSetFrame, (IMP *) &origSetFrame);

	if([[NSFileManager defaultManager] fileExistsAtPath: kLatchKey]) return;

	MSHookMessageEx(NSClassFromString(@"SBUIProudLockIconView"), @selector(didMoveToSuperview), (IMP) &overrideDMTS, (IMP *) &origDMTS);
	MSHookMessageEx(NSClassFromString(@"SBUIProudLockIconView"), @selector(layoutSubviews), (IMP) &overrideLayoutSubviews, (IMP *) &origLayoutSubviews);

	class_addMethod(
		NSClassFromString(@"SBUIProudLockIconView"),
		@selector(updateLockGlyphPosition),
		(IMP) &new_updateLockGlyphPosition,
		"v@:"
	);

}
