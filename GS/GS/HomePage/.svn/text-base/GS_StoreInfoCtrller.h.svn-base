//
//  GS_StoreInfoCtrller.h
//  GS
//
//  Created by W.S. on 13-6-6.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "WS_BaseViewController.h"
#import "GSStoreService.h"
#import "AppHeader.h"
#import "GS_StoreDetailCtrller.h"

@interface GS_StoreInfoCtrller : WS_BaseViewController<StoreDetailDelegate>
{
    BOOL hadUpdateStoreStatus;
    BOOL isGetStoreStatus;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sortLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *noteBtn;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;



@property (nonatomic,strong) NSArray *sortArray;
@property (strong,nonatomic) StoreInfo *iStore;
@property (weak,nonatomic) GS_StoreDetailCtrller *storeEditCtrller;

-(id)initWithStore:(StoreInfo*)store;

@end
