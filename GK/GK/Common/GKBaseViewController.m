//
//  GKBaseViewController.m
//  GK
//
//  Created by apple on 13-4-8.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GKBaseViewController.h"
#import "GlobalObject.h"
#import "ReferemceList.h"
#import "UIViewController+AKTabBarController.h"
#import "MMVectorImage.h"

#define kWSPresentPush @"WSPresendPush"
#define kWSPresentPop @"WSPresendPop"

@interface GKBaseViewController ()
{
    
}
@property (nonatomic,strong) UIImageView *statusBgView;
@property (nonatomic,strong) UIViewController *presentdVc;
@property (nonatomic,copy) NillBlock_Nill finishedBlock;
@property (nonatomic,assign) BOOL isPoping;
@property (nonatomic,strong) UIImage *navBgImg;

@property (strong,nonatomic) UIControl *maskView;
@property (strong,nonatomic) MBProgressHUD *processHud;
@property (assign,nonatomic) SEL maskHandler;

@end

@implementation GKBaseViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.status = VIEW_PROCESS_Init;
    }
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil style:(NSInteger)viewStyle
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.status = VIEW_PROCESS_Init;
        self.viewStyle = viewStyle;
        float navBarY = 0;

        if (IOS_VERSION >= 7.0 && !(self.viewStyle &VIEW_WITH_SYSNAVBAR) && !(self.viewStyle & VIEW_WITH_NOStatusBar)) {
            UIImageView *statusBgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 20)];
            [statusBgV setImage:[UIImage imageNamed:StatusBarBg]];
            self.statusBgView = statusBgV;
            navBarY = 20;
        }
        
        if (self.viewStyle & VIEW_WITH_NAVBAR) {
            self.navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, navBarY, APP_SCREEN_WIDTH, APP_NAVBAR_HEIGHT)];
            [self.navBar setBarStyle:UIBarStyleDefault];
            UINavigationItem *item = [[UINavigationItem alloc] init];
            [self.navBar pushNavigationItem:item animated:NO];
            self.navBgImg = NavBg();
          //  [self.navBar setBackgroundImage:NavBg() forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
        }
    }

    return self;
}

-(id)init
{
    return [self initWithNibName:[NSString stringWithUTF8String:class_getName([self class])] bundle:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (isRetina_640X1136) {
        self.view.frame = CGRectMake(0, 0, 320, 568);
    } else {
        self.view.frame = CGRectMake(0, 0, 320, 480);
    }
    
    float offsetY = 0 ;
    if (self.statusBgView ){//|| self.viewStyle & VIEW_WITH_SYSNAVBAR) {
        offsetY += 20;
    }
    
    if (self.navBar){// || self.viewStyle & VIEW_WITH_SYSNAVBAR) {
        offsetY += APP_NAVBAR_HEIGHT;
    }
    
    if (offsetY > 0 ) {
        for (UIView *v in self.view.subviews) {
            if (![v isKindOfClass:[UINavigationBar class]]) {
                [v move:offsetY direct:Direct_Down];
            }
        }
    }
    
    self.backgroundView = [[UIView alloc] initWithFrame:self.view.frame];
    self.backgroundView.backgroundColor = [UIColor clearColor];
  //  [self.backgroundView setBackgroundColor:colorWithUtfStr(CommonViewBGColor)];
   // [self setBackgroundWithImage:[UIImage imageNamed:@"screen_backgroud"]];
    [self.view addSubview:self.backgroundView];
    [self.view sendSubviewToBack:self.backgroundView];

     [self.view setBackgroundColor:colorWithUtfStr(CommonViewBGColor)];
    
    if (self.statusBgView) {
        [self.view addSubview:self.statusBgView];
    }
    
    if (self.navBar) {
        [self.view addSubview:self.navBar];
    }
    
//    if (self.viewStyle & VIEW_WITH_SYSNAVBAR) {
//        self.navBar = self.navigationController.navigationBar;
//    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
//    self.status = VIEW_PROCESS_DISAPPEAR;
    self.viewIsAppear = FALSE;
    
    if (self.GKBaseDelegate && [self.GKBaseDelegate respondsToSelector:@selector(childViewControllerWillDisappear)]) {
        [self.GKBaseDelegate performSelector:@selector(childViewControllerWillDisappear)];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    self.viewIsAppear = TRUE;
    if (self.navBar) {
        if (IOS_VERSION >= 7.0) {
            [self.navBar setBackgroundImage:self.navBgImg forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
        } else {
            [self.navBar setBackgroundImage:self.navBgImg forBarMetrics:UIBarMetricsDefault];
        }
        
    } else {
        if (IOS_VERSION >= 7.0) {
            [self.navigationController.navigationBar setBackgroundImage:self.navBgImg forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
        } else{
            [self.navigationController.navigationBar setBackgroundImage:self.navBgImg forBarMetrics:UIBarMetricsDefault];
        }
    }
    
    if (self.viewStyle & VIEW_WITH_NAVBAR || self.viewStyle == VIEW_NOBAR) {
        [self.navigationController setNavigationBarHidden:YES];
    } else {
        [self.navigationController setNavigationBarHidden:FALSE];
    }
    
}


-(void)dealloc
{
    self.backgroundView = nil;
    self.maskView = nil;
    self.maskHandler = nil;
    self.navBar = nil;
    self.backBtn = nil;
    self.rightBtn = nil;
}



#pragma mark - 
#pragma mark general function -
-(void)goback
{
    if (self.navigationController) {
        if (self.navigationController.viewControllers.count == 1) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
//            if (self.customNavigatorAni) {
//                [self.navigationController popViewControllerAnimatedWithTransition];
//            } else
            
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)setBackgroundWithUIColor:(UIColor*)color
{
    self.backgroundView.layer.contents = nil;
    self.backgroundView.backgroundColor = color;
}

-(void)setBackgroundWithImage:(UIImage*)image
{
    
    self.backgroundView.layer.contents = (id) image.CGImage;
    // 如果需要背景透明加上下面这句
        self.backgroundView.layer.backgroundColor = [UIColor clearColor].CGColor;
    //    UIColor *color = [UIColor colorWithPatternImage:image];
    //    self.backgroundView.backgroundColor = color;
}
-(void)setNavBgImg:(UIImage *)navBgImg
{
    _navBgImg = navBgImg;
}

-(void)setTile:(NSString *)title withDropBtn:(BOOL)dropEnabled action:(SEL)selector;
{
    if (dropEnabled && !self.navBar.topItem.titleView) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        float width = 10;
        
        if (IsSafeString(title)) {
            CGSize labsize = [title sizeWithFont:btn.titleLabel.font constrainedToSize:CGSizeMake(9999,20) lineBreakMode:NSLineBreakByWordWrapping];
            width = labsize.width;
        }
        
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:colorWithUtfStr(NavBarTitleColor) forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btn setFrame:CGRectMake(0,0 , width + NavBarDownArrowWidth, 30)];
//        btn.titleLabel.layer.shadowColor = [UIColor blackColor].CGColor; //阴影的颜色
//        btn.titleLabel.layer.shadowOpacity = 0.5f; //阴影的不透明度
//        btn.titleLabel.layer.shadowOffset = CGSizeMake(0.5f, 0.5f); //阴影的偏移量，这个很重要
//        btn.titleLabel.layer.shadowRadius = 0.2f; //阴影的扩散半径，个人感觉有点photoshop的锐化的感觉
        
        UIImageView *imgV =[[UIImageView alloc] initWithImage:[UIImage imageNamed:NavBarDownArrow]];
        [imgV setFrame:CGRectMake(width+7, 12, NavBarDownArrowWidth, NavBarDownArrowheight)];
        [btn addSubview:imgV];
        
        [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
        
        self.navBar.topItem.titleView = btn;
    } else {
        [self setTitle:title];
    }
}

-(void)setTitleWithGKLog
{
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed: GK_NavLog]];
    [imgV setFrame:CGRectMake(0, 0, GK_NavLogWidth, GK_NavLogHeight)];
    self.navBar.topItem.titleView = imgV;
}

-(void)setTitle:(NSString *)title
{
    if (self.navBar) {
        if (!self.navBar.topItem.titleView) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
            label.text = title;
            label.textColor = colorWithUtfStr(NavBarTitleColor);
            label.textAlignment = NSTextAlignmentCenter;
            label.font = FONT_NORMAL_21;
            label.backgroundColor = [UIColor clearColor];
            self.navBar.topItem.titleView = label;
        } else if([self.navBar.topItem.titleView isKindOfClass:[UIButton class]]){
            [((UIButton*)self.navBar.topItem.titleView) setTitle:title forState:UIControlStateNormal];
        } else if([self.navBar.topItem.titleView isKindOfClass:[UILabel class]]){
            ((UILabel*)self.navBar.topItem.titleView).text = title;
        }
    } else {
        [self.navigationItem setTitle:title];
    }

}



-(void)addBackItem
{
    if (self.presentingViewController) {
        [self addBackItemWithCloseImg:Nil];
    } else {
        [self addBackItem:nil img:nil action:nil];

    }
    //[self addBackItem:nil];
}

-(void)addBackItemWithCloseImg:(SEL)selector
{
    [self addBackItem:Nil img:[UIImage imageNamed:NavBarCloseIcon] action:selector];
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setImage:[UIImage imageNamed:NavBarCloseIcon] forState:UIControlStateNormal];
//    [btn setFrame:CGRectMake(0, 0, NavBarCloseIconWidth, NavBarCloseIconHeight)];
//    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
//        
//    self.backBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
//    self.navBar.topItem.leftBarButtonItem = self.backBtn;
}



-(void)addBackItem:(NSString*)title img:(UIImage*)image action:(SEL)selector
{
    UIImage *backImg ;
    if (image) {
        backImg = image;
    } else {
        backImg = [UIImage imageNamed:NavBarLeftArrow];
    }
    
    CGSize imgSize = backImg.size;
    CGRect rect = CGRectZero;
    rect.size = imgSize;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = rect;
    [btn setImage:backImg forState:UIControlStateNormal];
    if (IsSafeString(title)) {
        [btn setTitle:title forState:UIControlStateNormal];
        btn.titleLabel.font =[UIFont systemFontOfSize:14];
    }
    
    [btn addTarget:self action:selector?selector:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    
    self.backBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    if (self.viewStyle & VIEW_WITH_NAVBAR) {
        self.navBar.topItem.leftBarButtonItem = self.backBtn;
    } else {
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.leftBarButtonItem = self.backBtn ;
    }
}

-(void)addNavRightItem:(NSString *)title action:(SEL)selector
{
    self.rightBtn = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:selector];
    [self.rightBtn setTintColor:colorWithUtfStr("#e0a82e")];
    
    if (self.navBar) {
        self.navBar.topItem.rightBarButtonItem = self.rightBtn;
    } else{
        [self.navigationItem setRightBarButtonItem:self.rightBtn];
    }
    
}

-(void)addNavRightItem:(NSString *)title img:(UIImage*)image action:(SEL)selector
{
    
    if (title) {
        [self addNavRightItem:title action:selector];
    } else if(image){
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        [btn setImage:image forState:UIControlStateNormal];
       // btn.showsTouchWhenHighlighted = YES;
        [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
        
        self.rightBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navBar.topItem.rightBarButtonItem = self.rightBtn;
    }
}

-(void)setRightBtnTitle:(NSString*)title
{
    UIButton *btn = (UIButton*)self.rightBtn.customView;
    [btn setTitle:title forState:UIControlStateNormal];
}

-(void)removeRightItem
{
    self.navBar.topItem.rightBarButtonItem = nil;
    self.rightBtn = nil;
}
//-(void)addNavRightItem:(NSString*)title action:(NillBlock_Sender)handler
//{
//    self.rightBtn = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonSystemItemFastForward handler:handler];
//    self.navBar.topItem.rightBarButtonItem = self.rightBtn;
//}

//-(void)presentViewControllerWithCustomAnimation:(UIViewController *)viewControllerToPresent
//{
//    self.presentdVc = viewControllerToPresent;
//    if ([viewControllerToPresent isKindOfClass:[GKBaseViewController class]]) {
//        ((GKBaseViewController*)viewControllerToPresent).presentParentVc = self;
//    }
//    
//    CATransition *transition=[CATransition animation];
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
//    transition.duration = CMM_AnimatePerior;
//    transition.type = kCATransitionMoveIn;
//    transition.subtype = kCATransitionFromTop;
//    [self.presentdVc.view.layer addAnimation:transition forKey:kWSPresentPush];
//    [self.view addSubview:self.presentdVc.view];
//}
//
//-(void)dismissViewControllerWithCustomAnimation
//{
//    CGAffineTransform transform = CGAffineTransformMakeTranslation(self.view.frame.size.width, 0);
//    [UIView animateWithDuration:CMM_AnimatePerior animations:^{
//        self.presentdVc.view.transform = transform;
//    } completion:^(BOOL finished) {
//        if (finished) {
//            [self.presentdVc.view removeFromSuperview];
//            if ([self.presentdVc isKindOfClass:[GKBaseViewController class]]) {
//                ((GKBaseViewController*)self.presentdVc).presentParentVc = nil;
//            }
//            self.presentdVc = Nil;
//        }
//    }];
//}
//
//-(void)dismissSelfWithCustomAnimation
//{
//    [((GKBaseViewController*)self.presentParentVc) dismissViewControllerWithCustomAnimation];
//}

-(void)presentFullScreenViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
        self.presentdVc = viewControllerToPresent;
        self.finishedBlock = completion;
        if ([viewControllerToPresent isKindOfClass:[GKBaseViewController class]]) {
            ((GKBaseViewController*)viewControllerToPresent).presentParentVc = self;
        } else if([viewControllerToPresent isKindOfClass:[UINavigationController class]]){
            UINavigationController *vc = (UINavigationController*)viewControllerToPresent;
            if ([vc.topViewController isKindOfClass:[GKBaseViewController class]]) {
                ((GKBaseViewController*)vc.topViewController).presentParentVc = self;
            }
        }
    
        CATransition *transition=[CATransition animation];
        transition.duration = CMM_AnimatePerior;
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromTop;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut] ;
        transition.delegate = self;
  
        [self.presentdVc.view.layer addAnimation:transition forKey:kWSPresentPush];
        [APP_DELEGATE.window addSubview:self.presentdVc.view];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {

        if (self.isPoping) {
            self.isPoping = FALSE;
            [self.presentdVc.view removeFromSuperview];
            self.presentdVc = nil;
        }
        
        SAFE_BLOCK_CALL_VOID(self.finishedBlock);
        self.finishedBlock = nil;
    }
}

-(void)dismissFullScreenViewControllerAnimated:(WSDismissStyle)style completion:(void (^)(void))completion
{
    
    self.isPoping = TRUE;
    
    switch (style) {
        case WSDismissStyle_AlphaAnimation:
        {
            [UIView animateWithDuration:1.0f animations:^{
                self.presentdVc.view.alpha = 0;
            } completion:^(BOOL finished) {
                if (finished) {
                    self.isPoping = FALSE;
                    [self.presentdVc.view removeFromSuperview];
                    self.presentdVc = nil;
                    SAFE_BLOCK_CALL_VOID(completion);
                }
            }];
            
            //            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            //            animation.fromValue = [NSNumber numberWithFloat:1.0f];
            //            animation.toValue = [NSNumber numberWithFloat:0.0f];
            //            animation.duration = 1.0f;
            //            animation.delegate = self;
            //            [self.presentdVc.view.layer addAnimation:animation forKey:kWSPresentPop];
            break;
        }
        case WSDismissStyle_T2DAnimation:
        {
            [UIView animateWithDuration:CMM_AnimatePerior delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.presentdVc.view.transform = CGAffineTransformMakeTranslation(0, self.presentdVc.view.frame.size.height);
            } completion:^(BOOL finished) {
                if(finished) {
                    self.isPoping = FALSE;
                    [self.presentdVc.view removeFromSuperview];
                    self.presentdVc = nil;
                    SAFE_BLOCK_CALL_VOID(completion);
                }
            }];
            
//            [UIView animateWithDuration:CMM_AnimatePerior animations:^{
//                self.presentdVc.view.transform = CGAffineTransformMakeTranslation(0, self.presentdVc.view.frame.size.height);
//            } completion:^(BOOL finished) {
//                if(finished) {
//                    self.isPoping = FALSE;
//                    [self.presentdVc.view removeFromSuperview];
//                    self.presentdVc = nil;
//                    SAFE_BLOCK_CALL_VOID(completion);
//                }
//            }];
            break;
        }
        default:
            break;
    }
}

-(BOOL)isTabbarShowed
{
    return FALSE;
}

-(UIView*)maskView
{
    if (!_maskView) {
        float y = 0;
        float height = self.view.frame.size.height;
        
        if (!(self.viewStyle & VIEW_WITH_NOStatusBar))
            y += APP_STATUSBAR_HEIGHT;
        if (self.viewStyle & VIEW_WITH_NAVBAR)
            y += APP_NAVBAR_HEIGHT;
        
        height -= y;
        
        if ([self isTabbarShowed])
            height -= APP_TABBAR_HEIGHT;

        CGRect rect = self.view.frame;
        rect.origin.y += y;
        rect.size.height = height;
        _maskView = [[UIControl alloc] initWithFrame:rect];
        _maskView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_maskView];
    }
    
    return _maskView;
}


-(void)showWaiting:(NSString*)status task:(dispatch_block_t)block
{
    MBProgressHUD *hud =  [[MBProgressHUD alloc] initToView:self.maskView];
    [hud setMode:MBProgressHUDModeIndeterminate];
    [hud setLabelText:@"正在上传评论"];
    [hud setLabelFont:FONT_NORMAL_13];
    [hud showWhileExecuting:block animated:YES];
    self.processHud = hud;
}

-(void)updateWaitting:(NSString*)status
{
    if (self.processHud) {
        [self.processHud setLabelText:status];
        sleep(0.5f);
    }
}

-(void)updateWaittingForImg:(UIImage*)image status:(NSString*)status hide:(BOOL)hided
{
    if (self.processHud) {
        dispatch_block_t block = ^{
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            self.processHud.customView = imageView;
            [self.processHud setMode:MBProgressHUDModeCustomView];
            [self.processHud setLabelText:status];
            if (hided) {
                [self.processHud hide:YES afterDelay:1.3f];
                double delayInSeconds = 1.5f;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self.maskView removeFromSuperview];
                    self.maskView = nil;
                    self.processHud = nil;
                });
            }
        };
        
        if ([NSThread isMainThread]) {
            block();
        } else {
            dispatch_async(dispatch_get_main_queue(), block);
        }
    }
}

-(void)updateWaittingForError:(NSString*)errorInfo
{
    UIImage *image = [MMVectorImage
                      vectorImageShapeOfType:MMVectorShapeTypeX
                      size:CGSizeMake(37, 37)
                      fillColor:[UIColor colorWithWhite:1.f alpha:1.f]];

    [self updateWaittingForImg:image status:errorInfo hide:TRUE];
}

-(void)updateWaittingForSuccess:(NSString*)succInfo
{
    UIImage *image = [MMVectorImage
                      vectorImageShapeOfType:MMVectorShapeTypeCheck
                      size:CGSizeMake(37, 37)
                      fillColor:[UIColor colorWithWhite:1.f alpha:1.f]];
    
    [self updateWaittingForImg:image status:succInfo hide:TRUE];
}
//-(void)showMaskView:(SEL)maskHideHandler
//{
//    if (!self.maskControl) {
//        CGRect rect = APP_FRAME;
//        rect.origin.y = 0;
//        self.maskControl = [[UIControl alloc] initWithFrame:rect];
//        [self.maskControl addTarget:self action:@selector(hideMaskView) forControlEvents:UIControlEventTouchDown];
//        self.maskControl.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2f];
//    }
//    [self.view addSubview:self.maskControl];
//    self.maskHandler = maskHideHandler;
//}
//
//-(void)hideMaskView
//{
//    [self.maskControl removeFromSuperview];
//    if ([self respondsToSelector:self.maskHandler]) {
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//        [self performSelector:self.maskHandler];
//#pragma clang diagnostic pop
//    }
//}

-(void)showWatting:(BOOL)delay
{
    if (delay) {
        [NSTimer scheduledTimerWithTimeInterval:CMM_AnimatePerior target:self selector:@selector(showWatting) userInfo:nil repeats:NO];
    } else {
        [self showWatting];
    }
}

-(void)showWatting
{
    if (self.status == VIEW_PROCESS_GETTING && !self.isWaitting) {
        self.isWaitting = TRUE;
        [GlobalObject showWaitting:self.maskView];
    }
}

-(void)hideWaitting
{
    if (self.isWaitting) {
        self.isWaitting = FALSE;
        [GlobalObject hideWaitting];
        double delayInSeconds = 0.25f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.maskView removeFromSuperview];
            self.maskView = nil;
        });
    }
}


-(void)showTopPop:(NSString*)content
{
    [GlobalObject showPopup:content];
}

//-(void)addTabItems:(NSArray*)array
//{
//    for (TabItemData* tabItemInfo in array) {
//        UIImage *img = [UIImage imageNamed:tabItemInfo.imgUrl];
//        UITabBarItem *tabItem = [[UITabBarItem alloc] initWithTitle:tabItemInfo.title image:img tag:self.tabTag++];
//        [self.tabItems addObject:tabItem];
//    }
//    [self.tabBar setItems:self.tabItems];
//
//}
//
//-(void)addTabItem:(TabItemData*)tabItemInfo
//{
//    UIImage *img = [UIImage imageNamed:tabItemInfo.imgUrl];
//    UITabBarItem *tabItem = [[UITabBarItem alloc] initWithTitle:tabItemInfo.title image:img tag:self.tabTag++];
//    [self.tabItems addObject:tabItem];
//    [self.tabBar setItems:self.tabItems];
//}
//-(void)showCustTabBar:(NSString*)tTile
//{
//   // self.navigationController.tabBarItem.title = tTile;
//}

//-(void)showCustTabBar
//{
//#if  1
//    if (!self.tabBar) {
//        self.tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, 480 - 49-20, APP_FRAME.size.width, 49)];
//        self.tabBar.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
//
//        self.tabItems = [NSMutableArray arrayWithCapacity:4 ];
//        for (int k= 0 ;k<4;k++) {
//            // UIImage *img = [UIImage imageNamed:tabItemInfo.imgUrl];
//            UITabBarItem *tabItem = [[UITabBarItem alloc] initWithTitle:[NSString stringWithUTF8String:tabTitles[k]] image:nil tag:k];
//            [self.tabItems addObject:tabItem];
//
//        }
//        [self.tabBar setItems:self.tabItems];
//        [self.view addSubview:self.tabBar];
//        self.tabBar.delegate = self;
//
//    } else {
//        self.tabBar.hidden = FALSE;
//    }
//    self.hidesBottomBarWhenPushed = YES;
//#endif
//}

//-(void)setSelectItem:(NSInteger)index
//{
//    UITabBarItem *item = [self.tabBar.items objectAtIndex:index];
//    self.tabSelectIndex = index;
//    [self.tabBar setSelectedItem:item];
//}
//
////-(void)hideCustTabBar
////{
////    self.tabBar.hidden = TRUE;
////}
//
//- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
//{
//    NSInteger tag = item.tag;
//    UITabBarItem *sitem = [self.tabBar.items objectAtIndex:self.tabSelectIndex];
//    [self.tabBar  setSelectedItem:sitem];
//    [self.tabBarController setSelectedViewController:[self.tabBarController.childViewControllers objectAtIndex:tag]];
//}

//- (void)makeSystemTabBarHidden:(BOOL)hide
//{
//    if ( [self.tabBarController.view.subviews count] < 2  )
//    {
//        return;
//    }
//    UIView *contentView;
//
//    if ( [[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
//    {
//        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
//    }
//    else
//    {
//        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
//    }
//    //    [UIView beginAnimations:@"TabbarHide" context:nil];
//    if ( hide )
//    {
//        contentView.frame = self.tabBarController.view.bounds;
//    }
//    else
//    {
//        contentView.frame = CGRectMake(self.tabBarController.view.bounds.origin.x,
//                                       self.tabBarController.view.bounds.origin.y,
//                                       self.tabBarController.view.bounds.size.width,
//                                       self.tabBarController.view.bounds.size.height - self.tabBarController.tabBar.frame.size.height);
//    }
//
//    self.tabBarController.tabBar.hidden = hide;
//}
//-(void)GKPushViewController:(UIViewController*)vc animated:(BOOL)animated
//{
//    [self.view.superview addSubview:vc.view];
//    NSMutableArray *controller = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
//    [controller addObject:vc];
//    self.navigationController.viewControllers = controller;
//  //  [self.navigationController pushViewController:vc animated:NO];
//}
//
//-(void)GKPopViewController:(BOOL)animated
//{
//    NSMutableArray *controller = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
//    [controller removeLastObject];
//    self.navigationController.viewControllers = controller;
//    
//    [self.view removeFromSuperview];
//}


#pragma mark - 
#pragma mark inside function -


//-(void)addBackItem:(NSString*)title
//{
//    [self addBackItem:title action:nil];
//}
//
//-(void)addBackItem:(NSString*)title action:(SEL)selector
//{
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setImage:[UIImage imageNamed:NavBarLeftArrow] forState:UIControlStateNormal];
//    [btn setFrame:CGRectMake(0, 0, NavBarLeftArrowWidth, NavBarLeftArrowheight)];
//    
//    if (IsSafeString(title)) {
//        [btn setTitle:title forState:UIControlStateNormal];
//        btn.titleLabel.font =[UIFont systemFontOfSize:14];
//    }
//    
//    if (selector) {
//        [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
//    } else {
//        
//        
//        [btn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
//        
//    }
//    
//    self.backBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
//    self.navBar.topItem.leftBarButtonItem = self.backBtn;
//}
@end

//@implementation  TabItemData
//@synthesize title,imgUrl;
//@end
