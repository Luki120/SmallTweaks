#import "ArizonaVC.h"

#define kAriTintColor [UIColor colorWithRed:0.02 green:0.79 blue:0.95 alpha: 1.0]

@implementation ArizonaVC {

	UILabel *versionLabel;
	UIImageView *iconView;
	UIView *headerView;
	UIImageView *headerImageView;
	NSMutableDictionary *savedSpecifiers;
	OBWelcomeController *changelogController;

}

// ! Lifecycle

- (NSArray *)specifiers {

	if(_specifiers) return nil;
	_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];

	NSArray *specifiersIDs = @[
		@"GroupCell-1",
		@"SegmentCell",
		@"GroupCell-2",
		@"XAxisLabel",
		@"XAxisSlider",
		@"YAxisLabel",
		@"YAxisSlider",
		@"GroupCell-3",
		@"LockXAxisLabel",
		@"LockXAxisSlider",
		@"LockYAxisLabel",
		@"LockYAxisSlider"
	];

	savedSpecifiers = savedSpecifiers ?: [NSMutableDictionary new];

	for(PSSpecifier *specifier in _specifiers)

		if([specifiersIDs containsObject:[specifier propertyForKey:@"id"]])

			[savedSpecifiers setObject:specifier forKey:[specifier propertyForKey:@"id"]];

	return _specifiers;

}


- (id)init {

	self = [super init];
	if(!self) return nil;

	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{ registerArizonaTintCellClass(); });

	[self setupUI];

	return self;

}


- (void)viewDidLoad {

	[super viewDidLoad];
	[self reloadSpecifiers];

}


- (void)setupUI {

	UIImage *changelogButtonImage = [UIImage systemImageNamed:@"atom"];
	UIImage *iconImage = [UIImage imageWithContentsOfFile:rootlessPathNS(@"/Library/PreferenceBundles/ArizonaPrefs.bundle/Assets/Arizona@2x.png")];
	UIImage *bannerImage = [UIImage imageWithContentsOfFile:rootlessPathNS(@"/Library/PreferenceBundles/ArizonaPrefs.bundle/Assets/ArizonaBanner.png")];

	self.navigationItem.titleView = [UIView new];

	if(!versionLabel) {
		versionLabel = [UILabel new];
		versionLabel.font = [UIFont boldSystemFontOfSize: 17];
		versionLabel.text = @"0.9.2";
		versionLabel.textAlignment = NSTextAlignmentCenter;
		versionLabel.translatesAutoresizingMaskIntoConstraints = NO;
		[self.navigationItem.titleView addSubview: versionLabel];
	}

	if(!iconView) {
		iconView = [self createImageViewWithImage:iconImage contentMode: UIViewContentModeScaleAspectFit];
		iconView.alpha = 0;
		[self.navigationItem.titleView addSubview: iconView];
	}

	if(!headerView) headerView = [[UIView alloc] initWithFrame: CGRectMake(0,0,200,200)];

	if(!headerImageView) {
		headerImageView = [self createImageViewWithImage:bannerImage contentMode: UIViewContentModeScaleAspectFill];
		[headerView addSubview: headerImageView];
	}

	UIButton *changelogButton = [UIButton new];
	changelogButton.tintColor = kAriTintColor;
	[changelogButton setImage:changelogButtonImage forState: UIControlStateNormal];
	[changelogButton addTarget:self action:@selector(showWtfChangedInThisVersion) forControlEvents: UIControlEventTouchUpInside];

	UIBarButtonItem *changelogButtonItem = [[UIBarButtonItem alloc] initWithCustomView: changelogButton];
	self.navigationItem.rightBarButtonItem = changelogButtonItem;

	[self layoutUI];

}


- (void)layoutUI {

	[iconView anchorEqualsToView:self.navigationItem.titleView padding: UIEdgeInsetsZero];
	[versionLabel anchorEqualsToView:self.navigationItem.titleView padding: UIEdgeInsetsZero];
	[headerImageView anchorEqualsToView:headerView padding: UIEdgeInsetsZero];

}


- (void)reloadSpecifiers {

	[super reloadSpecifiers];

	if(![[self readPreferenceValue:[self specifierForID:@"FixedPositionSwitch"]] boolValue]) {

		[self removeSpecifier:savedSpecifiers[@"GroupCell-1"] animated:NO];
		[self removeSpecifier:savedSpecifiers[@"SegmentCell"] animated:NO];

	}

	else if(![self containsSpecifier:savedSpecifiers[@"GroupCell-1"]]) {

		[self insertSpecifier:savedSpecifiers[@"GroupCell-1"] afterSpecifierID:@"FixedPositionSwitch" animated:NO];
		[self insertSpecifier:savedSpecifiers[@"SegmentCell"] afterSpecifierID:@"GroupCell-1" animated:NO];

	}

	if(![[self readPreferenceValue:[self specifierForID:@"CustomPositionSwitch"]] boolValue])

		[self removeContiguousSpecifiers:@[savedSpecifiers[@"GroupCell-2"], savedSpecifiers[@"XAxisLabel"], savedSpecifiers[@"XAxisSlider"], savedSpecifiers[@"YAxisLabel"], savedSpecifiers[@"YAxisSlider"]] animated:NO];

	else if(![self containsSpecifier:savedSpecifiers[@"GroupCell-2"]])

		[self insertContiguousSpecifiers:@[savedSpecifiers[@"GroupCell-2"], savedSpecifiers[@"XAxisLabel"], savedSpecifiers[@"XAxisSlider"], savedSpecifiers[@"YAxisLabel"], savedSpecifiers[@"YAxisSlider"]] afterSpecifierID:@"CustomPositionSwitch" animated:NO];

	if(![[self readPreferenceValue:[self specifierForID:@"LockGlyphPositionSwitch"]] boolValue])

		[self removeContiguousSpecifiers:@[savedSpecifiers[@"GroupCell-3"], savedSpecifiers[@"LockXAxisLabel"], savedSpecifiers[@"LockXAxisSlider"], savedSpecifiers[@"LockYAxisLabel"], savedSpecifiers[@"LockYAxisSlider"]] animated:NO];

	else if(![self containsSpecifier:savedSpecifiers[@"GroupCell-3"]])

		[self insertContiguousSpecifiers:@[savedSpecifiers[@"GroupCell-3"], savedSpecifiers[@"LockXAxisLabel"], savedSpecifiers[@"LockXAxisSlider"], savedSpecifiers[@"LockYAxisLabel"], savedSpecifiers[@"LockYAxisSlider"]] afterSpecifierID:@"LockGlyphPositionSwitch" animated:NO];

}

// ! Selectors

- (void)showWtfChangedInThisVersion {

	AudioServicesPlaySystemSound(1521);

	UIImage *tweakIconImage = [UIImage imageWithContentsOfFile:rootlessPathNS(@"/Library/PreferenceBundles/ArizonaPrefs.bundle/Assets/ArizonaHotIcon.png")];
	UIImage *checkmarkImage = [UIImage systemImageNamed:@"checkmark.circle.fill"];

	if(changelogController) { [self presentViewController:changelogController animated:YES completion:nil]; return; }
	changelogController = [[OBWelcomeController alloc] initWithTitle:@"Arizona" detailText:@"0.9.2" icon: tweakIconImage];
	[changelogController addBulletedListItemWithTitle:@"Code" description:@"Refactoring ⇝ everything works the same, but better." image: checkmarkImage];

	_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle: 2];

	_UIBackdropView *backdropView = [[_UIBackdropView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:settings];
	backdropView.clipsToBounds = YES;
	[changelogController.viewIfLoaded insertSubview:backdropView atIndex: 0];

	changelogController.view.tintColor = kAriTintColor;
	changelogController.modalInPresentation = NO;
	changelogController.modalPresentationStyle = UIModalPresentationPageSheet;
	changelogController.viewIfLoaded.backgroundColor = UIColor.clearColor;
	[self presentViewController:changelogController animated:YES completion:nil];

}


- (void)shatterThePrefsToPieces {

	AudioServicesPlaySystemSound(1521);

	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Arizona" message:@"Do you want to start fresh?" preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Shoot" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

		[[NSFileManager defaultManager] removeItemAtPath:kPath error:nil];
		[self crossDissolveBlur];

	}];
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Meh" style:UIAlertActionStyleDefault handler:nil];

	[alertController addAction: confirmAction];
	[alertController addAction: cancelAction];
	[self presentViewController:alertController animated:YES completion:nil];

}


- (void)crossDissolveBlur {

	_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

	_UIBackdropView *backdropView = [[_UIBackdropView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:settings];
	backdropView.alpha = 0;
	backdropView.clipsToBounds = YES;
	[self.view addSubview: backdropView];

	[UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

		backdropView.alpha = 1;

	} completion:^(BOOL finished) { [self launchRespring]; }];

}


- (void)launchRespring {

	pid_t pid;
	const char* args[] = {"killall", "backboardd", NULL};
	posix_spawn(&pid, rootlessPathC("/usr/bin/killall"), NULL, NULL, (char* const*)args, NULL);

}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

	CGFloat offsetY = scrollView.contentOffset.y;

	if(offsetY > 150) {

		[UIView animateWithDuration:0.2 animations:^{

			iconView.alpha = 1;
			versionLabel.alpha = 0;

		}];

	}

	else {

		[UIView animateWithDuration:0.2 animations:^{

			iconView.alpha = 0;
			versionLabel.alpha = 1;

		}];

	}

}

// ! Reusable

- (UIImageView *)createImageViewWithImage:(UIImage *)image contentMode:(UIViewContentMode)contentMode {

	UIImageView *imageView = [UIImageView new];
	imageView.image = image;
	imageView.contentMode = contentMode;
	imageView.clipsToBounds = YES;
	imageView.translatesAutoresizingMaskIntoConstraints = NO;
	return imageView;

}

// ! UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	tableView.tableHeaderView = headerView;
	return [super tableView:tableView cellForRowAtIndexPath: indexPath];

}

// ! Preferences

- (id)readPreferenceValue:(PSSpecifier *)specifier {

	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile: kPath]];
	return settings[specifier.properties[@"key"]] ?: specifier.properties[@"default"];

}


- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {

	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile: kPath]];
	[settings setObject:value forKey:specifier.properties[@"key"]];
	[settings writeToFile:kPath atomically:YES];

	[super setPreferenceValue:value specifier: specifier];

	[NSDistributedNotificationCenter.defaultCenter postNotificationName:ArizonaDidUpdateGlyphOriginNotification object:nil];

	NSString *key = [specifier propertyForKey:@"key"];

	if([key isEqualToString:@"yes"]) {

		if(![value boolValue]) {

			[self removeSpecifier:savedSpecifiers[@"GroupCell-1"] animated:YES];
			[self removeSpecifier:savedSpecifiers[@"SegmentCell"] animated:YES];

		}

		else if(![self containsSpecifier:savedSpecifiers[@"SegmentCell"]]) {

			[self insertSpecifier:savedSpecifiers[@"GroupCell-1"] afterSpecifierID:@"FixedPositionSwitch" animated:YES];
			[self insertSpecifier:savedSpecifiers[@"SegmentCell"] afterSpecifierID:@"GroupCell-1" animated:YES];

		}

	}

	if([key isEqualToString:@"alternatePosition"]) {

		if(![value boolValue])

			[self removeContiguousSpecifiers:@[savedSpecifiers[@"GroupCell-2"], savedSpecifiers[@"XAxisLabel"], savedSpecifiers[@"XAxisSlider"], savedSpecifiers[@"YAxisLabel"], savedSpecifiers[@"YAxisSlider"]] animated:YES];

		else if(![self containsSpecifier:savedSpecifiers[@"GroupCell-2"]])

			[self insertContiguousSpecifiers:@[savedSpecifiers[@"GroupCell-2"], savedSpecifiers[@"XAxisLabel"], savedSpecifiers[@"XAxisSlider"], savedSpecifiers[@"YAxisLabel"], savedSpecifiers[@"YAxisSlider"]] afterSpecifierID:@"CustomPositionSwitch" animated:YES];

	}

	if([key isEqualToString:@"lockGlyphPosition"]) {

		if(![value boolValue])

			[self removeContiguousSpecifiers:@[savedSpecifiers[@"GroupCell-3"], savedSpecifiers[@"LockXAxisLabel"], savedSpecifiers[@"LockXAxisSlider"], savedSpecifiers[@"LockYAxisLabel"], savedSpecifiers[@"LockYAxisSlider"]] animated:YES];

		else if(![self containsSpecifier:savedSpecifiers[@"GroupCell-3"]])

			[self insertContiguousSpecifiers:@[savedSpecifiers[@"GroupCell-3"], savedSpecifiers[@"LockXAxisLabel"], savedSpecifiers[@"LockXAxisSlider"], savedSpecifiers[@"LockYAxisLabel"], savedSpecifiers[@"LockYAxisSlider"]] afterSpecifierID:@"LockGlyphPositionSwitch" animated:YES];

	}

}

// ! Dark juju

static void arizona_setTitle(PSTableCell *self, SEL _cmd, NSString *title) {

	struct objc_super superSetTitle = {
		self,
		[self superclass]
	};

	id (*superCall)(struct objc_super *, SEL, NSString *) = (void *)objc_msgSendSuper;
	superCall(&superSetTitle, _cmd, title);

	self.titleLabel.textColor = kAriTintColor;
	self.titleLabel.highlightedTextColor = kAriTintColor;

}

static void registerArizonaTintCellClass() {

	Class ArizonaTintCellClass = objc_allocateClassPair([PSTableCell class], "ArizonaTintCell", 0);
	Method method = class_getInstanceMethod([PSTableCell class], @selector(setTitle:));
	const char *typeEncoding = method_getTypeEncoding(method);
	class_addMethod(ArizonaTintCellClass, @selector(setTitle:), (IMP) arizona_setTitle, typeEncoding);

	objc_registerClassPair(ArizonaTintCellClass);

}

@end


@implementation ArizonaContributorsVC

- (NSArray *)specifiers {

	if(!_specifiers) _specifiers = [self loadSpecifiersFromPlistName:@"AriContributors" target:self];
	return _specifiers;

}

@end


@implementation ArizonaLinksVC

- (NSArray *)specifiers {

	if(!_specifiers) _specifiers = [self loadSpecifiersFromPlistName:@"AriLinks" target:self];
	return _specifiers;

}


- (void)launchDiscord { [self launchURL: [NSURL URLWithString: @"https://discord.gg/jbE3avwSHs"]]; }
- (void)launchPayPal { [self launchURL: [NSURL URLWithString: @"https://paypal.me/Luki120"]]; }
- (void)launchGitHub { [self launchURL: [NSURL URLWithString: @"https://github.com/Luki120/SmallTweaks/tree/main/SpringBoard/Arizona"]]; }
- (void)launchApril { [self launchURL: [NSURL URLWithString:@"https://repo.twickd.com/get/com.twickd.luki120.april"]]; }
- (void)launchMeredith { [self launchURL: [NSURL URLWithString:@"https://repo.twickd.com/get/com.twickd.luki120.meredith"]]; }

- (void)launchURL:(NSURL *)url { [UIApplication.sharedApplication openURL:url options:@{} completionHandler:nil]; }

@end
