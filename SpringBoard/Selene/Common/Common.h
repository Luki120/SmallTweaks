#import <rootless.h>

#define jbRootPath(path) ROOT_PATH_NS(path)

static NSString *const kSuiteName = @"me.luki.seleneprefs";
static NSNotificationName const SeleneDidCreateTapGestureNotification = @"SeleneDidCreateTapGestureNotification";

@interface NSDistributedNotificationCenter : NSNotificationCenter
@end
