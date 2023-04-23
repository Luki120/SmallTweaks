/*--- Put an image background as a CC module on the fly ---*/

#import "ZiraModule.h"


static NSString *const kBSC = @"/Library/MobileSubstrate/DynamicLibraries/BigSurCenter.dylib";
static NSString *const kPrysm = @"/Library/MobileSubstrate/DynamicLibraries/Prysm.dylib";


@implementation ZiraModule {

	ZiraContentModuleVC *ziraContentModuleVC;

}


- (id)init {

	self = [super init];
	if(!self) return nil;

	NSFileManager *fileM = [NSFileManager defaultManager];
	if([fileM fileExistsAtPath: kBSC] || [fileM fileExistsAtPath: kPrysm]) return nil;

	ziraContentModuleVC = [ZiraContentModuleVC new];
	ziraContentModuleVC.module = self;

	return self;

}


- (CCUILayoutSize)moduleSizeForOrientation:(NSInteger)orientation {

	CCUILayoutSize size;
	NSNumber *width, *height;

	switch(orientation) {

		case 0:
			width = [self retrieveDefaultsForKey: @"portraitWidth"];
			height = [self retrieveDefaultsForKey: @"portraitHeight"];
			break;

		case 1:
			width = [self retrieveDefaultsForKey: @"landscapeWidth"];
			height = [self retrieveDefaultsForKey: @"landscapeHeight"];
			break;

	}

	size.width = width ? [width unsignedLongLongValue] : 1;
	size.height = height ? [height unsignedLongLongValue] : 1;

	return size;

}


- (NSNumber *)retrieveDefaultsForKey:(NSString *)key {

	return [[NSUserDefaults.standardUserDefaults persistentDomainForName:@"me.luki.ziraprefs"] objectForKey: key];

}


- (UIViewController *)contentViewController { return ziraContentModuleVC; }

@end
