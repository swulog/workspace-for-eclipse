//
//  NSError+Helper.m
//  AirMenu
//
//  Created by yangxh yang on 11-8-18.
//  Copyright 2011年 codans. All rights reserved.
//

#import "NSError+Description.h"
#import "Constants.h"
@implementation NSError (Description)

+ (NSError *)errorWithMsg:(NSString *)msg
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:msg?:@"发生错误!", NSLocalizedDescriptionKey, nil];
    return [NSError errorWithDomain:GK_ERROR_DOMAIN code:-1000 userInfo:userInfo];
}

+ (NSError *)errorWithMsg:(NSString *)msg code:(NSInteger)_code
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:msg?:@"发生错误!", NSLocalizedDescriptionKey, nil];
    return [NSError errorWithDomain:GK_ERROR_DOMAIN code:_code userInfo:userInfo];
}

+(NSError *)errorWithCode:(NSInteger)_code
{
    return [NSError errorWithMsg:[NSString stringWithUTF8String:ErrorDesc[_code]] code:_code];
}
@end
