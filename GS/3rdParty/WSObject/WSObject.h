//
//  BossEObject.h
//  BossE_V1
//
//  Created by 万松 on 12-10-8.
//
//

#import <Foundation/Foundation.h>
#import <plausibleDatabase/PlausibleDatabase.h>



typedef NSArray* (^WS_Block_Dealize_Parser)(NSArray *array);




@interface WSObject : NSObject
{
 //   NSString *dbName;
    PLSqliteDatabase *myDb;
}

-(void)setDB:(PLSqliteDatabase*)db;
-(id)initWithDB:(PLSqliteDatabase*)db;
-(NSDictionary *)dictory;
-(void)Deserialize:(NSDictionary*)_dict;
-(void)Deserialize:(NSDictionary*)_dict coustom:(WS_Block_Dealize_Parser)_custParser;
-(void)DeserializeFromDBResult:(id<PLResultSet>)reslut;

-(void)save:(NSString*)keyName toDB:(PLSqliteDatabase*)_db;
-(void)saveWtihConstraints:(NSArray*)keyNames toDB:(PLSqliteDatabase*)_db;
-(void)save:(NSString*)keyName ;


+(id)get:(NSString*)keyName value:(NSString*)value fromDB:(PLSqliteDatabase*)_db;
//+(id)get:(NSString*)keyName value:(NSString*)value;
+(NSArray*)getList:(NSString*)keyName value:(NSString*)value fromDB:(PLSqliteDatabase*)_db;

-(void)delete:(NSString*)keyName fromDB:(PLSqliteDatabase*)_db;

@end


