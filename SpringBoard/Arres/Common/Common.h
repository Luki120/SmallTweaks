#import <rootless.h>

#define jbRootPath(path) ROOT_PATH_NS(path)

static NSString *const kSuiteName = @"me.luki.arresprefs";

static NSNotificationName const ArresNotificationArrivedNotification = @"ArresNotificationArrivedNotification";

@interface NSDistributedNotificationCenter : NSNotificationCenter
@end
