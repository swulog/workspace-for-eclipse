//
//  GS_CouponDetailCtrller.h
//  GS
//
//  Created by W.S. on 13-6-24.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "WS_BaseViewController.h"
#import "GSCouponService.h"
#import "GSStoreService.h"
@interface GS_CouponDetailCtrller : WS_BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) Coupon *coupon;
@property (strong,nonatomic) StoreInfo *store;
@property (weak, nonatomic) IBOutlet UIImageView *validateImg;

-(id)initWithCoupon:(Coupon*)coupon;

@end
