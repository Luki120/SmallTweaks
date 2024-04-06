#import <rootless.h>

#define jbRootPath(path) ROOT_PATH_NS(path)
#define kPrysm jbRootPath(@"/Library/MobileSubstrate/DynamicLibraries/Prysm.dylib")

static NSNotificationName const NetflixToggleDidDismissPrysmCCNotification = @"NetflixToggleDidDismissPrysmCCNotification";
