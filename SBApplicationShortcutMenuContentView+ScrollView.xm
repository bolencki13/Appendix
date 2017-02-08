#import <UIKit/UIKit.h>

#define NSLog(FORMAT, ...) NSLog(@"[%@]: %@",@"My Tweak" , [NSString stringWithFormat:FORMAT, ##__VA_ARGS__])

@interface SBApplicationShortcutMenuBackgroundView : UIView
@end

@interface SBApplicationShortcutMenuContentView : UIView
- (void)updateSelectionFromPressGestureRecognizer:(id)arg1;
- (void)_handlePress:(id)arg1;
- (double)_rowHeight;
- (double)_iconMenuMargin;
@end

BOOL hasRun;
UIScrollView *scvContentView;
NSTimer *upAction;
NSTimer *downAction;

%hook SBApplicationShortcutMenuContentView
- (id)initWithInitialFrame:(struct CGRect)arg1 containerBounds:(struct CGRect)arg2 orientation:(long long)arg3 shortcutItems:(id)arg4 application:(id)arg5 {
  hasRun = NO;

  return %orig;
}
- (void)layoutSubviews {
  %orig;

  if (!hasRun) {
    scvContentView = [[UIScrollView alloc] initWithFrame:self.bounds];
    for (UIView *view in self.subviews) {
      [view removeFromSuperview];//remove view from orignal superview
      [scvContentView addSubview:view];//adds view to our wrapper
    }
    [self addSubview:scvContentView];

    CGRect contentRect = CGRectZero;
    for (UIView *view in scvContentView.subviews) {
      CGRect rect = view.frame;
      rect.size.width = self.frame.size.width;
      contentRect = CGRectUnion(contentRect, rect);
    }
    scvContentView.contentSize = self.frame.size;//contentRect.size;//sets size of scrollView allows it to auto fit for x number of shortcuts

    hasRun = YES;
  }

  NSMutableArray *itemViews = MSHookIvar<NSMutableArray *>(self,"_itemViews");
  CGRect frameTemp = self.frame;
  if ([itemViews count] > 4) {
    frameTemp.size.height = [self _rowHeight]*4;
    // frameTemp.origin.y = frameTemp.origin.y-([self _rowHeight]*([itemViews count]-4));
  } else {
    frameTemp.size.height = [self _rowHeight]*[itemViews count];
  }
  self.frame = frameTemp;
  scvContentView.frame = self.bounds;

  CGRect contentRect = CGRectZero;
  for (UIView *view in scvContentView.subviews) {
    CGRect rect = view.frame;
    rect.size.width = self.frame.size.width;
    contentRect = CGRectUnion(contentRect, rect);
  }
  scvContentView.contentSize = contentRect.size;//sets size of scrollView allows it to auto fit for x number of shortcuts

  SBApplicationShortcutMenuBackgroundView *backgroundView = MSHookIvar<id>(self,"_backgroundView");
  backgroundView.frame = CGRectMake(0,0,contentRect.size.width,contentRect.size.height);
  for (UIView *view in backgroundView.subviews) {
    view.frame = backgroundView.bounds;
  }
}
- (void)updateSelectionFromPressGestureRecognizer:(UILongPressGestureRecognizer*)arg1 {
    if (arg1.state == UIGestureRecognizerStateChanged) {
      if ([arg1.view isKindOfClass:[self class]]) {
        CGPoint currentPos = [arg1 locationInView:arg1.view];
        if (currentPos.y < -10) {
          if (!upAction) {
            upAction = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(scrollUp) userInfo:nil repeats:YES];
          }
        } else if (currentPos.y > self.frame.size.height+10) {
          if (!downAction) {
            downAction = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(scrollDown) userInfo:nil repeats:YES];
          }
        } else {
          [downAction invalidate];
          downAction = nil;
          [upAction invalidate];
          upAction = nil;
        }
      } else {
        NSMutableArray *itemViews = MSHookIvar<NSMutableArray *>(self,"_itemViews");
        CGRect maxMenuFrame = MSHookIvar<CGRect>(self,"_maxMenuFrame");
        if ([itemViews count] > 4) {
          maxMenuFrame.size.height = [self _rowHeight]*4;
          // maxMenuFrame.origin.y = maxMenuFrame.origin.y-([self _rowHeight]*([itemViews count]-4));
        } else {
          maxMenuFrame.size.height = [self _rowHeight]*[itemViews count];
        }
        CGPoint currentPos = [arg1 locationInView:arg1.view];
        if (currentPos.y < maxMenuFrame.origin.y-10) {
          if (!upAction) {
            upAction = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(scrollUp) userInfo:nil repeats:YES];
          }
        } else if (currentPos.y > maxMenuFrame.origin.y+maxMenuFrame.size.height+10) {
          if (!downAction) {
            downAction = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(scrollDown) userInfo:nil repeats:YES];
          }
        } else {
          [downAction invalidate];
          downAction = nil;
          [upAction invalidate];
          upAction = nil;
        }
      }
    } else {
      [downAction invalidate];
      downAction = nil;
      [upAction invalidate];
      upAction = nil;
    }
    %orig;
}
%new
- (void)scrollUp {
  if (scvContentView.contentOffset.y > 0) {
    [scvContentView setContentOffset:CGPointMake(scvContentView.contentOffset.x, scvContentView.contentOffset.y - [self _rowHeight]) animated:YES];
  } else {
    [upAction invalidate];
    upAction = nil;
  }
}
%new
- (void)scrollDown {
  if (scvContentView.contentOffset.y < scvContentView.contentSize.height-scvContentView.frame.size.height+5) {
    [scvContentView setContentOffset:CGPointMake(scvContentView.contentOffset.x, scvContentView.contentOffset.y + [self _rowHeight]) animated:YES];
  } else {
    [downAction invalidate];
    downAction = nil;
  }
}
%end
%hook SBApplicationShortcutMenu
- (void)updateFromPressGestureRecognizer:(UILongPressGestureRecognizer*)arg1 {
  %orig;
  SBApplicationShortcutMenuContentView *contentView = MSHookIvar<id>(self,"_contentView");
  [contentView updateSelectionFromPressGestureRecognizer:arg1];
}
%end
