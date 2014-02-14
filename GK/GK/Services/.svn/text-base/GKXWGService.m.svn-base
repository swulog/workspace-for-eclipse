//
//  GKXWGService.m
//  GK
//
//  Created by W.S. on 13-8-26.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GKXWGService.h"
#import "GlobalObject.h"


#define TBK_URL_CONVERT_API @"taobao.taobaoke.mobile.items.convert"


@implementation GKXWGService

+(WSNetServicesReault*)getXWGList:(NSInteger)_cid order:(NSString*)_orderKey  page:(int)_pageNo num:(int)_pageNum succ:(NillBlock_OBJ_BOOL)sucCallback fail:(NillBlock_Error)failCallback
{
    NSMutableString *url ;
    BOOL extraParams = FALSE;
    if (_cid == GoodIDForEditor) {
        url = [NSMutableString  stringWithString:XWG_EDITOR_LIST_URL];
    } else {
        url = [NSMutableString  stringWithString:XWG_LIST_URL];
        [url appendString:[NSString stringWithFormat:@"?cid=%d",_cid]];
        extraParams = TRUE;
    }
    
    if (_pageNum != NOT_DEFINED) {
        [url appendString:[NSString stringWithFormat:@"%@per_page=%d",extraParams?@"&":@"?", _pageNum]];
        extraParams = TRUE;
    }
    
    if (_pageNo != NOT_DEFINED) {
        [url appendString:[NSString stringWithFormat:@"%@page=%d",extraParams?@"&":@"?",_pageNo]];
        extraParams = TRUE;
    }
    
    if (IsSafeString(_orderKey)) {
        [url appendString:[NSString stringWithFormat:@"%@orderby=%@",extraParams?@"&":@"?",[_orderKey mk_urlEncodedString]]];
    }
    
    WSNetServicesReault *result = [[WSNetServicesReault alloc] initWithUrl:url];
    [NetWorkClient requestURL:url withBody:nil method:HTTP_GET receiveHeader:[NSArray arrayWithObject:@"Link"] parser:^(NSObject *responseObj,NSDictionary *headers){
        if ([responseObj isKindOfClass:[NSArray class]]) {
            NSArray *responseArray = (NSArray*)responseObj;
            
            NSMutableArray *retArray = [NSMutableArray arrayWithCapacity:10];
            for (NSDictionary *obj in responseArray) {
                GoodsInfo *goodsInfo = [[GoodsInfo alloc] init];
                [goodsInfo Deserialize:obj];
                [retArray addObject:goodsInfo];
            }
            
            BOOL next = FALSE;
            NSString *link = [headers objectForKey:@"Link"];
            if (link && link.length > 0) {
                NSRange range = [link rangeOfString:@";rel=\"next\""];
                if (range.length > 0) {
                    next = TRUE;
                }
            }
            
            sucCallback(retArray,next);
        } else {
            NSError *err = [NSError errorWithMsg:[NSString stringWithUTF8String:ErrorDesc[DATA_FORMAT_NOT_MATCH-ERR_CODE_START]]];
            SAFE_BLOCK_CALL(failCallback, err);
            NSLog(@"Server Data Error:it must be dictionary");
        }
    } fail:^(NSError *err){
        SAFE_BLOCK_CALL(failCallback, err);
    }];
    
    return result;
}

+(NSArray*)getXWGGoodSorts:(NillBlock_Array)sucCallback fail:(NillBlock_Error)failCallback
{
    NSArray *retArray = [XWGGoodSort getAll];
    if (retArray) {
        return retArray;
    }
    
    NSString *url = [NSString stringWithFormat:XWG_GoodSort_URL];
    
    [NetWorkClient requestURL:url withBody:nil method:HTTP_GET user:[GlobalDataService userGKId] pwd:[GlobalDataService userPwd] token:[GlobalDataService token] needAuthorization:FALSE parser:^(NSObject *responseObj){
        if ([responseObj isKindOfClass:[NSArray class]]) {
            NSArray *array = (NSArray*)responseObj;
            NSMutableArray *sortList = [[NSMutableArray alloc] initWithCapacity:array.count];
            for (id obj in array) {
                XWGGoodSort *sort = [[XWGGoodSort alloc] init];
                [sort Deserialize:(NSDictionary*)obj];
                [sort save:@"id"];
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


+(id)getUserInfo:(NSString*)iD success:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failCallback
{
    id ret = nil;
     ret =  [UserInfo get:@"id" value:iD];
    if (ret) {
        return ret;
    }
    
    NSString *url = [NSString stringWithFormat:USER_INFO_URL,iD];
    [NetWorkClient requestURL:url withBody:nil method:HTTP_GET parser:^(NSObject *responseObj) {
        
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            
            UserInfo *idInfo = [[UserInfo alloc] init];
            [idInfo Deserialize:(NSDictionary*)responseObj];
            [idInfo save:@"id"];
            
            SAFE_BLOCK_CALL(sucCallback, idInfo);
        }else {
            NSLog(@"Server Data Error:it must be NSDictory");
            NSError *err = [NSError errorWithMsg:[NSString stringWithUTF8String:ErrorDesc[OTHER_ERROR-ERR_CODE_START]]];
            SAFE_BLOCK_CALL(failCallback, err);
        }
        
    } fail:^(NSError *err) {
        
        SAFE_BLOCK_CALL(failCallback, err);
    }];
    
    return ret;
}

+(void)loveGood:(NSString*)_goodId hadFocused:(BOOL)hadFocused  success:(NillBlock_Nill)sucCallback fail:(NillBlock_Error)failCallback
{
    
    NSString *url = [NSString stringWithFormat:XWG_LOVE_URL,_goodId];
    
    [NetWorkClient requestURL:url withBody:nil method:hadFocused?HTTP_DELETE:HTTP_POST user:[GlobalDataService userGKId] pwd:[GlobalDataService userPwd] token:[GlobalDataService token] needAuthorization:YES parser:^(NSObject *responseObj){
        
        XWGLove *love = [[XWGLove alloc] init];
        love.id = [GlobalDataService userGKId];
        love.xwgGoodId = _goodId;
        if (hadFocused) {
            [love deleteWtihConstraints:@"id",@"xwgGoodId",Nil];
        } else {
            [love saveWtihConstraints:@"id",@"xwgGoodId",Nil];
        }
        
        SAFE_BLOCK_CALL_VOID(sucCallback);
    } fail:^(NSError *err){
        if (err.code == 204) {
            XWGLove *love = [[XWGLove alloc] init];
            love.id = [GlobalDataService userGKId];
            love.xwgGoodId = _goodId;
            if (hadFocused) {
                [love deleteWtihConstraints:@"id",@"xwgGoodId",Nil];
            } else {
                [love saveWtihConstraints:@"id",@"xwgGoodId",Nil];
            }
            
            SAFE_BLOCK_CALL_VOID(sucCallback);
        } else {
            SAFE_BLOCK_CALL(failCallback, err);
        }
    }];
}

+(void)getLoveStatus:(NSString*)_goodId success:(NillBlock_BOOL)sucCallback fail:(NillBlock_Error)failCallback
{
    NSString *url = [NSString stringWithFormat:XWG_LOVE_URL,_goodId];
    
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

//+(NSString*)convertUrl2TBKUrl:(NSString*)itemId  succ:(NillBlock_OBJ)succBack fail:(NillBlock_Error)failBack
//{
//    NSString *value = nil;
//    
//    XWGGoodUrls *goodForUrl = [XWGGoodUrls get:@"item_id" value:itemId];
//    if (goodForUrl) {
//        value = goodForUrl.click_url;
//        return value;
//    }
//    
//    [[self shareInstance] setTbkFailBack:failBack];
//    [[self shareInstance] setTbkSuccBack:succBack];
//    [[self shareInstance] setItemId:itemId];
//    
//    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
//    
//    [params setObject:TBK_URL_CONVERT_API forKey:@"method"];
//    [params setObject:itemId forKey:@"num_iids"];
//    [params setObject:@"click_url" forKey:@"fields"];
//
//    
//    TopIOSClient *tbClient = [GlobalObject TBClient];
//    [tbClient api:@"GET" params:params target:[self shareInstance] cb:@selector(tbkUrlConvertResponse:) userId:nil needMainThreadCallBack:true];
//    return value;
//    
//}
//
//-(void)tbkUrlConvertResponse:(id)data
//{
//    if ([data isKindOfClass:[TopApiResponse class]])
//    {
//        TopApiResponse *response = (TopApiResponse *)data;
//
//        if (response.error) {
//            SAFE_BLOCK_CALL(self.tbkFailBack, response.error);
//            return;
//        }
//        
//        if (![response content]) {
//            NSError *err = [NSError errorWithMsg:[NSString stringWithUTF8String:ErrorDesc[OTHER_ERROR-ERR_CODE_START]]];
//            SAFE_BLOCK_CALL(self.tbkFailBack, err);
//            return;
//        }
//
//        NSError *err;
//        NSObject *responseObj = [NSJSONSerialization JSONObjectWithData:[[response content] dataUsingEncoding:NSUnicodeStringEncoding]  options:NSJSONReadingMutableContainers error:&err];
//
//        if (err) {
//            NSError *err = [NSError errorWithMsg:[NSString stringWithUTF8String:ErrorDesc[DATA_FORMAT_NOT_MATCH-ERR_CODE_START]]];
//            SAFE_BLOCK_CALL(self.tbkFailBack, err);
//            return;
//        }
//
//        if (![responseObj isKindOfClass:[NSDictionary class]]) {
//            NSError *err = [NSError errorWithMsg:[NSString stringWithUTF8String:ErrorDesc[DATA_FORMAT_NOT_MATCH-ERR_CODE_START]]];
//            SAFE_BLOCK_CALL(self.tbkFailBack, err);
//            return;
//        }
//
//        NSInteger count = [[(NSDictionary*)[(NSDictionary*)responseObj objectForKey:@"taobaoke_mobile_items_convert_response"] objectForKey:@"total_results"] intValue];
//        
//        if (count != 0) {
//            NSString *clickUrl =  [[(NSArray*)[(NSDictionary*)[(NSDictionary*)[(NSDictionary*)responseObj objectForKey:@"taobaoke_mobile_items_convert_response"] objectForKey:@"taobaoke_items"] objectForKey:@"taobaoke_item"] objectAtIndex:0] objectForKey:@"click_url"];
//            XWGGoodUrls *urlForGood = [[XWGGoodUrls alloc] init];
//            urlForGood.item_id = self.itemId;
//            urlForGood.click_url = clickUrl;
//            urlForGood.platform = @"TB";
//            [urlForGood save:@"item_id"];
//            self.tbkSuccBack(clickUrl);
//        } else {
//            self.tbkSuccBack(nil);
//        }
//    } else {
//        NSLog(@"TopApiResponse Format Error");
//    }
//
//}
@end


@implementation GoodsInfo
@end
@implementation XWGGoodUrls
-(NSTimeInterval)validatePeroid
{
    return XWG_GOOD_URL_CACHE_PEROID;
}
@end
@implementation UserInfo
-(PLSqliteDatabase*)database
{
    return [DataBaseClient shareDBFor:DB0Name];
}

-(NSTimeInterval)validatePeroid
{
    return USER_CACHE_VALIDATE_PEROID;
}
@end

@implementation XWGGoodSort
-(NSTimeInterval)validatePeroid
{
    return GoodSortCacheClearTimeInterval;
}
-(PLSqliteDatabase*)database
{
    return [DataBaseClient shareDBFor:DB0Name];
}
@end

