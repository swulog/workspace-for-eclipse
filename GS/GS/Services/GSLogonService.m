//
//  GKLogonService.m
//  GK
//
//  Created by apple on 13-4-16.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GSLogonService.h"
#import "DataBaseClient.h"
#import "NetWorkClient.h"
#import "APPConfig.h"
#import "AppHeader.h"
#import "GS_GlobalObject.h"

@implementation GSIDInfo
@end
@implementation AppInfo
@end

@implementation GSLogonService


+(BOOL)logon:(NSString*)iD pwd:(NSString*)pWd succ:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failCallback
{
    BOOL ret = FALSE; //if there is local data ,then get data from local ,return true
    
    NSString *url = [NSString stringWithFormat:GS_LOGON_URL];
    
    [NetWorkClient requestURL:url withBody:nil method:HTTP_GET user:iD pwd:pWd token:nil needAuthorization:YES parser:^(NSObject *responseObj){
        
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
        //    BOOL isExist = (BOOL)[(NSDictionary*)responseObj objectForKey:@"exist"];
            
            GSIDInfo *idinfo = [[GSIDInfo alloc] init];
            [idinfo Deserialize:(NSDictionary*)responseObj coustom:nil];
            idinfo.gsId = iD;
            idinfo.gspwd = pWd;
            
            [self saveUserInfo:idinfo];
            
            if (idinfo.exist) {
                [[NSUserDefaults standardUserDefaults] setValue:iD forKeyPath:@"LastUser"];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGON_OK object:idinfo];
         
            SAFE_BLOCK_CALL(sucCallback, idinfo);

        }else {
            NSLog(@"Server Data Error:it must be NSDictory");
            NSError *err =  WSErrorWithCode(WS_DataUnMatched);
            SAFE_BLOCK_CALL(failCallback, err);
       }
    } fail:^(NSError *err){
        SAFE_BLOCK_CALL(failCallback, err);
    }];
    
    return ret;
}

+(void)getToken:(NSString*)iD pwd:(NSString*)pWd succ:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failCallback
{
    
    NSString *url = [NSString stringWithFormat:GS_TOKEN_URL];
    
    [NetWorkClient requestURL:url withBody:nil method:HTTP_GET user:iD pwd:pWd token:nil needAuthorization:YES parser:^(NSObject *responseObj){
        
        if ([responseObj isKindOfClass:[NSArray class]]) {
//            [GS_GlobalObject GS_GObject].gToken = [(NSDictionary*)responseObj objectForKey:@"token"];
            
            SAFE_BLOCK_CALL(sucCallback, [(NSDictionary*)[(NSArray*)responseObj objectAtIndex:0 ] objectForKey:@"token"]);
            
        }else {
            NSLog(@"Server Data Error:it must be NSDictory");
            NSError *err =  WSErrorWithCode(WS_DataUnMatched);
            SAFE_BLOCK_CALL(failCallback, err);
        }
    } fail:^(NSError *err){
        SAFE_BLOCK_CALL(failCallback, err);
    }];
    
}

+(void)saveUserInfo:(GSIDInfo*)iDinfo
{
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM IDInfo WHERE ID = \"%@\"",iDinfo.gsId];
    id<PLResultSet> result = [DataBaseClient exeSQL:sql];
    
    if ([result next]) {
        [result close];
        sql = [NSString stringWithFormat:@"DELETE FROM IDInfo WHERE ID = \"%@\"",iDinfo.gsId];
        
        [DataBaseClient exeSQL:sql];
    }
    
    sql = [NSString stringWithFormat:@"INSERT INTO IDInfo (ID,PWD,avatar_url,Name,GSUid,exist,store_id) VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",%d,\"%@\")",iDinfo.gsId,iDinfo.gspwd,iDinfo.avatar_url,iDinfo.name,iDinfo.id,iDinfo.exist,iDinfo.store_id];
    
    [DataBaseClient exeSQL:sql];
}

+(GSIDInfo*) getUserInfo:(NSString*)GSID
{
    //  NSString *sql = [NSString stringWithFormat:@"SELECT * FROM IDInfo WHERE GKID = \"%@\"",GKID];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM IDInfo WHERE ID = \"%@\"",GSID];
    id<PLResultSet> result = [DataBaseClient exeSQL:sql];
    
    GSIDInfo *idinfo = nil;
    
    if ([result next]) {
        idinfo = [[GSIDInfo alloc] init];
        idinfo.gsId = GSID;
        idinfo.gspwd = [result stringForColumn:@"PWD"];
        idinfo.exist = [result boolForColumn:@"exist"];
        idinfo.avatar_url = [result stringForColumn:@"avatar_url"];
        idinfo.name = [result stringForColumn:@"Name"];
        idinfo.id = [result stringForColumn:@"GSUid"];
        idinfo.store_id = [result stringForColumn:@"store_id"];
    }
    
    return idinfo;
}

+(void)UpdatePWD:(NSString*)_phoneNum verifyCode:(NSString*)code npwd:(NSString*)_npwd success:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failCallback
{
    NSString *url = GS_UPDATE_PWD_URL;//[NSString stringWithFormat:GK_VERIFY_URL,_phoneNum];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:_npwd forKey:@"password"];
     //[GS_GlobalObject GS_GObject].gToken
    [NetWorkClient requestURL:url withBody:dict method:HTTP_POST user:_phoneNum pwd:code token:nil needAuthorization:YES parser:^(NSObject *responseObj){
        
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            
            GSIDInfo *idInfo = [[GSIDInfo alloc] init];
            [idInfo Deserialize:(NSDictionary*)responseObj];
            
            idInfo.gspwd = _npwd;
            idInfo.gsId =   _phoneNum;//[GS_GlobalObject GS_GObject].ownIdInfo.gsId;
           // [GS_GlobalObject GS_GObject].ownIdInfo = idInfo;

            [self saveUserInfo:idInfo];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGON_OK object:idInfo];

            SAFE_BLOCK_CALL(sucCallback, idInfo);
            
        }else {
            NSLog(@"Server Data Error:it must be NSDictory");
            NSError *err = WSErrorWithCode(WS_DataUnMatched);
            SAFE_BLOCK_CALL(failCallback, err);
        }
    } fail:^(NSError *err){
        SAFE_BLOCK_CALL(failCallback, err);
    }];
}

+(void)Register:(NSString*)_phoneNum success:(NillBlock_Nill)sucCallback fail:(NillBlock_Error)failCallback
{
    NSString *url = [NSString stringWithFormat:GS_REGISTER_URL,_phoneNum];
    
    [NetWorkClient requestURL:url withBody:nil method:HTTP_GET parser:^(NSObject *responseObj){
        SAFE_BLOCK_CALL_VOID(sucCallback);
    } fail:^(NSError *err){
        SAFE_BLOCK_CALL(failCallback, err);
    }];
}
+(void)GetVerifyCode:(NSString*)_phoneNum success:(NillBlock_Nill)sucCallback fail:(NillBlock_Error)failCallback
{
    NSString *url = [NSString stringWithFormat:GS_VERIFY_URL,_phoneNum];
    
    [NetWorkClient requestURL:url withBody:nil method:HTTP_GET parser:^(NSObject *responseObj){
        SAFE_BLOCK_CALL_VOID(sucCallback);
    } fail:^(NSError *err){
        SAFE_BLOCK_CALL(failCallback, err);
    }];
    
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
            }else {
                NSError *err = WSErrorWithCode(WS_UndifinedError);
                SAFE_BLOCK_CALL(failCallback, err);
            }
        } else {
            NSError *err = WSErrorWithCode(WS_DataUnMatched);
            SAFE_BLOCK_CALL(failCallback, err);
        }

    } fail:^(NSError *err){
        SAFE_BLOCK_CALL(failCallback, err);
    }];
    
}
@end




