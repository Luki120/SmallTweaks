@import AudioToolbox.AudioServices;
@import ObjectiveC.message;
@import Preferences.PSSpecifier;
@import Preferences.PSTableCell;
@import Preferences.PSListController;
#import <GcUniversal/HelperFunctions.h>
#import <spawn.h>
#import "Common/Common.h"


@interface OBWelcomeController : UIViewController
- (id)initWithTitle:(id)arg1 detailText:(id)arg2 icon:(id)arg3;
- (void)addBulletedListItemWithTitle:(id)arg1 description:(id)arg2 image:(id)arg3;
@end


@interface _UIBackdropViewSettings : NSObject
+ (id)settingsForStyle:(NSInteger)arg1;
@end


@interface _UIBackdropView : UIView
- (id)initWithFrame:(CGRect)arg1 autosizesToFitSuperview:(BOOL)arg2 settings:(id)arg3;
@end


@interface PSListController (Private)
- (BOOL)containsSpecifier:(PSSpecifier *)arg1;
@end


@interface ArizonaVC : PSListController
@end


@interface ArizonaContributorsVC : PSListController
@end


@interface ArizonaLinksVC : PSListController
@end
