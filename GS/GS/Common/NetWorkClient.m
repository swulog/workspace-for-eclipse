//
//  NetWorkClient.m
//  NXTGateway
//
//  Created by feinno on 12-9-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NetWorkClient.h"
#import "AppHeader.h"

static char* httpMethodStr[] ={"GET","POST","PUT","DELETE"};

static POST_DATA_ENCODE postDataFormat = POST_DATA_WITH_JSON;

@implementation NetWorkClient


+(void)requestURL:(NSString *)_url withBody:(NSMutableDictionary*)_bodyData method:(HTTP_METHOD)_method  extraHeader:(NSDictionary*)_extraHeaders data:(NSData*)_data user:(NSString*)_user pwd:(NSString*)_pwd token:(NSString*)_token needAuthorization:(BOOL)_isAuth postUserPwd:(BOOL)_postNamePwdWithHeader parser:(Block_JsonParser)_customParser fail:(NillBlock_Error)failCallback
{
    
    [NetWorkClient requestURL:_url withBody:_bodyData method:_method extraHeader:_extraHeaders data:_data user:_user pwd:_pwd token:_token  needAuthorization:_isAuth postUserPwd:_postNamePwdWithHeader Success:^(MKNetworkOperation *op){
        NSString *jsonStr = op.responseString;
        NSError *err;
        NSObject *dict = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUnicodeStringEncoding]  options:NSJSONReadingMutableContainers error:&err];
        _customParser(dict);
        
    }Fail:^(NSError *error){
        failCallback(error);
    }];
}

+(void)requestURL:(NSString *)_url withBody:(NSMutableDictionary*)_bodyData method:(HTTP_METHOD)_method user:(NSString*)_user pwd:(NSString*)_pwd token:(NSString*)_token needAuthorization:(BOOL)_isAuth  parser:(Block_JsonParser)_customParser fail:(NillBlock_Error)failCallback
{
    [NetWorkClient requestURL:_url withBody:_bodyData method:_method extraHeader:nil data:nil user:_user pwd:_pwd token:_token needAuthorization:_isAuth  postUserPwd:FALSE Success:^(MKNetworkOperation *op){
        NSString *jsonStr = op.responseString;
        NSError *err;
        
        if (op.HTTPStatusCode == 204) {
            _customParser(nil);
        } else {
            NSObject *dict = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUnicodeStringEncoding]  options:NSJSONReadingMutableContainers error:&err];
            _customParser(dict);
        }
        

        
    }Fail:^(NSError *error){
        failCallback(error);
    }];
}

+(void)requestURL:(NSString *)_url withBody:(NSMutableDictionary*)_bodyData method:(HTTP_METHOD)_method  parser:(Block_JsonParser)_customParser fail:(NillBlock_Error)failCallback
{
    [NetWorkClient requestURL:_url withBody:_bodyData method:_method extraHeader:nil data:nil user:nil pwd:nil token:nil  needAuthorization:FALSE  postUserPwd:FALSE Success:^(MKNetworkOperation *op){
        NSString *jsonStr = op.responseString;
        NSError *err;
        NSObject *dict = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUnicodeStringEncoding]  options:NSJSONReadingMutableContainers error:&err];
        
        _customParser(dict);
        
    }Fail:^(NSError *error){
        failCallback(error);
    }];
}
#if 0

+(void)requestURL:(NSString *)_url withBody:(NSMutableDictionary *)_bodyData method:(HTTP_METHOD)_method extraHeader:(NSDictionary *)_extraHeaders data:(NSData*)_data user:(NSString*)_user pwd:(NSString*)_pwd token:(NSString*)_token needAuthorization:(BOOL)_isAuth postUserPwd:(BOOL)_postNamePwdWithHeader Success:(MKNKResponseBlock)response Fail:(MKNKErrorBlock)fail
{

#ifdef TEST_FOR_URL_WATCH
    NSLog(@"%@",_url);
#endif
    
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:getHost(_url)];
    MKNetworkOperation *op = [engine operationWithPath:getPath(_url) params:_bodyData httpMethod:[NSString stringWithUTF8String:httpMethodStr[_method]]];
    
    [op addHeaders:[NSDictionary dictionaryWithObject:@"close" forKey:@"Connection"]];
    if (_isAuth) {
        if (_token) {
            [op setAuthorizationHeaderValue: _token forAuthType:@"token"];
        } else {
            [op setUsername:_user password:_pwd basicAuth:YES];
        }
    }
    
    if (_postNamePwdWithHeader) {
    }
    
    if (postDataFormat == POST_DATA_WITH_JSON && (_method == HTTP_POST || _method == HTTP_PUT)) {
        [op setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
    }
    
    if (_extraHeaders) {
        [op addHeaders:_extraHeaders];
    }
    
    [op onCompletion:response onError:fail];
    [engine enqueueOperation:op];

}
#else




+(void)requestURL:(NSString *)_url withBody:(NSMutableDictionary *)_bodyData method:(HTTP_METHOD)_method extraHeader:(NSDictionary *)_extraHeaders data:(NSData*)_data user:(NSString*)_user pwd:(NSString*)_pwd token:(NSString*)_token needAuthorization:(BOOL)_isAuth postUserPwd:(BOOL)_postNamePwdWithHeader Success:(MKNKResponseBlock)response Fail:(MKNKErrorBlock)fail
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
    
    if (postDataFormat == POST_DATA_WITH_JSON && (_method == HTTP_POST || _method == HTTP_PUT)) {
        [op setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
    }
    
    if (_extraHeaders) {
        [op addHeaders:_extraHeaders];
    }
    
    //   [op onCompletion:response onError:fail];
    [op addCompletionHandler:response errorHandler:^(MKNetworkOperation* completedOperation, NSError* error){
        NSString *errStr = completedOperation.responseString;
        if (errStr && errStr.length>0) {
            NSError *err;
            NSObject *dict = [NSJSONSerialization JSONObjectWithData:[errStr dataUsingEncoding:NSUnicodeStringEncoding]  options:NSJSONReadingMutableContainers error:&err];
            error = [NSError errorWithMsg:[dict valueForKey:@"message"] code:error.code];
            NSLog(@"NetWorkClient : Error ------> %@",error.localizedDescription);
            fail(error);
        } else  {
            error = WSErrorWithCode(WS_NetError);
            NSLog(@"NetWorkClient : Error ------> %@",error.localizedDescription);
            fail(error);
        }
    }];
    
    [engine enqueueOperation:op];
    
}

+(void)requestURL:(NSString *)_url withBody:(NSMutableDictionary *)_bodyData method:(HTTP_METHOD)_method  user:(NSString*)_user pwd:(NSString*)_pwd token:(NSString*)_token customerBodyHandler:(MKNKEncodingBlock)strBodyHandler processHandler:(MKNKProgressBlock)progressHandler Success:(MKNKResponseBlock)response Fail:(MKNKErrorBlock)fail
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
    
    if (IsSafeString(_token)) {
        [op setAuthorizationHeaderValue: _token forAuthType:@"token"];
    } else  if(IsSafeString(_user) && IsSafeString(_pwd)){
        [op setUsername:_user password:_pwd basicAuth:YES];
    }
    
    if (postDataFormat == POST_DATA_WITH_JSON && (_method == HTTP_POST || _method == HTTP_PUT)) {
        [op setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
    }
    
    if (strBodyHandler) {
        [op setCustomPostDataEncodingHandler:strBodyHandler forType:@"text/html"];
    }
    
    if (progressHandler) {
        if (_method == HTTP_GET) {
            [op onDownloadProgressChanged:progressHandler];
        } else {
            [op onUploadProgressChanged:progressHandler];
        }
    }
    
    [op addCompletionHandler:response errorHandler:^(MKNetworkOperation* completedOperation, NSError* error){
        NSString *errStr = completedOperation.responseString;
        if (errStr && errStr.length>0) {
            NSError *err;
            NSObject *dict = [NSJSONSerialization JSONObjectWithData:[errStr dataUsingEncoding:NSUnicodeStringEncoding]  options:NSJSONReadingMutableContainers error:&err];
            error = [NSError errorWithMsg:[dict valueForKey:@"message"] code:error.code];
            NSLog(@"NetWorkClient : Error ------> %@",error.localizedDescription);
            fail(error);
        } else  {
            error = WSErrorWithCode(WS_NetError);
            NSLog(@"NetWorkClient : Error ------> %@",error.localizedDescription);
            fail(error);
        }
    }];
    
    [engine enqueueOperation:op];
    
}

+(void)uploadToUrl:(NSString *)_url withBody:(NSMutableDictionary*)_bodyData customerBodyHandler:(StrBlock_Dict)strBodyHandler processHandler:(NillBlock_Double)progressHandler withToken:(NSString*)_token   parser:(Block_JsonParser)_customParser fail:(NillBlock_Error)failCallback
{
    [self requestURL:_url withBody:_bodyData method:HTTP_POST  user:nil pwd:nil token:_token  customerBodyHandler:strBodyHandler processHandler:progressHandler Success:^(MKNetworkOperation *op) {
        NSString *jsonStr = op.responseString;
        NSError *err;
        NSObject *dict = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUnicodeStringEncoding]  options:NSJSONReadingMutableContainers error:&err];
        
        _customParser(dict);
        
    }Fail:^(NSError *error){
        failCallback(error);
    }  ];
}
#endif

    
@end


