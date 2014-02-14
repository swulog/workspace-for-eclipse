//
//  DataBaseClient.h
//  NXTGateway
//
//  Created by feinno on 12-9-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <plausibleDatabase/PlausibleDatabase.h>
#import "Singleton.h"

typedef enum {
    SQL_SELECT,
    SQL_UPDATE
}SQL_TYPE;

@interface DataBaseClient : Singleton
{
}
//+(id<PLResultSet>)exeSQL:(NSString*)sqlStr;
+(PLSqliteDatabase*)shareDBFor:(NSString*)name;
+(void)clearDB:(NSString*)name;
@end
