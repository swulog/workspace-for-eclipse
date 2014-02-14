//
//  GSStoreService.m
//  GS
//
//  Created by W.S. on 13-6-8.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GSStoreService.h"
#import "DataBaseClient.h"
#import "NetWorkClient.h"
#import "APPConfig.h"
#import "AppHeader.h"
#import <objc/runtime.h>
#import "GS_GlobalObject.h"
@implementation StoreSort
@end
@implementation City
@end
@implementation District
@end
@implementation StorePhotos
@end
@implementation StoreUploadPhoto
@end

@implementation StoreInfo

- (id)copyWithZone:(NSZone *)zone
{
    StoreInfo *copy = [[self class] allocWithZone: zone];
    
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName =[NSString stringWithUTF8String:property_getName(property)];
        //   NSLog(@"%@",propertyName);
        id propertyValue = [self  valueForKey:propertyName];
        
        [copy setValue:propertyValue forKey:propertyName];
    }
    return copy; //返回副本
}
@end





@implementation GSStoreService


+(NSArray*)getStoreSort:(BOOL)forceUpdate succ:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failCallback
{
    
    NSArray *ret = nil;
    NSArray *sortArray =   [GSStoreService getStoreSort];
    
    if (sortArray && sortArray.count > 0) {
        //SAFE_BLOCK_CALL(sucCallback, sortArray);
        ret = sortArray;
    }
    
    if (forceUpdate || !sortArray || sortArray.count == 0 ) {
        NSString *url = [NSString stringWithFormat:GS_SORT_URL,GK_CITY_GuiZHou_ID];
        
        [NetWorkClient requestURL:url withBody:nil method:HTTP_GET parser:^(NSObject *responseObj){
            if ([responseObj isKindOfClass:[NSArray class]]) {
                NSMutableArray *retArray = [NSMutableArray arrayWithCapacity:10];
                for (id  obj in (NSArray*)responseObj) {
                    StoreSort *sort = [[StoreSort alloc] init];
                    [sort Deserialize:obj];
                    [retArray addObject:sort];
                }
                [self saveStoreSort:retArray];
                SAFE_BLOCK_CALL(sucCallback, retArray);
            } else {
                NSLog(@"Server Data Error:it must be NSArray");
                NSError *err =  WSErrorWithCode(WS_DataUnMatched);
                SAFE_BLOCK_CALL(failCallback, err);
            }
        }fail:^(NSError *err){
            SAFE_BLOCK_CALL(failCallback, err);
//            NSError *error = WSErrorWithCode(WS_NetError);
//            SAFE_BLOCK_CALL(failCallback, error);
        }];
    }
    
    return ret;
}

+(NSArray*)getStoreSort
{
    NSMutableArray *retArray = [[NSMutableArray alloc] init];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM StoreSort"];
    id<PLResultSet> result = [DataBaseClient exeSQL:sql];
    
    while([result next]) {
        StoreSort *sort = [[StoreSort alloc] init];
        sort.id = [result objectForColumn:@"id"];
        sort.name = [result objectForColumn:@"name"];
        sort.image_url = [result objectForColumn:@"image_url"];
        [retArray addObject:sort];
    }
    
    return retArray;
}

+(void)saveStoreSort:(NSArray*)sortArray
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM StoreSort"];
    [DataBaseClient exeSQL:sql];
    
    for (StoreSort *storeSort in sortArray) {
        sql = [NSString stringWithFormat:@"INSERT INTO StoreSort (id,name,image_url) VALUES (\"%@\",\"%@\",\"%@\")",storeSort.id,storeSort.name,storeSort.image_url];
        [DataBaseClient exeSQL:sql];
    }
}

//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
+(void)saveStoreInfo:(StoreInfo*)_storeInfo  succ:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failCallback
{
    NSString *url = [NSString stringWithFormat:GS_STORE_UPDATE_URL,_storeInfo.id];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:8];
    [dict setValue:_storeInfo.name forKey:@"name"];
    [dict setValue:_storeInfo.address forKey:@"address"];
    [dict setValue:_storeInfo.taxo_id forKey:@"taxoId"];
    [dict setValue:_storeInfo.phone forKey:@"phone"];
    [dict setValue:_storeInfo.hours forKey:@"hours"];
    [dict setValue:_storeInfo.discount forKey:@"discount"];
    [dict setValue:_storeInfo.city_id forKey:@"cityId"];
    if(IsSafeString(_storeInfo.districtId)) {
        [dict setValue:_storeInfo.districtId forKey:@"districtId"];
    }

    
    [dict setValue:[NSNumber numberWithDouble:_storeInfo.latitude] forKey:@"latitude"];
    [dict setValue:[NSNumber numberWithDouble:_storeInfo.longitude] forKey:@"longitude"];
    
#if  0
    static char* httpMethodStr[] ={"GET","POST","PUT","DELETE"};
    NSString *_url = url ;
    
    
    NSString *host = getHost(_url);
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:host];
    
    MKNetworkOperation *op = [engine operationWithPath:getPath(_url) params:nil httpMethod:[NSString stringWithUTF8String:httpMethodStr[HTTP_POST]]];
    [op addHeaders:[NSDictionary dictionaryWithObject:@"close" forKey:@"Connection"]];
    [op setAuthorizationHeaderValue: [GS_GlobalObject GS_GObject].gToken forAuthType:@"token"];
    [op setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) {
        //   NSMutableString *bodyStr = [[NSMutableString alloc] init];
        NSError *error = nil;
        NSMutableString *returnStr = [[NSMutableString alloc] init];
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
        
        [returnStr appendString:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];

        
        return returnStr;
        
        
    } forType:@"application/json"];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSLog(@"xxx");
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"ddd");
    }];
    [engine enqueueOperation:op];

#else
    [NetWorkClient requestURL:url withBody:dict method:HTTP_POST user:nil pwd:nil token:[GS_GlobalObject GS_GObject].gToken needAuthorization:YES  parser:^(NSObject *responseObj){
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            
            StoreInfo *sort = [[StoreInfo alloc] init];
            [sort Deserialize:(NSDictionary*)responseObj];
            [sort save2DB:@"id"];
            
            SAFE_BLOCK_CALL(sucCallback, sort);
        } else {
            NSLog(@"Server Data Error:it must be NSArray");
            NSError *err =  WSErrorWithCode(WS_DataUnMatched);
            SAFE_BLOCK_CALL(failCallback, err);
        }
    }fail:^(NSError *err){
//        NSError *error = WSErrorWithCode(WS_NetError);
//        SAFE_BLOCK_CALL(failCallback, error);
        SAFE_BLOCK_CALL(failCallback, err);

    }];
    
#endif
}

+(NSArray*)getStoreInfo:(NSString*)userId refreshed:(BOOL)forceUpdate succ:(NillBlock_Array)sucCallback fail:(NillBlock_Error)failCallback
#if 0
{
    
    NSArray *ret = nil;
    NSArray *sortArray = [GSStoreService getStoreInfo:userId];
    
    if (sortArray && sortArray.count > 0) {
        //    SAFE_BLOCK_CALL(sucCallback, sortArray);
        ret = sortArray;
    }
    
    if (forceUpdate || !sortArray || sortArray.count == 0 ) {
        NSString *url = [NSString stringWithFormat:GS_STORE_INFO_URL,userId];
        
        [NetWorkClient requestURL:url withBody:nil method:HTTP_GET parser:^(NSObject *responseObj){
            if ([responseObj isKindOfClass:[NSArray class]]) {
                NSMutableArray *retArray = [NSMutableArray arrayWithCapacity:10];
                for (id  obj in (NSArray*)responseObj) {
                    StoreInfo *sort = [[StoreInfo alloc] init];
                    [sort Deserialize:obj];
                    [sort save2DB:@"id"];
                    [retArray addObject:sort];
                }
                
                SAFE_BLOCK_CALL(sucCallback, retArray);
            } else {
                NSLog(@"Server Data Error:it must be NSArray");
                NSError *err =  WSErrorWithCode(WS_DataUnMatched);
                SAFE_BLOCK_CALL(failCallback, err);
            }
        }fail:^(NSError *err){
//            NSError *error = WSErrorWithCode(WS_NetError);
//            SAFE_BLOCK_CALL(failCallback, error);
            SAFE_BLOCK_CALL(failCallback, err);
        }];
    }
    
    return ret;

}
#else
{
    
    NSArray *ret = nil;

    NSArray *sortArray = [GSStoreService getStoreInfo:userId];
    
    if (sortArray && sortArray.count > 0) {
        //    SAFE_BLOCK_CALL(sucCallback, sortArray);
        ret = sortArray;
    }
    
    if (forceUpdate || !sortArray || sortArray.count == 0 ) {
        NSString *url = GS_STORE_INFO_URL;
        [NetWorkClient requestURL:url withBody:nil method:HTTP_GET user:nil pwd:nil token:[GS_GlobalObject GS_GObject].gToken  needAuthorization:YES parser:^(NSObject *responseObj){
            if ([responseObj isKindOfClass:[NSArray class]]) {
                NSMutableArray *retArray = [NSMutableArray arrayWithCapacity:10];
                for (id  obj in (NSArray*)responseObj) {
                    StoreInfo *sort = [[StoreInfo alloc] init];
                    [sort Deserialize:obj];
                    [sort save2DB:@"id"];
                    [retArray addObject:sort];
                }
                
                SAFE_BLOCK_CALL(sucCallback, retArray);
            } else {
                NSLog(@"Server Data Error:it must be NSArray");
                NSError *err =  WSErrorWithCode(WS_DataUnMatched);
                SAFE_BLOCK_CALL(failCallback, err);
            }
        }fail:^(NSError *err){
            //            NSError *error = WSErrorWithCode(WS_NetError);
            //            SAFE_BLOCK_CALL(failCallback, error);
            SAFE_BLOCK_CALL(failCallback, err);
        }];
    }
    return ret;
    
}
#endif
+(void)getStoreStatus:(NSString*)_storeId  succ:(NillBlock_BOOL)sucCallback fail:(NillBlock_Error)failCallback
{
    NSString *url = [NSString stringWithFormat:GS_STORE_STATUS_URL,_storeId];
    
    [NetWorkClient requestURL:url withBody:nil method:HTTP_GET parser:^(NSObject *responseObj){
        SAFE_BLOCK_CALL(sucCallback, FALSE);
    }fail:^(NSError *err){
        if (err.code == 404) {
            SAFE_BLOCK_CALL(sucCallback, TRUE);
        } else {
            SAFE_BLOCK_CALL(failCallback, err);
        }
    }];
}


+(NSArray*)getStoreInfo:(NSString*)userId
{
    NSMutableArray *retArray = nil;
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM StoreInfo where owner_id = \"%@\"",userId];
    id<PLResultSet> result = [DataBaseClient exeSQL:sql];
    
    while([result next]) {
        StoreInfo *sort = [[StoreInfo alloc] init];
        [sort DeserializeFromDBResult:result];
        if (!retArray) {
            retArray = [NSMutableArray arrayWithCapacity:1];
        }
        [retArray addObject:sort];
    }
    
    return retArray;
}

+(NSArray*)getStorePhotoes:(NSString*)storeId refreshed:(BOOL)forceUpdate succ:(NillBlock_Array)sucCallback fail:(NillBlock_Error)failCallback
{
    
    NSArray *ret = nil;
    

    if (!forceUpdate) {
        ret = [StorePhotos getList:@"storeId" value:storeId fromDB:[DataBaseClient shareDataBase]];
        if (ret && ret.count > 0 && !forceUpdate) {
            return ret;
        }
    }
    
    NSString *url = [NSString stringWithFormat:GS_STORE_PIC_INFO_URL,storeId] ;
    [NetWorkClient requestURL:url withBody:nil method:HTTP_GET user:nil pwd:nil token:nil  needAuthorization:FALSE parser:^(NSObject *responseObj){
        if ([responseObj isKindOfClass:[NSArray class]]) {
            NSMutableArray *retArray = [NSMutableArray arrayWithCapacity:4];
            for (id  obj in (NSArray*)responseObj) {
                StorePhotos *sort = [[StorePhotos alloc] init];
                [sort Deserialize:obj];
                sort.storeId = storeId;
                [sort save2DBWtihConstraints:@"storeId",@"name",nil];
                [retArray addObject:sort];
            }
            
            SAFE_BLOCK_CALL(sucCallback, retArray);
        } else {
            NSLog(@"Server Data Error:it must be NSArray");
            NSError *err =  WSErrorWithCode(WS_DataUnMatched);
            SAFE_BLOCK_CALL(failCallback, err);
        }
    }fail:^(NSError *err){
        SAFE_BLOCK_CALL(failCallback, err);
    }];
    return ret;
    
}
+(void)updateStorePhotoes:(NSString*)storeId photes:(NSArray*)photoes succ:(NillBlock_Array)sucCallback fail:(NillBlock_Error)failCallback
{
    NSString *_url = [NSString stringWithFormat:GS_STORE_PIC_INFO_URL,storeId] ;

    [NetWorkClient uploadToUrl:_url withBody:nil customerBodyHandler:^NSString *(NSDictionary *postDataDict) {
        NSError *error = nil;
        NSMutableString *returnStr = [[NSMutableString alloc] init];
        [returnStr appendFormat:@"["];
        for (StoreUploadPhoto *photo in photoes) {
            NSData *data = [NSJSONSerialization dataWithJSONObject:[photo dictory]
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
            
            [returnStr appendString:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
            if (photo != [photoes lastObject]) {
                [returnStr appendFormat:@","];
            }
        }
        [returnStr appendFormat:@"]"];
        return returnStr;
        
    } processHandler:nil withToken:[GS_GlobalObject GS_GObject].gToken parser:^(NSObject *responseObj) {
        if ([responseObj isKindOfClass:[NSArray class]]) {
            NSMutableArray *retArray = [NSMutableArray arrayWithCapacity:4];
            for (id  obj in (NSArray*)responseObj) {
                StorePhotos *sort = [[StorePhotos alloc] init];
                [sort Deserialize:obj];
                sort.storeId = storeId;
                [sort save2DBWtihConstraints:@"storeId",@"name",nil];
                [retArray addObject:sort];
            }
            
            SAFE_BLOCK_CALL(sucCallback, retArray);
        } else {
            NSLog(@"Server Data Error:it must be NSArray");
            NSError *err =  WSErrorWithCode(WS_DataUnMatched);
            SAFE_BLOCK_CALL(failCallback, err);
        }
        
    } fail:^(NSError *err) {
        SAFE_BLOCK_CALL(failCallback, err);
    }];
}

+(void)uploadStorePhotoes:(NSString*)storeId photes:(NSArray*)photoes succ:(NillBlock_Array)sucCallback fail:(NillBlock_Error)failCallback processHandler:(NillBlock_Double)processHandler
{
    NSString *_url = [NSString stringWithFormat:GS_STORE_PIC_INFO_URL,storeId] ;
    
    [NetWorkClient uploadToUrl:_url withBody:nil customerBodyHandler:^NSString *(NSDictionary *postDataDict) {
        NSError *error = nil;
        NSMutableString *returnStr = [[NSMutableString alloc] init];
        [returnStr appendFormat:@"["];
        for (StoreUploadPhoto *photo in photoes) {
            NSData *data = [NSJSONSerialization dataWithJSONObject:[photo dictory]
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
            
            [returnStr appendString:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
            if (photo != [photoes lastObject]) {
                [returnStr appendFormat:@","];
            }
        }
        [returnStr appendFormat:@"]"];
        return returnStr;
        
    } processHandler:processHandler withToken:[GS_GlobalObject GS_GObject].gToken parser:^(NSObject *responseObj) {
        if ([responseObj isKindOfClass:[NSArray class]]) {
            NSMutableArray *retArray = [NSMutableArray arrayWithCapacity:4];
            for (id  obj in (NSArray*)responseObj) {
                StorePhotos *sort = [[StorePhotos alloc] init];
                [sort Deserialize:obj];
                sort.storeId = storeId;
                [sort save2DBWtihConstraints:@"storeId",@"name",nil];
                [retArray addObject:sort];
            }
            
            SAFE_BLOCK_CALL(sucCallback, retArray);
        } else {
            NSLog(@"Server Data Error:it must be NSArray");
            NSError *err =  WSErrorWithCode(WS_DataUnMatched);
            SAFE_BLOCK_CALL(failCallback, err);
        }

    } fail:^(NSError *err) {
        SAFE_BLOCK_CALL(failCallback, err);
    }];

}


//+(void)saveStoreInfo:(StoreInfo*)storeInfo
//{
//    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM StoreInfo WHERE id = \"%@\"",storeInfo.id];
//    id<PLResultSet> result = [DataBaseClient exeSQL:sql];
//
//
//    if ([result next]) {
//        [result close];
//        sql = [NSString stringWithFormat:@"DELETE FROM StoreInfo WHERE id = \"%@\"",storeInfo.id];
//
//        result = [DataBaseClient exeSQL:sql];
//    }
//
////    sql = [NSString stringWithFormat:@"INSERT INTO IDInfo (ID,PWD,avatar_url,Name,GSUid,StoreCount) VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",%d)",iDinfo.gsId,iDinfo.gspwd,iDinfo.avatar_url,iDinfo.name,iDinfo.id,iDinfo.exist];
////
////    [DataBaseClient exeSQL:sql];
//
//    return ;
//
//}

//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
+(void)updateHeadIcon:(UIImage*)_image storeID:(NSString*)_storeId  success:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failCallback
{
    
    NSString *url = [NSString stringWithFormat:GS_STORE_UPDATE_ICON_URL,_storeId] ;
    
    NSData *postData = UIImageJPEGRepresentation(_image, 0.75);
    
    NSMutableDictionary *bodyDict = [NSMutableDictionary dictionaryWithObject:[postData base64EncodedString] forKey:@"image"];
    
    [NetWorkClient requestURL:url withBody:bodyDict method:HTTP_POST parser:^(NSObject *responseObj){
        
        if([responseObj isKindOfClass:[NSDictionary class]]){
            StoreInfo *storeInfo = [[StoreInfo alloc] init];
            [storeInfo Deserialize:(NSDictionary*)responseObj];
            [storeInfo save2DB:@"id"];
            SAFE_BLOCK_CALL(sucCallback,storeInfo);
        } else {
            NSLog(@"Server Data Error");
            NSError *err =  WSErrorWithCode(WS_DataUnMatched);
            SAFE_BLOCK_CALL(failCallback, err);
        }
        
    } fail:^(NSError *err){
//        NSError *error = WSErrorWithCode(WS_NetError);
//        SAFE_BLOCK_CALL(failCallback, error);
        SAFE_BLOCK_CALL(failCallback, err);
    }];
    
}
//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
+(void)scan:(NSString*)_consumerId withStore:(NSString*)_storeId  success:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failCallback
{
    NSString *url = [NSString stringWithFormat:GS_STORE_SCAN_URL,_storeId,_consumerId] ;
    
    [NetWorkClient requestURL:url withBody:nil method:HTTP_GET user:[GS_GlobalObject GS_GObject].ownIdInfo.gsId pwd:[GS_GlobalObject GS_GObject].ownIdInfo.gspwd token:[GS_GlobalObject GS_GObject].gToken needAuthorization:YES parser:^(NSObject *responseObj){
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            StoreInfo *sort = [[StoreInfo alloc] init];
            [sort Deserialize:(NSDictionary*)responseObj];
            [sort save2DB:@"id"];
            SAFE_BLOCK_CALL(sucCallback, sort);
        } else {
            NSLog(@"Server Data Error");
            NSError *err =  WSErrorWithCode(WS_DataUnMatched);
            SAFE_BLOCK_CALL(failCallback, err);

        }
            } fail:^(NSError *err){
        //        if (err.code == 422) {
        //            NSError *error =  WSErrorWithCode(WS_PWDIDError);
        //            SAFE_BLOCK_CALL(failCallback, error);
        //        }else
        {
//            NSError *error = WSErrorWithCode(WS_NetError);
//            SAFE_BLOCK_CALL(failCallback, error);
            SAFE_BLOCK_CALL(failCallback, err);
        }
    }];
    
    
}
//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
+(City*)getCityId:(NSString*)name success:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failCallback
{
    
    City *city = [self getCity:name];
    if (city) {
        return city;
    }
    
    NSString *url = [NSString stringWithFormat:CITY_ID_URL,[name mk_urlEncodedString]];
    
    [NetWorkClient requestURL:url withBody:nil method:HTTP_GET  parser:^(NSObject *responseObj){
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            City *city = [[City alloc] initWithDB:[DataBaseClient shareDataBase]];
            [city Deserialize:(NSDictionary*)responseObj];
            [city save:@"id" toDB:[DataBaseClient shareDataBase]];
            SAFE_BLOCK_CALL(sucCallback, city);
        } else {
            NSLog(@"Server Data Error:it must be dictionary");
            NSError *err = WSErrorWithCode(WS_DataUnMatched);
            SAFE_BLOCK_CALL(failCallback, err);
        }
    } fail:^(NSError *err){
        SAFE_BLOCK_CALL(failCallback, err);
    }];
    return nil;
}

+(City*)getCity:(NSString*)name
{
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM City WHERE name = \"%@\"",name];
    id<PLResultSet> result = [DataBaseClient exeSQL:sql];
    
    if([result next]) {
        City *city = [[City alloc] init];
        [city DeserializeFromDBResult:result];
        return city;
    }
    
    return nil;
}

+(District*)getDistrictId:(NSString*)cityId disctrictName:(NSString*)name success:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failCallback
{
    
    District *district =  [self getDistrict:name inCity:cityId];
    if (district) {
        return district;
    }
    
    NSString *url = [NSString stringWithFormat:DISTRICT_ID_URL,cityId,[name mk_urlEncodedString]];
    
    [NetWorkClient requestURL:url withBody:nil method:HTTP_GET  parser:^(NSObject *responseObj){
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            District *city = [[District alloc] initWithDB:[DataBaseClient shareDataBase]];
            [city Deserialize:(NSDictionary*)responseObj];
            [self saveDistrict:city];
            SAFE_BLOCK_CALL(sucCallback, city);
        } else {
            NSLog(@"Server Data Error:it must be dictionary");
            NSError *err = WSErrorWithCode(WS_DataUnMatched);
            SAFE_BLOCK_CALL(failCallback, err);
        }
    } fail:^(NSError *err){
        SAFE_BLOCK_CALL(failCallback, err);
    }];
    return nil;
}

+(District*)getDistrict:(NSString*)name inCity:(NSString*)cityId
{
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM City WHERE name = \"%@\" AND city_id =\"%@\"",name,cityId];
    id<PLResultSet> result = [DataBaseClient exeSQL:sql];
    
    if([result next]) {
        District *district = [[District alloc] init];
        [district DeserializeFromDBResult:result];
        return district;
    }
    
    return nil;
}
+(void)saveDistrict:(District*)district
{
    
    if (!district) {
        return;
    }
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM District WHERE  name = \"%@\" AND city_id =\"%@\"",district.name,district.city_id];
    
    [DataBaseClient exeSQL:sql];
    
    sql = [NSString stringWithFormat:@"INSERT INTO StoreSort (id,name,city_id) VALUES (\"%@\",\"%@\",\"%@\")",district.id,district.name,district.city_id];
    [DataBaseClient exeSQL:sql];
}
@end
