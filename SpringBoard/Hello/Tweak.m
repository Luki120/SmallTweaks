/*--- Change the status bar string to a "Hello" one with a nice good looking font,
credits to ETHN for the font included in his tweak Greeting ---*/

// context -> https://www.reddit.com/r/jailbreak/comments/s3oa5y/question_anyone_know_this_tweak_or_how_to_replace/
// but anyways fuck that sub and their discord :frCoal:

@import UIKit;
@import CoreText;
@import CydiaSubstrate;
#import <rootless.h>

#define jbRootPath(path) ROOT_PATH_NS(path)


@interface _UIStatusBarStringView : UILabel
@end


static NSString *timeString = nil;

#define kClass(string) NSClassFromString(string)

static id (*origIWF)(_UIStatusBarStringView *, SEL, CGRect);
static id overrideIWF(_UIStatusBarStringView *self, SEL _cmd, CGRect frame) { // load font

	NSString *fontPath = jbRootPath(@"/Library/Tweak Support/Hello/IntroScript-Bold.ttf");

	NSData *fontData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath: fontPath]];
	CFErrorRef error;
	CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)fontData);
	CGFontRef font = CGFontCreateWithDataProvider(provider);

	if(!CTFontManagerRegisterGraphicsFont(font, &error)) {
		CFStringRef errorDescription = CFErrorCopyDescription(error);
		CFRelease(errorDescription);
	}

	CFRelease(font);
	CFRelease(provider);

	return origIWF(self, _cmd, frame);

}

static void (*origST)(_UIStatusBarStringView *, SEL, NSString *);
static void overrideST(_UIStatusBarStringView *self, SEL _cmd, NSString *origString) {

	if(![origString containsString: @":"]) return origST(self, _cmd, origString);

	origST(self, _cmd, origString);

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

		timeString = origString;
		origST(self, _cmd, @"hello.");
		[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(crossDissolveLabel) userInfo:nil repeats:NO];

	});

}

static void (*origDMTS)(_UIStatusBarStringView *, SEL);
static void overrideDMTS(_UIStatusBarStringView *self, SEL _cmd) {

	if(![self.text containsString: @"hello."]) return origDMTS(self, _cmd);

	origDMTS(self, _cmd);
	self.font = [UIFont fontWithName:@"IntroScript-Bold" size: 14];

}

static void new_crossDissolveLabel(_UIStatusBarStringView *self, SEL _cmd) {

	[UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

		origST(self, _cmd, @"");
		origST(self, _cmd, timeString);
		self.font = [UIFont systemFontOfSize:12 weight: UIFontWeightSemibold];

	} completion:nil];

}

__attribute__((constructor)) static void init(void) {

	MSHookMessageEx(kClass(@"_UIStatusBarStringView"), @selector(initWithFrame:), (IMP) &overrideIWF, (IMP *) &origIWF);
	MSHookMessageEx(kClass(@"_UIStatusBarStringView"), @selector(setText:), (IMP) &overrideST, (IMP *) &origST);
	MSHookMessageEx(kClass(@"_UIStatusBarStringView"), @selector(didMoveToSuperview), (IMP) &overrideDMTS, (IMP *) &origDMTS);

	class_addMethod(
		kClass(@"_UIStatusBarStringView"),
		@selector(crossDissolveLabel),
		(IMP) &new_crossDissolveLabel,
		"v@:"
	);

}
