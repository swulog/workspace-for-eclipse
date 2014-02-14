//
//  GKLogonService.m
//  GK
//
//  Created by apple on 13-4-16.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//
#import "GlobalObject.h"

#import "GKOwnerService.h"
#import "GKStoreSortListService.h"
#import "GKLogonService.h"
#import "GKXWGService.h"


@implementation GKOwnerService

+(BOOL)getFocusStoreList:(int)_pageNo num:(int)_pageNum success:(NillBlock_OBJ_BOOL)sucCallback fail:(NillBlock_Error)failCallback
{
    BOOL ret = FALSE; //if there is local data ,then get data from local ,return true
    
    NSString *url = [NSString stringWithFormat:USER_FOCUS_LIST_URL,_pageNum,_pageNo] ;
    
    
    [NetWorkClient requestURL:url withBody:nil method:HTTP_GET user:[GlobalDataService userGKId] pwd:[GlobalDataService userPwd] token:[GlobalDataService token] needAuthorization:YES receiveHeader:[NSArray arrayWithObject:@"Link"] parser:^(NSObject *responseObj,NSDictionary *headers){
        
        if ([responseObj isKindOfClass:[NSArray class]]) {
            NSArray *resultArray = (NSArray*)responseObj;
            NSMutableArray *returnArray = [NSMutableArray arrayWithCapacity:resultArray.count];
            for (id obj in resultArray) {
                StoreInfo *store = [[StoreInfo alloc] init];
                [store Deserialize:obj];
                [returnArray addObject:store];
            }

            NSString *link = [headers objectForKey:@"Link"];
            BOOL next = FALSE;
            if (link && link.length > 0) {
                NSRange range = [link rangeOfString:@";rel=\"next\""];
                if (range.length > 0) {
                    next = TRUE;
                }
            }

            sucCallback(returnArray,next);
            
        } else {
            NSError *err = [NSError errorWithMsg:[NSString stringWithUTF8String:ErrorDesc[DATA_FORMAT_NOT_MATCH-ERR_CODE_START]]];
            SAFE_BLOCK_CALL(failCallback, err);
        }
    } fail:^(NSError *err){
        SAFE_BLOCK_CALL(failCallback, err);
    }];
    
    
    
    return ret;
}

+(NSArray*)getCouponLoveList:(int)_pageNo num:(int)_pageNum refresh:(BOOL)refresh success:(NillBlock_OBJ_BOOL)sucCallback fail:(NillBlock_Error)failCallback
{
    
    if (_pageNum == 9999 && !refresh) {
        NSArray *array = [CouponLove getList:@"id" value:[GlobalDataService userGKId]];
        if (IsSafeArray(array)) {
            NSMutableArray *couponArray  = [NSMutableArray arrayWithCapacity:array.count];
            for (CouponLove *love in array) {
                Coupon *coupon = [Coupon get:@"id" value:love.couponId];
                if (coupon) {
                    [couponArray addObject:coupon];
                } else {
                //    [love delete:@"id"];
                    couponArray = nil;
                    break;
                }
            }
            if (couponArray){
                couponArray = [NSMutableArray arrayWithArray:[couponArray sortedArrayUsingComparator:^NSComparisonResult(Coupon *obj1, Coupon *obj2) {
                    NSDate *date1 = dateFromString(obj1.created);
                    NSDate *date2 = dateFromString(obj2.created);
                    return (NSComparisonResult)[date1 compare:date2];
                }]];
                
                if (sucCallback)
                    sucCallback(couponArray,FALSE);
                return Nil;
            }

        }
    }
    
    NSString *url = [NSString stringWithFormat:COUPON_LOVE_LIST_URL,_pageNum,_pageNo] ;
    
    [NetWorkClient requestURL:url withBody:nil method:HTTP_GET user:[GlobalDataService userGKId] pwd:[GlobalDataService userPwd] token:[GlobalDataService token] needAuthorization:YES receiveHeader:[NSArray arrayWithObject:@"Link"] parser:^(NSObject *responseObj,NSDictionary *headers){
        
        if ([responseObj isKindOfClass:[NSArray class]]) {
            NSArray *resultArray = (NSArray*)responseObj;
            NSMutableArray *returnArray = [NSMutableArray arrayWithCapacity:resultArray.count];
            for (id obj in resultArray) {
                Coupon *store = [[Coupon alloc] init];
                [store Deserialize:obj];
                [store save:@"id"];
                [returnArray addObject:store];
                
                CouponLove *love = [[CouponLove alloc] init];
                love.id = [GlobalDataService userGKId];
                love.couponId = store.id;
                [love saveWtihConstraints:@"id",@"couponId",Nil];
            }
            
            NSString *link = [headers objectForKey:@"Link"];
            BOOL next = FALSE;
            if (link && link.length > 0) {
                NSRange range = [link rangeOfString:@";rel=\"next\""];
                if (range.length > 0) {
                    next = TRUE;
                }
            }
            
            [GlobalObject dateToListRefresh:kListIdentifier[LI_OwnerCouponList] date:[NSDate date]];
            
            sucCallback(returnArray,next);
            
        } else {
            NSError *err = [NSError errorWithMsg:[NSString stringWithUTF8String:ErrorDesc[DATA_FORMAT_NOT_MATCH-ERR_CODE_START]]];
            SAFE_BLOCK_CALL(failCallback, err);
        }
    } fail:^(NSError *err){
        SAFE_BLOCK_CALL(failCallback, err);
    }];
    
    
    
    return nil;
}

+(NSArray*)getXWGGoodsLoveList:(int)_pageNo num:(int)_pageNum refresh:(BOOL)refresh success:(NillBlock_OBJ_BOOL)sucCallback fail:(NillBlock_Error)failCallback
{
    
    if (_pageNum == 9999 && !refresh){
        NSArray *array = [XWGLove getList:@"id" value:[GlobalDataService userGKId]];
        if (IsSafeArray(array)) {
            NSMutableArray *couponArray  = [NSMutableArray arrayWithCapacity:array.count];
            for (XWGLove *love in array) {
                XWGLove *coupon = [XWGLove get:@"id" value:love.xwgGoodId];
                if (coupon) {
                    [couponArray addObject:coupon];
                } else {
                 //   [love delete:@"id"];
                    couponArray = nil;
                    break;
                }
            }
            if (couponArray){
                if (sucCallback)
                    sucCallback(couponArray,FALSE);
                return Nil;
            }
        }
    }
    
    NSString *url = [NSString stringWithFormat:XWG_LOVE_LIST_URL,_pageNum,_pageNo] ;
    
    [NetWorkClient requestURL:url withBody:nil method:HTTP_GET user:[GlobalDataService userGKId] pwd:[GlobalDataService userPwd] token:[GlobalDataService token] needAuthorization:YES receiveHeader:[NSArray arrayWithObject:@"Link"] parser:^(NSObject *responseObj,NSDictionary *headers){
        
        if ([responseObj isKindOfClass:[NSArray class]]) {
            NSArray *resultArray = (NSArray*)responseObj;
            NSMutableArray *returnArray = [NSMutableArray arrayWithCapacity:resultArray.count];
            for (id obj in resultArray) {
                GoodsInfo *store = [[GoodsInfo alloc] init];
                [store Deserialize:obj];
                [store save:@"id"];
                [returnArray addObject:store];
                
                XWGLove *love = [[XWGLove alloc] init];
                love.id = [GlobalDataService userGKId];
                love.xwgGoodId = store.id;
                [love saveWtihConstraints:@"id",@"xwgGoodId",Nil];
            }
            
            NSString *link = [headers objectForKey:@"Link"];
            BOOL next = FALSE;
            if (link && link.length > 0) {
                NSRange range = [link rangeOfString:@";rel=\"next\""];
                if (range.length > 0) {
                    next = TRUE;
                }
            }
            
            [GlobalObject dateToListRefresh:kListIdentifier[LI_OwnerXWGItemList] date:[NSDate date]];
            
            sucCallback(returnArray,next);
            
        } else {
            NSError *err = [NSError errorWithMsg:[NSString stringWithUTF8String:ErrorDesc[DATA_FORMAT_NOT_MATCH-ERR_CODE_START]]];
            SAFE_BLOCK_CALL(failCallback, err);
        }
    } fail:^(NSError *err){
        SAFE_BLOCK_CALL(failCallback, err);
    }];
    
    return nil;
}


+(BOOL)updateName:(NSString*)_newName success:(NillBlock_Nill)sucCallback fail:(NillBlock_Error)failCallback
{
    BOOL ret = FALSE; //if there is local data ,then get data from local ,return true
    
    NSString *url = [NSString stringWithFormat:USER_NAME_UPDATE_URL,[GlobalDataService userGKUId]] ;
    NSMutableDictionary *bodyDict = [NSMutableDictionary dictionaryWithObject:_newName forKey:@"name"];

    [NetWorkClient requestURL:url withBody:bodyDict method:HTTP_POST user:[GlobalDataService userGKId] pwd:[GlobalDataService userPwd] token:[GlobalDataService token] needAuthorization:YES parser:^(NSObject *responseObj){
        GO(GlobalDataService).gUserInfo.name = _newName;
        [GO(GlobalDataService).gUserInfo save:@"gkId"];
     //   [GKLogonService saveUserInfo:GO(GlobalObject).ownLogonInfo];
            SAFE_BLOCK_CALL_VOID(sucCallback);
    } fail:^(NSError *err){
        SAFE_BLOCK_CALL(failCallback, err);
    }];
    
    return ret;
}

+(BOOL)updateHeadIcon:(UIImage*)_image success:(NillBlock_Nill)sucCallback fail:(NillBlock_Error)failCallback progress:(NillBlock_Double)progressHandler
{
    BOOL ret = FALSE; //if there is local data ,then get data from local ,return true
    
    NSString *url = [NSString stringWithFormat:USER_HEADICON_UPDATE_URL,[GlobalDataService userGKUId]] ;

    NSData *postData = UIImageJPEGRepresentation(_image, 0.75);

    NSMutableDictionary *bodyDict = [NSMutableDictionary dictionaryWithObject:[postData base64EncodedString] forKey:@"avatar"];
    [NetWorkClient uploadToUrl:url withBody:bodyDict withToken:[GlobalDataService token] processHandler:progressHandler parser:^(NSObject *responseObj) {
        
    // [NetWorkClient requestURL:url withBody:bodyDict method:HTTP_POST user:[GlobalDataService userGKId] pwd:[GlobalDataService userPwd] token:[GlobalDataService token] needAuthorization:YES parser:^(NSObject *responseObj){
    
        if([responseObj isKindOfClass:[NSDictionary class]]){
            GKIDInfo *idInfo = [[GKIDInfo alloc] init];
            [idInfo Deserialize:(NSDictionary*)responseObj];
            
            GO(GlobalDataService).gUserInfo.avatar_url = idInfo.avatar_url;
            [GO(GlobalDataService).gUserInfo save:@"gkId"];
            
            SAFE_BLOCK_CALL_VOID(sucCallback);
        } else {
            NSLog(@"Server Data Error");
            NSError *err = [NSError errorWithMsg:[NSString stringWithUTF8String:ErrorDesc[DATA_FORMAT_NOT_MATCH-ERR_CODE_START]]];
            SAFE_BLOCK_CALL(failCallback, err);
        }
        
    } fail:^(NSError *err){
        SAFE_BLOCK_CALL(failCallback, err);
    }];
    
    return ret;
}


@end

@implementation XWGLove
-(NSTimeInterval)validatePeroid
{
    return XWG_GOOD_LOVE_CACHE_PEROID;
}

@end

