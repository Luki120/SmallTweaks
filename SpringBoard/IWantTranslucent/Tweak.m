/*--- Gets rid of the ugly blur effects present
in the context menus & replaces them with a clean
translucent look + hides separators system wide ---*/

@import UIKit;
@import CydiaSubstrate;


@interface UIView ()
@property (nonatomic, strong) UIVisualEffectView *backgroundView;
@property (nonatomic, strong) UIVisualEffectView *visualEffectView;
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
#define kOSVersion [[UIDevice currentDevice].systemVersion floatValue]


// Translucency
static void (*origContextMenuDMTW)(UIView *, SEL);
static void overrideContextMenuDMTW(UIView *self, SEL _cmd) {

	origContextMenuDMTW(self, _cmd);
	if(kOSVersion >= 15.0) self.backgroundView.alpha = 0.5;
	else self.visualEffectView.alpha = 0.5;

}

// Hide context menu separators system wide
static void (*origContextMenuSeparatorDMTW)(UIView *, SEL);
static void overrideContextMenuSeparatorDMTW(UIView *self, SEL _cmd) {

	origContextMenuSeparatorDMTW(self, _cmd);
	[self removeFromSuperview];

}

// Thick context menu separator
static void (*origUICollectionReusableViewDMTW)(UICollectionReusableView *, SEL);
static void overrideUICollectionReusableViewDMTW(UICollectionReusableView *self, SEL _cmd) {

	NSString *reuseIdentifier;

	if(kOSVersion >= 15.0) reuseIdentifier = @"kContextMenuSectionSeparator";
	else reuseIdentifier = @"kContextMenuItemSeparator";

	if(![self.reuseIdentifier isEqualToString: reuseIdentifier]) return origUICollectionReusableViewDMTW(self, _cmd);

	origUICollectionReusableViewDMTW(self, _cmd);
	self.hidden = YES;

}

// CC Bluetooth & WiFi expanded modules
static CGFloat overrideSeparatorHeight(CCUIMenuModuleItemView *self, SEL _cmd) { return 0; }

// CC media player airplay expanded module
static void (*origDMTW)(MRUNowPlayingContainerView *, SEL);
static void overrideDMTW(MRUNowPlayingContainerView *self, SEL _cmd) {

	origDMTW(self, _cmd);
	[self.separatorView removeFromSuperview];

}

__attribute__((constructor)) static void init(void) {

	if(kOSVersion >= 15.0) {
		MSHookMessageEx(kClass(@"_UIContextMenuListView"), @selector(didMoveToWindow), (IMP) &overrideContextMenuDMTW, (IMP *) &origContextMenuDMTW);
		MSHookMessageEx(kClass(@"_UIContextMenuReusableSeparatorView"), @selector(didMoveToWindow), (IMP) &overrideContextMenuSeparatorDMTW, (IMP *) &origContextMenuSeparatorDMTW);
	}

	else {
		MSHookMessageEx(kClass(@"_UIElasticContextMenuBackgroundView"), @selector(didMoveToWindow), (IMP) &overrideContextMenuDMTW, (IMP *) &origContextMenuDMTW);
		MSHookMessageEx(kClass(@"_UIContextMenuActionsListSeparatorView"), @selector(didMoveToWindow), (IMP) &overrideContextMenuSeparatorDMTW, (IMP *) &origContextMenuSeparatorDMTW);
	}

	for(NSString *class in @[@"MRUNowPlayingContainerView", @"MRURoutingTableViewCell", @"MRURoutingHeaderView"]) {
		MSHookMessageEx(kClass(class), @selector(didMoveToWindow), (IMP) &overrideDMTW, (IMP *) &origDMTW);
	}

	MSHookMessageEx(kClass(@"CCUIMenuModuleItemView"), @selector(_separatorHeight), (IMP) &overrideSeparatorHeight, (IMP *) NULL);
	MSHookMessageEx(kClass(@"UICollectionReusableView"), @selector(didMoveToWindow), (IMP) &overrideUICollectionReusableViewDMTW, (IMP *) &origUICollectionReusableViewDMTW);

}
