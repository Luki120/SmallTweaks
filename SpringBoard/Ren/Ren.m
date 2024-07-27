/*--- Recreates the ShareSheet's main collection view's compositional layout
in order to resize the items of the horizontal scroll views so that more of
them can fit on the screen without scrolling. Made as a bounty ---*/

#import "Headers/Ren.h"


@class _UIActivityContentCollectionView;

static NSString *const kApplePhotosBundleID = @"com.apple.mobileslideshow";

static id (*origIWFC)(_UIActivityContentCollectionView *, SEL, CGRect, _UIActivityCollectionViewCompositionalLayout *);
static id overrideIWFC(_UIActivityContentCollectionView *self, SEL _cmd, CGRect frame, _UIActivityCollectionViewCompositionalLayout *layout) {

	loadShit();

	_UIActivityCollectionViewCompositionalLayout *compositionalLayout = [[_UIActivityCollectionViewCompositionalLayout alloc] initWithSectionProvider: ^(NSInteger sectionIndex, id<NSCollectionLayoutEnvironment> layoutEnvironment) {

		if([[NSBundle mainBundle].bundleIdentifier isEqualToString: kApplePhotosBundleID]) {
			if(sectionIndex == 0 || sectionIndex > 2)
				return layout.layoutSectionProvider(sectionIndex, layoutEnvironment);
		}

		else if(sectionIndex > 1) return layout.layoutSectionProvider(sectionIndex, layoutEnvironment);

		NSCollectionLayoutSize *itemSize = [NSCollectionLayoutSize
			sizeWithWidthDimension:[NSCollectionLayoutDimension absoluteDimension: widthDimension]
			heightDimension:[NSCollectionLayoutDimension estimatedDimension: heightDimension]
		];
		NSCollectionLayoutItem *item = [NSCollectionLayoutItem itemWithLayoutSize: itemSize];

		NSCollectionLayoutSize *groupSize = [NSCollectionLayoutSize
			sizeWithWidthDimension:[NSCollectionLayoutDimension absoluteDimension: widthDimension]
			heightDimension:[NSCollectionLayoutDimension estimatedDimension: heightDimension]
		];

		NSCollectionLayoutGroup *group = [NSCollectionLayoutGroup horizontalGroupWithLayoutSize:groupSize subitems: @[item]];

		NSCollectionLayoutSection *section = [NSCollectionLayoutSection sectionWithGroup: group];
		section.contentInsets = NSDirectionalEdgeInsetsMake(0, sectionHorizontalPadding, 0, sectionHorizontalPadding);
		section.orthogonalScrollingBehavior = UICollectionLayoutSectionOrthogonalScrollingBehaviorContinuous;

		return section;
	}];

	return origIWFC(self, _cmd, frame, compositionalLayout);

}

static id (*origAirDropIWF)(UIAirDropGroupActivityCell *, SEL, CGRect);
static id overrideAirDropIWF(UIAirDropGroupActivityCell *self, SEL _cmd, CGRect frame) {

	id orig = origAirDropIWF(self, _cmd, frame);

	[self.imageSlotView.widthAnchor constraintEqualToConstant: iconSize].active = YES;
	[self.imageSlotView.heightAnchor constraintEqualToConstant: iconSize].active = YES;

	return orig;

}

static void (*origAirDropLS)(UIAirDropGroupActivityCell *, SEL);
static void overrideAirDropLS(UIAirDropGroupActivityCell *self, SEL _cmd) {

	origAirDropLS(self, _cmd);
	self.imageSlotView.layer.cornerRadius = iconSize / 2;

}

static id (*origShareGroupIWF)(UIShareGroupActivityCell *, SEL, CGRect);
static id overrideShareGroupIWF(UIShareGroupActivityCell *self, SEL _cmd, CGRect frame) {

	id orig = origShareGroupIWF(self, _cmd, frame);

	[self.imageSlotView.widthAnchor constraintEqualToConstant: iconSize].active = YES;
	[self.imageSlotView.heightAnchor constraintEqualToConstant: iconSize].active = YES;

	return orig;

}

__attribute__((constructor)) static void init(void) {

	loadShit();

	MSHookMessageEx(NSClassFromString(@"UIAirDropGroupActivityCell"), @selector(layoutSubviews), (IMP) &overrideAirDropLS, (IMP *) &origAirDropLS);
	MSHookMessageEx(NSClassFromString(@"UIAirDropGroupActivityCell"), @selector(initWithFrame:), (IMP) &overrideAirDropIWF, (IMP *) &origAirDropIWF);
	MSHookMessageEx(NSClassFromString(@"UIShareGroupActivityCell"), @selector(initWithFrame:), (IMP) &overrideShareGroupIWF, (IMP *) &origShareGroupIWF);
	MSHookMessageEx(NSClassFromString(@"_UIActivityContentCollectionView"), @selector(initWithFrame:collectionViewLayout:), (IMP) &overrideIWFC, (IMP *) &origIWFC);

}
