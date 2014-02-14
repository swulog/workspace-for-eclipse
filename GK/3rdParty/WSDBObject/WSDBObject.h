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

@protocol WSDBObjectDataSource <NSObject>

@optional
-(PLSqliteDatabase*)database;
-(NSTimeInterval)validatePeroid;
@end


@interface WSDBObject : NSObject<WSDBObjectDataSource>
{
    PLSqliteDatabase *myDb;
    NSTimeInterval validePeroid;
}

-(void)setDB:(PLSqliteDatabase*)db;
-(id)initWithDB:(PLSqliteDatabase*)db;
-(NSDictionary *)dictory;

-(void)Deserialize:(NSDictionary*)_dict;
-(void)Deserialize:(NSDictionary*)_dict coustom:(WS_Block_Dealize_Parser)_custParser;
-(void)DeserializeFromDBResult:(id<PLResultSet>)reslut;

-(void)saveWtihConstraints:(NSArray*)keyNames;
-(void)save:(NSString*)keyName ;

+(id)get:(NSString*)keyName value:(NSString*)value;
+(NSArray*)getList:(NSString*)keyName value:(NSString*)value;
+(NSArray*)getAll;

-(void)delete:(NSString*)keyName;
-(void)deleteWtihConstraints:(NSArray*)keyNames;
+(void)removeAll;

@end


