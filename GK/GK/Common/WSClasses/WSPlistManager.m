//
//  WSPlistManager.m
//  GK
//
//  Created by W.S. on 13-7-18.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "WSPlistManager.h"

static NSMutableDictionary *plistManagers;

@implementation WSPlistManager

+(WSPlistManager*)createForPlistFile:(NSString*)plistFile
{
    WSPlistManager *retManager = nil;
    @synchronized(plistManagers){
        if (!plistManagers) plistManagers = [NSMutableDictionary dictionaryWithCapacity:1];
        retManager = plistManagers[plistFile];
        if (retManager) {
            return retManager;
        }
    }
    
    retManager  = [[WSPlistManager alloc] init];
    
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *rootPath = [array objectAtIndex:0];
    NSString *filePath = [rootPath stringByAppendingString: [NSString stringWithFormat:@"/%@.plist",plistFile]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:filePath])
    {
        NSString *orgFile = [[NSBundle mainBundle] pathForResource:plistFile ofType:@"plist"];
        if([fileManager fileExistsAtPath:orgFile])
            [retManager setDict:[[NSMutableDictionary alloc] initWithContentsOfFile:orgFile]];
        else
            retManager = nil;
    } else {
        [retManager setDict:[[NSMutableDictionary alloc] initWithContentsOfFile:filePath]];
    }
    
    if (retManager) {
        [retManager setDestFilePath:filePath];
        @synchronized(plistManagers){
            [plistManagers setValue:retManager forKey:plistFile];
        }
        [[NSNotificationCenter defaultCenter] addObserver:retManager selector:@selector(save) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:retManager selector:@selector(save) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:retManager selector:@selector(save) name:UIApplicationWillTerminateNotification object:nil];
    }
    return retManager;
}

-(void)setValue:(id)value forKey:(NSString *)key
{
    [plistDict setObject:value forKey:key];
    updated = TRUE;
}

-(id)valueForKey:(NSString *)key
{
    return [plistDict objectForKey:key];
}


-(void)empty
{
    if (plistDict) {
        [plistDict removeAllObjects];
        updated = TRUE;
    }
}

-(void)setDict:(NSMutableDictionary*)_dict
{
    plistDict = _dict;
}

-(void)setDestFilePath:(NSString*)path
{
    plistPath = path;
}

-(void)save
{
    if (updated) {
        updated = FALSE;
        [plistDict writeToFile:plistPath atomically:YES];
    }
}

@end
