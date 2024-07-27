/*--- Make Signal believe that we're on an iOS version above their minimum
requirement, in order to prevent the app from eventually "expiring". Made as a bounty ---*/

@import CydiaSubstrate;
@import Foundation;


@class AppExpiryImpl;

static NSUInteger overrideAppExpiredStatusCode(AppExpiryImpl *self, SEL _cmd) {

	return 0;

}

static NSOperatingSystemVersion (*origSystemVersion)(NSProcessInfo *, SEL);
static NSOperatingSystemVersion overrideSystemVersion(NSProcessInfo *self, SEL _cmd) {

	NSOperatingSystemVersion version = origSystemVersion(self, _cmd);
	version.majorVersion = 10000;
	return version;

}

__attribute__((constructor)) static void init(void) {

	Class AppExpiryImpl = objc_getMetaClass("SignalServiceKit.AppExpiryImpl");

	MSHookMessageEx(AppExpiryImpl, @selector(appExpiredStatusCode), (IMP) &overrideAppExpiredStatusCode, NULL);
	MSHookMessageEx([NSProcessInfo class], @selector(operatingSystemVersion), (IMP) &overrideSystemVersion, (IMP *) &origSystemVersion);

}
