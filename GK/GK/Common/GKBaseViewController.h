//
//  GKBaseViewController.h
//  GK
//
//  Created by apple on 13-4-8.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//


#import "Appheader.h"
#import "NSObject+GKExpand.h"

#define VIEW_NOBAR 0x0000
#define VIEW_WITH_NAVBAR 0x01
#define VIEW_WITH_TABBAR 0x02
#define VIEW_WITH_SYSNAVBAR 0x04
#define VIEW_WITH_NOStatusBar 0x08

typedef enum{
    VIEW_PROCESS_Init,
    VIEW_PROCESS_NORMAL,
    VIEW_PROCESS_GETTING,
    VIEW_PROCESS_FAIL,
    VIEW_PROCESS_REFRESH,
    VIEW_PROCESS_LOADMORE
   // ,VIEW_PROCESS_DISAPPEAR
}ViewProcessStatus;


typedef enum{
    WSDismissStyle_AlphaAnimation,
    WSDismissStyle_T2DAnimation
}WSDismissStyle;

@protocol GKBaseViewControllerDelegate <NSObject>
@optional
-(void)BaseControllerWouldUnload;
-(void)childViewControllerWillDisappear;
@end


@interface GKBaseViewController : UIViewController

@property (assign,nonatomic) id<GKBaseViewControllerDelegate> GKBaseDelegate;

@property (assign,nonatomic) int viewStyle;
@property (assign,nonatomic) ViewProcessStatus status;


@property (strong,nonatomic) UIView *backgroundView;




@property (strong,nonatomic) UINavigationBar *navBar;
@property (strong,nonatomic) UIBarButtonItem *backBtn;
@property (strong,nonatomic) UIBarButtonItem *rightBtn;

@property (nonatomic,strong) NSString *tabImageName;
@property (nonatomic,strong) NSString *tabTitle;

///@property (nonatomic,strong) UIView *contentView;
@property (assign,nonatomic) BOOL viewIsAppear;



-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil style:(NSInteger)viewStyle;
-(void)setBackgroundWithImage:(UIImage*)image;
-(void)setBackgroundWithUIColor:(UIColor*)color;
-(void)setTitle:(NSString *)title;
-(void)setTitleWithGKLog;
-(void)setTile:(NSString *)title withDropBtn:(BOOL)dropEnabled action:(SEL)selector;
@property (nonatomic,assign) BOOL customNavigatorAni;
-(void)addBackItem:(NSString*)title img:(UIImage*)image action:(SEL)selector;
-(void)addBackItemWithCloseImg:(SEL)selector;
-(void)addBackItem;
//-(void)addBackItemInside:(NSString *)title;

-(void)goback;
-(void)setNavBgImg:(UIImage *)navBgImg;
-(void)addNavRightItem:(NSString *)title action:(SEL)selector;
-(void)addNavRightItem:(NSString *)title img:(UIImage*)image action:(SEL)selector;
-(void)setRightBtnTitle:(NSString*)title;
-(void)removeRightItem;

//-(void)presentViewControllerWithCustomAnimation:(UIViewController *)viewControllerToPresent;
//-(void)dismissViewControllerWithCustomAnimation;
//-(void)dismissSelfWithCustomAnimation;
@property (nonatomic,strong) GKBaseViewController *presentParentVc;

-(void)presentFullScreenViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion;
-(void)dismissFullScreenViewControllerAnimated:(WSDismissStyle)style completion:(void (^)(void))completion;

//-(void)showMaskView:(SEL)maskHideHandler;
//-(void)hideMaskView;

@property (nonatomic,assign) BOOL isWaitting;
-(void)showWatting:(BOOL)delay;
-(void)showWatting;
-(void)hideWaitting;
-(void)showTopPop:(NSString*)content;

-(void)showWaiting:(NSString*)status task:(dispatch_block_t)block;
-(void)updateWaitting:(NSString*)status;
-(void)updateWaittingForError:(NSString*)errorInfo;
-(void)updateWaittingForSuccess:(NSString*)succInfo;

-(UIView*)maskView;
-(BOOL)isTabbarShowed; //使用到maskview得controller可以重载，默认是true
//-(void)showCustTabBar;
//-(void)showCustTabBar:(NSString*)tTile;

//-(void)hideCustTabBar;
//-(void)makeSystemTabBarHidden:(BOOL)hide;
//-(void)setSelectItem:(NSInteger)index;

//-(void)GKPushViewController:(UIViewController*)vc animated:(BOOL)animated;

@end





