//
//  GSAppDelegate.m
//  GS
//
//  Created by W.S. on 13-6-4.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GSAppDelegate.h"
#import "GS_GlobalObject.h"
#import "GS_HomePageFrameCtrller.h"

@implementation GSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:
    (NSDictionary *)launchOptions
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
        [application setStatusBarStyle:UIStatusBarStyleLightContent];
        }
    else {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor blackColor];
    
    [[GS_GlobalObject GS_GObject] initAPP];
    
    GS_HomePageFrameCtrller *vc = [[GS_HomePageFrameCtrller alloc] initNibWithStyle:WS_ViewStyleNoneBar];
    self.window.rootViewController = vc;
//    
//    
//    if (![GS_GlobalObject GS_GObject].ownIdInfo) {//还没有登录过
//        GS_LogonCtrller *vc = [[GS_LogonCtrller alloc] initNibWithStyle:WS_ViewStyleWithNavBar];
//        self.window.rootViewController = vc;
//    } else if([GS_GlobalObject GS_GObject].ownIdInfo.hasLogoned && [GS_GlobalObject GS_GObject].ownIdInfo.exist){
//        GS_HomePageFrameCtrller *vc = [[GS_HomePageFrameCtrller alloc] initNibWithStyle:WS_ViewStyleNoneBar];
//        self.window.rootViewController = vc;
//        //showModalViewCtroller(self,vc,YES);
//    } else if([GS_GlobalObject GS_GObject].ownIdInfo.hasLogoned) {
//        
//        } else {
//        [self showWaittingScreen];
//    }
   // [NSTimer scheduledTimerWithTimeInterval:0.26f target:self selector:@selector(showWaittingScreen) userInfo:nil repeats:NO];
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
