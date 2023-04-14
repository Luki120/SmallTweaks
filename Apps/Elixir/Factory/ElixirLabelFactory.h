#import "View/ElixirLabel.h"


@interface ElixirLabelFactory : NSObject
+ (ElixirLabel *)makeElixirLabel;
+ (NSString *)tweakCountString;
+ (void)pinElixirLabelToTheTopCenteredOnTheXAxisOfView:(UIView *)view;
@end
