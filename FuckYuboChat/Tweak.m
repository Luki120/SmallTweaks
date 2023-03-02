/*--- Hides the bottom bar on Yubo app on a livestream,
as well as the black bottom gradient, made as a bounty  ---*/


@import UIKit;
@import CydiaSubstrate;


@interface UIView ()
- (UIViewController *)_viewControllerForAncestor;
@end


static void(*origDMTW)(UITableView *self, SEL _cmd);
static void overrideDMTW(UITableView *self, SEL _cmd) {

	origDMTW(self, _cmd);
	[self removeFromSuperview];

}

static void(*origMessagesSuggestionsDMTW)(UIView *self, SEL _cmd);
static void overrideMessagesSuggestionsDMTW(UIView *self, SEL _cmd) {

	origMessagesSuggestionsDMTW(self, _cmd);
	self.hidden = YES;

}

static void(*origBottomBarDMTW)(UIView *self, SEL _cmd);
static void overrideBottomBarDMTW(UIView *self, SEL _cmd) {

	origBottomBarDMTW(self, _cmd);
	self.hidden = YES;

}

static void(*origDarkableDMTW)(UIView *self, SEL _cmd);
static void overrideDarkableDMTW(UIView *self, SEL _cmd) {

	origDarkableDMTW(self, _cmd);

	Class LiveRoomVC = NSClassFromString(@"Yubo.LiveRoomViewController");

	UIViewController *ancestor = [self _viewControllerForAncestor];
	if(![ancestor isKindOfClass:LiveRoomVC]) return;

	self.hidden = YES;

}

__attribute__((constructor)) static void init() {

	Class DarkableView = NSClassFromString(@"Yubo.DarkableView");
	Class InvertedTableView = NSClassFromString(@"Yubo.InvertedTableView");
	Class MessagesSuggestionsView = NSClassFromString(@"Yubo.ChatMessageSuggestionView");

	MSHookMessageEx(DarkableView, @selector(didMoveToWindow), (IMP) &overrideDarkableDMTW, (IMP *) &origDarkableDMTW);
	MSHookMessageEx(InvertedTableView, @selector(didMoveToWindow), (IMP) &overrideDMTW, (IMP *) &origDMTW);
	MSHookMessageEx(MessagesSuggestionsView, @selector(didMoveToWindow), (IMP) &overrideMessagesSuggestionsDMTW, (IMP *) &origMessagesSuggestionsDMTW);
	MSHookMessageEx(NSClassFromString(@"_TtCC4Yubo40LiveRoomBottomBarComponentViewController4View"), @selector(didMoveToWindow), (IMP) &overrideBottomBarDMTW, (IMP *) &origBottomBarDMTW);

}
