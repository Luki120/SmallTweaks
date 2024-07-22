@import CydiaSubstrate;
@import UIKit.UICollectionViewCompositionalLayout;


@class _UIActivityContentCollectionView;

@interface _UIActivityCollectionViewCompositionalLayout: UICollectionViewCompositionalLayout
@property UICollectionViewCompositionalLayoutSectionProvider layoutSectionProvider;
@end


id (*origIWFC)(_UIActivityContentCollectionView *, SEL, CGRect, _UIActivityCollectionViewCompositionalLayout *);
id overrideIWFC(_UIActivityContentCollectionView *self, SEL _cmd, CGRect frame, _UIActivityCollectionViewCompositionalLayout *layout) {
	_UIActivityCollectionViewCompositionalLayout *compositionalLayout = [[_UIActivityCollectionViewCompositionalLayout alloc] initWithSectionProvider: ^(NSInteger sectionIndex, id<NSCollectionLayoutEnvironment> layoutEnvironment) {
		if(sectionIndex != 0) return layout.layoutSectionProvider(sectionIndex, layoutEnvironment);

		NSCollectionLayoutSize *itemSize = [NSCollectionLayoutSize
			sizeWithWidthDimension:[NSCollectionLayoutDimension absoluteDimension: 78]
			heightDimension:[NSCollectionLayoutDimension estimatedDimension: 118.5]
		];
		NSCollectionLayoutItem *item = [NSCollectionLayoutItem itemWithLayoutSize: itemSize];

		NSCollectionLayoutSize *groupSize = [NSCollectionLayoutSize
			sizeWithWidthDimension:[NSCollectionLayoutDimension absoluteDimension: 78]
			heightDimension:[NSCollectionLayoutDimension estimatedDimension: 118.5]
		];
		NSCollectionLayoutGroup *group = [NSCollectionLayoutGroup horizontalGroupWithLayoutSize:groupSize subitems: @[item]];

		NSCollectionLayoutSection *section = [NSCollectionLayoutSection sectionWithGroup: group];
		section.contentInsets = NSDirectionalEdgeInsetsMake(0, 13, 0, 13);
		section.orthogonalScrollingBehavior = UICollectionLayoutSectionOrthogonalScrollingBehaviorContinuous;

		return section;
	}];

	return origIWFC(self, _cmd, frame, compositionalLayout);
}

__attribute__((constructor)) static void init(void) {

	MSHookMessageEx(NSClassFromString(@"_UIActivityContentCollectionView"), @selector(initWithFrame:collectionViewLayout:), (IMP) &overrideIWFC, (IMP *) &origIWFC);

}
