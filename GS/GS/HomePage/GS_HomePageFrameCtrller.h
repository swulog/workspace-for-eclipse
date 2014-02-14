//
//  GS_HomePageFrameCtrller.h
//  GS
//
//  Created by W.S. on 13-6-6.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "WS_BaseViewController.h"
#import "GS_HomePageCtrller.h"
#import "GS_StoreInfoCtrller.h"
#import "GSStoreService.h"
#import "GS_StoreDetailCtrller.h"
#import "GS_LogonCtrller.h"

@interface GS_HomePageFrameCtrller : WS_BaseViewController<SlidingTabsControlDelegate,StoreDetailDelegate,LogonDelegate>
{
    UIViewController *visibleCtrller;
}

@property (weak, nonatomic) IBOutlet SlidingTabsControl *slideTab;
@property (weak, nonatomic) IBOutlet UIView *contentView;


//@property (strong,nonatomic) GS_HomePageCtrller *homePageCtrller;
//@property (strong,nonatomic) GS_StoreInfoCtrller *storeInfoCtrller;
@property(strong,nonatomic) UIViewController *homePageCtrller,*storeInfoCtrller;

//@property (strong,nonatomic) StoreInfo *iStore;

@end
