#import "ZiraContentModuleVC.h"
#import <rootless.h>
#import <ControlCenterUIKit/CCUIToggleModule.h>

#define rootlessPathC(cPath) ROOT_PATH(cPath)
#define jbRootPath(path) ROOT_PATH_NS(path)


typedef struct CCUILayoutSize {
	NSUInteger width;
	NSUInteger height;
} CCUILayoutSize;


@interface ZiraModule : CCUIToggleModule
@end
