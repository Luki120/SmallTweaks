@import UIKit;
@import CydiaSubstrate;
@import LocalAuthentication;
#import "Headers/Common.h"


@interface PXNavigationListGadget : UIViewController
@end

static BOOL isKaiaToggleSelected;

static void (*origVDL)(PXNavigationListGadget *, SEL);
static void overrideVDL(PXNavigationListGadget *self, SEL _cmd) {

	origVDL(self, _cmd);

	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(didSelectKaiaToggle:) name:KaiaDidSelectToggleNotification object:nil];
	[NSDistributedNotificationCenter.defaultCenter postNotificationName:KaiaDidRetrieveToggleStateNotification object:nil];

}

static void (*origDidSelectRowAtIndexPath)(PXNavigationListGadget *, SEL, UITableView *, NSIndexPath *);
static void overrideDidSelectRowAtIndexPath(PXNavigationListGadget *self, SEL _cmd, UITableView *tableView, NSIndexPath *indexPath) {

	if(!isKaiaToggleSelected) return origDidSelectRowAtIndexPath(self, _cmd, tableView, indexPath);

	UITableViewCell *cell = [tableView cellForRowAtIndexPath: indexPath];
	if(![cell isKindOfClass:NSClassFromString(@"PXNavigationListCell")] || indexPath.row != 1)
		return origDidSelectRowAtIndexPath(self, _cmd, tableView, indexPath);

	[[LAContext new] evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"Show yourself bozo, authenticate" reply:^(BOOL success, NSError *error) {
		if(!success || error) {
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
			return;
		}
		else
			dispatch_async(dispatch_get_main_queue(), ^{ origDidSelectRowAtIndexPath(self, _cmd, tableView, indexPath); });
	}];

}

static void new_didSelectKaiaToggle(PXNavigationListGadget *self, SEL _cmd, NSNotification *notification) {

	NSNumber *kaiaToggleSelected = notification.userInfo[@"kaiaToggleSelected"];
	isKaiaToggleSelected = kaiaToggleSelected.boolValue;

}


__attribute__((constructor)) static void init() {

	MSHookMessageEx(NSClassFromString(@"PXNavigationListGadget"), @selector(viewDidLoad), (IMP) &overrideVDL, (IMP *) &origVDL);
	MSHookMessageEx(NSClassFromString(@"PXNavigationListGadget"), @selector(tableView:didSelectRowAtIndexPath:), (IMP) &overrideDidSelectRowAtIndexPath, (IMP *) &origDidSelectRowAtIndexPath);

	class_addMethod(
		NSClassFromString(@"PXNavigationListGadget"),
		@selector(didSelectKaiaToggle:),
		(IMP) &new_didSelectKaiaToggle,
		"v@:@"
	);

}
