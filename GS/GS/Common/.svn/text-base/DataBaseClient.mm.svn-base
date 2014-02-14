//
//  DataBaseClient.m
//  NXTGateway
//
//  Created by feinno on 12-9-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DataBaseClient.h"
#import "AppConstans.h"


@implementation DataBaseClient

+(id<PLResultSet>)exeSQL:(NSString*)sqlStr
{
    NSLog(@"%@",sqlStr);

    
    id<PLResultSet> ret;
    
    PLSqliteDatabase* db = [DataBaseClient shareDataBase];
    
    if([sqlStr.uppercaseString hasPrefix:@"SELECT"]){
        ret = [db executeQuery:sqlStr];
    } else {
        [db executeUpdate:sqlStr];
    }
    
    return ret;
}

+(PLSqliteDatabase*)shareDataBase
{
    static PLSqliteDatabase *db = nil;
    
    if (db) {
        return db;
    }
    
    @synchronized(self){
        
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *dbPath = [documentPath stringByAppendingPathComponent:DBName]; 
        NSLog(@"%@",dbPath);
        
        if(![[NSFileManager defaultManager] fileExistsAtPath:dbPath]){
            NSString *sourcePath = [[NSBundle mainBundle] pathForResource:DBName ofType:@"sqlite"];
            NSError *error;
            if (![[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:dbPath error:&error]) {
                NSLog(@"%@",[error localizedDescription]);
            }
        }
        db = [[PLSqliteDatabase alloc] initWithPath:dbPath];
        [db open];

        return db;
    }
    
}

+(void)close
{
    if([DataBaseClient shareDataBase])
    {
        [[DataBaseClient shareDataBase] close];
    }
}

+(void)clearTable:(NSString*)tableName
{
    
}

+(void)clearDB
{
    @synchronized(self){
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *dbPath = [documentPath stringByAppendingPathComponent:DBName];
        NSLog(@"%@",dbPath);
        
        if([[NSFileManager defaultManager] fileExistsAtPath:dbPath]){
            NSString *sourcePath = [[NSBundle mainBundle] pathForResource:DBName ofType:@"sqlite"];
            if ([[NSFileManager defaultManager] fileExistsAtPath:sourcePath]) {
                NSError *err;
                [[NSFileManager defaultManager] removeItemAtPath:dbPath error:&err];
            }
        }
        
        return;
    }
}
@end
