//
//  GlobalObject.h
//  NXTGateway
//
//  Created by feinno on 12-9-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import "Appheader.h"
#import "GKLogonService.h"
#import "GKAppDelegate.h"
#import "WS_GlobalObjectWithServices.h"
#import "GKOwnerService.h"
#import "GKStoreSortListService.h"
#import "GKXWGService.h"
#import "GlobalDataService.h"

enum{
    GO_INIT_STATUS_NOMAL,
    GO_INIT_STATUS_GETLOC,
    GO_INIT_STATUS_GETCITY,
    GO_STATUS_GETCOUPONLOVELIST,
    GO_STATUS_GETXWGLOVELIST
}GlobalObject_InitStatus;


NS_ENUM(NSInteger, ListIdentify){
    LI_OwnerCouponList,
    LI_OwnerXWGItemList
};


extern NSString* const kListIdentifier[];

@interface GlobalObject : WS_GlobalObjectWithServices

+(void)ExeSelectorOnBgTask:(dispatch_block_t)block;
+(void)initAPP;

@property (nonatomic,strong) NSString *cityId;
@property (nonatomic,strong) NSString *cityName;



@property (nonatomic,strong) BMKAddrInfo *curAddr;
-(void)setCityId:(NSString *)cityId name:(NSString*)cityName;


//+(BMKAddrInfo*)getCurPos;

+(NSString*)getCityIdForExtraUser:(NillBlock_OBJ)succBack fail:(NillBlock_Error)failBack;
+(BMKAddrInfo*)getCurLocForExtraUser:(BOOL)forcedRefreh succ:(NillBlock_OBJ)succBack fail:(NillBlock_Error)failBack;

//+(void)logonGK:(NSString*)iD pwd:(NSString*)pWd success:(NillBlock_Nill)sucCallback fail:(NillBlock_Error)failCallback;

+(void)pushOwnPositionInsideMap:(CLLocation*)curPos in:(UIViewController*)pVc title:(NSString*)_title;

+(void)setHiddenStoreIcon:(BOOL)hIdden;
+(BOOL)getHiddenStoreIconConfig;


#pragma mark - app statistics info
@property (nonatomic,strong) WSPlistManager *statisticsPlistManager;


+(NSMutableArray*)totalCustStoreSorts;
+(NSMutableArray*)locateStoreSorts;
+(void)setLocStoreSorts:(NSArray*)sorts;

+(NSDate*)dateForListRefresh:(NSString*)listIdentifier;
+(void)dateToListRefresh:(NSString*)listIdentifier date:(NSDate*)date;


+(void)SNSSyncClose:(NSString*)snsName;
+(void)SNSSyncOpen:(NSString*)snsName;
+(BOOL)SNSSyncClosed:(NSString*)snsName;
@end


@interface CustomStoreSort : WSDBObject
@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) NSString *Name;
@property (nonatomic,strong) NSString *PID;
@property (nonatomic,strong) NSString *Icon;
@end



