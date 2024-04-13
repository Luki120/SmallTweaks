/*--- Gets rid of the ugly blur effects present
in the context menus & replaces them with a clean
translucent look + hides separators system wide ---*/

@import UIKit;
@import CydiaSubstrate;


@interface _UIContextMenuActionsListTitleView: UIView
@end


@interface _UIContextMenuHeaderView: UIView
@property (nonatomic, strong) UIVisualEffectView *bgView;
@property (nonatomic, strong) UIView *separator;
@end


@interface MRUNowPlayingContainerView : UIView
@property (nonatomic, strong) UIView *separatorView;
@end


@class CCUIMenuModuleItemView;
@class _UIContextMenuTitleView;

#define kClass(string) NSClassFromString(string)
#define kOSVersion [[UIDevice currentDevice].systemVersion floatValue]

// ! iOS 14+

// Translucency
static void (*origSetBackgroundView)(UIView *, SEL, UIVisualEffectView *);
static void overrideSetBackgroundView(UIView *self, SEL _cmd, UIVisualEffectView *visualEffectView) {

	origSetBackgroundView(self, _cmd, visualEffectView);
	visualEffectView.alpha = 0.5;

}

// Separators
static void (*origContextMenuSeparatorDMTW)(UIView *, SEL);
static void overrideContextMenuSeparatorDMTW(UIView *self, SEL _cmd) {

	origContextMenuSeparatorDMTW(self, _cmd);
	[self removeFromSuperview];

}

// Thick context menu separator
static void (*origUICollectionReusableViewDMTW)(UICollectionReusableView *, SEL);
static void overrideUICollectionReusableViewDMTW(UICollectionReusableView *self, SEL _cmd) {

	origUICollectionReusableViewDMTW(self, _cmd);

	NSString *reuseIdentifier;

	if(kOSVersion >= 15.0) reuseIdentifier = @"kContextMenuSectionSeparator";
	else reuseIdentifier = @"kContextMenuItemSeparator";

	if(![self.reuseIdentifier isEqualToString: reuseIdentifier]) return;
	self.hidden = YES;

}

// ! iOS 16

static void (*origContextMenuHeaderDMTW)(_UIContextMenuHeaderView *, SEL);
static void overrideContextMenuHeaderDMTW(_UIContextMenuHeaderView *self, SEL _cmd) {

	origContextMenuHeaderDMTW(self, _cmd);
	self.bgView.hidden = YES;
	self.separator.hidden = YES;

}

// ! iOS 15

static UIVisualEffectView *overrideTitleBackgroundView(_UIContextMenuTitleView *self, SEL _cmd) {

	return [UIVisualEffectView new];

}

static UIView *overrideTitleSeparator(_UIContextMenuTitleView *self, SEL _cmd) {

	return [UIView new];

}

// ! iOS 14

static void (*origContextMenuTitleDMTW)(_UIContextMenuActionsListTitleView *, SEL);
static void overrideContextMenuTitleDMTW(_UIContextMenuActionsListTitleView *self, SEL _cmd) {

	origContextMenuTitleDMTW(self, _cmd);

	for(UIView *view in self.subviews) {
		if(![view isKindOfClass: [UIVisualEffectView class]]) return;
		[view removeFromSuperview];
	}

}

// ! Control Center

// CC Bluetooth & WiFi expanded modules
static CGFloat overrideSeparatorHeight(CCUIMenuModuleItemView *self, SEL _cmd) { return 0; }

// CC media player airplay expanded module
static void (*origMRUNowPlayingContainerViewDMTW)(MRUNowPlayingContainerView *, SEL);
static void overrideMRUNowPlayingContainerViewDMTW(MRUNowPlayingContainerView *self, SEL _cmd) {

	origMRUNowPlayingContainerViewDMTW(self, _cmd);
	[self.separatorView removeFromSuperview];

}

static UIView *overrideSeparatorView(UIView *self, SEL _cmd) {

	return [UIView new];

}

__attribute__((constructor)) static void init(void) {

	if(kOSVersion >= 15.0) {
		MSHookMessageEx(kClass(@"_UIContextMenuListView"), @selector(setBackgroundView:), (IMP) &overrideSetBackgroundView, (IMP *) &origSetBackgroundView);
		MSHookMessageEx(kClass(@"_UIContextMenuTitleView"), @selector(bgView), (IMP) &overrideTitleBackgroundView, (IMP *) NULL);
		MSHookMessageEx(kClass(@"_UIContextMenuTitleView"), @selector(separator), (IMP) &overrideTitleSeparator, (IMP *) NULL);
		MSHookMessageEx(kClass(@"_UIContextMenuReusableSeparatorView"), @selector(didMoveToWindow), (IMP) &overrideContextMenuSeparatorDMTW, (IMP *) &origContextMenuSeparatorDMTW);

		if(kOSVersion >=16.0)
			MSHookMessageEx(kClass(@"_UIContextMenuHeaderView"), @selector(didMoveToWindow), (IMP) &overrideContextMenuHeaderDMTW, (IMP *) &origContextMenuHeaderDMTW);
	}

	else {
		MSHookMessageEx(kClass(@"_UIElasticContextMenuBackgroundView"), @selector(setVisualEffectView:), (IMP) &overrideSetBackgroundView, (IMP *) &origSetBackgroundView);
		MSHookMessageEx(kClass(@"_UIContextMenuActionsListTitleView"), @selector(didMoveToWindow), (IMP) &overrideContextMenuTitleDMTW, (IMP *) &origContextMenuTitleDMTW);
		MSHookMessageEx(kClass(@"_UIContextMenuActionsListSeparatorView"), @selector(didMoveToWindow), (IMP) &overrideContextMenuSeparatorDMTW, (IMP *) &origContextMenuSeparatorDMTW);
	}

	for(NSString *class in @[@"MRURoutingHeaderView", @"MRURoutingTableViewCell"]) {
		MSHookMessageEx(kClass(class), @selector(separatorView), (IMP) &overrideSeparatorView, (IMP *) NULL);
	}

	MSHookMessageEx(kClass(@"CCUIMenuModuleItemView"), @selector(_separatorHeight), (IMP) &overrideSeparatorHeight, (IMP *) NULL);
	MSHookMessageEx(kClass(@"MRUNowPlayingContainerView"), @selector(didMoveToWindow), (IMP) &overrideMRUNowPlayingContainerViewDMTW, (IMP *) &origMRUNowPlayingContainerViewDMTW);
	MSHookMessageEx(kClass(@"UICollectionReusableView"), @selector(didMoveToWindow), (IMP) &overrideUICollectionReusableViewDMTW, (IMP *) &origUICollectionReusableViewDMTW);

}
