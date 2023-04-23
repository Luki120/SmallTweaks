@import AVFoundation;
#import "IslaView.h"


@implementation IslaView {

	UIStackView *islaStackView;
	UIImageView *islaSpeakerImageView;
	UIView *islaHudView;
	UIView *islaSliderView;
	NSLayoutConstraint *islaSliderWidthAnchorConstraint;
	float outputVolume;

}

static NSDictionary *views;

- (id)init {

	self = [super init];
	if(!self) return nil;

	[self setupIslaView];

	[[AVAudioSession sharedInstance] addObserver:self forKeyPath:@"outputVolume" options:0 context:nil];
	[[AVAudioSession sharedInstance] setActive:YES error: nil];

	outputVolume = [AVAudioSession sharedInstance].outputVolume;

	return self;

}


- (void)layoutSubviews {

	[super layoutSubviews];
	[self layoutIslaView];

}


- (void)setupIslaView {

	self.translatesAutoresizingMaskIntoConstraints = NO;

	if(!islaStackView) {
		islaStackView = [UIStackView new];
		islaStackView.spacing = 5;
		islaStackView.alignment = UIStackViewAlignmentCenter;
		islaStackView.translatesAutoresizingMaskIntoConstraints = NO;
		[self addSubview: islaStackView];
	}

	if(!islaSpeakerImageView) {
		UIImageSymbolConfiguration *configuration = [UIImageSymbolConfiguration configurationWithWeight: UIImageSymbolWeightBold];

		islaSpeakerImageView = [UIImageView new];
		islaSpeakerImageView.image = [UIImage systemImageNamed:@"speaker.wave.2" withConfiguration: configuration];
		islaSpeakerImageView.tintColor = UIColor.labelColor;
		islaSpeakerImageView.contentMode = UIViewContentModeScaleAspectFit;
		islaSpeakerImageView.clipsToBounds = YES;
		islaSpeakerImageView.translatesAutoresizingMaskIntoConstraints = NO;
		[islaStackView addArrangedSubview: islaSpeakerImageView];
	}

	if(!islaHudView) {
		islaHudView = [self setupUIViewWithBackgroundColor: UIColor.systemGrayColor];
		[islaStackView addArrangedSubview: islaHudView];
	}

	if(!islaSliderView) {
		islaSliderView = [self setupUIViewWithBackgroundColor: UIColor.labelColor];
		[islaHudView addSubview: islaSliderView];
	}

}


- (void)layoutIslaView {

	views = @{
		@"islaStackView": islaStackView,
		@"islaSpeakerImageView": islaSpeakerImageView,
		@"islaHudView": islaHudView,
		@"islaSliderView": islaSliderView
	};

	NSArray *formatStrings = @[
		@"V:|-[islaStackView]-|",
		@"H:|-[islaStackView]-|",
		@"H:[islaSpeakerImageView(==15)]",
		@"V:[islaSpeakerImageView(==15)]",
		@"V:[islaHudView(==2)]",
		@"V:[islaSliderView(==2)]"
	];

	for(NSString *formatString in formatStrings) [self setupConstraintsWithFormat: formatString];

	islaSliderWidthAnchorConstraint.active = NO;
	islaSliderWidthAnchorConstraint = [islaSliderView.widthAnchor constraintEqualToConstant: floor(outputVolume * 229)];
	islaSliderWidthAnchorConstraint.active = YES;

}

// Reusable

- (void)setupConstraintsWithFormat:(NSString *)format {

	[NSLayoutConstraint activateConstraints:
		[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views: views]];

}


- (UIView *)setupUIViewWithBackgroundColor:(UIColor *)color {

	UIView *view = [UIView new];
	view.backgroundColor = color;
	view.layer.cornerCurve = kCACornerCurveContinuous;
	view.layer.cornerRadius = 1;
	view.translatesAutoresizingMaskIntoConstraints = NO;
	return view;

}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

	float newVolume = [AVAudioSession sharedInstance].outputVolume;

	[UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{

		float newConstant = newVolume < 0.999 ? floor(newVolume * 229) : 229;

		islaSliderWidthAnchorConstraint.active = NO;
		islaSliderWidthAnchorConstraint = [islaSliderView.widthAnchor constraintEqualToConstant: newConstant];
		islaSliderWidthAnchorConstraint.active = YES;

		[self layoutIfNeeded];

	} completion:nil];

}


- (void)dealloc { [[AVAudioSession sharedInstance] removeObserver:self forKeyPath:@"outputVolume"]; }

@end
