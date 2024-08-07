@import CydiaSubstrate;
@import UIKit;
#import "Prefs.h"


@interface _UIActivityCollectionViewCompositionalLayout: UICollectionViewCompositionalLayout
@property UICollectionViewCompositionalLayoutSectionProvider layoutSectionProvider;
@end


@interface UIAirDropGroupActivityCell: UICollectionViewCell
@property (nonatomic, strong) UIView *imageSlotView;
@end


@interface UIShareGroupActivityCell: UICollectionViewCell
@property (nonatomic, strong) UIView *imageSlotView;
@end


@interface _UIActivityActionCellTitleLabel : UILabel
@end
