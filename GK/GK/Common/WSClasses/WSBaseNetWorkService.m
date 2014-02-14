//
//  WSBaseNetWorkService.m
//  GK
//
//  Created by W.S. on 13-11-29.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "WSBaseNetWorkService.h"
#import "NetWorkClient.h"

@implementation WSBaseNetWorkService

+(void)cancelRequest:(NSString*)url
{
    [NetWorkClient cancelReqiest:url];
}

+(BOOL)checkNetPage:(NSDictionary*)headers
{
    NSString *link = [headers objectForKey:@"Link"];
    BOOL next = FALSE;
    if (link && link.length > 0) {
        NSRange range = [link rangeOfString:@";rel=\"next\""];
        if (range.length > 0) {
            next = TRUE;
        }
    }
    return next;
}
@end

@implementation WSNetServicesReault
-(id)initWithUrl:(NSString*)url
{
    self = [super init] ;
    if (self) {
        self.url = url;
        self.result = FALSE;
    }
    return self;
}
@end