#import <rootless.h>

#define jbRootPath(path) ROOT_PATH_NS(path)
#define kPath jbRootPath(@"/var/mobile/Library/Preferences/me.luki.bscimageprefs.plist")

static NSNotificationName const BSCImageApplyImageNotification = @"BSCImageApplyImageNotification";

@interface NSDistributedNotificationCenter : NSNotificationCenter
@end
