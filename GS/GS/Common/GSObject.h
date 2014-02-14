//
//  GSObject.h
//  GS
//
//  Created by W.S. on 13-7-2.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "WSObject.h"

@interface GSObject : WSObject
-(void)save2DB:(NSString *)keyName;
-(void)save2DBWtihConstraints:(NSString *)keyName,...;
@end
