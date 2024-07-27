/*--- Swipe up on the dock to get a test notification, no dependencies at all ™ ---*/

@import CydiaSubstrate;
@import UIKit;


@interface BBBulletin : NSObject
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL clearable;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *recordID;
@property (nonatomic, copy) NSString *sectionID;
@property (nonatomic, copy) NSString *bulletinID;
@property (nonatomic, copy) NSString *publisherBulletinID;
@property (nonatomic, assign) BOOL showsMessagePreview;
@end


@interface BBServer : NSObject
- (id)initWithQueue:(id)queue;
- (void)publishBulletin:(BBBulletin *)bulletin destinations:(NSUInteger)destinations;
@end


@interface SBDockView : UIView
@end


@interface UNSDefaultDataProviderFactory : NSObject
@end


@interface UNSUserNotificationServer : NSObject
+ (id)sharedInstance;
@end


extern dispatch_queue_t __BBServerQueue;

static BBServer *bbServer;
static NSNotificationName const WisteriaDidSwipeUpDockNotification = @"WisteriaDidSwipeUpDockNotification";

static BBServer *(*origIWQ)(BBServer *, SEL, dispatch_queue_t *);
static BBServer *overrideIWQ(BBServer *self, SEL _cmd, dispatch_queue_t *queue) {

	bbServer = origIWQ(self, _cmd, queue);
	return bbServer;

}

static void (*origDMTS)(SBDockView *, SEL);
static void overrideDMTS(SBDockView *self, SEL _cmd) {

	origDMTS(self, _cmd);

	UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(wisteria_didSwipeUp)];
	swipeRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
	[self addGestureRecognizer: swipeRecognizer];

}

static void wisteria_didSwipeUp(SBDockView *self, SEL _cmd) {

	[NSNotificationCenter.defaultCenter postNotificationName:WisteriaDidSwipeUpDockNotification object: nil];

}

static void sendTestNotification(void) {

	// credits for finding this out ⇝ Gc
	UNSDefaultDataProviderFactory *dataProvider = MSHookIvar<UNSDefaultDataProviderFactory *>([NSClassFromString(@"UNSUserNotificationServer") sharedInstance] , "_dataProviderFactory");
	if(!dataProvider) return;

	NSMutableSet *authorizedBundlesSet = MSHookIvar<NSMutableSet *>(dataProvider, "_authorizedBundleIdentifiers");
	NSArray *authorizedBundles = [authorizedBundlesSet allObjects];

	NSPredicate *cleanPredicate = [NSPredicate predicateWithFormat: @"NOT (SELF BEGINSWITH %@)", @"com.apple"];
	NSArray *cleanAuthorizedBundles = [authorizedBundles filteredArrayUsingPredicate: cleanPredicate];

	BBBulletin *bulletin = [BBBulletin new];
	bulletin.date = [NSDate new];
	bulletin.title = @"Wisteria";
	bulletin.message = @"Test notification incoming";
	bulletin.recordID = [[NSProcessInfo processInfo] globallyUniqueString];
	bulletin.clearable = YES;
	bulletin.sectionID = cleanAuthorizedBundles[arc4random_uniform(cleanAuthorizedBundles.count)];
	bulletin.bulletinID = [[NSProcessInfo processInfo] globallyUniqueString];
	bulletin.publisherBulletinID = [[NSProcessInfo processInfo] globallyUniqueString];
	bulletin.showsMessagePreview = YES;

	if(!bbServer) return;
	dispatch_sync(__BBServerQueue, ^{ [bbServer publishBulletin:bulletin destinations:15]; });

}

static id observer;

__attribute__((constructor)) static void init(void) {

	MSHookMessageEx(NSClassFromString(@"BBServer"), @selector(initWithQueue:), (IMP) &overrideIWQ, (IMP *) &origIWQ);
	MSHookMessageEx(NSClassFromString(@"SBDockView"), @selector(didMoveToSuperview), (IMP) &overrideDMTS, (IMP *) &origDMTS);

	class_addMethod(NSClassFromString(@"SBDockView"), @selector(wisteria_didSwipeUp), (IMP) &wisteria_didSwipeUp, "v@:");

	observer = [NSNotificationCenter.defaultCenter addObserverForName:WisteriaDidSwipeUpDockNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {

		sendTestNotification();

	}];

}
