//
//  GSCouponService.m
//  GS
//
//  Created by W.S. on 13-6-22.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GSCouponService.h"
#import "DataBaseClient.h"
#import "NetWorkClient.h"
#import "APPConfig.h"
#import "AppHeader.h"
#import <objc/runtime.h>
#import "GS_GlobalObject.h"


@implementation GSCouponService

+(void)saveCoupon:(Coupon*)_coupon isAdd:(BOOL)_iaAdd  succ:(NillBlock_OBJ)succBack fail:(NillBlock_Error)failBack
{
    NSString *url;
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:6];
    HTTP_METHOD method = HTTP_POST;
    
    [dict setValue:_coupon.title forKey:@"title"];
    [dict setValue:_coupon.body forKey:@"body"];
    [dict setValue:_coupon.note forKey:@"note"];
    [dict setValue:_coupon.start forKey:@"start"];
    [dict setValue:_coupon.end  forKey:@"end"];
    
    
    if (IsSafeString(_coupon.coupon_picture)) {
        [dict setValue:_coupon.coupon_picture  forKey:@"coupon_picture"];
    }
    
//    else if(IsSafeString(_coupon.image_url)) {
//        [dict setValue:_coupon.image_url  forKey:@"image_url"];
//    }
    
    if (_iaAdd) {
        url = [NSString stringWithFormat:GS_COUPON_RELEASE_URL];
        [dict setValue:_coupon.store_id  forKey:@"storeId"];
    } else {
        url = [NSString stringWithFormat:GS_COUPON_EDIT_URL,_coupon.id];
        method = HTTP_PUT;
    }

    [NetWorkClient requestURL:url withBody:dict method:method user:nil pwd:nil token:[GS_GlobalObject GS_GObject].gToken needAuthorization:YES  parser:^(NSObject *responseObj){
        if (responseObj == nil) {
            _coupon.status = CouponStatus_Pengding;
            [_coupon save2DB:@"id"];
            SAFE_BLOCK_CALL(succBack, nil);

        } else if ([responseObj isKindOfClass:[NSDictionary class]]) {
            Coupon *sort = [[Coupon alloc] init];
            [sort Deserialize:(NSDictionary*)responseObj];
            sort.status = CouponStatus_Pengding;
            [sort save2DB:@"id"];
            
            SAFE_BLOCK_CALL(succBack, sort);
        } else {
            NSLog(@"Server Data Error:it must be NSArray");
            NSError *err =  WSErrorWithCode(WS_DataUnMatched);
            SAFE_BLOCK_CALL(failBack, err);
        }
    }fail:^(NSError *err){
//        NSError *error = WSErrorWithCode(WS_NetError);
//        SAFE_BLOCK_CALL(failBack, error);
        SAFE_BLOCK_CALL(failBack, err);
    }];
    
    
}

+(void)getCouponList:(int)couponStatus store:(NSString*)storeId page:(NSInteger)_pageNo pageNum:(NSInteger)_pageNum  succ:(NillBlock_OBJ)succBack fail:(NillBlock_Error)failBack
{
    
//    NSArray *ret = nil;
//    NSArray *couponArray = [GSCouponService getCouponList:storeId status:couponStatus];
    
//    if (couponArray && couponArray.count > 0) {
//        ret = couponArray;
//        return;
//    }

    static char* statusStr[] = {"normal","pending","expired"};
    
    NSString *url = [NSString stringWithFormat:GS_COUPON_LIST_URL,storeId,[NSString stringWithUTF8String:statusStr[couponStatus]],_pageNo,_pageNum];
    
    [NetWorkClient requestURL:url withBody:nil method:HTTP_GET user:nil pwd:nil token:nil needAuthorization:FALSE  parser:^(NSObject *responseObj){
        if ([responseObj isKindOfClass:[NSArray class]]) {
            NSArray *array = (NSArray*)responseObj;
            NSMutableArray *retArray = [NSMutableArray arrayWithCapacity:20];
            
            for (NSDictionary *dict in array) {
                Coupon *coupon = [[Coupon alloc] init];
                [coupon Deserialize:dict];
                [coupon save2DB:@"id"];
                [retArray addObject:coupon];
            }

            SAFE_BLOCK_CALL(succBack, retArray);
        } else {
            NSLog(@"Server Data Error:it must be NSArray");
            NSError *err =  WSErrorWithCode(WS_DataUnMatched);
            SAFE_BLOCK_CALL(failBack, err);
        }
    }fail:^(NSError *err){
//        NSError *error = WSErrorWithCode(WS_NetError);
//        SAFE_BLOCK_CALL(failBack, error);
        SAFE_BLOCK_CALL(failBack, err);
    }];
    
    
}

//+(NSArray*)getCouponList:(NSString*)_storeId status:(CouponStatus)_status
//{
//    NSMutableArray *retArray = [[NSMutableArray alloc] init];
//    
//    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM Counpon WHERE storeId = %@ AND status = %d",_storeId,_status];
//    id<PLResultSet> result = [DataBaseClient exeSQL:sql];
//    
//    while([result next]) {
//        Coupon *coupon = [[Coupon alloc] init];
//        [coupon DeserializeFromDBResult:result];
//        [retArray addObject:coupon];
//    }
//    
//    return retArray;
//}

+(void)deleteCoupon:(NSString*)_couponId status:(int)status
{
    NSString *url = nil;
    HTTP_METHOD method;
    
    if (status == 2) {
        url = [NSString stringWithFormat:GS_COUPON_DEL_URL,_couponId];
        method = HTTP_DELETE;
    } else {
        url = [NSString stringWithFormat:GS_COUPON_REVOKE_URL,_couponId];
        method = HTTP_POST;
    }
    
    [NetWorkClient requestURL:url withBody:nil method:method user:nil pwd:nil token:[GS_GlobalObject GS_GObject].gToken needAuthorization:YES  parser:^(NSObject *responseObj){
    }fail:^(NSError *err){
    }];

    
}


@end


@implementation Coupon
@end