#import <rootless.h>

#define rootlessPathC(cPath) ROOT_PATH(cPath)
#define rootlessPathNS(path) ROOT_PATH_NS(path)

static NSString *const kPlistPath = rootlessPathNS(@"/var/mobile/Library/Preferences/me.luki.seleneprefs.plist");
static NSNotificationName const SeleneDidCreateTapGestureNotification = @"SeleneDidCreateTapGestureNotification";

@interface NSDistributedNotificationCenter : NSNotificationCenter
@end
