#import <rootless.h>

static NSString *const kSuiteName = @"me.luki.autorespringprefs";
static NSNotificationName const AutoRespringDidEnableTweakNotification = @"AutoRespringDidEnableTweakNotification";

@interface NSDistributedNotificationCenter: NSNotificationCenter
@end
