#import "ElixirLabelFactory.h"


@implementation ElixirLabelFactory

static ElixirLabel *elixirLabel;

+ (ElixirLabel *)makeElixirLabel {

	if(!elixirLabel) elixirLabel = [ElixirLabel new];
	return elixirLabel;

}


+ (NSString *)tweakCountString { return elixirLabel.tweakCountString; }
+ (void)centerElixirLabelOnBothAxesOfView:(UIView *)view {

	// Hi, if you've reached here, please do yourself a favor if this is your case.
	// Stop doing cursed, weird af UIScreen calculations with frames for UI layout stuff, 
	// learn and embrace constraints instead, they are natural and beautiful,
	// also known as AutoLayout, AUTO (it does the thing for you!!!)
	[elixirLabel.centerXAnchor constraintEqualToAnchor: view.centerXAnchor].active = YES;
	[elixirLabel.centerYAnchor constraintEqualToAnchor: view.centerYAnchor].active = YES;

}


+ (void)pinElixirLabelToTheTopCenteredOnTheXAxisOfView:(UIView *)view {

	[elixirLabel.topAnchor constraintEqualToAnchor: view.topAnchor constant: 8].active = YES;
	[elixirLabel.centerXAnchor constraintEqualToAnchor: view.centerXAnchor].active = YES;

}

@end
