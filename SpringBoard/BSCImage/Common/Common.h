#import <rootless.h>

#define rootlessPathC(cPath) ROOT_PATH(cPath)
#define rootlessPathNS(path) ROOT_PATH_NS(path)

static NSString *const kPath = rootlessPathNS(@"/var/mobile/Library/Preferences/me.luki.bscimageprefs.plist");

static NSNotificationName const BSCImageApplyImageNotification = @"BSCImageApplyImageNotification";

@interface NSDistributedNotificationCenter : NSNotificationCenter
@end
