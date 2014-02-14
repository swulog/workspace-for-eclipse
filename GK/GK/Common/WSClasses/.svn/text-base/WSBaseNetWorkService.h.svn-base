//
//  WSBaseNetWorkService.h
//  GK
//
//  Created by W.S. on 13-11-29.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "Singleton.h"

@interface WSBaseNetWorkService : Singleton
+(void)cancelRequest:(NSString*)url;
+(BOOL)checkNetPage:(NSDictionary*)headers;

@end

@interface WSNetServicesReault : NSObject
@property (nonatomic,assign) BOOL result;
@property (nonatomic,strong) NSString *url; /*request identify*/

-(id)initWithUrl:(NSString*)url;
@end