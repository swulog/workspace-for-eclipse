//
//  SlidingTabsControl.h
//  SlidingTabs
//
//  Created by Mathew Piccinato on 5/12/11.
//  Copyright 2011 Constructt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlidingTabsTab.h"

typedef enum{
    SlidTabStyle_Label,
    SlideTabStyle_View
}SlideTabStyle;

@class SlidingTabsControl;
@protocol SlidingTabsControlDelegate;

@interface SlidingTabsControl : UIView {
    SlidingTabsTab* _tab;
    UIView *nTab;
    
    NSMutableArray* _buttons;
    NSObject <SlidingTabsControlDelegate> *_delegate;
    
    SlideTabStyle iStyle;
}
@property(assign,nonatomic) int selectTabIndex;
@property(assign,nonatomic) BOOL needDropArraow;
/**
 * Setup the tabs
 */
-(void)setSlideTitle:(NSString*)_title for:(NSInteger)index;
- (id) initWithTabCount:(NSUInteger)tabCount
                   delegate:(NSObject <SlidingTabsControlDelegate>*)slidingTabsControlDelegate;

-(void)initWithTabCount_Ex:(NSUInteger)tabCount 
                  delegate:(NSObject <SlidingTabsControlDelegate>*)slidingTabsControlDelegate;

-(void)initWithCount:(NSUInteger)tabCount drop:(BOOL)enbaled delegate:(NSObject<SlidingTabsControlDelegate> *)slidingTabsControlDelegate;
@end

@protocol SlidingTabsControlDelegate




@optional
- (UILabel*) labelFor:(SlidingTabsControl*)slidingTabsControl atIndex:(NSUInteger)tabIndex;
- (NSString*) titleFor:(SlidingTabsControl*)slidingTabsControl atIndex:(NSUInteger)tabIndex;
- (UIView*) viewFor:(SlidingTabsControl*)slidingTabsControl atIndex:(NSUInteger)tabIndex;

-(UIView*)maskViewFor:(SlidingTabsControl*)slidingTabsControl;
@optional
- (void) touchUpInsideTabIndex:(NSUInteger)tabIndex;
- (void) touchDownAtTabIndex:(NSUInteger)tabIndex;
@end
