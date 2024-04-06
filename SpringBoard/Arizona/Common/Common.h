#import <rootless.h>

#define jbRootPathC(cPath) ROOT_PATH(cPath)
#define jbRootPath(path) ROOT_PATH_NS(path)

#define kPath jbRootPath(@"/var/mobile/Library/Preferences/me.luki.arizonaprefs.plist")

static NSNotificationName const ArizonaDidUpdateGlyphOriginNotification = @"ArizonaDidUpdateGlyphOriginNotification";

@interface NSDistributedNotificationCenter : NSNotificationCenter
@end
