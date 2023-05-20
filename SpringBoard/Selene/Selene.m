/*--- Triple tap on the LS to save the stock wallapers on the fly ---*/

@import UIKit;
@import CydiaSubstrate;
#import "Common/Common.h"


extern CFArrayRef CPBitmapCreateImagesFromData(CFDataRef cpbitmap, void *, int, void *);

static NSString *const kWallPath = rootlessPathNS(@"/var/mobile/Library/SpringBoard/LockBackground.cpbitmap");
static NSString *const kDarkWallPath = rootlessPathNS(@"/var/mobile/Library/SpringBoard/LockBackgrounddark.cpbitmap");

static BOOL yes;
static NSInteger wallType;

static UITapGestureRecognizer *tapGestureRecognizer;

#define kClass(string) NSClassFromString(string)

static void loadWithoutAFuckingRespring() {

	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: kPlistPath];
	NSMutableDictionary *prefs = dict ? [dict mutableCopy] : [NSMutableDictionary dictionary];

	yes = prefs[@"yes"] ? [prefs[@"yes"] boolValue] : NO;
	wallType = prefs[@"wallType"] ? [prefs[@"wallType"] integerValue] : 0;

}


@interface CSCoverSheetViewController : UIViewController
- (void)saveWall;
@end


@interface UIViewController (KeyWindow)
- (UIWindow *)keyWindow;
@end


@implementation UIViewController (KeyWindow)

- (UIWindow *)keyWindow {

	UIWindow *rootWindow = nil;
	NSArray *windows = UIApplication.sharedApplication.windows;

	for(UIWindow *window in windows)

		if(window.isKeyWindow) {
			rootWindow = window;
			break;
		}

	return rootWindow;

}

@end


static void new_createTapGesture(CSCoverSheetViewController *self, SEL _cmd) {

	loadWithoutAFuckingRespring();
	[self.view removeGestureRecognizer: tapGestureRecognizer];

	if(!yes) return;

	tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selene_didTripleTap)];
	tapGestureRecognizer.numberOfTapsRequired = 3;
	[self.view addGestureRecognizer: tapGestureRecognizer];

}

static void new_selene_didTripleTap(CSCoverSheetViewController *self, SEL _cmd) {

	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Selene" message:@"Do you want to save this wallpaper?" preferredStyle:UIAlertControllerStyleActionSheet];

	UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

		[self saveWall];

	}];

	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Not now" style:UIAlertActionStyleCancel handler:nil];

	[alertController addAction: confirmAction];
	[alertController addAction: cancelAction];

	[[self keyWindow].rootViewController presentViewController:alertController animated:YES completion:nil];

}

static void new_saveWall(CSCoverSheetViewController *self, SEL _cmd) {

	NSData *lsWallpaperData;
	NSString *const kDarkPath = [[NSFileManager defaultManager] fileExistsAtPath: kDarkWallPath] ? kDarkWallPath : kWallPath;

	switch(wallType) {
		case 0: lsWallpaperData = [NSData dataWithContentsOfFile: kDarkPath]; break;
		case 1: lsWallpaperData = [NSData dataWithContentsOfFile: kWallPath]; break;
	}

	CFDataRef lsWallpaperDataRef = (__bridge CFDataRef)lsWallpaperData;
	CFArrayRef imageArray = CPBitmapCreateImagesFromData(lsWallpaperDataRef, NULL, 1, NULL);
	UIImage *wallpaperImage = [UIImage imageWithCGImage:(CGImageRef)CFArrayGetValueAtIndex(imageArray, 0)];
	CFRelease(imageArray);

	UIImageWriteToSavedPhotosAlbum(wallpaperImage, nil, nil, nil);

}

static void (*origVDL)(CSCoverSheetViewController *, SEL);
static void overrideVDL(CSCoverSheetViewController *self, SEL _cmd) {

	origVDL(self, _cmd);
	new_createTapGesture(self, _cmd);

	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(createTapGesture) name:SeleneDidCreateTapGestureNotification object:nil];

}

__attribute__((constructor)) static void init(void) {

	MSHookMessageEx(kClass(@"CSCoverSheetViewController"), @selector(viewDidLoad), (IMP) &overrideVDL, (IMP *) &origVDL);

	class_addMethod(kClass(@"CSCoverSheetViewController"), @selector(createTapGesture), (IMP) &new_createTapGesture, "v@:");
	class_addMethod(kClass(@"CSCoverSheetViewController"), @selector(selene_didTripleTap), (IMP) &new_selene_didTripleTap, "v@:");
	class_addMethod(kClass(@"CSCoverSheetViewController"), @selector(saveWall), (IMP) &new_saveWall, "v@:");

}
