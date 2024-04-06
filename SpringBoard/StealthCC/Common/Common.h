#import <rootless.h>

#define jbRootPath(path) ROOT_PATH_NS(path)

static NSString *const kSuiteName = @"me.luki.stealthccprefs";
static NSNotificationName const StealthCCDidApplyCustomBlurNotification = @"StealthCCDidApplyCustomBlurNotification";

@interface NSDistributedNotificationCenter : NSNotificationCenter
@end
