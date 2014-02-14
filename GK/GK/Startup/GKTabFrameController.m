//
//  GKTabFrameController.m
//  GK
//
//  Created by apple on 13-4-12.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GKTabFrameController.h"
#import "GKHeadPageViewController.h"
#import "GKStoreListCtrller.h"
#import "GKQRViewController.h"
#import "OwnerViewController.h"
#import "XWGListCtrller.h"
#import "AKTabBarController.h"
#import "GlobalObject.h"
#import "ThemeADVCCtrller.h"
//#import "OwnerParentViewController.h"
@interface GKTabFrameController ()
@property (strong,nonatomic) AKTabBarController *akTab;
@property (strong,nonatomic) UIViewController *logonController;
@end

@implementation GKTabFrameController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // Do any additional setup after loading the view from its nib.
       // self.tab = [[UITabBarController alloc] init];
    }

    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self showHomePage];

    if (![GlobalDataService isLogoned]) {
        GKLogonCtroller *logonvc = [[GKLogonCtroller alloc] initWithCloseBtn:FALSE];
        logonvc.logonDelegate = self;
        UINavigationController *vc = [[UINavigationController alloc] initWithRootViewController:logonvc];
        [vc setNavigationBarHidden:YES];

        [self addChildViewController:vc];

        [self.view addSubview:vc.view];
        self.logonController = vc;
        vc.view.frame = self.view.bounds;
    }
}


-(void)showHomePage
{
   
    NSMutableArray *controllers = [NSMutableArray arrayWithCapacity:5];
    
    self.akTab = [[AKTabBarController alloc] initWithTabBarHeight:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 70 : APP_TABBAR_HEIGHT];
    [self.akTab setMinimumHeightToDisplayTitle:APP_TABBAR_HEIGHT];
    [self.akTab setBackgroundImageName:TabBarBg];
    
    [self.akTab setTabColors:@[[UIColor colorWithRed:1.0f green:130.0f/255.0f blue:130.0f/255.0f alpha:1.0],
                               [UIColor colorWithRed:1.0f green:130.0f/255.0f blue:130.0f/255.0f alpha:1.0]]];
    
    UIColor *selectedColor = colorWithUtfStr(Color_TabSelectedColor);
    NSArray *colors = [NSArray arrayWithObjects:selectedColor,
                       selectedColor, nil];
    [self.akTab setSelectedTabColors:colors];
    [self.akTab setTabEdgeColor:colorWithUtfStr("#F4BEC1")];
    self.akTab.tabStrokeColor = colorWithUtfStr("#F4BEC1");
    self.akTab.iconColors = [NSArray arrayWithObjects:[UIColor whiteColor],[UIColor whiteColor], nil];
    self.akTab.selectedIconColors = self.akTab.iconColors;
    
    GKHeadPageViewController    *tabCtrller0 = [[GKHeadPageViewController alloc] init];
    GKStoreListCtrller          *tabCtrller1 = [[GKStoreListCtrller alloc] initForNeighbour];
    XWGListCtrller              *tabCtrller2 = [[XWGListCtrller alloc] init];
    ThemeADVCCtrller            *tabCtrller3 = [[ThemeADVCCtrller alloc] init];
    OwnerViewController         *tabCtrller4 = [[OwnerViewController alloc] init];
    
    UIViewController *vc[] = {
        tabCtrller0,
        tabCtrller1,
        tabCtrller2,
        tabCtrller3,
        tabCtrller4
    };
    
    for (int k =0; k< 5; k++) {
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc[k]];
        [nvc setNavigationBarHidden:YES];
        [controllers addObject:nvc];
    }
    
    [self.akTab setViewControllers:controllers];
    [self.view addSubview:self.akTab.view];
}

-(void)logonSuccess
{
    [UIView animateWithDuration:1.0f animations:^{
        self.logonController.view.alpha = 0 ;
        self.akTab.view.alpha = 1;
    }completion:^(BOOL isfinished){
        if (isfinished) {
            [self.logonController.view removeFromSuperview];
            [self.logonController removeFromParentViewController];
            self.logonController = nil;
        }
    }];
}

-(BOOL)logonCancel
{
    CGAffineTransform form = CGAffineTransformMakeTranslation(APP_SCREEN_WIDTH, 0);
    
    //self.akTab.view.alpha = 0;
    [UIView animateWithDuration:CMM_AnimatePerior animations:^{
        self.logonController.view.transform = form;
      //  self.akTab.view.alpha = 1;
    }completion:^(BOOL isfinished){
        if (isfinished) {
            [self.logonController.view removeFromSuperview];
            [self.logonController removeFromParentViewController];
            self.logonController = nil;
        }
    }];
    
    return FALSE;
}

@end
