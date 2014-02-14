//
//  GS_HomePageFrameCtrller.m
//  GS
//
//  Created by W.S. on 13-6-6.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GS_HomePageFrameCtrller.h"
#import "GS_StartupViewCtrller.h"
#import "GS_StoreDetailCtrller.h"
#import "GS_GlobalObject.h"

static char* SlideTabTitleStr[] = {"商户管理","商户资料"};

@interface GS_HomePageFrameCtrller ()

@end

@implementation GS_HomePageFrameCtrller

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self findShowingCtroller:[GS_GlobalObject GS_GObject].ownIdInfo];
    if (![visibleCtrller isKindOfClass:[UINavigationController class]] ) {
        [self.view addSubview:visibleCtrller.view];
    }    else {
        [self.contentView addSubview:visibleCtrller.view];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reLogOn) name:NOTIFCATION_LOGOFF object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logonOK) name:NOTIFICATION_LOGON_FAIL object:nil];

    
    //    self.homePageCtrller = [[GS_HomePageCtrller alloc] initNibWithStyle:WS_ViewStyleWithNavBar];
    //    [self addChildViewController:self.homePageCtrller];
    //    [self.contentView addSubview:self.homePageCtrller.view];
    //    visibleCtrller = self.homePageCtrller;
    //
    //    self.storeInfoCtrller = [[GS_StoreInfoCtrller alloc] initNibWithStyle:WS_ViewStyleWithNavBar];
    //    [self addChildViewController:self.storeInfoCtrller];
    //    [self.slideTab initWithCount:2 drop:FALSE delegate:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [[GS_GlobalObject GS_GObject] removeObserver:self forKeyPath:@"ownIdInfo"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFCATION_LOGOFF object:nil];

    
    [self setSlideTab:nil];
    [self setContentView:nil];
    [super viewDidUnload];
    

}

#pragma mark -
#pragma mark inside function -
-(void)reLogOn
{
    
    for (UIView *v in self.contentView.subviews) {
        [v removeFromSuperview];
    }
    
    for (UIViewController *vc in self.childViewControllers) {
        [vc removeFromParentViewController];
    }
    
    self.homePageCtrller = nil;
    self.storeInfoCtrller = nil;
    
    [GS_GlobalObject GS_GObject].ownIdInfo = nil;
    [GS_GlobalObject GS_GObject].gToken = nil;

    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"LastUser"];
    
    [self findShowingCtroller:[GS_GlobalObject GS_GObject].ownIdInfo];
    if (![visibleCtrller isKindOfClass:[UINavigationController class]] ) {
        [self.view addSubview:visibleCtrller.view];
    }    else {
        [self.contentView addSubview:visibleCtrller.view];
    }
}

//-(void)logonFail
//{
//    [self findShowingCtroller:[GS_GlobalObject GS_GObject].ownIdInfo];
//    if (![visibleCtrller isKindOfClass:[UINavigationController class]] ) {
//        [self.view addSubview:visibleCtrller.view];
//    }    else {
//        [self.contentView addSubview:visibleCtrller.view];
//    }
//}

-(void)logonOK
{
    UIViewController *cVc = visibleCtrller;
    GSIDInfo *idInfo = [GS_GlobalObject GS_GObject].ownIdInfo;
    UIViewController *vc = [self findShowingCtroller:idInfo];
    
    if (![vc isKindOfClass:[UINavigationController class]] ) {
        [self.view insertSubview:vc.view belowSubview:cVc.view];
    }    else {
        [self.contentView insertSubview:vc.view belowSubview:cVc.view];
    }
    
    vc.view.alpha = 0;
    [UIView animateWithDuration:1.26f animations:^{
        cVc.view.alpha = 0.0f;
        vc.view.alpha =1.0f;
    }completion:^(BOOL finished){
        if (finished) {
            [cVc.view removeFromSuperview];
            [cVc removeFromParentViewController];
        }
    }];
}

-(void)showMe
{
    GS_HomePageCtrller *vc1 = [[GS_HomePageCtrller alloc] initNibWithStyle:WS_ViewStyleWithNavBar];
    self.homePageCtrller = [[UINavigationController alloc] initWithRootViewController:vc1];
    [self addChildViewController:self.homePageCtrller];
    vc1.view.tag =  443;
    visibleCtrller = self.homePageCtrller;
  //  [self.contentView addSubview:self.homePageCtrller.view];
  //  [self.homePageCtrller.navigationController setNavigationBarHidden:YES animated:NO];

    GS_StoreInfoCtrller  *vc;
    if (vc1.iStore) {
        vc= [[GS_StoreInfoCtrller alloc] initWithStore:vc1.iStore];
    } else {
       vc  = [[GS_StoreInfoCtrller alloc] initNibWithStyle:WS_ViewStyleWithNavBar];
    }
    
    self.storeInfoCtrller = [[UINavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:self.storeInfoCtrller];
    vc.view.tag = 444;
    //   [self.contentView addSubview:self.storeInfoCtrller.view];
 //   [self.storeInfoCtrller.view removeFromSuperview];
//    [self.contentView bringSubviewToFront:self.homePageCtrller.view];
    
   // [self.storeInfoCtrller.navigationController setNavigationBarHidden:YES animated:NO];

    [self.slideTab initWithCount:2 drop:FALSE delegate:self];

}

-(UIViewController*)findShowingCtroller:(GSIDInfo*)idinfo
{
//    if (!idinfo) { //还没有登录过
//        return [[GS_LogonCtrller alloc] initNibWithStyle:WS_ViewStyleWithNavBar];
//    } else if(idinfo.hasLogoned && idinfo.exist){
//        return nil;
//    } else if(idinfo.hasLogoned){
//        return [[GS_StoreDetailCtrller alloc] initNibWithStyle:WS_ViewStyleWithNavBar];
//    } else {
//        return [[GS_StartupViewCtrller alloc] initWithNibName:@"GS_StartupViewCtrller" bundle:nil];
//    }
    
    UIViewController *vc = nil;
    
    if (!idinfo) { //还没有登录过
        vc = [[GS_LogonCtrller alloc] initNibWithStyle:WS_ViewStyleWithNavBar];
        ((GS_LogonCtrller*)vc).delegate = self;

    //    [self.view addSubview:vc.view];
    } else if(idinfo.exist && idinfo.hasLogoned ){ //已经注册商店
        [self showMe];
    } else if(idinfo.hasLogoned) { //还没注册商店
        vc  =  [[GS_StoreDetailCtrller alloc] initWithStoreID:idinfo.store_id];
        ((GS_StoreDetailCtrller*)vc).delegate = self;
      //  [self.view addSubview:vc.view];
    } else {
        vc = [[GS_StartupViewCtrller alloc] initWithNibName:@"GS_StartupViewCtrller" bundle:nil];
   //     [self.view addSubview:vc.view];
     //   NSLog(@"ddd");
        [[GS_GlobalObject GS_GObject] addObserver:self forKeyPath:@"ownIdInfo" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    
    if (vc != nil) {
        visibleCtrller = vc;
    }
    
    return visibleCtrller;
}
//-(UIViewController*)findShowingCtroller_ex:(GSIDInfo*)idinfo
//{
//      
//    UIViewController *vc = nil;
//    
//    if (!idinfo) { //还没有登录过
//        vc = [[GS_LogonCtrller alloc] initNibWithStyle:WS_ViewStyleWithNavBar];
//        ((GS_LogonCtrller*)vc).delegate = self;
//        
//        [self.view addSubview:vc.view];
//    } else if(idinfo.hasLogoned && idinfo.exist){ //已经注册商店
//        [self showMe];
//    } else if(idinfo.hasLogoned) { //还没注册商店
//        vc  =  [[GS_StoreDetailCtrller alloc] initWithStoreID:idinfo.store_id];
//        ((GS_StoreDetailCtrller*)vc).delegate = self;
//        [self.view addSubview:vc.view];
//    } else {
//        vc = [[GS_StartupViewCtrller alloc] initWithNibName:@"GS_StartupViewCtrller" bundle:nil];
//        [self.view addSubview:vc.view];
//        //   NSLog(@"ddd");
//        [[GS_GlobalObject GS_GObject] addObserver:self forKeyPath:@"ownIdInfo" options:NSKeyValueObservingOptionNew context:nil];
//    }
//    
//    if (vc != nil) {
//        visibleCtrller = vc;
//    }
//    
//    return visibleCtrller;
//}



#pragma mark -
#pragma mark  event handler-
-(void)saveOK
{
    UIViewController *cVc = visibleCtrller;
    GSIDInfo *idInfo = [GS_GlobalObject GS_GObject].ownIdInfo;
    idInfo.exist = TRUE;
    UIViewController *vc = [self findShowingCtroller:idInfo];
    
    
    if (![vc isKindOfClass:[UINavigationController class]] ) {
        [self.view insertSubview:vc.view belowSubview:cVc.view];
    }    else {
        [self.contentView insertSubview:vc.view belowSubview:cVc.view];
    }
    
    vc.view.alpha = 0;
    [UIView animateWithDuration:2.26f animations:^{
        cVc.view.alpha = 0.0f;
        vc.view.alpha =1.0f;
    }completion:^(BOOL finished){
        if (finished) {
            [cVc.view removeFromSuperview];
            [cVc removeFromParentViewController];
        }
    }];
}



-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{    
    if ([keyPath isEqualToString:@"ownIdInfo"]) {
        
        
        UIViewController *cVc = visibleCtrller;
    
        
        
        GSIDInfo *idInfo = [GS_GlobalObject GS_GObject].ownIdInfo;
        
        if (!idInfo.hasLogoned) {
            return;
        }
        
        UIViewController *vc = [self findShowingCtroller:idInfo];
        
        if([vc isKindOfClass:[UINavigationController class]]){
            [self.contentView addSubview:vc.view];
        } else {
            [self.view addSubview:vc.view];
        }
        
        
        vc.view.alpha = 0.0f;
        [UIView animateWithDuration:1.26f animations:^{
            cVc.view.alpha = 0.0f;
            vc.view.alpha =1.0f;
        }completion:^(BOOL finished){
            if (finished) {
                [cVc.view removeFromSuperview];
                [cVc removeFromParentViewController];
                [[GS_GlobalObject GS_GObject] removeObserver:self forKeyPath:@"ownIdInfo"];
            }
        }];
    }
}

#pragma mark -
#pragma mark sliding tab delegate -
-(NSString*)titleFor:(SlidingTabsControl *)slidingTabsControl atIndex:(NSUInteger)tabIndex
{
    NSString *titleStr = [NSString stringWithUTF8String:SlideTabTitleStr[tabIndex]];

    return titleStr;
}

-(UIView*)maskViewFor:(SlidingTabsControl*)slidingTabsControl
{
    UIImageView *v = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slideTabMaskBg"]];
    return v;
}

- (void) touchDownAtTabIndex:(NSUInteger)tabIndex
{
    

    if (self.slideTab.selectTabIndex != tabIndex) {
        BOOL toLeft = FALSE;
        
             
        UIViewController *childVc =  [self.childViewControllers objectAtIndex:tabIndex];
        
        if (self.slideTab.selectTabIndex > tabIndex) {
            [childVc.view moevrTo:CGPointMake(320,0)];
            toLeft = TRUE;
        } else {
            
            [childVc.view moevrTo:CGPointMake(-320,0)];
        }
        
        self.view.userInteractionEnabled = FALSE;
        [self transitionFromViewController:visibleCtrller toViewController:childVc duration:0.26f options:UIViewAnimationOptionLayoutSubviews animations:^{
            [childVc.view moevrTo:CGPointMake(0,0)];
            [visibleCtrller.view moevrTo:(toLeft?CGPointMake(-320,0):CGPointMake(320, 0))];
        } completion:^(BOOL finished){
            if (finished) {
                visibleCtrller = childVc;
                self.view.userInteractionEnabled = TRUE;
            }
        }];
        
        
    }
}


@end
