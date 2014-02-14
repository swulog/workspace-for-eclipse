//
//  DataBaseClient.h
//  NXTGateway
//
//  Created by feinno on 12-9-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <plausibleDatabase/PlausibleDatabase.h>

typedef enum {
    SQL_SELECT,
    SQL_UPDATE
}SQL_TYPE;

@interface DataBaseClient : NSObject
+(id<PLResultSet>)exeSQL:(NSString*)sqlStr;
+(PLSqliteDatabase*)shareDataBase;
+(void)clearDB;
@end
