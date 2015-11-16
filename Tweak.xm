#import <UIKit/UIKit.h>

#define NSLog(FORMAT, ...) NSLog(@"[%@]: %@",@"Appendix" , [NSString stringWithFormat:FORMAT, ##__VA_ARGS__])


@interface UIInteractionProgress : NSObject
@end
@interface UIPreviewForceInteractionProgress : UIInteractionProgress
- (id)initWithGestureRecognizer:(id)arg1;
@end

@interface UIImage()
+(UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)bundleIdentifier format:(int)format scale:(CGFloat)scale;
@end
@interface SBApplication : NSObject
- (NSString*)bundleIdentifier;
- (NSString*)displayName;
@end;
@interface SBIcon : NSObject
- (void)launchFromLocation:(int)location;
- (BOOL)isFolderIcon;// iOS 4+
- (NSString*)applicationBundleID;
- (SBApplication*)application;
@end
@interface SBFolder : NSObject
- (SBIcon*)iconAtIndexPath:(NSIndexPath *)indexPath;
@end
@interface SBFolderIcon : NSObject
- (SBFolder*)folder;
@end


@interface SBIconView : UIView
@property(retain, nonatomic) SBIcon* icon;
@property(retain, nonatomic) UIPreviewForceInteractionProgress *shortcutMenuPresentProgress; // @synthesize shortcutMenuPresentProgress=_shortcutMenuPresentProgress;
@property(retain, nonatomic) UILongPressGestureRecognizer *shortcutMenuPeekGesture; // @synthesize shortcutMenuPeekGesture=_shortcutMenuPeekGesture;
- (void)cancelLongPressTimer;
@end
@interface SBFolderIconView : SBIconView
- (SBFolderIcon*)folderIcon;
@end


@interface SBSApplicationShortcutItem : NSObject
- (void)setIcon:(id)arg1;
- (void)setLocalizedSubtitle:(id)arg1;
- (void)setLocalizedTitle:(id)arg1;
- (void)setType:(id)arg1;
@end
@interface SBApplicationShortcutMenuItemView : UIView
@property(readonly, nonatomic) long long menuPosition; // @synthesize menuPosition=_menuPosition;
@property(retain, nonatomic) SBSApplicationShortcutItem *shortcutItem; // @synthesize shortcutItem=_shortcutItem;
@property(nonatomic) _Bool highlighted; // @synthesize highlighted=_highlighted;
@end
@interface SBApplicationShortcutMenuContentView : UIView
@end
@class SBApplicationShortcutMenu;
@protocol SBApplicationShortcutMenuDelegate <NSObject>
- (void)applicationShortcutMenu:(SBApplicationShortcutMenu *)arg1 launchApplicationWithIconView:(SBIconView *)arg2;
- (void)applicationShortcutMenu:(SBApplicationShortcutMenu *)arg1 startEditingForIconView:(SBIconView *)arg2;
- (void)applicationShortcutMenu:(SBApplicationShortcutMenu *)arg1 activateShortcutItem:(SBSApplicationShortcutItem *)arg2 index:(long long)arg3;

@optional
- (void)applicationShortcutMenuDidPresent:(SBApplicationShortcutMenu *)arg1;
- (void)applicationShortcutMenuDidDismiss:(SBApplicationShortcutMenu *)arg1;
@end
@interface SBApplicationShortcutMenu : UIView
@property(retain, nonatomic) SBApplication *application; // @synthesize application=_application;
@property(retain ,nonatomic) id <SBApplicationShortcutMenuDelegate> applicationShortcutMenuDelegate; // @synthesize applicationShortcutMenuDelegate=_applicationShortcutMenuDelegate;
- (id)initWithFrame:(CGRect)arg1 application:(id)arg2 iconView:(id)arg3 interactionProgress:(id)arg4 orientation:(long long)arg5;
- (void)presentAnimated:(_Bool)arg1;
- (void)menuContentView:(id)arg1 activateShortcutItem:(id)arg2 index:(long long)arg3;
- (void)updateFromPressGestureRecognizer:(id)arg1;
@end


@interface SBIconController : UIViewController <SBApplicationShortcutMenuDelegate>
@property(retain, nonatomic) SBApplicationShortcutMenu *presentedShortcutMenu; // @synthesize presentedShortcutMenu=_presentedShortcutMenu;
+ (id)sharedInstance;
- (void)_handleShortcutMenuPeek:(UILongPressGestureRecognizer*)arg1;
- (void)applicationShortcutMenuDidPresent:(id)arg1;
@end


@interface SBSApplicationShortcutIcon : NSObject
@end
@interface SBSApplicationShortcutSystemIcon : SBSApplicationShortcutIcon
- (id)initWithType:(UIApplicationShortcutIconType)arg1;
@end
@interface SBSApplicationShortcutCustomImageIcon : SBSApplicationShortcutIcon
- (id)initWithImagePNGData:(id)arg1;
@end
@interface SBSApplicationShortcutContactIcon : SBSApplicationShortcutIcon
-(instancetype)initWithContactIdentifier:(NSString *)contactIdentifier;
-(instancetype)initWithFirstName:(NSString*)firstName lastName:(NSString*)lastName;
-(instancetype)initWithFirstName:(NSString*)firstName lastName:(NSString*)lastName imageData:(NSData*)imageData;
@end

@interface UIApplication (Private)
-(BOOL)launchApplicationWithIdentifier:(NSString*)identifier suspended:(BOOL)suspended;
@end



%hook SBFolderIconView
- (void)setIcon:(id)arg1 {
	%orig;
	self.shortcutMenuPeekGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:[%c(SBIconController) sharedInstance] action:@selector(_handleShortcutMenuPeek:)];
	self.shortcutMenuPresentProgress = [[UIPreviewForceInteractionProgress alloc] initWithGestureRecognizer:self.shortcutMenuPeekGesture];
	[self cancelLongPressTimer];
}
%end

static SBFolderIconView *currentFolderView;

%hook SBIconController
- (void)_handleShortcutMenuPeek:(UILongPressGestureRecognizer*)arg1 {
	if ([arg1.view class] == [%c(SBFolderIconView) class]) {
		switch (arg1.state) {
        case UIGestureRecognizerStateBegan: {
						currentFolderView = (SBFolderIconView*)arg1.view;

						self.presentedShortcutMenu = [[%c(SBApplicationShortcutMenu) alloc] initWithFrame:[UIScreen mainScreen].bounds application:nil iconView:arg1.view interactionProgress:nil orientation:1];
						self.presentedShortcutMenu.applicationShortcutMenuDelegate = self;
						UIViewController *rootView = [[UIApplication sharedApplication].keyWindow rootViewController];
						[rootView.view addSubview:self.presentedShortcutMenu];
						[self.presentedShortcutMenu presentAnimated:YES];
						[self applicationShortcutMenuDidPresent:self.presentedShortcutMenu];

					}break;

					case UIGestureRecognizerStateChanged: {
						[self.presentedShortcutMenu updateFromPressGestureRecognizer:arg1];
					}break;
					case UIGestureRecognizerStateEnded: {
						SBApplicationShortcutMenuContentView *contentView = MSHookIvar<id>(self.presentedShortcutMenu,"_contentView");
						NSMutableArray *itemViews = MSHookIvar<NSMutableArray *>(contentView,"_itemViews");
						for(SBApplicationShortcutMenuItemView *item in itemViews) {
							if (item.highlighted == YES) {
								[self.presentedShortcutMenu menuContentView:contentView activateShortcutItem:item.shortcutItem index:item.menuPosition];
								break;
							}
						}
					}break;
        default:
            break;
    }

	} else {
		%orig;
	}
}
%end


%hook SBApplicationShortcutMenu
- (void)menuContentView:(id)arg1 activateShortcutItem:(UIApplicationShortcutItem*)arg2 index:(long long)arg3 {
	NSString *input = arg2.type;
	if ([input containsString:@"_=_"]) {
		NSArray *arySplitString = [input componentsSeparatedByString:@"_=_"];
		NSString *folderName = [arySplitString objectAtIndex:0];
		NSString *bundleID = [arySplitString objectAtIndex:1];

		[[UIApplication sharedApplication] launchApplicationWithIdentifier:bundleID suspended:NO];
	} else {
		%orig;
	}
}
- (id)_shortcutItemsToDisplay {

	if (self.application == nil) {
		NSMutableArray *aryItems = [NSMutableArray new];

		for (int x = 0; x < 4; x++) {
			NSIndexPath *indexPath = [NSIndexPath indexPathForRow:x inSection:0];
			NSString *folderName = @"Jailbreak";
			NSString *bundleID = [currentFolderView.folderIcon.folder iconAtIndexPath:indexPath].application.bundleIdentifier;
			if (bundleID == nil || [bundleID isEqualToString:@""]) {
				break;
			}

			UIImage *icon1 = [UIImage _applicationIconImageForBundleIdentifier:bundleID format:0 scale:[UIScreen mainScreen].scale];
			SBSApplicationShortcutItem *action = [[%c(SBSApplicationShortcutItem) alloc] init];
			[action setIcon:[[%c(SBSApplicationShortcutCustomImageIcon) alloc] initWithImagePNGData:UIImagePNGRepresentation(icon1)]];
			NSString *appName = [currentFolderView.folderIcon.folder iconAtIndexPath:indexPath].application.displayName;
			[action setLocalizedTitle:appName];
			[action setType:[NSString stringWithFormat:@"%@_=_%@",folderName,bundleID]];

			[aryItems addObject:action];
		}

		return aryItems;
	} else {
		return %orig;
	}
}
%end
