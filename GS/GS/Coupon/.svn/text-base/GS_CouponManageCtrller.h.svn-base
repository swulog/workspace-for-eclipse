//
//  GS_CouponManageCtrller.h
//  GS
//
//  Created by W.S. on 13-6-22.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "WS_BaseViewController.h"
#import "GSCouponService.h"
#import "GKTableView.h"
#import "GS_CouponReleaseCtrller.h"

typedef enum {
    CouponTableSort_Normal,
    CouponTableSort_Pengding,
    CouponTableSort_Experied,
    
    CouponTableSort_Count
}CouponTableSort;

@interface GS_CouponManageCtrller : WS_BaseViewController<GSCouponReleaseDelegate,GKTableDelegate>
{
    NSInteger pageNum;
    CouponTableSort curStatus;
    BOOL initStatus[CouponTableSort_Count];
    int pageIndex[CouponTableSort_Count];
    BOOL nextPageEnabled[CouponTableSort_Count];
    BOOL rowDeleted[CouponTableSort_Count];
};



@property (weak, nonatomic) IBOutlet UISegmentedControl *switchView;
@property (weak, nonatomic) IBOutlet GKTableView *tableView;
@property (weak, nonatomic) IBOutlet GKTableView *pengdingTable;
@property (weak, nonatomic) IBOutlet GKTableView *expiredTable;

@property (strong, nonatomic) NSString *storeId;
-(id)initWithID:(NSString*)sToreId;

@property (strong,nonatomic) NSMutableArray *listArray;
@property (strong,nonatomic) NSArray *tableViewArray;


- (IBAction)switchValueChanged:(id)sender;


@end
