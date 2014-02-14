//
//  NetWorkClient.m
//  NXTGateway
//
//  Created by feinno on 12-9-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NetWorkClient.h"
#import "GlobalObject.h"


static char* httpMethodStr[] ={"GET","POST","PUT","DELETE"};
static POST_DATA_ENCODE postDataFormat = POST_DATA_WITH_JSON;

@implementation NetWorkClient

+(BOOL)NetworkIsReachable
{
    BOOL isReachable = ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
    if (isReachable) return isReachable;

    isReachable = ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
    return isReachable;
}



+(void)cancelReqiest:(NSString*)_url
{
    NetWorkClient *clent = [self shareInstance];
    
    NSString *host = getHost(_url);
    if (!clent.engines || !clent.engines[host]) {
        return;
    }
    
    [MKNetworkEngine cancelOperationsContainingURLString:_url];
}

+(void)requestURL:(NSString *)_url withBody:(NSMutableDictionary *)_bodyData method:(HTTP_METHOD)_method extraHeader:(NSDictionary *)_extraHeaders data:(NSData*)_data user:(NSString*)_user pwd:(NSString*)_pwd token:(NSString*)_token needAuthorization:(BOOL)_isAuth postUserPwd:(BOOL)_postNamePwdWithHeader progress:(NillBlock_Double)progressHandler Success:(MKNKResponseBlock)response Fail:(MKNKErrorBlock)fail
{
    
#ifdef TEST_FOR_URL_WATCH
    NSLog(@"%@",_url);
#endif
    
    NetWorkClient *clent = [self shareInstance];
    MKNetworkEngine *engine = nil;
    
    NSString *host = getHost(_url);
    if (!host || host.length == 0) {
        return;
    } else {
        @synchronized(clent){
            if (!clent.engines) {
                clent.engines = [NSMutableDictionary dictionaryWithCapacity:2];
            }
            
            engine = clent.engines[host];
            
            if (!engine) {
                engine = [[MKNetworkEngine alloc] initWithHostName:host];
                [clent.engines setObject:engine forKey:host];
            }
        }
    }
    
    MKNetworkOperation *op = [engine operationWithPath:getPath(_url) params:_bodyData httpMethod:[NSString stringWithUTF8String:httpMethodStr[_method]]];
    [op addHeaders:[NSDictionary dictionaryWithObject:@"close" forKey:@"Connection"]];
    
    if (_isAuth) {
        if (_token) {
            [op setAuthorizationHeaderValue: _token forAuthType:@"token"];
        } else {
            [op setUsername:_user password:_pwd basicAuth:YES];
        }
    }
    
    //    if (_postNamePwdWithHeader) {
    //    }
    
    if (postDataFormat == POST_DATA_WITH_JSON && (_method == HTTP_POST || _method == HTTP_PUT)) {
        [op setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
    }
    
    if (_extraHeaders) {
        [op addHeaders:_extraHeaders];
    }
    
    if (progressHandler) {
        if (_method == HTTP_GET) {
            [op onDownloadProgressChanged:progressHandler];
        } else {
            [op onUploadProgressChanged:progressHandler];
        }
    }
    
    //   [op onCompletion:response onError:fail];
    [op addCompletionHandler:response errorHandler:^(MKNetworkOperation* completedOperation, NSError* error){
        NSString *errStr = completedOperation.responseString;
        if (errStr && errStr.length>0) {
            NSError *err;
            NSObject *dict = [NSJSONSerialization JSONObjectWithData:[errStr dataUsingEncoding:NSUnicodeStringEncoding]  options:NSJSONReadingMutableContainers error:&err];
            error = [NSError errorWithMsg:[dict valueForKey:@"message"] code:error.code];
            fail(error);
        } else {
            error = [NSError errorWithMsg:[NSString stringWithUTF8String:ErrorDesc[NET_SERVER_ERROR-ERR_CODE_START]] code:error.code];
            fail(error);
        }
        
    }];
    
    [engine enqueueOperation:op];
    
}

//+(void)requestURL:(NSString*)_url withBody:(NSMutableDictionary*)_bodyData method:(HTTP_METHOD)_method extraHeader:(NSDictionary*)_extraHeaders Success:(MKNKResponseBlock)response Fail:(MKNKErrorBlock)fail
//{
//#ifdef TEST_URL
//    NSLog(@"%@",_url);
//#endif
//
//    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:getHost(_url)];
//    MKNetworkOperation *op = [engine operationWithPath:getPath(_url) params:_bodyData httpMethod:(_method==HTTP_GET?@"GET":@"POST")];
//    [op addHeaders:[NSDictionary dictionaryWithObject:@"close" forKey:@"Connection"]];
//
//    if (postDataFormat == POST_DATA_WITH_JSON && _method == HTTP_POST) {
//        [op setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
//    }
//    if (_extraHeaders) {
//        [_extraHeaders enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//            if ([key isEqualToString:@"Authorization"]) {
//                [op setAuthorizationHeaderValue:@"Authorization" forAuthType:@""];
//            }
//        }];
//
//        [op addHeaders:_extraHeaders];
//    }
//
//    //[op onCompletion:response onError:fail];
//    [op addCompletionHandler:response errorHandler:^(MKNetworkOperation* completedOperation, NSError* error){
//        fail(error);
//    }];    [engine enqueueOperation:op];
//
//
//}

//+(void)requestURL:(NSString *)_url withBody:(NSMutableDictionary *)_bodyData method:(HTTP_METHOD)_method extraHeader:(NSDictionary *)_extraHeaders data:(NSData*)_data user:(NSString*)_user pwd:(NSString*)_pwd needAuthorization:(BOOL)_isAuth postUserPwd:(BOOL)_postNamePwdWithHeader Success:(MKNKResponseBlock)response Fail:(MKNKErrorBlock)fail
//{
//#ifdef TEST_URL
//    NSLog(@"%@",_url);
//#endif
//
//
//    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:getHost(_url)];
//    MKNetworkOperation *op = [engine operationWithPath:getPath(_url) params:_bodyData httpMethod:[NSString stringWithUTF8String:httpMethodStr[_method]]];
//
//    [op addHeaders:[NSDictionary dictionaryWithObject:@"close" forKey:@"Connection"]];
//    if (_isAuth) {
//        [op setUsername:_user password:_pwd basicAuth:YES];
//    }
//
//    if (_postNamePwdWithHeader) {
//    }
//
//    if (postDataFormat == POST_DATA_WITH_JSON && _method == HTTP_POST) {
//        [op setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
//    }
//
//    if (_extraHeaders) {
//        [op addHeaders:_extraHeaders];
//    }
//
////    if (_data) {
////        [op addData:_data forKey:@"avatar"]; //头像二进制流
////    }
//
//  //  [op onCompletion:response onError:fail];
//    [op addCompletionHandler:response errorHandler:^(MKNetworkOperation* completedOperation, NSError* error){
//        fail(error);
//    }];
//    [engine enqueueOperation:op];
//
//
//}

//+(void)requestURL:(NSString *)_url withBody:(NSMutableDictionary *)_bodyData method:(HTTP_METHOD)_method extraHeader:(NSDictionary *)_extraHeaders user:(NSString*)_user pwd:(NSString*)_pwd needAuthorization:(BOOL)_isAuth postUserPwd:(BOOL)_postNamePwdWithHeader Success:(MKNKResponseBlock)response Fail:(MKNKErrorBlock)fail
//{
//#ifdef TEST_URL
//    NSLog(@"%@",_url);
//#endif
//
//    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:getHost(_url)];
//    MKNetworkOperation *op = [engine operationWithPath:getPath(_url) params:_bodyData httpMethod:[NSString stringWithUTF8String:httpMethodStr[_method]]];
//
//    [op addHeaders:[NSDictionary dictionaryWithObject:@"close" forKey:@"Connection"]];
//    if (_isAuth) {
//        [op setUsername:_user password:_pwd basicAuth:YES];
//    }
//
//    if (_postNamePwdWithHeader) {
//    }
//
//    if (postDataFormat == POST_DATA_WITH_JSON && _method == HTTP_POST) {
//        [op setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
//    }
//
//    if (_extraHeaders) {
//        [op addHeaders:_extraHeaders];
//    }
//
//    //[op onCompletion:response onError:fail];
//    [op addCompletionHandler:response errorHandler:^(MKNetworkOperation* completedOperation, NSError* error){
//        fail(error);
//    }];
//    [engine enqueueOperation:op];
//
//}

//+(void)requestURL:(NSString *)_url withBody:(NSMutableDictionary*)_bodyData method:(HTTP_METHOD)_method  extraHeader:(NSDictionary*)_extraHeaders user:(NSString*)_user pwd:(NSString*)_pwd needAuthorization:(BOOL)_isAuth postUserPwd:(BOOL)_postNamePwdWithHeader parser:(Block_JsonParser)_customParser fail:(NillBlock_Error)failCallback
//{
//
//    [NetWorkClient requestURL:_url withBody:_bodyData method:_method extraHeader:_extraHeaders user:_user pwd:_pwd needAuthorization:_isAuth postUserPwd:_postNamePwdWithHeader Success:^(MKNetworkOperation *op){
//        NSString *jsonStr = op.responseString;
//        NSError *err;
//        NSObject *dict = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUnicodeStringEncoding]  options:NSJSONReadingMutableContainers error:&err];
//        _customParser(dict);
//
//    }Fail:^(NSError *error){
//        NSLog(@"NetWork Fail ===========>");
//        failCallback(error);
//    }];
//}





///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
+(void)requestURL:(NSString *)_url withBody:(NSMutableDictionary*)_bodyData method:(HTTP_METHOD)_method  receiveHeader:(NSArray*)keys parser:(Block_JsonParser_Body_Header)_customParser fail:(NillBlock_Error)failCallback
{
    [NetWorkClient requestURL:_url withBody:_bodyData method:_method extraHeader:nil data:nil user:nil pwd:nil token:nil needAuthorization:FALSE postUserPwd:FALSE progress:nil Success:^(MKNetworkOperation *op){
        
        NSString *jsonStr = op.responseString;
        NSError *err;
        NSObject *dict = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUnicodeStringEncoding]  options:NSJSONReadingMutableContainers error:&err];
        
        NSMutableDictionary *headers = nil;
        if (keys && keys.count > 0 ) {
            headers = [NSMutableDictionary  dictionaryWithCapacity:keys.count];
            for (NSString *key in keys) {
                if ([op.readonlyResponse.allHeaderFields objectForKey:key]) {
                    [headers setObject:[op.readonlyResponse.allHeaderFields objectForKey:key] forKey:key];
                }
                
            }
        }
        
        _customParser(dict,headers);
        
    }Fail:^(NSError *error){
        failCallback(error);
    }];
}


+(void)requestURL:(NSString *)_url withBody:(NSMutableDictionary*)_bodyData method:(HTTP_METHOD)_method  parser:(Block_JsonParser)_customParser fail:(NillBlock_Error)failCallback
{
    [NetWorkClient requestURL:_url withBody:_bodyData method:_method extraHeader:nil data:nil user:nil pwd:nil token:nil needAuthorization:FALSE postUserPwd:FALSE progress:nil Success:^(MKNetworkOperation *op){
        
        NSString *jsonStr = op.responseString;
        NSError *err;
//        NSObject *dict = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUnicodeStringEncoding]  options:NSJSONReadingMutableContainers error:&err];
        NSObject *dict = nil;
        
        if (jsonStr) {
            dict = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUnicodeStringEncoding]  options:NSJSONReadingMutableContainers error:&err];
        }
        _customParser(dict);
        
        
    }Fail:^(NSError *error){
        //   NSError *err = [NSError errorWithMsg:[NSString stringWithUTF8String:ErrorDesc[NET_SERVER_ERROR - ERR_CODE_START]]];
        failCallback(error);
    }];
}

+(void)requestURL:(NSString *)_url withBody:(NSMutableDictionary*)_bodyData method:(HTTP_METHOD)_method  extraHeader:(NSDictionary*)_extraHeaders parser:(Block_JsonParser)_customParser fail:(NillBlock_Error)failCallback
{
    [NetWorkClient requestURL:_url withBody:_bodyData method:_method extraHeader:_extraHeaders data:nil user:nil pwd:nil token:nil needAuthorization:FALSE postUserPwd:FALSE progress:nil  Success:^(MKNetworkOperation *op){
        NSString *jsonStr = op.responseString;
        NSError *err;
        NSObject *dict = nil;
        
        if (jsonStr) {
            dict = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUnicodeStringEncoding]  options:NSJSONReadingMutableContainers error:&err];
        }
        _customParser(dict);
        
    }Fail:^(NSError *error){
        //        NSError *err = [NSError errorWithMsg:[NSString stringWithUTF8String:ErrorDesc[NET_SERVER_ERROR - ERR_CODE_START]]];
        failCallback(error);
    }];
}

+(void)requestURL:(NSString *)_url withBody:(NSMutableDictionary*)_bodyData method:(HTTP_METHOD)_method user:(NSString*)_user pwd:(NSString*)_pwd token:(NSString*)_token needAuthorization:(BOOL)_isAuth  parser:(Block_JsonParser)_customParser fail:(NillBlock_Error)failCallback
{
    [NetWorkClient requestURL:_url withBody:_bodyData method:_method extraHeader:nil data:nil user:_user pwd:_pwd token:_token needAuthorization:_isAuth  postUserPwd:FALSE progress:nil Success:^(MKNetworkOperation *op){
        NSString *jsonStr = op.responseString;
        NSError *err;
        
        if (op.HTTPStatusCode == 204) {
            _customParser(nil);
        } else {
            NSObject *dict = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUnicodeStringEncoding]  options:NSJSONReadingMutableContainers error:&err];
            _customParser(dict);
        }
        
    }Fail:^(NSError *error){
        //    NSError *err = WSErrorWithCode(WS_NetError);
        failCallback(error);
    }];
}

+(void)requestURL:(NSString *)_url withBody:(NSMutableDictionary*)_bodyData method:(HTTP_METHOD)_method user:(NSString*)_user pwd:(NSString*)_pwd token:(NSString*)_token needAuthorization:(BOOL)_isAuth receiveHeader:(NSArray*)keys parser:(Block_JsonParser_Body_Header)_customParser  fail:(NillBlock_Error)failCallback
{
    [NetWorkClient requestURL:_url withBody:_bodyData method:_method extraHeader:nil data:nil user:_user pwd:_pwd token:_token needAuthorization:_isAuth  postUserPwd:FALSE progress:nil Success:^(MKNetworkOperation *op){
        NSString *jsonStr = op.responseString;
        NSError *err;
        
        if (op.HTTPStatusCode == 204) {
            _customParser(nil,FALSE);
        } else {
            NSObject *dict = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUnicodeStringEncoding]  options:NSJSONReadingMutableContainers error:&err];
            //   _customParser(dict);
            
            
            NSMutableDictionary *headers = nil;
            if (keys && keys.count > 0 ) {
                headers = [NSMutableDictionary  dictionaryWithCapacity:keys.count];
                for (NSString *key in keys) {
                    if ([op.readonlyResponse.allHeaderFields objectForKey:key]) {
                        [headers setObject:[op.readonlyResponse.allHeaderFields objectForKey:key] forKey:key];
                    }
                }
            }
            _customParser(dict,headers);
        }
        
    }Fail:^(NSError *error){
        failCallback(error);
    }];
}

+(void)uploadToUrl:(NSString *)_url withBody:(NSMutableDictionary*)_bodyData withToken:(NSString*)_token processHandler:(NillBlock_Double)progressHandler parser:(Block_JsonParser)_customParser fail:(NillBlock_Error)failCallback
{
    [self requestURL:_url withBody:_bodyData method:HTTP_POST extraHeader:nil data:nil user:nil pwd:nil token:_token needAuthorization:YES postUserPwd:FALSE progress:progressHandler Success:^(MKNetworkOperation *completedOperation) {
        NSString *jsonStr = completedOperation.responseString;
        NSError *err;
        NSObject *dict = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUnicodeStringEncoding]  options:NSJSONReadingMutableContainers error:&err];
        _customParser(dict);
        
    }Fail:^(NSError *error){
        failCallback(error);
    }];
}
@end


