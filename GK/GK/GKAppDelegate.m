//
//  GKAppDelegate.m
//  GK
//
//  Created by apple on 13-4-7.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GKAppDelegate.h"

#import "GKGuideFlowController.h"
#import "Config.h"
#import "Constants.h"

#import "GKHeadPageViewController.h"
#import "GKTabFrameController.h"

#import "GlobalObject.h"

@implementation GKAppDelegate

@synthesize guideController,viewController,headPageController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [GlobalObject initAPP];

    self.viewController  = [[UIViewController alloc] init];
 //   [self.viewController.view setFrame:self.window.frame];
    [self.viewController.view setFrame:CGRectMake(0, 0, 320, 568)];

    self.headPageController = [[GKTabFrameController alloc] initWithNibName:@"GKTabFrameController" bundle:nil];
    [self.viewController addChildViewController:self.headPageController];
    [self.viewController.view addSubview:self.headPageController.view];
    
    
    BOOL isUnFirst = [[NSUserDefaults standardUserDefaults] boolForKey:@"ISUnFirst"];
    
    if (!isUnFirst) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ISUnFirst"];
    }
    
    isUnFirst = TRUE;
    if (!isUnFirst) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ISUnFirst"];
                
        self.guideController = [[GKGuideFlowController alloc] initWithNibName:@"GKGuideFlowController" bundle:nil];
        ((GKGuideFlowController*)self.guideController).GKBaseDelegate = self;
        
        [self.viewController addChildViewController:self.guideController];
        [self.viewController.view addSubview:self.guideController.view];

    }
    
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_APPEnterBackground object:nil];

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_APPBecomeActive object:nil];

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UMSocialSnsService  applicationDidBecomeActive];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

#pragma mark -
#pragma mark some delegate -

-(void)BaseControllerWouldUnload
{    
    self.headPageController.view.alpha = 0.0f;
        
    [self.viewController transitionFromViewController:self.guideController toViewController:self.headPageController duration:2.6f options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionCurveLinear animations:^{
        self.guideController.view.alpha = 0.0f;
        self.headPageController.view.alpha = 1.0f;

    } completion:^(BOOL isFinished){
        if (isFinished) {
            [self.guideController removeFromParentViewController];
            self.guideController = nil;
        }

    }];
    
}

@end
