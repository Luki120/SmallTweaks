/*--- Displays the number of installed apps in the storage settings' page ---*/

@import CydiaSubstrate;
@import Preferences.PSListController;


@interface STStorageController: PSListController
@property (nonatomic, strong) NSArray *appSpecs;
@end

@class PSCapacityBarCell;

static NSArray *_actualApps;

static UITableViewCell *(*origCFRAI)(STStorageController *, SEL, UITableView *, NSIndexPath *);
static UITableViewCell *overrideCFRAI(STStorageController *self, SEL _cmd, UITableView *tableView, NSIndexPath *indexPath) {

	NSPredicate *_predicateOne = [NSPredicate predicateWithFormat: @"SELF.identifier != %@", @"com.apple.FileProvider.LocalStorage"];
	NSPredicate *_predicateTwo = [NSPredicate predicateWithFormat: @"SELF.identifier != %@", @"com.apple.ToneSettingsUsage"];
	NSPredicate *_predicateThree = [NSPredicate predicateWithFormat: @"SELF.detailControllerClass != %@", NSClassFromString(@"STStorageCloudDiskDetailController")];

	if(!_actualApps) _actualApps = [NSArray new];
	_actualApps = [self.appSpecs filteredArrayUsingPredicate: [NSCompoundPredicate andPredicateWithSubpredicates: @[_predicateOne, _predicateTwo, _predicateThree]]];

	return origCFRAI(self, _cmd, tableView, indexPath);

}

static void (*origCL)(PSCapacityBarCell *, SEL, NSArray *);
static void overrideCL(PSCapacityBarCell *self, SEL _cmd, NSArray *legends) {

	origCL(self, _cmd, legends);

	UILabel *_sizeLabel = MSHookIvar<UILabel *>(self, "_sizeLabel");
	if([MSHookIvar<UILabel *>(self, "_titleLabel").text	isEqualToString: @"iPod touch"]) _sizeLabel.font = [UIFont systemFontOfSize: 13];
	_sizeLabel.text = [_sizeLabel.text stringByAppendingString:[NSString stringWithFormat: @", %ld Apps", [_actualApps count]]];

}

__attribute__((constructor)) static void init(void) {

	[[NSBundle bundleWithPath: @"/System/Library/PreferenceBundles/StorageSettings.bundle"] load];

	MSHookMessageEx(NSClassFromString(@"PSCapacityBarCell"), @selector(createLegends:), (IMP) &overrideCL, (IMP *) &origCL);
	MSHookMessageEx(NSClassFromString(@"STStorageController"), @selector(tableView:cellForRowAtIndexPath:), (IMP) &overrideCFRAI, (IMP *) &origCFRAI);

}
