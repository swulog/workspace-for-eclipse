//
//  GS_CouponReleaseCtrller.h
//  GS
//
//  Created by W.S. on 13-6-21.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "WS_BaseViewController.h"
#import "GS_EditCtrller.h"
#import "GSCouponService.h"
#import "GKImgCroperViewController.h"


@protocol GSCouponReleaseDelegate ;
@interface GS_CouponReleaseCtrller : WS_BaseViewController<WS_GeneralTableFieldDelegate,EditCtrllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,GKImgCroperDelegate>
{
UIView *focusField;
}
@property (assign,nonatomic) id<GSCouponReleaseDelegate> delegate;

@property (strong,nonatomic) NSString *storeId;
@property (strong,nonatomic) Coupon *coupon;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak,nonatomic) NSDate *startDate;
@property (weak,nonatomic) NSDate *endDate;



@property (strong,nonatomic) NSMutableArray *fieldArray;
@property (strong,nonatomic) WS_GeneralTableFieldView *startDateField,*endDateField,*titleField,*detailField,*limitField;
- (IBAction)commitClick:(id)sender;

-(id)initWithCoupon:(Coupon*)coupon;
@end


@protocol GSCouponReleaseDelegate <NSObject>

-(void)reReleaseOK:(Coupon*)coupon;

@end
