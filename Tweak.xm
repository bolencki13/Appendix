#import <UIKit/UIKit.h>

#define NSLog(FORMAT, ...) NSLog(@"[%@]: %@",@"Appendix" , [NSString stringWithFormat:FORMAT, ##__VA_ARGS__])
#define SCREEN ([UIScreen mainScreen].bounds)
#define prefs ([[NSUserDefaults alloc] initWithSuiteName:@"com.bolencki13.appendix"])

@interface UIInteractionProgress : NSObject
@end
@interface UIPreviewForceInteractionProgress : UIInteractionProgress
- (id)initWithGestureRecognizer:(id)arg1;
@end


@interface UIImage()
+(UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)bundleIdentifier format:(int)format scale:(CGFloat)scale;
@end

@interface SBApplicationShortcutStoreManager : NSObject
+ (id)sharedManager;
- (void)saveSynchronously;
- (void)setShortcutItems:(id)arg1 forBundleIdentifier:(id)arg2;
- (id)shortcutItemsForBundleIdentifier:(id)arg1;
- (id)init;
@end
@interface SBApplication : NSObject
@property(copy, nonatomic) NSArray *dynamicShortcutItems;
@property(copy, nonatomic) NSArray *staticShortcutItems;
- (id)badgeNumberOrString;
- (void)loadStaticShortcutItemsFromInfoDictionary:(id)arg1 bundle:(id)arg2;
- (NSString*)bundleIdentifier;
- (NSString*)displayName;
@end;
@interface SBIcon : NSObject
- (void)launchFromLocation:(int)location;
- (BOOL)isFolderIcon;
- (NSString*)applicationBundleID;
- (SBApplication*)application;
- (id)badgeNumberOrString;
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

@class SBSApplicationShortcutIcon;
@interface SBSApplicationShortcutItem : NSObject
@property (nonatomic, copy) NSString *type;
- (id)icon;
- (void)setIcon:(id)arg1;
- (void)setLocalizedSubtitle:(id)arg1;
- (void)setLocalizedTitle:(id)arg1;
- (void)setType:(id)arg1;
@end
@interface SBApplicationShortcutMenuItemView : UIView
@property(readonly, nonatomic) long long menuPosition; // @synthesize menuPosition=_menuPosition;
@property(retain, nonatomic) SBSApplicationShortcutItem *shortcutItem; // @synthesize shortcutItem=_shortcutItem;
@property(retain, nonatomic) UIImageView *iconView; // @synthesize iconView=_iconView;
@property(nonatomic) _Bool highlighted; // @synthesize highlighted=_highlighted;
+ (id)_imageForShortcutItem:(id)arg1 application:(id)arg2 assetManagerProvider:(id)arg3 monogrammerProvider:(id)arg4 maxHeight:(double *)arg5;
@end
@class SBApplicationShortcutMenuContentView;
@protocol SBApplicationShortcutMenuContentViewDelegate <NSObject>
- (void)menuContentView:(SBApplicationShortcutMenuContentView *)arg1 activateShortcutItem:(SBSApplicationShortcutItem *)arg2 index:(long long)arg3;
- (_Bool)menuContentView:(SBApplicationShortcutMenuContentView *)arg1 canActivateShortcutItem:(SBSApplicationShortcutItem *)arg2;
@end
@interface SBApplicationShortcutMenuContentView : UIView <SBApplicationShortcutMenuContentViewDelegate>
@property(assign,nonatomic) id <SBApplicationShortcutMenuContentViewDelegate> delegate;
- (id)initWithInitialFrame:(struct CGRect)arg1 containerBounds:(struct CGRect)arg2 orientation:(long long)arg3 shortcutItems:(id)arg4 application:(id)arg5;
- (void)updateSelectionFromPressGestureRecognizer:(id)arg1;
- (void)_handlePress:(id)arg1;
- (double)_rowHeight;
- (void)_populateRowsWithShortcutItems:(id)arg1 application:(id)arg2;
- (void)modifyView:(UIView*)view;
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
- (_Bool)_canRevealShortcutMenu;
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
	self.shortcutMenuPeekGesture.minimumPressDuration = 2.0;
	self.shortcutMenuPresentProgress = [[UIPreviewForceInteractionProgress alloc] initWithGestureRecognizer:self.shortcutMenuPeekGesture];
	[self cancelLongPressTimer];
}
%end

static SBFolderIconView *currentFolderView;
static SBApplicationShortcutMenuContentView *appShortcutView;
static BOOL onScreen;

%hook SBIconController
- (void)_handleShortcutMenuPeek:(UILongPressGestureRecognizer*)arg1 {

	if ([arg1.view class] == [%c(SBFolderIconView) class]) {
			switch (arg1.state) {
					case UIGestureRecognizerStateBegan: {

						if ([((SBFolderIconView*)arg1.view) isGrabbed]) return;

						currentFolderView = (SBFolderIconView*)arg1.view;

						self.presentedShortcutMenu = [[%c(SBApplicationShortcutMenu) alloc] initWithFrame:[UIScreen mainScreen].bounds application:nil iconView:arg1.view interactionProgress:nil orientation:1];
						self.presentedShortcutMenu.applicationShortcutMenuDelegate = self;
						UIViewController *rootView = [[UIApplication sharedApplication].keyWindow rootViewController];
						[rootView.view addSubview:self.presentedShortcutMenu];
						[self.presentedShortcutMenu presentAnimated:YES];
						[self applicationShortcutMenuDidPresent:self.presentedShortcutMenu];

					}break;

					case UIGestureRecognizerStateChanged: {
						if (!self.presentedShortcutMenu) return;
						[self.presentedShortcutMenu updateFromPressGestureRecognizer:arg1];
					}break;

					case UIGestureRecognizerStateEnded: {
						if (!self.presentedShortcutMenu) return;
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

static SBApplication *previousApp = nil;
%hook SBApplicationShortcutMenu
+ (void)initialize {
	static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class myClass = [self class];

        SEL originalSelector = @selector(_shortcutItemsToDisplay);
        SEL swizzledSelector = @selector(my___shortcutItemsToDisplay);

        Method originalMethod = class_getInstanceMethod(myClass, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(myClass, swizzledSelector);

        BOOL didAddMethod = class_addMethod(myClass,
                                            originalSelector,
                                            method_getImplementation(swizzledMethod),
                                            method_getTypeEncoding(swizzledMethod));

        if (didAddMethod) {
            class_replaceMethod(myClass,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
				HBLogDebug(@"Swizzling '-(id)_shortcutItemsToDisplay;'");
    });
}
- (id)initWithFrame:(struct CGRect)arg1 application:(id)arg2 iconView:(id)arg3 interactionProgress:(id)arg4 orientation:(long long)arg5 {
	onScreen = NO;
	return %orig;
}
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

		NSInteger shortcutItemCount = [prefs integerForKey:@"shortcutCount"];
		if (shortcutItemCount <= 0 || shortcutItemCount > 9) {
				shortcutItemCount = 4;
		}
		for (int x = 0; x < shortcutItemCount; x++) {
			NSIndexPath *indexPath = [NSIndexPath indexPathForRow:x inSection:0];
			NSString *folderName = @"Jailbreak";
			NSString *bundleID = [currentFolderView.folderIcon.folder iconAtIndexPath:indexPath].application.bundleIdentifier;
			if (bundleID != nil && ![bundleID isEqualToString:@""]) {
				UIImage *icon1 = [UIImage _applicationIconImageForBundleIdentifier:bundleID format:0 scale:[UIScreen mainScreen].scale];
				SBSApplicationShortcutItem *action = [[%c(SBSApplicationShortcutItem) alloc] init];
				[action setIcon:[[%c(SBSApplicationShortcutCustomImageIcon) alloc] initWithImagePNGData:UIImagePNGRepresentation(icon1)]];
				NSString *appName = [currentFolderView.folderIcon.folder iconAtIndexPath:indexPath].application.displayName;
				[action setLocalizedTitle:appName];
				[action setType:[NSString stringWithFormat:@"%@_=_%@",folderName,bundleID]];

				[aryItems addObject:action];
			}
	}

		return aryItems;
	} else {
		return %orig;
	}
}
%new
- (id)my___shortcutItemsToDisplay {
	if (self.application == nil) {
		NSMutableArray *aryItems = [NSMutableArray new];

		NSInteger shortcutItemCount = [prefs integerForKey:@"shortcutCount"];
		if (shortcutItemCount <= 0 || shortcutItemCount > 9) {
				shortcutItemCount = 4;
		}
		for (int x = 0; x < shortcutItemCount; x++) {
			NSIndexPath *indexPath = [NSIndexPath indexPathForRow:x inSection:0];
			NSString *folderName = @"Jailbreak";
			NSString *bundleID = [currentFolderView.folderIcon.folder iconAtIndexPath:indexPath].application.bundleIdentifier;
			if (bundleID != nil && ![bundleID isEqualToString:@""]) {
				UIImage *icon1 = [UIImage _applicationIconImageForBundleIdentifier:bundleID format:0 scale:[UIScreen mainScreen].scale];
				SBSApplicationShortcutItem *action = [[%c(SBSApplicationShortcutItem) alloc] init];
				[action setIcon:[[%c(SBSApplicationShortcutCustomImageIcon) alloc] initWithImagePNGData:UIImagePNGRepresentation(icon1)]];
				NSString *appName = [currentFolderView.folderIcon.folder iconAtIndexPath:indexPath].application.displayName;
				[action setLocalizedTitle:appName];
				[action setType:[NSString stringWithFormat:@"%@_=_%@",folderName,bundleID]];

				[aryItems addObject:action];
			}
	}

		return aryItems;
	} else {
		return [self my___shortcutItemsToDisplay];
	}
}
- (void)updateFromPressGestureRecognizer:(UIGestureRecognizer*)arg1 {
	%orig;

	if (self.application == nil) {
		SBApplicationShortcutMenuContentView *contentView = MSHookIvar<id>(self,"_contentView");
		NSMutableArray *itemViews = MSHookIvar<NSMutableArray *>(contentView,"_itemViews");

		if (onScreen == NO) {
			CGRect maxMenuFrame = MSHookIvar<CGRect>(contentView,"_maxMenuFrame");
			NSInteger origin = maxMenuFrame.origin.x + maxMenuFrame.size.width+5;
			NSInteger testWidth = 40;
			if (origin+testWidth+5 > [UIScreen mainScreen].bounds.size.width) {
				origin = maxMenuFrame.origin.x - maxMenuFrame.size.width -5;
			}
      return;
      CGRect viewFrame = maxMenuFrame;
			viewFrame.origin.x = origin;
			viewFrame.size.height = 0;
			appShortcutView = [[%c(SBApplicationShortcutMenuContentView) alloc] initWithInitialFrame:maxMenuFrame containerBounds:viewFrame orientation:[[UIDevice currentDevice] orientation] shortcutItems:[[%c(SBApplicationShortcutStoreManager) sharedManager] shortcutItemsForBundleIdentifier:[currentFolderView.folderIcon.folder iconAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].application.bundleIdentifier] application:[currentFolderView.folderIcon.folder iconAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].application];
			[self addSubview:appShortcutView];
			appShortcutView.frame = viewFrame;
			onScreen = YES;
		}

		static SBApplicationShortcutMenuItemView *currentItem = nil;
		static int totalItems = 0;
		for(SBApplicationShortcutMenuItemView *item in itemViews) {
			if (item.highlighted == YES) {
				currentItem = item;
			}
			totalItems++;
		}
		NSString *input = currentItem.shortcutItem.type;
		if ([input containsString:@"_=_"]) {
			NSArray *arySplitString = [input componentsSeparatedByString:@"_=_"];
			NSString *currentBundleID = [arySplitString objectAtIndex:1];
			for (int x = 0; x < totalItems; x++) {
				NSIndexPath *indexPath = [NSIndexPath indexPathForRow:x inSection:0];
				SBApplication *currentApp = [currentFolderView.folderIcon.folder iconAtIndexPath:indexPath].application;
				NSString *bundleID = currentApp.bundleIdentifier;
				if ([currentBundleID isEqualToString:bundleID]) {
					NSArray *aryShortcutItems = [[%c(SBApplicationShortcutStoreManager) sharedManager] shortcutItemsForBundleIdentifier:bundleID];
					if (aryShortcutItems != NULL) {
						appShortcutView.hidden = NO;
						if (previousApp != currentApp) {
							[appShortcutView _populateRowsWithShortcutItems:aryShortcutItems application:currentApp];
							appShortcutView.frame = CGRectMake(appShortcutView.frame.origin.x,appShortcutView.frame.origin.y,appShortcutView.frame.size.width,([appShortcutView _rowHeight]*[aryShortcutItems count]));
						}
						previousApp = currentApp;
					} else {
						appShortcutView.hidden = YES;
					}
					break;
				}
			}
		}
	}
}
- (void)dealloc {
	[appShortcutView removeFromSuperview];
	appShortcutView = nil;
	%orig;
}
- (void)layoutSubviews {
  %orig;
  if (onScreen == NO && [[self _shortcutItemsToDisplay] count] > 4 && self.application == nil && [prefs boolForKey:@"hideIcon"] == YES) {
    UIView *icon = MSHookIvar<id>(self,"_proxyIconViewWrapper");
    icon.hidden = YES;
  }
}
%end

%hook SBApplicationShortcutMenuContentView
- (void)_populateRowsWithShortcutItems:(id)arg1 application:(id)arg2 {
	%orig;
/*

if ([view isKindOfClass:NSClassFromString(@"SBApplicationShortcutMenuItemView")]) {
	NSString *bundleID = [((SBApplicationShortcutMenuItemView*)view).shortcutItem.type stringByReplacingOccurrencesOfString:@"Jailbreak_=_" withString:@""];;
	HBLogDebug(@"%@",bundleID);
} else {
	HBLogDebug(@"%@",NSStringFromClass([view class]));
}

*/
	[self modifyView:self];
}
%new
- (void)modifyView:(UIView*)view {
	NSArray *subviews = [view subviews];

    if ([subviews count] == 0) return;

    for (UIView *subview in subviews) {
				if ([subview isKindOfClass:NSClassFromString(@"SBApplicationShortcutMenuItemView")]) {
					NSString *bundleID = [((SBApplicationShortcutMenuItemView*)subview).shortcutItem.type stringByReplacingOccurrencesOfString:@"Jailbreak_=_" withString:@""];

					SBApplication *app = [[NSClassFromString(@"SBApplicationController") sharedInstance] applicationWithBundleIdentifier:bundleID];
					// if ([app badgeNumberOrString] == nil) return;
					NSString *badgeText = [NSString stringWithFormat:@"%@",[app badgeNumberOrString]];

					HBLogDebug(@"%@ has badge of %@",bundleID,badgeText);
					if (badgeText != nil && badgeText != NULL && ![badgeText isEqualToString:@""] && ![badgeText isEqualToString:@"(null)"]) {
						UILabel *badge = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(subview.frame)+12, -10, 20, 20)];
						badge.textColor = [UIColor whiteColor];
						badge.layer.cornerRadius = CGRectGetHeight(badge.frame)/2;
						badge.layer.masksToBounds = YES;
						badge.textAlignment = NSTextAlignmentCenter;
						badge.backgroundColor = [UIColor redColor];
						badge.text = badgeText;
						[((SBApplicationShortcutMenuItemView*)subview).iconView addSubview:badge];
					}
					// HBLogDebug(@"%@",bundleID);
				} else {
					[self modifyView:subview];
				}
    }
}
%end
