//
//  GlobalDataService.h
//  GK
//
//  Created by W.S. on 13-11-5.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "Singleton.h"
#import "GKLogonService.h"


/**********************************
    处理 全局、须与服务器进行同步的数据
**********************************/

#define kSyncDataService_XWGLove @"XWGLoveList"
@protocol WSSDODataSource;

@interface GlobalDataService : Singleton

@property (nonatomic,strong) GKIDInfo *gUserInfo;
@property (nonatomic,strong) NSString *gToken;
@property (nonatomic,assign) BOOL isOffLine;

//@property (nonatomic,strong) NSMutableArray *gCouponLoveList;
//@property (nonatomic,strong) NSMutableArray *gXWGLoveList;

+(void)startUpDataService;
+(void)resetDataService;

/*************** user info ***************/

+(BOOL)isLogoned;
+(NSString*)userPwd;
+(NSString*)userGKId;
+(NSString*)userGKUId;
+(NSString*)userName;
+(NSString*)token;
+(WeiBo_Type)webForLogon;

+(void)logonGK:(NSString*)iD
           pwd:(NSString*)pWd
       success:(NillBlock_Nill)sucCallback
          fail:(NillBlock_Error)failCallback;

+(void)logonGKWith3rdAccount:(NSString*)usid
                    platform:(NSString*)_plat
                        name:(NSString*)_name
                     headUrl:(NSString*)_headIconUrl
                     success:(NillBlock_OBJ)sucCallback
                        fail:(NillBlock_Error)failCallback;

/*************** coupon love list ***************/

//+(void)couponLoveList:(NSInteger)pageIndex
//              pagenum:(NSInteger)pageNum
//                 succ:(NillBlock_OBJ_BOOL)succBack
//                 fail:(NillBlock_Error)failBack;

//+(NSMutableArray*)couponLoveList:(NillBlock_OBJ)succBack
//                            fail:(NillBlock_Error)failBack;

+(void)GetMyCouponLoveList:(BOOL)refreshEnabled
                     index:(NSInteger)pIndex
                   pagenum:(NSInteger)pNum
                      succ:(NillBlock_OBJ_BOOL)succBack
                      fail:(NillBlock_Error)failBack;




/*************** xwg good love list ***************/


+(void)GetMyXWGLoveList:(BOOL)refreshEnabled
                  index:(NSInteger)pIndex
                pagenum:(NSInteger)pNum
                   succ:(NillBlock_OBJ_BOOL)succBack
                   fail:(NillBlock_Error)failBack;

+(void)getXWGLoveStatus:(NSString*)goodId
                        succ:(NillBlock_BOOL)succBack
                        fail:(NillBlock_Error)failBack;



/*************** Store Sort List ***************/

+(void)GetStoreSort:(BOOL)refresh
               succ:(NillBlock_Array)succBack
               fail:(NillBlock_Error)failBack;

@end



typedef NS_ENUM(NSInteger, SyncDataStatus)
{
    SDUS_UnInited,
    SDUS_Geting,
    SDUS_Done,
    SDUS_Fail
};

@protocol WSSDODelegate <NSObject>
-(void)syncAppendOK:(NSObject*)object;
-(void)syncOK:(NSObject*)object;
-(void)syncFail:(NSError*)error;

@end


@interface WSSyncDataObject : NSObject<WSSDODelegate>
@property (nonatomic,strong) NSString *identifier;
@property (nonatomic,assign) id<WSSDODataSource> dataSource;
@property (nonatomic,assign) SyncDataStatus status;

@property (nonatomic,strong) NSObject *syncObj;
@property (nonatomic,copy) NillBlock_Nill getBlock;
@property (nonatomic,assign) BOOL refresh;
@property (nonatomic,strong) NSArray *params;

-(id)initWithClassName:(NSString*)className;
-(id)initWithClass:(Class)class;
-(id)initWithObject:(NSObject*)object;

-(void)addSyncHandler:(NillBlock_OBJ)succHandler fail:(NillBlock_Error)failHandler;
-(void)startSync:(BOOL)refreshEnabled;
//-(void)startRefresh;

@end


@protocol  WSSDODataSource <NSObject>
@optional
-(void)SDOSource:(WSSyncDataObject*)sdo;
-(void)SDOSuccBack:(WSSyncDataObject*)sdo;
@end


