//
//  WS_BaseViewController.m
//  GS
//
//  Created by W.S. on 13-6-4.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "WS_BaseViewController.h"
#import "GS_GlobalObject.h"


@interface WS_BaseViewController ()
@property (nonatomic,strong) UIControl *maskControl;
@property (assign,nonatomic) SEL maskHandler;

@end

@implementation WS_BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initNibWithStyle:(WS_ViewStyle)style
{
    NSString *className = [NSString stringWithUTF8String:object_getClassName(self)];
    self = [self initWithNibName:[className isEqualToString:@"WS_BaseViewController" ]?nil:className bundle:nil];
    
    if (self) {
        iStatus = WS_ViewStatus_Normal;
        iStyle = style;
        if (style & WS_ViewStyleWithNavBar ) {
            self.navBar = [[GKNavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
            UINavigationItem *topItem = [[UINavigationItem alloc] init];
            [self.navBar pushNavigationItem:topItem animated:NO];
            
            [self.navBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                 [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],
                                                 UITextAttributeTextColor,
                                                 [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8],
                                                 UITextAttributeTextShadowColor,
                                                 [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
                                                 UITextAttributeTextShadowOffset,
                                                 FONT_BOLD_18,
                                                 UITextAttributeFont,nil]];
        }

          }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
     self.view.autoresizingMask =     UIViewAutoresizingFlexibleHeight;
    if (isRetina_640X1136) {
        self.view.frame = CGRectMake(0, 0, 320, 568);
    } else {
        self.view.frame = CGRectMake(0, 0, 320, 480);
    }
    
    
    
    //背景色
    self.backgroundView = [[UIView alloc] initWithFrame:self.view.frame];
    [self setBackgroundWithImage:[UIImage imageNamed:GeneralBackgoundImg]];
    [self.view addSubview:self.backgroundView];
    [self.view sendSubviewToBack:self.backgroundView];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    
    NSInteger lookup = iStyle;
    //初始化 uinavigationBar
    if (lookup & WS_ViewStyleWithNavBar) {
        
        float offset = 0;
        if (IOS_VERSION >=7.0 && !self.fullScreenEnabled) {
            offset+=20;
            [self.navBar move:offset direct:Direct_Down];
        }

        for (UIView *v in self.view.subviews) {
            [v move: offset+44 direct:Direct_Down];
        }
        
        [self.view addSubview:self.navBar];
        
        
        if ([self.navBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:NavBarBackgoundImg] forBarMetrics:UIBarMetricsDefault];
        }
        [self.navigationController setNavigationBarHidden:YES];
        
        
        lookup &= ~WS_ViewStyleWithNavBar;
    }
    
    //暂时未实现
    if (lookup & WS_ViewStyleWithTabBar) {
        lookup &= ~WS_ViewStyleWithTabBar;
    }

}
-(void)viewWillAppear:(BOOL)animated
{
//    [self.navigationController setNavigationBarHidden:YES];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark nomal view config for user -

-(void)pushViewControler:(WS_BaseViewController*)_viewCtrller withNavBar:(BOOL)_enableNav animated:(BOOL)animated
{
    _viewCtrller.customAni = animated;
  //  _viewCtrller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;    // 设置动画效果
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:_viewCtrller];
    nvc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;//用自带动画animated设为YES
    [self presentModalViewController:nvc animated:YES];
//    [UIView beginAnimations: nil context:NULL];
//    [UIView setAnimationDuration:0.5];
//    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:_viewCtrller.view cache:YES];
//    [self presentModalViewController:_viewCtrller animated:NO];
//    [UIView commitAnimations];
    
//    CATransition *animation = [CATransition animation];
//  //  animation.delegate = self;
//    animation.duration = 2.26f;
//    animation.timingFunction = UIViewAnimationCurveEaseInOut;
//    animation.type = kCATransitionMoveIn;
//    animation.subtype = kCATransitionFromRight;
//    animation.delegate = self;

 //   [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
//    [[_viewCtrller.view layer] addAnimation:animation forKey:@"animation"];//SwitchToView
//    if (_enableNav) {
//        [self presentModalViewController:_viewCtrller animated:NO];
//    }
    
    
    
//    [UIView animateWithDuration:0.26f animations:^{
//
//    }completion:^(BOOL finished){
//        
//    }];
} 

-(void)setBackgroundWithImage:(UIImage*)image
{
    
    self.backgroundView.layer.contents = (id) image.CGImage;
    // 如果需要背景透明加上下面这句
//    self.backgroundView.layer.backgroundColor = [UIColor clearColor].CGColor;
    
//    UIColor *color = [UIColor colorWithPatternImage:image];
//    self.backgroundView.backgroundColor = color;
}

-(void)setBackgroundWithUIColor:(UIColor*)color
{
    self.backgroundView.layer.contents = nil;
    self.backgroundView.backgroundColor = color;
}

-(void)setNavTitle:(NSString *)title
{
    self.navBar.topItem.title = title;
    

}

-(void)addBackItem:(NSString*)title action:(SEL)selector
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:NavBarBackImg] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 50, 30)];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font =[UIFont systemFontOfSize:14];
    if (selector) {
        [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    } else {
        [btn  addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    }
    self.backBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];

    self.navBar.topItem.leftBarButtonItem =  self.backBtn;
}

-(void)goback
{
    if (self.navigationController) {
        if (self.customAni) {
            [self.navigationController dismissModalViewControllerAnimated:YES];
        } else {
            if (self.navigationController.viewControllers.count == 1) {
                [self dismissModalViewControllerAnimated:YES];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }
    } else {
        [self dismissModalViewControllerAnimated:YES];
    }

}

-(void)addNavRightItem:(NSString *)title action:(SEL)selector
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"navRightBtnBg"] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 60, 30)];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font =[UIFont systemFontOfSize:14];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem  *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.rightBtn = rightBtn;
    self.navBar.topItem.rightBarButtonItem = rightBtn;
}


-(void)showWatting
{
    if (iStatus == WS_ViewStatus_Getting && !self.isWaitting) {
        self.isWaitting = TRUE;
        [WS_GlobalObject showTopWaitting];
    }
}

-(void)hideWaitting
{
    self.isWaitting = FALSE;
    [WS_GlobalObject hideWaitting];
}

-(void)showMaskView:(SEL)maskHideHandler
{
    if (!self.maskControl) {
        CGRect rect = APP_FRAME;
        rect.origin.y = 0;
        self.maskControl = [[UIControl alloc] initWithFrame:rect];
        [self.maskControl addTarget:self action:@selector(hideMaskView) forControlEvents:UIControlEventTouchDown];
        self.maskControl.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2f];
    }
    [self.view addSubview:self.maskControl];
    self.maskHandler = maskHideHandler;
}

-(void)hideMaskView
{
    [self.maskControl removeFromSuperview];
    if ([self respondsToSelector:self.maskHandler]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:self.maskHandler];
#pragma clang diagnostic pop
    }
}
@end
