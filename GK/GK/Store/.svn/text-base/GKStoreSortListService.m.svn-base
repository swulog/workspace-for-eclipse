 //
//  GKStoreSortListService.m
//  GK
//
//  Created by apple on 13-4-17.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GKStoreSortListService.h"
//#import "NetWorkClient.h"
#import "GlobalObject.h"
#import "DataBaseClient.h"
#import "UIDevice+IdentifierAddition.h"

@class CouponLove;

@implementation GKStoreSortListService

//+(BOOL)getStoreList:(NSInteger)sOrteId isDistance:(BOOL)nEedDostance success:(NillBlock_Array)sucCallback fail:(NillBlock_Error)failCallback
//{
//    BOOL ret = FALSE; //if there is local data ,then get data from local ,return true
//    
//    if (!nEedDostance) {
//        NSString *url = [NSString stringWithFormat:STORE_SORT_LIST_URL,sOrteId];
//        
//        [NetWorkClient requestURL:url withBody:nil method:HTTP_GET parser:^(NSObject *responseArray){
//            if ([responseArray isKindOfClass:[NSArray class]]) {
//                NSMutableArray *returnArray = [NSMutableArray arrayWithCapacity:((NSArray*)responseArray).count];
//                for (id obj in (NSArray*)responseArray) {
//                    StoreInfo *storeInfo =  [[StoreInfo alloc] init];
//                    [storeInfo Deserialize:obj];
//                    storeInfo.storeSortId = (StoreTopSort)sOrteId;
//                    [returnArray addObject:storeInfo];
//                }
//                
//                sucCallback(returnArray);
//
//            } else {
//                NSLog(@"Server Data Error:it must be NSArray");
//            }
//        } fail:^(NSError *err){
//            SAFE_BLOCK_CALL(failCallback, err);
//        }];
//    }
//    return ret;
//}

+(WSNetServicesReault*)getStoreList:(NSInteger)_sortId  city:(NSString*)_cityId region:(NSString*)regsionId loc:(CLLocationCoordinate2D)_location sortWith:(NSString*)_sortKey distance:(float)_distance  index:(int)_pageNo num:(int)_pageNum success:(NillBlock_OBJ_BOOL)sucCallback fail:(NillBlock_Error)failCallback
{
    NSMutableString *url = [NSMutableString stringWithFormat:STORE_SORT_LIST_URL,_sortId] ;
    
    BOOL extraParams = FALSE;
    if (_pageNum != NOT_DEFINED) {
        [url appendString:[NSString stringWithFormat:@"?per_page=%d",_pageNum]];
        extraParams = TRUE;
    }
    
    if (_pageNo != NOT_DEFINED) {
        [url appendString:[NSString stringWithFormat:@"%@page=%d",extraParams?@"&":@"?",_pageNo]];
        extraParams = TRUE;
    }
    
    if (CLLocationCoordinate2DIsValid(_location)) {
        [url appendString:[NSString stringWithFormat:@"%@latitude=%lf",extraParams?@"&":@"?",_location.latitude]];
        [url appendString:[NSString stringWithFormat:@"&longitude=%lf",_location.longitude]];
        extraParams = TRUE;
    }
 
    if (regsionId) {
        [url appendString:[NSString stringWithFormat:@"%@district=%@",extraParams?@"&":@"?",regsionId]];
        extraParams = TRUE;
    }

    if (_cityId) {
        [url appendString:[NSString stringWithFormat:@"%@cityId=%@",extraParams?@"&":@"?",_cityId]];
        extraParams = TRUE;
    }
    
    if (IsSafeString(_sortKey)) {
        [url appendString:[NSString stringWithFormat:@"%@orderby=%@",extraParams?@"&":@"?",[_sortKey mk_urlEncodedString]]];
    }
    
    if (_distance > 0) {
        [url appendString:[NSString stringWithFormat:@"%@distance=%f",extraParams?@"&":@"?",_distance]];
    }

    WSNetServicesReault *result = [[WSNetServicesReault alloc] initWithUrl:url];
    [NetWorkClient requestURL:url withBody:nil method:HTTP_GET receiveHeader:[NSArray arrayWithObject:@"Link"] parser:^(NSObject *responseObj,NSDictionary *headers){
        if ([responseObj isKindOfClass:[NSArray class]]) {
            NSArray *responseArray = (NSArray*)responseObj;
            NSMutableArray *retArray = [NSMutableArray arrayWithCapacity:20];
            for (NSDictionary *obj in responseArray) {
                StoreInfo *storeInfo = [[StoreInfo alloc] init];
                [storeInfo Deserialize:obj];
                [storeInfo save:@"id" ];
                [retArray addObject:storeInfo];
            }
                
            NSString *link = [headers objectForKey:@"Link"];
            BOOL next = FALSE;
            if (link && link.length > 0) {
                NSRange range = [link rangeOfString:@";rel=\"next\""];
                if (range.length > 0) {
                    next = TRUE;
                }
            }
            sucCallback(retArray,next);
        } else {
            NSLog(@"Server Data Error:it must be dictionary");
            NSError *err =  [NSError errorWithMsg:[NSString stringWithUTF8String:ErrorDesc[DATA_FORMAT_NOT_MATCH-ERR_CODE_START]]];
            SAFE_BLOCK_CALL(failCallback, err);
        }
        
    } fail:^(NSError *err){
        SAFE_BLOCK_CALL(failCallback, err);
    }];

    return result;
}


+(StoreInfo*)getStoreDetail:(NSString*)sToredId from:(NSString*)adv success:(NillBlock_IStoreInfo)sucCallback fail:(NillBlock_Error)failCallback
{
    
    StoreInfo *store = [StoreInfo get:@"id" value:sToredId];
    
    NillBlock_Nill statisticsBlock = ^{
        if (adv && adv.length > 0) {        //统计广告
            NSMutableDictionary *newClickDict = nil;
            NSMutableArray *array =  [GO(GlobalObject).statisticsPlistManager valueForKey:@"AdvClicks"];
            
            for (NSMutableDictionary *advClickDict in array) {
                if ([advClickDict[@"advId"] isEqualToString:adv]) {
                    newClickDict =  advClickDict;
                    break;
                }
            }
            
            if (!newClickDict) {
                newClickDict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithInt:1],adv, nil] forKeys:[NSArray arrayWithObjects:@"clickCount", @"advId",nil]];
                
                if (!array) {
                    array =[NSMutableArray arrayWithObject:newClickDict];
                    [GO(GlobalObject).statisticsPlistManager setValue:array forKey:@"AdvClicks"];
                } else {
                    [array addObject:newClickDict];
                }
            } else {
                int lunchCount = [((NSNumber*)[newClickDict valueForKey:@"clickCount"]) intValue];
                lunchCount++;
                [newClickDict setValue:[NSNumber numberWithInt:lunchCount] forKey:@"clickCount"];
            }
        }
    };
        
    if (store) {
        SAFE_BLOCK_CALL_VOID(statisticsBlock);
        return store;
    }
    
    NSString *url = [NSString stringWithFormat:STORE_INFO_URL,sToredId];
    [NetWorkClient requestURL:url withBody:nil method:HTTP_GET parser:^(NSObject *responseArray){
        if ([responseArray isKindOfClass:[NSDictionary class]]) {
            StoreInfo *storeInfo =  [[StoreInfo alloc] init];
            [storeInfo Deserialize:(NSDictionary*)responseArray];
            [storeInfo save:@"id"];
            SAFE_BLOCK_CALL_VOID(statisticsBlock);
            SAFE_BLOCK_CALL(sucCallback, storeInfo);
        } else {
            NSError *err =  [NSError errorWithMsg:[NSString stringWithUTF8String:ErrorDesc[DATA_FORMAT_NOT_MATCH-ERR_CODE_START]]];
            SAFE_BLOCK_CALL(failCallback, err);
        }
    } fail:^(NSError *err){
        SAFE_BLOCK_CALL(failCallback, err);
    }];
    return nil;
}

//+(NSArray*)getCouponList:(NSString*)_storeId
//{
//    NSMutableArray *retArray = [[NSMutableArray alloc] init];
//    
//    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM Coupon WHERE store_id = %@ AND status = %d",_storeId,CouponStatus_Normal];
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





+(NSArray*)getStoreSorts:(NillBlock_Array)sucCallback fail:(NillBlock_Error)failCallback
{
    NSArray *retArray = [StoreSort getAll];
    if (retArray) {
       // return retArray;
        SAFE_BLOCK_CALL(sucCallback, retArray);
        return retArray;
    }
    
    NSString *url = [NSString stringWithFormat:STORE_SORTS_URL];
    
    [NetWorkClient requestURL:url withBody:nil method:HTTP_GET user:[GlobalDataService userGKId] pwd:[GlobalDataService userPwd] token:[GlobalDataService token] needAuthorization:FALSE parser:^(NSObject *responseObj){
        if ([responseObj isKindOfClass:[NSArray class]]) {
            NSArray *array = (NSArray*)responseObj;
            NSMutableArray *sortList = [[NSMutableArray alloc] initWithCapacity:array.count];
            for (id obj in array) {
                StoreSort *sort = [[StoreSort alloc] init];
                [sort Deserialize:(NSDictionary*)obj];
                [sort save];
                [((NSMutableArray*)sortList) addObject:sort];
            }
            SAFE_BLOCK_CALL(sucCallback, sortList);
        } else {
            NSLog(@"Server Data Error:it must be dictionary");
            NSError *err = [NSError errorWithMsg:[NSString stringWithUTF8String:ErrorDesc[DATA_FORMAT_NOT_MATCH-ERR_CODE_START]]];
            SAFE_BLOCK_CALL(failCallback, err);
        }
        
    } fail:^(NSError *err){
        if (err.code == 404) {
            SAFE_BLOCK_CALL(sucCallback, FALSE);
        } else {
            SAFE_BLOCK_CALL(failCallback, err);
        }
    }];
    return Nil;
}


+(NSArray*)getCounponList:(NSString*)sToredId success:(NillBlock_Array)sucCallback fail:(NillBlock_Error)failCallback
{
    
    NSArray *array = [Coupon getList:@"store_id" value:sToredId];
    NSMutableArray *couponArray  = [NSMutableArray arrayWithArray:array];

//    if (IsSafeArray(array)) {
//        for (StoreCoupon *love in array) {
//            Coupon *coupon = [Coupon get:@"id" value:love.couponId];
//            if (coupon) {
//                [couponArray addObject:coupon];
//            } else {
//                couponArray = nil;
//                break;
//            }
//        }
//    }

    if (IsSafeArray(couponArray))
    {
       NSMutableArray *delArray = [NSMutableArray arrayWithCapacity:couponArray.count];
        
        NSDate *curDate = [NSDate date];
        NSString *curDateStr =   transDatetoChinaDateStr(curDate);
        curDate = dateFromChinaDateString(curDateStr);
        

        
        for (Coupon *coupon in couponArray) {
            if (coupon.status != CouponStatus_Expired) {
                NSDate *endDate = dateFromString(coupon.end);
                NSString *endDateStr =   transDatetoChinaDateStr(endDate);
                endDate = dateFromChinaDateString(endDateStr);
                
                if ([endDate compare:curDate] < NSOrderedSame) {
                    coupon.status = CouponStatus_Expired;
                    [coupon save:@"id"];
                    [delArray addObject:coupon];
                }
            } else {
                [delArray addObject:coupon];
            }
        }
        
        for (Coupon *coupon in delArray) {
            [couponArray removeObject:coupon];
        }
        delArray = nil;
    }
    
    if (IsSafeArray(couponArray)) {
        return couponArray;
    }
    
    NSString *url = [NSString stringWithFormat:COUPON_INFO_URL,sToredId];
    
    [NetWorkClient requestURL:url withBody:nil method:HTTP_GET parser:^(NSObject *responseArray){
        if ([responseArray isKindOfClass:[NSArray class]]) {
            NSMutableArray *returnArray = [NSMutableArray arrayWithCapacity:((NSArray*)responseArray).count];
            for (NSDictionary *dict in (NSArray*)responseArray) {
                Coupon *coupon = [[Coupon alloc] init];
                [coupon Deserialize:dict];
                [coupon save:@"id"];
                [returnArray addObject:coupon];
            }
            SAFE_BLOCK_CALL(sucCallback, returnArray);
     } else {
         SAFE_BLOCK_CALL(sucCallback, nil);
        }
    } fail:^(NSError *err){
        SAFE_BLOCK_CALL(failCallback, err);
    }];
    
    return nil;
}


+(void)getFocusStatus:(NSString*)sToredId user:(NSString*)iD  success:(NillBlock_BOOL)sucCallback fail:(NillBlock_Error)failCallback
{
    NSString *url = [NSString stringWithFormat:STORE_FOCUS_URL,sToredId];
    
    [NetWorkClient requestURL:url withBody:nil method:HTTP_GET user:[GlobalDataService userGKId] pwd:[GlobalDataService userPwd] token:[GlobalDataService token] needAuthorization:YES parser:^(NSObject *responseObj){
        SAFE_BLOCK_CALL(sucCallback, TRUE);
    } fail:^(NSError *err){
        if (err.code == 404) {
            SAFE_BLOCK_CALL(sucCallback, FALSE);
        } else {
            SAFE_BLOCK_CALL(failCallback, err);
        }
    }];
}

+(void)focusStore:(NSString*)sToredId isFocus:(BOOL)_isFocus  success:(NillBlock_Nill)sucCallback fail:(NillBlock_Error)failCallback
{
    
    NSString *url = [NSString stringWithFormat:STORE_FOCUS_URL,sToredId];

    [NetWorkClient requestURL:url withBody:nil method:_isFocus?HTTP_DELETE:HTTP_PUT user:[GlobalDataService userGKId] pwd:[GlobalDataService userPwd] token:[GlobalDataService token] needAuthorization:YES parser:^(NSObject *responseObj){
    
        SAFE_BLOCK_CALL_VOID(sucCallback);
     } fail:^(NSError *err){
         if (err.code == 204) {
             SAFE_BLOCK_CALL_VOID(sucCallback);
         } else if(err.code == 404){
             NSError *error = [NSError errorWithDomain:GK_ERROR_DOMAIN code:GK_ERROR_FOCUS_STATUS_EXCEPTION userInfo:nil];
             SAFE_BLOCK_CALL(failCallback, error);
         } else if(err.code == 422 && !_isFocus){
             NSError *err = [NSError errorWithMsg:[NSString stringWithUTF8String:ErrorDesc[WS_ERR_HADFOCUSED-ERR_CODE_START]] code:GK_ERROR_FOCUS_STATUS_EXCEPTION];
             SAFE_BLOCK_CALL(failCallback, err);
         }
         else {
             SAFE_BLOCK_CALL(failCallback, err);
         }
    }];
}

//+(NSArray*)getRegionList:(NSString*)_cityId
//{
//    NSMutableArray *retArray = [[NSMutableArray alloc] init];
//    
//    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM Region WHERE city_id = %@",_cityId];
//    id<PLResultSet> result = [DataBaseClient exeSQL:sql];
//    
//    while([result next]) {
//        Region *coupon = [[Region alloc] init];
//        [coupon DeserializeFromDBResult:result];
//        [retArray addObject:coupon];
//    }
//    
//    return retArray;
//}


+(NSArray*)getRegionList:(NSString*)pRegionId success:(NillBlock_Array)sucCallback fail:(NillBlock_Error)failCallback
{
//    NSMutableArray *regionArray =[NSMutableArray arrayWithArray:[self getRegionList:pRegionId]];
//    
//    BOOL clearCache = FALSE;
//    for (Region *coupon in regionArray) {
//        if (![coupon validate:REGION_CACHE_CLEAR_INTERVAL]) {
//            clearCache = TRUE;
//            break;
//        }
//    }
//    
//    if (clearCache) {
//        [self delRegion:pRegionId];
//        regionArray = nil;
//    }
//    
//    if (regionArray && regionArray.count > 0) {
//        return regionArray;
//    }
    
    NSArray *retArray = [Region getList:@"city_id" value:pRegionId deleteOnceinvalid:TRUE];
    if (retArray) {
        return retArray;
    }
    
    NSString *url = [NSString stringWithFormat:CITY_AREA_URL,pRegionId];
    
    [NetWorkClient requestURL:url withBody:nil method:HTTP_GET  extraHeader:nil parser:^(NSObject *responseObj){
        if ([responseObj isKindOfClass:[NSArray class]]) {
            NSArray *array = (NSArray*)responseObj;
            NSMutableArray *regionList = [[NSMutableArray alloc] initWithCapacity:array.count];
            for (id obj in array) {
                Region *region = [[Region alloc] init];
                [region Deserialize:obj];
               // [region save:@"id" toDB:[DataBaseClient shareDBFor:DB1Name]];
                [region save:@"id"];
                [((NSMutableArray*)regionList) addObject:region];
            }
            SAFE_BLOCK_CALL(sucCallback, regionList);
        } else {
            NSLog(@"Server Data Error:it must be dictionary");
            NSError *err = [NSError errorWithMsg:[NSString stringWithUTF8String:ErrorDesc[DATA_FORMAT_NOT_MATCH-ERR_CODE_START]]];
            SAFE_BLOCK_CALL(failCallback, err);
        }
    } fail:^(NSError *err){
        SAFE_BLOCK_CALL(failCallback, err);
    }];
    
    return nil;
}

+(BOOL)searchStore:(NSString*)keyword city:(NSString*)_cityId index:(int)_pageNo num:(int)_pageNum success:(NillBlock_OBJ_BOOL)sucCallback fail:(NillBlock_Error)failCallback
{
    BOOL ret = FALSE; //if there is local data ,then get data from local ,return true
    
    NSMutableString *url = [NSMutableString stringWithFormat:COUPON_SEARCH_URL,[keyword mk_urlEncodedString]] ;
    
    [url appendString:[NSString stringWithFormat:@"?per_page=%d",_pageNum==NOT_DEFINED?100:_pageNum]];
    [url appendString:[NSString stringWithFormat:@"&page=%d",_pageNo==NOT_DEFINED?0:_pageNo]];
    if (_cityId) {
        [url appendString:[NSString stringWithFormat:@"&cityId=%@",_cityId]];
    }
    
    [NetWorkClient requestURL:url withBody:nil method:HTTP_GET receiveHeader:[NSArray arrayWithObject:@"Link"] parser:^(NSObject *dataDict, NSDictionary *headers) {
            if ([dataDict isKindOfClass:[NSArray class]]) {
                NSMutableArray *returnArray = [NSMutableArray arrayWithCapacity:((NSArray*)dataDict).count];
                for (id obj in (NSArray*)dataDict) {
                    StoreInfo *storeInfo =  [[StoreInfo alloc] init];
                    [storeInfo Deserialize:obj];
                    [storeInfo save:@"id"];
                    [returnArray addObject:storeInfo];
                }
            

            sucCallback(returnArray,[self checkNetPage:headers]);
            
            } else {
                NSLog(@"Server Data Error:it must be NSArray");
                NSError *err = [NSError errorWithMsg:[NSString stringWithUTF8String:ErrorDesc[DATA_FORMAT_NOT_MATCH-ERR_CODE_START]]];
                SAFE_BLOCK_CALL(failCallback, err);
            }
        } fail:^(NSError *err){
            if (err.code == 404) {
                //SAFE_BLOCK_CALL(sucCallback, nil);
                sucCallback(nil,FALSE);
            } else {
                SAFE_BLOCK_CALL(failCallback, err);
            }

        }];
    return ret;
}

+(NSArray*)getSearchHotKyes:(NSString*)cityId succ:(NillBlock_OBJ)succBack fail:(NillBlock_Error)failBack
{
    NSArray *value = [SearchHotKey getList:@"cityId" value:cityId];
    
    if (!value) {
        NSString *url = [NSString stringWithFormat:STORE_SEARCH_HOTKEY_URL,cityId];
        
        [NetWorkClient requestURL:url withBody:nil method:HTTP_GET parser:^(NSObject *obj){
            NSMutableArray *value = nil;
            if ([obj isKindOfClass:[NSArray class]]) {
                value = [NSMutableArray arrayWithCapacity:((NSArray*)obj).count];
                for (id sobj in (NSArray*)obj) {
                    SearchHotKey *keyInfo = [[SearchHotKey alloc] init];
                    keyInfo.key = sobj;
                    keyInfo.cityId = cityId;
                    [keyInfo saveWtihConstraints:@"cityId",@"key",nil];
                    [value addObject:keyInfo];
                }  
            }
            SAFE_BLOCK_CALL(succBack,value);
        }fail:^(NSError *err) {
            SAFE_BLOCK_CALL(failBack, err);
        }];
    }
    
    return value;
}

+(void)sendStatistics:(NillBlock_Nill)sucCallback fail:(NillBlock_Error)failCallback
{
    
    NSString *url = ADV_STATISTICS_URL;
    
    NSMutableDictionary *bodyDict = [NSMutableDictionary dictionaryWithCapacity:7];
    
    float osVersion = IOS_VERSION;
    [bodyDict setValue:[NSNumber numberWithFloat:osVersion] forKey:@"osVersion"];
    
    NSString *deviceName = [[UIDevice currentDevice] name];
    [bodyDict setValue:deviceName forKey:@"deviceName"];

    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [bodyDict setValue:appVersion forKey:@"appVersion"];

    NSNumber *lunchCount = [GO(GlobalObject).statisticsPlistManager valueForKey:@"lunchCount"];
    [bodyDict setValue:lunchCount forKey:@"lunchCount"];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSString *curDateStr = [formatter stringFromDate:date];
    [bodyDict setValue:curDateStr forKey:@"date"];
    
    NSArray *advClicks = [GO(GlobalObject).statisticsPlistManager valueForKey:@"AdvClicks"];
 //   BOOL hadClick = TRUE;
    NSMutableDictionary *advClicks_send = [NSMutableDictionary dictionaryWithCapacity:5];
    for (NSDictionary *advClickDict in advClicks) {
        if (!advClickDict[@"advId"] || ((NSString*)advClickDict[@"advId"]).length == 0) {
            advClicks = nil;
            break;
        } else if([((NSNumber*)advClickDict[@"clickCount"]) intValue]!=0) {
            [advClicks_send setValue:((NSNumber*)advClickDict[@"clickCount"]) forKey:((NSString*)advClickDict[@"advId"])];
//            NSDictionary *sendDict = [NSDictionary dictionaryWithObject:((NSNumber*)advClickDict[@"clickCount"]) forKey:((NSString*)advClickDict[@"advId"])];
        //    [advClicks_send addObject:sendDict];
        }
    }

    [bodyDict setValue:advClicks_send forKey:@"advertClicks"];
    
   // [bodyDict setValue:@"{1:1,5:2}" forKey:@"advertClicks"];
  //  [bodyDict setValue:advClickStr forKey:@"advertClicks"];
    NSString *deviceID  = [[UIDevice currentDevice] uniqueGlobalDeviceIdentifier] ;
    [bodyDict setValue:deviceID forKey:@"deviceId"];

    
    [NetWorkClient requestURL:url withBody:bodyDict method:HTTP_POST parser:^(NSObject *obj){
        SAFE_BLOCK_CALL_VOID(sucCallback);
    }fail:^(NSError *err) {
        SAFE_BLOCK_CALL(failCallback, err);
    }];
    
}
#import "Reachability.h"
+(NSArray*)getStorePhotoes:(NSString*)storeId refreshed:(BOOL)forceUpdate succ:(NillBlock_Array)sucCallback fail:(NillBlock_Error)failCallback
{
    
    NSArray *ret = nil;
    
    if (!forceUpdate) {
        ret = [StorePhotos getList:@"storeId" value:storeId];
        if (ret && ret.count > 0 && !forceUpdate) {
            return ret;
        }
    }
    
    NSString *url = [NSString stringWithFormat:GK_STORE_PIC_INFO_URL,storeId] ;
    [NetWorkClient requestURL:url withBody:nil method:HTTP_GET user:nil pwd:nil token:nil  needAuthorization:FALSE parser:^(NSObject *responseObj){
        if ([responseObj isKindOfClass:[NSArray class]]) {
            NSMutableArray *retArray = [NSMutableArray arrayWithCapacity:4];
            for (id  obj in (NSArray*)responseObj) {
                StorePhotos *sort = [[StorePhotos alloc] init];
                [sort Deserialize:obj];
                sort.storeId = storeId;
                [sort saveWtihConstraints:@"storeId",@"name",nil];
                [retArray addObject:sort];
            }
            
            SAFE_BLOCK_CALL(sucCallback, retArray);
        } else {
            NSLog(@"Server Data Error:it must be NSArray");
            
            NSError *err =  [NSError errorWithMsg:[NSString stringWithUTF8String:ErrorDesc[DATA_FORMAT_NOT_MATCH-ERR_CODE_START]]];
            SAFE_BLOCK_CALL(failCallback, err);
        }
    }fail:^(NSError *err){
        SAFE_BLOCK_CALL(failCallback, err);
    }];
    return ret;
    
}

+(void)loveCoupon:(NSString*)couponId isLoved:(BOOL)_isLove  success:(NillBlock_Nill)sucCallback fail:(NillBlock_Error)failCallback
{
    
    NSString *url = [NSString stringWithFormat:COUPON_LOVE_URL,couponId];
    
    [NetWorkClient requestURL:url withBody:nil method:_isLove?HTTP_DELETE:HTTP_POST user:[GlobalDataService userGKId] pwd:[GlobalDataService userPwd] token:[GlobalDataService token] needAuthorization:YES parser:^(NSObject *responseObj){
        CouponLove *love = [[CouponLove alloc] init];
        love.id = [GlobalDataService userGKId];
        love.couponId = couponId;
        if (_isLove) {
            [love deleteWtihConstraints:@"id",@"couponId",Nil];
        } else {
            [love saveWtihConstraints:@"id",@"couponId",Nil];
        }
        SAFE_BLOCK_CALL_VOID(sucCallback);
    } fail:^(NSError *err){
        SAFE_BLOCK_CALL(failCallback,err);
    }];
}


@end
@implementation StoreInfo
@end
//@implementation StoreList
//@end

@implementation Coupon
@end
@implementation Region
-(NSTimeInterval)validatePeroid
{
    return REGION_CACHE_CLEAR_INTERVAL;
}
-(PLSqliteDatabase*)database
{
    return [DataBaseClient shareDBFor:DB0Name];
}
@end
@implementation StorePhotos
@end
@implementation CouponLove
@end
//@implementation StoreCoupon
//@end
@implementation SearchHotKey
-(NSTimeInterval)validatePeroid
{
    return SearchHotKeyCacheClearInterval;
}
@end




@implementation StoreSort
-(NSTimeInterval)validatePeroid
{
    return StoreSortCacheClearTimeInterval;
}
-(PLSqliteDatabase*)database
{
    return [DataBaseClient shareDBFor:DB0Name];
}
-(void)Deserialize:(NSDictionary *)_dict
{
    WS_Block_Dealize_Parser block = ^NSArray *(NSArray *array){
        NSMutableArray *retArray = nil;
        if (IsSafeArray(array)) {
            retArray = [NSMutableArray array];
            for (id obj in array) {
                StoreSort *cSort = [[StoreSort alloc] init];
                [cSort Deserialize:(NSDictionary*)obj];
                [retArray addObject:cSort];
            }
        }
        return retArray;
    };
    
    [super Deserialize:_dict coustom:block];
}


-(void)save
{
    NSMutableArray *children = self.children;
    if (IsSafeArray(children)) {
        for (StoreSort *cSort in children) {
            [cSort save];
        }
        self.children = nil;
    }
    
    [super saveWtihConstraints:@"id",@"city_id",nil];
    self.children = children;
}

+(id)getList:(NSString *)keyName value:(NSString *)value deleteOnceinvalid:(BOOL)deleted
{
    NSMutableArray *array = [super getList:keyName value:value deleteOnceinvalid:deleted];
    if (IsSafeArray(array)) {
        NSMutableArray *topArray = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(StoreSort *sort, NSUInteger idx, BOOL *stop) {
            sort.children = nil;
            if ([sort.parent_cid isEqualToString:TOPSort_PID]) {
                sort.children = [NSMutableArray array];
                [topArray addObject:sort];
               // [array removeObject:sort];
            }

        }];
//        for (StoreSort *sort in array) {
//            if ([sort.parent_cid isEqualToString:TOPSort_PID]) {
//                [topArray addObject:sort];
//                [array removeObject:sort];
//            }
//        }
//        for (StoreSort *sort in topArray) {
//            [sort getChildren:array];
//        }
        [array enumerateObjectsUsingBlock:^(StoreSort *sort, NSUInteger idx, BOOL *stop) {
            for (StoreSort *topsort in topArray) {
                if ([sort.parent_cid isEqualToString:topsort.id]) {
                    [topsort.children addObject:sort];
                  //  [array removeObject:sort];
                }
            }
        }];
        return topArray;
    }
    return nil;
}

-(void)getChildren:(NSMutableArray*)array
{
    NSMutableArray *retArray = [NSMutableArray array];
    //  for (StoreSort *sort in array) {
//    NSEnumerator *enumerator=[array objectEnumerator];
//    StoreSort *sort=nil;
//    while (sort=[enumerator nextObject]) {
//        NSLog(@"next->%@",sort);
//        if ([sort.parent_cid isEqualToString:self.id]) {
//            [retArray addObject:sort];
//            [array removeObject:sort];
//        }
//        
//    }
    
    [array enumerateObjectsUsingBlock:^(StoreSort *sort, NSUInteger idx, BOOL *stop) {

        if ([sort.parent_cid isEqualToString:self.id]) {
            [retArray addObject:sort];
            [array removeObject:sort];
        }
    }];
    
    self.children = retArray;
    for (StoreSort *sort in retArray) {
        [sort getChildren:array];
    }
}

@end