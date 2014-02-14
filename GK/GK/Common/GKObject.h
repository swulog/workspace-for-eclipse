//
//  GKObject.h
//  GK
//
//  Created by W.S. on 13-7-5.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "WSDBObject.h"
#import "DataBaseClient.h"




@interface GKObject : WSDBObject

@property (nonatomic,strong) NSString *createDate;

//-(BOOL)validate:(NSTimeInterval)interval;
//-(void)setValidatePeroid:(NSTimeInterval)peroid;

//+(id)get:(NSString *)keyName value:(NSString *)value;
//+(id)getList:(NSString *)keyName value:(NSString *)value;
+(id)getList:(NSString *)keyName value:(NSString *)value deleteOnceinvalid:(BOOL)deleted;
//+(NSArray*)getAll;

-(void)saveWtihConstraints:(NSString *)keyName,...;
-(void)deleteWtihConstraints:(NSString *)keyName,...;
@end


