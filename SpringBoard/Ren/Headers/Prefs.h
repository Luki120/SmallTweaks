#import "Common.h"

static CGFloat iconSize;
static CGFloat widthDimension;
static CGFloat heightDimension;
static CGFloat sectionHorizontalPadding;

static void loadShit(void) {

	NSDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile: kPath];

	iconSize = prefs[@"iconSize"] ? [prefs[@"iconSize"] floatValue] : 60;
	widthDimension = prefs[@"widthDimension"] ? [prefs[@"widthDimension"] floatValue] : 78;
	heightDimension = prefs[@"heightDimension"] ? [prefs[@"heightDimension"] floatValue] : 118.5;
	sectionHorizontalPadding = prefs[@"sectionHorizontalPadding"] ? [prefs[@"sectionHorizontalPadding"] floatValue] : 13;

}
