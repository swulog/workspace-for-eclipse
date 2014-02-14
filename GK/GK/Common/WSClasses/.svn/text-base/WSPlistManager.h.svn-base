//
//  WSPlistManager.h
//  GK
//
//  Created by W.S. on 13-7-18.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WSPlitManagerDelegate;

@interface WSPlistManager : NSObject
{
    NSString *plistPath;
    NSMutableDictionary *plistDict;
    BOOL updated;
}

+(WSPlistManager*)createForPlistFile:(NSString*)plistFile;

-(void)setValue:(id)value forKey:(NSString *)key ;
-(id)valueForKey:(NSString *)key;
-(void)empty;
@end


