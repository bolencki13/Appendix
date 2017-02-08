#import <Preferences/PSListController.h>

@interface apdSettingsListController: PSListController {
}
@end

@implementation apdSettingsListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"apdSettings" target:self] retain];
	}
	return _specifiers;
}
@end

// vim:ft=objc
