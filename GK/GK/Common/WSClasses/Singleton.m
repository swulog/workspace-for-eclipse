//
//  Singleton.m
//  XMSkinUpdateDemo
//
//  Created by feinno on 12-9-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Singleton.h"
#import <objc/runtime.h>

//#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
//static dispatch_once_t onceToken = 0; \
//__strong static id sharedInstance = nil; \
//dispatch_once(&onceToken, ^{ \
//    sharedInstance = block(); \
//    }); \


@implementation Singleton

+(id)shareInstance{

//    static dispatch_once_t onceToken = 0;
//    __strong static id sharedInstance = nil;
    static NSMutableDictionary *shareInstance = nil;
    NSString *className = [NSString stringWithUTF8String:class_getName([self class])];

    @synchronized(self){
        if (!shareInstance) {
            shareInstance = [NSMutableDictionary dictionaryWithCapacity:2];
        }
        
        if (!shareInstance[className]) {
            shareInstance[className] = [[super allocWithZone:NULL] init];
        }
    }
    
    return shareInstance[className];
}



//prevent to alloc
+(id) allocWithZone:(NSZone *)zone
{
    //return [super allocWithZone:zone];;
    return [self shareInstance];
}

//prevent to copy
- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)init {
//    static dispatch_once_t initToken = 0;
//    dispatch_once(&initToken,^{
//        //执行初始化函数
//    });
    return self;
}

@end

