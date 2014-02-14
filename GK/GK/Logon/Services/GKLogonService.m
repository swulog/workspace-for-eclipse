//
//  GKLogonService.m
//  GK
//
//  Created by apple on 13-4-16.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GKLogonService.h"
//#import "DataBaseClient.h"
//#import "NetWorkClient.h"
#import "GlobalObject.h"


@implementation GKLogonService

//+(GKIDInfo*) getUserInfo:(NSString*)GKID
//{
//  //  NSString *sql = [NSString stringWithFormat:@"SELECT * FROM IDInfo WHERE GKID = \"%@\"",GKID];
//      NSString *sql = [NSString stringWithFormat:@"SELECT * FROM IDInfo WHERE GKID = \"%@\"",GKID];
//    id<PLResultSet> result = [DataBaseClient exeSQL:sql];
//    
//    GKIDInfo *idinfo = nil;
//    
//    if ([result next]) {
//        idinfo = [[GKIDInfo alloc] init];
//        idinfo.gkId = GKID;
//        idinfo.gkpwd = [result stringForColumn:@"GKPWD"];
//        idinfo.type = [result stringForColumn:@"IDType"];
//       // idinfo.QRImg = [result ]
//        
//    //    idinfo.qr_code_url = [result stringForColumn:@"QRUrl"];
//        idinfo.weiboId = [result stringForColumn:@"WeiBoID"];
//        idinfo.weiboType = [result intForColumn:@"WeiBoType"];
//    }
//    
//    return idinfo;
//}
//+(NSString*)getUserQRImg:(NSString*)GKID
//{
//    return [GKLogonService getUserInfo:GKID].qr_code_url;
//}


//+(void)saveUserInfo:(GKIDInfo*)iDinfo
//{
//    
////    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM IDInfo WHERE GKID = \"%@\"",iDinfo.gkId];
//    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM IDInfo WHERE GKID = \"%@\"",iDinfo.gkId];
//    id<PLResultSet> result = [DataBaseClient exeSQL:sql];
//    
//    if ([result next]) {
//        [result close];
////        sql = [NSString stringWithFormat:@"DELETE FROM IDInfo WHERE GKID = \"%@\"",iDinfo.gkId];
//        sql = [NSString stringWithFormat:@"DELETE FROM IDInfo WHERE GKID = \"%@\"",iDinfo.gkId];
//
//        result = [DataBaseClient exeSQL:sql];
//    }
////    NSData *data = nil;
////    if (iDinfo.QRImg) {
////         data = UIImageJPEGRepresentation(iDinfo.QRImg, 1.0);
////    }
//    
//   // sql = [NSString stringWithFormat:@"INSERT INTO IDInfo (\"GKID\",\"GKPWD\",\"WeiBoID\",\"WeiBoType\",\"QRImg\",\"IDType\",\"QRUrl\",\"HeadUrl\",\"HeadIconName\") VALUES (%@,%@,%@,%d,%@,%@,%@,%@,%@)",iDinfo.gkId,iDinfo.gkpwd,iDinfo.weiboId,iDinfo.weiboType,data,iDinfo.type,iDinfo.qr_code_url,iDinfo.headUrl,iDinfo.headNativeName];
//    sql = [NSString stringWithFormat:@"INSERT INTO IDInfo (gkId,gkpwd,weiBoID,weiBoType,IDType,HeadUrl,HeadIconName,GKUID,Name) VALUES (\"%@\",\"%@\",\"%@\",%d,\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",iDinfo.gkId,iDinfo.gkpwd,iDinfo.weiboId?iDinfo.weiboId:@"",iDinfo.weiboType,iDinfo.type,iDinfo.avatar_url,iDinfo.headNativeName?iDinfo.headNativeName:@"",iDinfo.id,iDinfo.name];
//
//    [DataBaseClient exeSQL:sql];
//}

//+(void)updateUser:(NSString*)iD QR:(UIImage*)img
//{
//    if (img) {
//        NSData *data = UIImageJPEGRepresentation(img, 1.0);
//        NSString *sql = [NSString stringWithFormat:@"UPDATE IDInfo SET QRImg = \"%@\" WHERE GKID = \"%@\"",data,iD];
//        [DataBaseClient exeSQL:sql];
//    }
//}
//
//+(void)updateUser:(NSString*)iD pwd:(NSString*)pwd
//{
//    NSString *sql = [NSString stringWithFormat:@"UPDATE IDInfo SET GKPWD = \"%@\" WHERE GKID = \"%@\"",pwd,iD];
//    [DataBaseClient exeSQL:sql];
//}

+(void)logonGKWith3rdAccount:(NSString*)usid platform:(NSString*)_plat name:(NSString*)_name headUrl:(NSString*)_headIconUrl  success:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failCallback
{
    NSString *url = [NSString stringWithFormat:GK_3RD_LOGON_URL,_plat,usid];
    
    NSString *user = [NSString stringWithFormat:@"%@%@",_plat,usid];
    NSString *code = [NSString stringWithFormat:@"uid%@",user];
    
    NSMutableDictionary *bodyDict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:_name,_headIconUrl, nil] forKeys:[NSArray arrayWithObjects:@"name",@"avatar", nil]];
    
    [NetWorkClient requestURL:url withBody:bodyDict method:HTTP_POST user:user pwd:code token:nil needAuthorization:YES parser:^(NSObject *responseObj){
        
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            
            GKIDInfo *idInfo = [[GKIDInfo alloc] init];
            [idInfo Deserialize:(NSDictionary*)responseObj];
            idInfo.gkId = user;
            idInfo.gkpwd = code;
            [idInfo save:@"gkId"];

            SAFE_BLOCK_CALL(sucCallback, idInfo);
        }else {
            NSLog(@"Server Data Error:it must be NSDictory");
            NSError *err = [NSError errorWithMsg:[NSString stringWithUTF8String:ErrorDesc[OTHER_ERROR-ERR_CODE_START]]];
            SAFE_BLOCK_CALL(failCallback, err);
        }
    } fail:^(NSError *err){
        SAFE_BLOCK_CALL(failCallback, err);
    }];
}

+(BOOL)logonGK:(NSString*)iD pwd:(NSString*)pWd  success:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failCallback
{
    BOOL ret = FALSE; //if there is local data ,then get data from local ,return true
    
    NSString *url = [NSString stringWithFormat:GK_LOGON_URL];
    
    [NetWorkClient requestURL:url withBody:nil method:HTTP_GET user:iD pwd:pWd token:nil needAuthorization:YES parser:^(NSObject *responseObj){
    
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            
            GKIDInfo *idInfo = [[GKIDInfo alloc] init];
            [idInfo Deserialize:(NSDictionary*)responseObj];
            idInfo.gkId = iD;
            idInfo.gkpwd = pWd;
            [idInfo save:@"gkId"];

            SAFE_BLOCK_CALL(sucCallback, idInfo);
        }else {
            NSError *err = [NSError errorWithMsg:[NSString stringWithUTF8String:ErrorDesc[OTHER_ERROR-ERR_CODE_START]]];
            SAFE_BLOCK_CALL(failCallback, err);
        }
    } fail:^(NSError *err){
        if (err.code == 422) {
            NSError *error = [NSError errorWithMsg:[NSString stringWithUTF8String:ErrorDesc[PWD_ID_ERROR - ERR_CODE_START]]];
            SAFE_BLOCK_CALL(failCallback, error);
        }else{
            SAFE_BLOCK_CALL(failCallback, err);
        }
    }];
    
    return ret;
}

+(void)LogonSync:(NSString*)gkId pwd:(NSString*)gkpwd succ:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failBack
{
    
    NSURL *url = [NSURL URLWithString:GK_LOGON_URL];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSString *base64EncodedString = [[[NSString stringWithFormat:@"%@:%@", gkId , gkpwd] dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
    [request setValue:[NSString stringWithFormat:@"%@ %@", @"Basic", base64EncodedString]forHTTPHeaderField:@"Authorization"];
    [request setTimeoutInterval:TimerOutForLogonSync];
    
    NSError *err = nil;;
    NSURLResponse *response = nil;
    NSData *data  = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    BOOL logonOK = FALSE;
    int statusCode = 0;
    if (!err && response) {
        statusCode = [(NSHTTPURLResponse *)response statusCode];
        if ((statusCode > 199) && (statusCode < 299) && (data != nil)) logonOK = TRUE;
    }
    
    if (logonOK) {
        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        GKIDInfo *idinfo = [[GKIDInfo alloc] init];
        [idinfo Deserialize:resDict];
        idinfo.gkId = gkId;
        idinfo.gkpwd = gkpwd;
        [idinfo save:@"gkId"];
        SAFE_BLOCK_CALL(sucCallback, idinfo);
    } else {
        if (statusCode == 408 || statusCode == 0) {
            SAFE_BLOCK_CALL(sucCallback, nil);
        } else {
            SAFE_BLOCK_CALL(failBack, err);
        }
    }
}

+(void)GetAppInfo:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failCallback
{
    NSString *url = APP_VERSION_URL;
    
    [NetWorkClient requestURL:url withBody:nil method:HTTP_GET parser:^(NSObject *responseObj){
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            if ([(NSDictionary*)responseObj objectForKey:@"resultCount"] > 0) {
                NSDictionary *result = [(NSArray*)[(NSDictionary*)responseObj objectForKey:@"results"] objectAtIndex:0];
                AppInfo *appInfo = [[AppInfo alloc] init];
                appInfo.storeVersion = [result objectForKey:@"version"];
                appInfo.storeReleaseNotes = [result objectForKey:@"releaseNotes"];
                SAFE_BLOCK_CALL(sucCallback, appInfo);
            } else {
                NSError *err = [NSError errorWithMsg:[NSString stringWithUTF8String:ErrorDesc[OTHER_ERROR-ERR_CODE_START]]];
                SAFE_BLOCK_CALL(failCallback, err);
            }
        } else {
            NSError *err = [NSError errorWithMsg:[NSString stringWithUTF8String:ErrorDesc[DATA_FORMAT_NOT_MATCH-ERR_CODE_START]]];
            SAFE_BLOCK_CALL(failCallback, err);
        }
    } fail:^(NSError *err){
        SAFE_BLOCK_CALL(failCallback, err);
    }];
    
    
}

+(NSArray*)getAdvInfo:(NSString*)cityId succ:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failCallback
{
    
    __block NSString *city = cityId;
    if (!IsSafeString(city)) {
        city = UnDefinedCityId;
    }
    
    NSArray *array = [GKAdvInfo getList:@"city_id" value:city];
    if (IsSafeArray(array)) {
        return  array;
    }
    
    NSString *url ;
    if (IsSafeString(cityId)) {
        url = [NSString stringWithFormat:(ADV_BANNER_URL @"/%@"),cityId];
    } else {
        url = ADV_BANNER_URL;
    }
        
    [NetWorkClient requestURL:url withBody:nil method:HTTP_GET parser:^(NSObject *responseObj){
        if ([responseObj isKindOfClass:[NSArray class]]) {
            NSArray *respnseArray = (NSArray*)responseObj;
            NSMutableArray *returnArray = [NSMutableArray arrayWithCapacity:respnseArray.count];
            
            GKAdvInfo *adv =[[GKAdvInfo alloc] init];
            adv.city_id = cityId;
            [adv delete:@"city_id"];
            
            for (id obj in respnseArray) {
                GKAdvInfo *adv =[[GKAdvInfo alloc] init];
                [adv Deserialize:obj];
           //     adv.cityId = cityId;
                [adv save:@"id"];
                [returnArray addObject:adv];
            }
            SAFE_BLOCK_CALL(sucCallback, returnArray);
        } else {
            NSLog(@"Server Data Error:it must be dictionary");
           // SAFE_BLOCK_CALL(failCallback, nil);
            SAFE_BLOCK_CALL(sucCallback, nil);
        }
    } fail:^(NSError *err){
        SAFE_BLOCK_CALL(failCallback, err);
    }];


    return nil;
}

+(NSArray*)getThemeAdvInfo:(NSString*)cityId refresh:(BOOL)forced succ:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failCallback
{
    
    if (!forced) {
        NSString *city = cityId;
        if (!IsSafeString(city)) {
            city = UnDefinedCityId;
        }
        
        NSArray *array = [GKThemeAdvInfo getList:@"city_id" value:city deleteOnceinvalid:YES];
        if (IsSafeArray(array)) {
            return  array;
        }
    }

    
    NSString *url ;
    
    if (IsSafeString(cityId)) {
        url = [NSString stringWithFormat:(ThemeADV_URL @"/%@"),cityId];
    } else {
        url = ThemeADV_URL;
    }
    
    [NetWorkClient requestURL:url withBody:nil method:HTTP_GET parser:^(NSObject *responseObj){
        if ([responseObj isKindOfClass:[NSArray class]]) {
            NSArray *respnseArray = (NSArray*)responseObj;
            NSMutableArray *returnArray = [NSMutableArray arrayWithCapacity:respnseArray.count];
            
            GKThemeAdvInfo *adv =[[GKThemeAdvInfo alloc] init];
            [adv delete:@"city_id"];
            
            for (id obj in respnseArray) {
                GKThemeAdvInfo *adv =[[GKThemeAdvInfo alloc] init];
                [adv Deserialize:obj];
                adv.city_id = cityId;
                [adv save:@"id"];
                [returnArray addObject:adv];
            }
            SAFE_BLOCK_CALL(sucCallback, returnArray);
        } else {
            NSLog(@"Server Data Error:it must be dictionary");
            SAFE_BLOCK_CALL(sucCallback, nil);
        }
    } fail:^(NSError *err){
        SAFE_BLOCK_CALL(failCallback, err);
    }];
    
    
    return nil;
}


+(void)Register:(NSString*)_phoneNum success:(NillBlock_Nill)sucCallback fail:(NillBlock_Error)failCallback
{
    NSString *url = [NSString stringWithFormat:GK_REGISTER_URL,_phoneNum];
    
    [NetWorkClient requestURL:url withBody:nil method:HTTP_GET parser:^(NSObject *responseObj){
        SAFE_BLOCK_CALL_VOID(sucCallback);
    } fail:^(NSError *err){
        if (err.code == 422) {
            NSError *error = [NSError errorWithMsg:[NSString stringWithUTF8String:ErrorDesc[WS_RegisterError-ERR_CODE_START]]];
            SAFE_BLOCK_CALL(failCallback, error);
        } else if (err.code == 404 || err.code == 500) {
            NSError *newErr = [NSError errorWithMsg:[NSString stringWithUTF8String:ErrorDesc[REGISTER_ERROR-ERR_CODE_START]]];
            SAFE_BLOCK_CALL(failCallback, newErr);
        } else {
            NSError *err = [NSError errorWithMsg:[NSString stringWithUTF8String:ErrorDesc[NET_SERVER_ERROR - ERR_CODE_START]]];
            SAFE_BLOCK_CALL(failCallback, err);
        }        
    }];
}

+(void)GetVerifyCode:(NSString*)_phoneNum success:(NillBlock_Nill)sucCallback fail:(NillBlock_Error)failCallback
{
    NSString *url = [NSString stringWithFormat:GK_VERIFY_URL,_phoneNum];
    
    [NetWorkClient requestURL:url withBody:nil method:HTTP_GET parser:^(NSObject *responseObj){
        SAFE_BLOCK_CALL_VOID(sucCallback);
    } fail:^(NSError *err){
        SAFE_BLOCK_CALL(failCallback, err);
      
    }];

}

+(void)UpdatePWD:(NSString*)_phoneNum verifyCode:(NSString*)code npwd:(NSString*)_npwd  success:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failCallback
{
    NSString *url = GK_UPDATE_PWD_URL;//[NSString stringWithFormat:GK_VERIFY_URL,_phoneNum];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:_npwd forKey:@"password"];

    [NetWorkClient requestURL:url withBody:dict method:HTTP_POST user:_phoneNum pwd:code token:nil needAuthorization:YES parser:^(NSObject *responseObj){
    
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            
            GKIDInfo *idInfo = [[GKIDInfo alloc] init];
            [idInfo Deserialize:(NSDictionary*)responseObj];
            
            idInfo.gkpwd = _npwd;
            idInfo.gkId = GO(GlobalDataService).gUserInfo.gkId;
            [idInfo save:@"gkId"];

            GO(GlobalDataService).gUserInfo = idInfo;

            SAFE_BLOCK_CALL(sucCallback, idInfo);
        }else {
            NSError *err = [NSError errorWithMsg:[NSString stringWithUTF8String:ErrorDesc[OTHER_ERROR-ERR_CODE_START]]];
            SAFE_BLOCK_CALL(failCallback, err);
        }
    } fail:^(NSError *err){
        //SAFE_BLOCK_CALL(failCallback, err);
        if (err.code == 422) {
            NSError *error = [NSError errorWithMsg:[NSString stringWithUTF8String:ErrorDesc[WS_VerifyCodeErr-ERR_CODE_START]]];
            SAFE_BLOCK_CALL(failCallback, error);
        } else {
            NSError *err = [NSError errorWithMsg:[NSString stringWithUTF8String:ErrorDesc[NET_SERVER_ERROR - ERR_CODE_START]]];
            SAFE_BLOCK_CALL(failCallback, err);
        }
    }];
}

+(void)getToken:(NSString*)iD pwd:(NSString*)pWd succ:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failCallback
{
    
    NSString *url = GS_TOKEN_URL;
    
    [NetWorkClient requestURL:url withBody:nil method:HTTP_GET user:iD pwd:pWd token:nil needAuthorization:YES parser:^(NSObject *responseObj){
        
        if ([responseObj isKindOfClass:[NSArray class]]) {
            SAFE_BLOCK_CALL(sucCallback, [(NSDictionary*)[(NSArray*)responseObj objectAtIndex:0 ] objectForKey:@"token"]);
            
        }else {
            NSLog(@"Server Data Error:it must be NSDictory");
            NSError *err =  [NSError errorWithMsg:[NSString stringWithUTF8String:ErrorDesc[OTHER_ERROR-ERR_CODE_START]]];
            SAFE_BLOCK_CALL(failCallback, err);
        }
    } fail:^(NSError *err){
        if (err.code == 422) {
            NSError *error = [NSError errorWithMsg:[NSString stringWithUTF8String:ErrorDesc[PWD_ID_ERROR-ERR_CODE_START]]];
            SAFE_BLOCK_CALL(failCallback, error);
        } else {
            NSError *error = [NSError errorWithMsg:[NSString stringWithUTF8String:ErrorDesc[NET_SERVER_ERROR-ERR_CODE_START]]];
            SAFE_BLOCK_CALL(failCallback, error);
        }
    }];
    
}


+(void)getBaiduLocation:(CLLocation*)_location success:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failCallback
{
    NSString *url = [NSString stringWithFormat:BMMAP_POS_CONVERT_URL,_location.coordinate.longitude,_location.coordinate.latitude];
    
    [NetWorkClient requestURL:url withBody:nil method:HTTP_GET parser:^(NSObject *responseObj){
        NSDictionary *dict = (NSDictionary*)responseObj;
        NSString *xstr = [[NSString alloc] initWithData:[NSData  dataFromBase64String:(NSString*)[dict objectForKey:@"x"]] encoding:NSASCIIStringEncoding];
        double x = [xstr doubleValue];
        
        NSString *ystr = [[NSString alloc] initWithData:[NSData  dataFromBase64String:(NSString*)[dict objectForKey:@"y"]] encoding:NSASCIIStringEncoding];
        double y = [ystr doubleValue];
        
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:y longitude:x];
        SAFE_BLOCK_CALL(sucCallback,loc);
    } fail:^(NSError *err){
        NSError *error= [NSError errorWithMsg:[NSString stringWithUTF8String:ErrorDesc[LOCATION_ERROR-ERR_CODE_START]]];
        SAFE_BLOCK_CALL(failCallback, error);
    }];
    
}

+(City*)getCityId:(NSString*)name success:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failCallback
{
    
    City *city = [City get:@"name" value:name];
    if (city) {
        return city;
    }
    
    NSString *url = [NSString stringWithFormat:CITY_ID_URL,[name mk_urlEncodedString]];
    
    [NetWorkClient requestURL:url withBody:nil method:HTTP_GET  extraHeader:nil parser:^(NSObject *responseObj){
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            City *city = [[City alloc] init];
            [city Deserialize:(NSDictionary*)responseObj];
           // [city save:@"id" toDB:[DataBaseClient shareDBFor:DB1Name]];
            [city save:@"id"];
            SAFE_BLOCK_CALL(sucCallback, city);
        } else {
            NSError *err = [NSError errorWithMsg:[NSString stringWithUTF8String:ErrorDesc[DATA_FORMAT_NOT_MATCH-ERR_CODE_START]]];
            SAFE_BLOCK_CALL(failCallback, err);
        }
    } fail:^(NSError *err){
        SAFE_BLOCK_CALL(failCallback, err);
    }];
    return nil;
}

//+(City*)getCity:(NSString*)name
//{
//    
//    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM City WHERE name = \"%@\"",name];
//    id<PLResultSet> result = [DataBaseClient exeSQL:sql];
//    
//    if([result next]) {
//        City *city = [[City alloc] init];
//        [city DeserializeFromDBResult:result];
//        return city;
//    }
//    
//    return nil;
//}

+(NSArray*)getCityLIist:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failCallback
{
    NSArray *list = [City getAll];
    
    if (list) {
        return list;
    }
    
    NSString *url = [NSString stringWithFormat:CITY_LIST_URL];
    
    [NetWorkClient requestURL:url withBody:nil method:HTTP_GET  extraHeader:nil parser:^(NSObject *responseObj){
        if ([responseObj isKindOfClass:[NSArray class]]) {
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:((NSArray*)responseObj).count];
            for (id obj in (NSArray*)responseObj) {
                City *city = [[City alloc] init];
                [city Deserialize:(NSDictionary*)obj];
                [city save:@"id"];
                //[city save:@"id" toDB:[DataBaseClient shareDBFor:DB1Name]];
                [array addObject:city];
            }

            SAFE_BLOCK_CALL(sucCallback, array);
        } else {
            NSLog(@"Server Data Error:it must be NSArray");
            NSError *err = [NSError errorWithMsg:[NSString stringWithUTF8String:ErrorDesc[DATA_FORMAT_NOT_MATCH-ERR_CODE_START]]];
            SAFE_BLOCK_CALL(failCallback, err);
        }
    } fail:^(NSError *err){
        SAFE_BLOCK_CALL(failCallback, err);
    }];
    return nil;
}


@end


@implementation GKIDInfo
-(NSTimeInterval)validatePeroid
{
    return 0;
}
-(PLSqliteDatabase*)database
{
    return [DataBaseClient shareDBFor:DB0Name];
}


@end
@implementation GKAdvInfo
-(NSTimeInterval)validatePeroid
{
    return ADVCacheClearTimeInterval;
}
@end
@implementation City
-(NSTimeInterval)validatePeroid
{
    return CityCacheClearTimeInterval;
}
-(PLSqliteDatabase*)database
{
    return [DataBaseClient shareDBFor:DB0Name];
}

@end
@implementation AppInfo
@end
@implementation GKThemeAdvInfo
-(NSTimeInterval)validatePeroid
{
    return ADVCacheClearTimeInterval;
}
@end
