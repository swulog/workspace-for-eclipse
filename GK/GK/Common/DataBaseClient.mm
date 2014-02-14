//
//  DataBaseClient.m
//  NXTGateway
//
//  Created by feinno on 12-9-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DataBaseClient.h"

#import "Config.h"

static NSMutableDictionary *dbs;

@implementation DataBaseClient



+(PLSqliteDatabase*)shareDBFor:(NSString*)name
{
    @synchronized(dbs){
    
    if (!dbs) {
        dbs = [NSMutableDictionary dictionary];
    }
    
    if (dbs[name]) {
        return dbs[name];
    }
    
    
        
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *dbPath = [documentPath stringByAppendingPathComponent:name];
        
        if(![[NSFileManager defaultManager] fileExistsAtPath:dbPath]){
            NSString *sourcePath = [[NSBundle mainBundle] pathForResource:name ofType:@"sqlite"];
            NSError *error;
            if (![[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:dbPath error:&error]) {
                NSLog(@"%@",[error localizedDescription]);
            }
        }
        PLSqliteDatabase *db = [[PLSqliteDatabase alloc] initWithPath:dbPath];
        [db open];
        dbs[name] = db;
        return db;
    }
    
}

//+(void)closeDB:(NSString*)name
//{
//    if([DataBaseClient shareDBFor:DB1Name])
//    {
//        [[DataBaseClient shareDBFor:DB1Name] close];
//    }
//}


//+(id<PLResultSet>)exeSQL:(NSString*)sqlStr
//{
//    NSLog(@"%@",sqlStr);
//    
//    
//    id<PLResultSet> ret;
//    
//    PLSqliteDatabase* db = [DataBaseClient shareDBFor:DB1Name];
//    
//    if([sqlStr.uppercaseString hasPrefix:@"SELECT"]){
//        ret = [db executeQuery:sqlStr];
//    } else {
//        [db executeUpdate:sqlStr];
//    }
//    
//    return ret;
//}

+(void)clearDB:(NSString*)name
{
    @synchronized(self){
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *dbPath = [documentPath stringByAppendingPathComponent:name];
        
        if([[NSFileManager defaultManager] fileExistsAtPath:dbPath]){
            NSString *sourcePath = [[NSBundle mainBundle] pathForResource:name ofType:@"sqlite"];
            if ([[NSFileManager defaultManager] fileExistsAtPath:sourcePath]) {
                NSError *err;
                [[NSFileManager defaultManager] removeItemAtPath:dbPath error:&err];
                [dbs removeObjectForKey:name];
            }
        }
        
        return;
    }
}
@end
