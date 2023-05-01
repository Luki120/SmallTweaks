#import "View/ElixirLabel.h"


@interface ElixirLabelFactory : NSObject
+ (ElixirLabel *)makeElixirLabel;
+ (NSString *)tweakCountString;
+ (void)centerElixirLabelOnBothAxesOfView:(UIView *)view;
+ (void)pinElixirLabelToTheTopCenteredOnTheXAxisOfView:(UIView *)view;
@end
