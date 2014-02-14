//
//  GSObject.m
//  GS
//
//  Created by W.S. on 13-7-2.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GSObject.h"
#import "AppConstans.h"
#import "DataBaseClient.h"

@implementation GSObject
-(id)init
{
    self = [super init];
    if (self) {
//        dbName = DBName;
    }
    
    return self;
}
-(void)save2DB:(NSString *)keyName
{
    [super save:keyName toDB:[DataBaseClient shareDataBase]];
}

-(void)save2DBWtihConstraints:(NSString *)keyName,...
{
    va_list   argp;   /*   定义保存函数参数的结构   */
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:2];
    
    NSString *key;

    va_start(argp,keyName);
    while((key = va_arg(argp, NSString*))) {
            [array addObject:key];
    }
    va_end(   argp   );

    [super saveWtihConstraints:array toDB:[DataBaseClient shareDataBase]];
}
@end
