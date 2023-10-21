/*--- fix Star+ requiring you to update to 15.3 in order to use the app ---*/

@import Foundation;
@import CydiaSubstrate;

static NSDictionary *(*origInfoDict)(NSBundle *, SEL);
static NSDictionary *overrideInfoDict(NSBundle *self, SEL _cmd) {

	NSMutableDictionary *mutablePlist = [origInfoDict(self, _cmd) mutableCopy] ?: [NSMutableDictionary dictionary];
	[mutablePlist setObject:@"2.13" forKey: @"CFBundleShortVersionString"];
	return mutablePlist;

}

__attribute__((constructor)) static void init(void) {

	MSHookMessageEx([NSBundle class], @selector(infoDictionary), (IMP) &overrideInfoDict, (IMP *) &origInfoDict);

}
