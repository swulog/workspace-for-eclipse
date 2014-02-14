//
//  WS_BaseViewController.h
//  GS
//
//  Created by W.S. on 13-6-4.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppHeader.H"


#define WS_ViewStyleNoneBar 0x00
#define WS_ViewStyleWithNavBar 0x01
#define WS_ViewStyleWithTabBar 0x02
typedef NSInteger WS_ViewStyle;



typedef enum{
    WS_ViewStatus_Normal,
    WS_ViewStatus_Getting,
    WS_ViewStatus_Refreshing,
    WS_ViewStatus_LoadMore,
    WS_ViewStatus_GetFail
}WS_ViewStatus;


@interface WS_BaseViewController : UIViewController
{
    WS_ViewStatus iStatus;
    WS_ViewStyle  iStyle;
}
@property (assign,nonatomic) BOOL fullScreenEnabled;
@property (strong,nonatomic) UIView *backgroundView;
@property (strong,nonatomic) UINavigationBar *navBar;
@property (strong,nonatomic) UIBarButtonItem *rightBtn;
@property (strong,nonatomic) UIBarButtonItem *backBtn;

-(id)initNibWithStyle:(WS_ViewStyle)style;
//背景
-(void)setBackgroundWithImage:(UIImage*)image;
-(void)setBackgroundWithUIColor:(UIColor*)color;

//navigation bar 
-(void)setNavTitle:(NSString *)title;
-(void)addBackItem:(NSString*)title action:(SEL)selector;
-(void)addNavRightItem:(NSString *)title action:(SEL)selector;
-(void)goback;

//waitting screen
@property (assign,nonatomic) BOOL isWaitting;
-(void)showWatting;
-(void)hideWaitting;
-(void)showMaskView:(SEL)maskHideHandler;
-(void)hideMaskView;
-(void)pushViewControler:(WS_BaseViewController*)_viewCtrller withNavBar:(BOOL)_enableNav animated:(BOOL)animated;
@property(nonatomic) BOOL customAni;
@end
