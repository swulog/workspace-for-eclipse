//
//  GSCouponService.h
//  GS
//
//  Created by W.S. on 13-6-22.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSObject.h"
#import "AppConstans.h"
typedef enum{
    CouponStatus_Cancel = -2,
    CouponStatus_Expired,
    CouponStatus_Pengding,
    CouponStatus_Normal
}CouponStatus;
@class Coupon;

@interface GSCouponService : NSObject
+(void)saveCoupon:(Coupon*)_coupon isAdd:(BOOL)_iaAdd  succ:(NillBlock_OBJ)succBack fail:(NillBlock_Error)failBack;

+(void)getCouponList:(int)couponStatus store:(NSString*)storeId page:(NSInteger)_pageNo pageNum:(NSInteger)_pageNum  succ:(NillBlock_OBJ)succBack fail:(NillBlock_Error)failBack;

+(void)deleteCoupon:(NSString*)_couponId status:(int)status;

@end





@interface Coupon : GSObject
@property (strong,nonatomic) NSString *id;
@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *body;
@property (strong,nonatomic) NSString *image_url;
@property (strong,nonatomic) NSString *store_id;
@property (strong,nonatomic) NSString *note;
@property (strong,nonatomic) NSString *start;
@property (strong,nonatomic) NSString *end;
@property (strong,nonatomic) NSString *created;
@property (strong,nonatomic) NSString *coupon_picture;

@property (assign,nonatomic) CouponStatus status;
@end

