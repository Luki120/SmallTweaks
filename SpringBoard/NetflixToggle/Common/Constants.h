#import <rootless.h>

#define rootlessPathC(cPath) ROOT_PATH(cPath)
#define rootlessPathNS(path) ROOT_PATH_NS(path)

static NSString *const kPrysm = rootlessPathNS(@"/Library/MobileSubstrate/DynamicLibraries/Prysm.dylib");
static NSNotificationName const NetflixToggleDidDismissPrysmCCNotification = @"NetflixToggleDidDismissPrysmCCNotification";
