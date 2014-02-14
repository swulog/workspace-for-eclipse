//
//  NetWorkClient.h
//  NXTGateway
//
//  Created by feinno on 12-9-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "Singleton.h"
#import "MKNetworkKit.h"

typedef enum{
    
    HTTP_GET,
    HTTP_POST,
    HTTP_PUT,
    HTTP_DELETE
}HTTP_METHOD;


typedef enum{
    POST_DATA_WITH_JSON
}POST_DATA_ENCODE;



@interface NetWorkClient : Singleton
{
//    NSMutableArray *engines;
//    NSMutableString *hosts;
}

@property (nonatomic,strong) NSMutableDictionary *engines;
+(BOOL)NetworkIsReachable;
//+(void)requestURL:(NSString *)_url withBody:(NSMutableDictionary*)_bodyData method:(HTTP_METHOD)_method  extraHeader:(NSDictionary*)_extraHeaders data:(NSData*)_data user:(NSString*)_user pwd:(NSString*)_pwd needAuthorization:(BOOL)_isAuth postUserPwd:(BOOL)_postNamePwdWithHeader parser:(Block_JsonParser)_customParser fail:(NillBlock_Error)failCallback;

//+(void)requestURL:(NSString *)_url withBody:(NSMutableDictionary*)_bodyData method:(HTTP_METHOD)_method  extraHeader:(NSDictionary*)_extraHeaders user:(NSString*)_user pwd:(NSString*)_pwd needAuthorization:(BOOL)_isAuth postUserPwd:(BOOL)_postNamePwdWithHeader parser:(Block_JsonParser)_customParser fail:(NillBlock_Error)failCallback;
+(void)requestURL:(NSString *)_url withBody:(NSMutableDictionary*)_bodyData method:(HTTP_METHOD)_method  receiveHeader:(NSArray*)keys parser:(Block_JsonParser_Body_Header)_customParser fail:(NillBlock_Error)failCallback;

+(void)requestURL:(NSString *)_url withBody:(NSMutableDictionary*)_bodyData method:(HTTP_METHOD)_method  parser:(Block_JsonParser)_customParser fail:(NillBlock_Error)failCallback;

+(void)requestURL:(NSString *)_url withBody:(NSMutableDictionary*)_bodyData method:(HTTP_METHOD)_method  extraHeader:(NSDictionary*)_extraHeaders parser:(Block_JsonParser)_customParser fail:(NillBlock_Error)failCallback;

+(void)requestURL:(NSString *)_url withBody:(NSMutableDictionary*)_bodyData method:(HTTP_METHOD)_method user:(NSString*)_user pwd:(NSString*)_pwd token:(NSString*)_token needAuthorization:(BOOL)_isAuth  parser:(Block_JsonParser)_customParser fail:(NillBlock_Error)failCallback;

+(void)requestURL:(NSString *)_url withBody:(NSMutableDictionary*)_bodyData method:(HTTP_METHOD)_method user:(NSString*)_user pwd:(NSString*)_pwd token:(NSString*)_token needAuthorization:(BOOL)_isAuth receiveHeader:(NSArray*)keys parser:(Block_JsonParser_Body_Header)_customParser  fail:(NillBlock_Error)failCallback;
+(void)uploadToUrl:(NSString *)_url withBody:(NSMutableDictionary*)_bodyData withToken:(NSString*)_token processHandler:(NillBlock_Double)progressHandler parser:(Block_JsonParser)_customParser fail:(NillBlock_Error)failCallback;

+(void)cancelReqiest:(NSString*)_url;
@end
