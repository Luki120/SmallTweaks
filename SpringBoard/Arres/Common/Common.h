#import <rootless.h>

#define rootlessPathC(cPath) ROOT_PATH(cPath)
#define rootlessPathNS(path) ROOT_PATH_NS(path)

static NSString *const kPath = rootlessPathNS(@"/var/mobile/Library/Preferences/me.luki.arresprefs.plist");

static NSNotificationName const ArresNotificationArrivedNotification = @"ArresNotificationArrivedNotification";

@interface NSDistributedNotificationCenter : NSNotificationCenter
@end
