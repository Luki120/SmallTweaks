/*--- Gets rid of the ugly blur effects present
in the context menus & replaces them with a clean
translucent look + hides separators system wide ---*/

@import UIKit;
@import CydiaSubstrate;


@interface _UIElasticContextMenuBackgroundView : UIView
@property (nonatomic, strong) UIVisualEffectView *visualEffectView;
@end


@interface _UIContextMenuActionsListSeparatorView : UIView
@end


@interface CCUIMenuModuleItemView : UIView
@end


@interface MRUNowPlayingContainerView : UIView
@property (nonatomic, strong) UIView *separatorView;
@end


@interface MRURoutingTableViewCell : UITableViewCell
@property (nonatomic, strong) UIView *separatorView;
@end


@interface MRURoutingHeaderView : UIView
@property (nonatomic, strong) UIView *separatorView;
@end


#define kClass(string) NSClassFromString(string)


// Translucency
static void (*origUIElasticContextMenuDMTW)(_UIElasticContextMenuBackgroundView *, SEL);
static void overrideUIElasticContextMenuDMTW(_UIElasticContextMenuBackgroundView *self, SEL _cmd) {

	origUIElasticContextMenuDMTW(self, _cmd);
	self.visualEffectView.alpha = 0.5;

}

// Hide context menu separators system wide
static void (*origUIContextMenuActionsListDMTW)(_UIContextMenuActionsListSeparatorView *, SEL);
static void overrideUIContextMenuActionsListDMTW(_UIContextMenuActionsListSeparatorView *self, SEL _cmd) {

	origUIContextMenuActionsListDMTW(self, _cmd);
	[self removeFromSuperview];

}

// Thick context menu separator

static void (*origUICollectionReusableViewDMTW)(UICollectionReusableView *, SEL);
static void overrideUICollectionReusableViewDMTW(UICollectionReusableView *self, SEL _cmd) {

	if(![self.reuseIdentifier isEqualToString:@"kContextMenuItemSeparator"]) return origUICollectionReusableViewDMTW(self, _cmd);

	origUICollectionReusableViewDMTW(self, _cmd);
	self.hidden = YES;

}

// CC Bluetooth & WiFi expanded modules
static CGFloat overrideSeparatorHeight(CCUIMenuModuleItemView *self, SEL _cmd) { return 0; }

// CC media player airplay expanded module
static void (*origMRUContainerDMTW)(MRUNowPlayingContainerView *, SEL);
static void overrideMRUContainerDMTW(MRUNowPlayingContainerView *self, SEL _cmd) {

	origMRUContainerDMTW(self, _cmd);
	[self.separatorView removeFromSuperview];

}

static void (*origMRUTableViewCellDMTW)(MRURoutingTableViewCell *, SEL);
static void overrideMRUTableViewCellDMTW(MRURoutingTableViewCell *self, SEL _cmd) {

	origMRUTableViewCellDMTW(self, _cmd);
	[self.separatorView removeFromSuperview];

}

static void (*origMRUHeaderDMTW)(MRURoutingHeaderView *, SEL);
static void overrideMRUHeaderDMTW(MRURoutingHeaderView *self, SEL _cmd) {

	origMRUHeaderDMTW(self, _cmd);
	[self.separatorView removeFromSuperview];

}

__attribute__((constructor)) static void init() {

	MSHookMessageEx(kClass(@"_UIElasticContextMenuBackgroundView"), @selector(didMoveToWindow), (IMP) &overrideUIElasticContextMenuDMTW, (IMP *) &origUIElasticContextMenuDMTW);
	MSHookMessageEx(kClass(@"_UIContextMenuActionsListSeparatorView"), @selector(didMoveToWindow), (IMP) &overrideUIContextMenuActionsListDMTW, (IMP *) &origUIContextMenuActionsListDMTW);
	MSHookMessageEx(kClass(@"CCUIMenuModuleItemView"), @selector(_separatorHeight), (IMP) &overrideSeparatorHeight, (IMP *) NULL);
	MSHookMessageEx(kClass(@"MRUNowPlayingContainerView"), @selector(didMoveToWindow), (IMP) &overrideMRUContainerDMTW, (IMP *) &origMRUContainerDMTW);
	MSHookMessageEx(kClass(@"MRURoutingTableViewCell"), @selector(didMoveToWindow), (IMP) &overrideMRUTableViewCellDMTW, (IMP *) &origMRUTableViewCellDMTW);
	MSHookMessageEx(kClass(@"MRURoutingHeaderView"), @selector(didMoveToWindow), (IMP) &overrideMRUHeaderDMTW, (IMP *) &origMRUHeaderDMTW);
	MSHookMessageEx(kClass(@"UICollectionReusableView"), @selector(didMoveToWindow), (IMP) &overrideUICollectionReusableViewDMTW, (IMP *) &origUICollectionReusableViewDMTW);

}
