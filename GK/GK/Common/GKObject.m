//
//  GKObject.m
//  GK
//
//  Created by W.S. on 13-7-5.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GKObject.h"
#import "GlobalObject.h"

#define NOT_FOUND -1

@implementation GKObject

-(id)init
{
    self = [super init];
    
    if (self) {
        validePeroid =  CACHE_CLEAR_INTERVAL;
        myDb = [DataBaseClient shareDBFor:DB1Name];
        
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        self.createDate = [formatter stringFromDate:date];
    }
    
    return self;
}

+(id)get:(NSString *)keyName value:(NSString *)value
{
    id ret =[super get:keyName value:value];
    
    if (ret) {
        if ([ret validatePeroid] > 0) {
            if (![ret validate:[ret validatePeroid]]) {
                [ret delete:keyName];
                ret = nil;
            }
        }
    }
    
    return ret;
}

+(id)getList:(NSString *)keyName value:(NSString *)value deleteOnceinvalid:(BOOL)deleted
{
    NSMutableArray *returnArray  = nil;
    
    NSArray *array  =[super getList:keyName value:value];
    if (IsSafeArray(array)) {
        returnArray = [NSMutableArray arrayWithCapacity:5];
        
        for (int k = 0; k < array.count; k++) {
            id ret = [array objectAtIndex:k];
            
            if ([ret validatePeroid] > 0) {
                if (![ret validate:[ret validatePeroid]]) {
                    [ret delete:keyName];
                    if (deleted) {
                        returnArray = nil;
                        break;
                    }
                } else {
                    [returnArray addObject:ret];
                }
            }
        }
    }
    
    return returnArray;
}

+(id)getList:(NSString *)keyName value:(NSString *)value
{
    return [self getList:keyName value:value deleteOnceinvalid:FALSE];
}

+(NSArray*)getAll
{
    NSArray *returnArray = [super getAll];
    if (returnArray && returnArray.count > 0) {
        for (int k = 0; k < returnArray.count; k++) {
            id tSelf = [returnArray objectAtIndex:k];
            
            if ([tSelf validatePeroid] > 0) {
                if (![tSelf validate:[tSelf validatePeroid]]) {
                    [self removeAll];
                    returnArray = nil;
                    break;
                }
            }
        }
    } else {
        returnArray = nil;
    }
    
    return returnArray;
}

-(void)saveWtihConstraints:(NSString *)keyName,...
{
    va_list   argp;   /*   定义保存函数参数的结构   */
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:2];
    
    NSString *key;
    
    va_start(argp,keyName);
    [array addObject:keyName];
    while((key = va_arg(argp, NSString*))) {
        [array addObject:key];
    }
    va_end(   argp   );
    
    [super saveWtihConstraints:array];
}


-(void)deleteWtihConstraints:(NSString *)keyName,...
{
    va_list   argp;   /*   定义保存函数参数的结构   */
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:2];
    
    NSString *key;
    
    va_start(argp,keyName);
    while((key = va_arg(argp, NSString*))) {
        [array addObject:key];
    }
    va_end(   argp   );
    
    [super deleteWtihConstraints:array];

}

-(PLSqliteDatabase*)database
{
    return [DataBaseClient shareDBFor:DB1Name];
}

-(NSTimeInterval)validatePeroid
{
    return validePeroid;
}

-(BOOL)validate:(NSTimeInterval)interval
{
    NSDate *crDate = dateFromString(self.createDate);
    NSDate *lastDate = [crDate dateByAddingTimeInterval:interval];
    
    if ([(NSDate*)[NSDate date] compare:lastDate] >= NSOrderedSame) {
        return FALSE;
    }
    
    return TRUE;
}
@end
