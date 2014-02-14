//
//  GlobalDataService.m
//  GK
//
//  Created by W.S. on 13-11-5.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GlobalDataService.h"
#import "GKOwnerService.h"
#import "GKStoreSortListService.h"
#import "GKXWGService.h"
#import "GlobalObject.h"

//typedef void (^WS_NillBlock_CLLocation)(CLLocation *location) ;
//typedef void (^WS_NillBlock_Error)(NSError *error) ;
//typedef void (^WS_NillBlock_NSString)(NSString *string) ;

typedef enum {
    Status_Idele,
    Status_GetXWGLoveList,
    Status_GetCouponLoveList,
    Status_GetStoreFocusList
} OwnerProcessStatus;

#define kCouponLoveList @"CouponLoveList"
#define kXWGLoveList    @"XWGLoveList"

#define kStoreSortList @"StoreSortList"
//#define kStoreCommentList @"StoreCommentList"

@interface GlobalDataService()<WSSDODataSource>
{
    
}

@property (nonatomic,assign) NSInteger      processStatus;

//@property (nonatomic,strong) NSMutableArray *ownCouponLoveListHandlers;
//@property (nonatomic,assign) BOOL hadInitedCouponLoveList;
//
//@property (nonatomic,strong) NSMutableArray *ownXWGLoveListHandlers;
//@property (nonatomic,assign) BOOL hadInitedXWGLoveList;

@property (nonatomic,strong) NSMutableArray *ownStoreFocusListHandlers;
@property (nonatomic,assign) BOOL hadInitedStoreFocusedList;

@property (nonatomic,strong) NSMutableDictionary *syncObjs;


@end

@implementation GlobalDataService

#pragma mark -
#pragma mark interface for user -

+(void)startUpDataService
{
    GlobalDataService   *tSelf = SC(GlobalDataService);
    
    tSelf.processStatus = Status_Idele;

//    tSelf.gCouponLoveList = [NSMutableArray array];
//    tSelf.ownCouponLoveListHandlers = [NSMutableArray array];
    tSelf.syncObjs = [NSMutableDictionary dictionary];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:tSelf selector:@selector(updateCouponLoveList:) name:NOTIFICATION_COUPON_LOVED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:tSelf selector:@selector(updateCouponLoveList:) name:NOTIFICATION_COUPON_UNLOVED object:nil];
    
//    tSelf.gXWGLoveList = [NSMutableArray array];
//    tSelf.ownXWGLoveListHandlers = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:tSelf selector:@selector(updateXWGLoveList:) name:NOTIFICATION_GOOD_LOVED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:tSelf selector:@selector(updateXWGLoveList:) name:NOTIFICATION_GOOD_UNLOVED object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:tSelf selector:@selector(focused:) name:Notification_StoreFocus object:Nil];
    [[NSNotificationCenter defaultCenter] addObserver:tSelf selector:@selector(focused:) name:Notification_StoreUnFocus object:Nil];
    
    [GlobalObject ExeSelectorOnBgTask:^{
        [self GetStoreSort:FALSE succ:nil fail:nil];
    }];
    
    [tSelf logonSync];
    
    //背景线程获取loveList
    //等待实现

}


+(void)resetDataService
{
    GlobalDataService   *tSelf = SC(GlobalDataService);

    tSelf.processStatus = Status_Idele;
    
//    [tSelf.ownCouponLoveListHandlers removeAllObjects];
//    [tSelf.gCouponLoveList removeAllObjects];
//    tSelf.hadInitedCouponLoveList = FALSE;
//    
//    [tSelf.ownXWGLoveListHandlers removeAllObjects];
//    [tSelf.gXWGLoveList removeAllObjects];
//    tSelf.hadInitedXWGLoveList = FALSE;
    
    [tSelf.syncObjs removeAllObjects];
    
    tSelf.gToken = nil;
    tSelf.gUserInfo = nil;
}

//+(void)couponLoveList:(NSInteger)pageIndex pagenum:(NSInteger)pageNum succ:(NillBlock_OBJ_BOOL)succBack fail:(NillBlock_Error)failBack
//{
//    GlobalDataService *go = SC(GlobalDataService);
//    
//    NillBlock_Array nextHandler = ^(NSArray *array){
//            BOOL next = FALSE;
//            
//            int size = array.count - (pageIndex-1) * pageNum;
//            if (size > 0) {
//                if (pageNum < size) {
//                    next = TRUE;
//                    size = pageNum;
//                }
//            } else {
//                size = 0;
//            }
//            
//            NSRange range = {(pageIndex-1) * pageNum ,  size};
//            NSMutableArray *retArray = [NSMutableArray arrayWithArray:[array subarrayWithRange:range]];
//            succBack(retArray,next);
//        };
//
//    BOOL isWaitting = [go isGettingCouponLoveList];
//    if (!isWaitting && go.hadInitedCouponLoveList) {
//        SAFE_BLOCK_CALL(nextHandler, go.gCouponLoveList);
//    } else {
//        NillBlock_OBJ_BOOL handler = ^(NSObject *obj,BOOL result){
//            if (!result) {
//                SAFE_BLOCK_CALL(failBack, (NSError*)obj);
//            } else {
//                SAFE_BLOCK_CALL(nextHandler, go.gCouponLoveList);
//            }
//        };
//        
//        [go.ownCouponLoveListHandlers addObject:[handler copy]];
//        if (!isWaitting) {
//            [go getOwnCouponLoveList];
//        }
//        return;
//    }
//}

//+(NSMutableArray*)couponLoveList:(NillBlock_OBJ)succBack fail:(NillBlock_Error)failBack
//{
//    GlobalDataService *go = SC(GlobalDataService);
//    BOOL isWaitting = [go isGettingCouponLoveList];
//    
//    if (!isWaitting && go.hadInitedCouponLoveList) {
//        return go.gCouponLoveList;
//    } else {
//        NillBlock_OBJ_BOOL handler = ^(NSObject *obj,BOOL result){
//            if (result) {
//                SAFE_BLOCK_CALL(succBack, obj);
//            } else{
//                SAFE_BLOCK_CALL(failBack, (NSError*)obj);
//            }
//        };
//        
//        [go.ownCouponLoveListHandlers addObject:[handler copy] ];
//        if (!isWaitting) {
//            [go getOwnCouponLoveList];
//        }
//        return nil;
//    }
//}


+(void)GetMyCouponLoveList:(BOOL)refreshEnabled
                     index:(NSInteger)pIndex
                   pagenum:(NSInteger)pNum
                      succ:(NillBlock_OBJ_BOOL)succBack
                      fail:(NillBlock_Error)failBack
{
    GlobalDataService   *tSelf = SC(GlobalDataService);
    
    [tSelf SyncWith:kCouponLoveList params:[NSArray arrayWithObjects:[NSNumber numberWithInt:pIndex],[NSNumber numberWithInt:pNum], nil]
            refresh:refreshEnabled
               succ:^(NSObject *obj){
                   WSSyncDataObject *couponObj = (WSSyncDataObject*)obj;
                   NSArray *array =  [tSelf getNextListFrom:(NSArray *)couponObj.syncObj index:pIndex num:pNum];
                   BOOL next = [tSelf nextListAvailabled:(NSArray *)couponObj.syncObj index:pIndex num:pNum];
                   if (succBack) succBack(array,next);
               }
               fail:failBack];
}

+(void)GetMyXWGLoveList:(BOOL)refreshEnabled
                     index:(NSInteger)pIndex
                   pagenum:(NSInteger)pNum
                      succ:(NillBlock_OBJ_BOOL)succBack
                      fail:(NillBlock_Error)failBack
{
    GlobalDataService   *tSelf = SC(GlobalDataService);
    
    [tSelf SyncWith:kXWGLoveList params:[NSArray arrayWithObjects:[NSNumber numberWithInt:pIndex],[NSNumber numberWithInt:pNum], nil]
            refresh:refreshEnabled
               succ:^(NSObject *obj){
                   WSSyncDataObject *couponObj = (WSSyncDataObject*)obj;
                   NSArray *array =  [tSelf getNextListFrom:(NSArray *)couponObj.syncObj index:pIndex num:pNum];
                   BOOL next = [tSelf nextListAvailabled:(NSArray *)couponObj.syncObj index:pIndex num:pNum];
                   if (succBack) succBack(array,next);
               }
               fail:failBack];
}





//
//+(void)XWGLoveList:(NSInteger)pageIndex pagenum:(NSInteger)pageNum succ:(NillBlock_OBJ_BOOL)succBack fail:(NillBlock_Error)failBack
//{
//    GlobalDataService *go = SC(GlobalDataService);
//    
//    NillBlock_Array nextHandler = ^(NSArray *array){
//        BOOL next = FALSE;
//        int size = array.count - (pageIndex-1) * pageNum;
//        if (size > 0) {
//            if (pageNum < size) {
//                next = TRUE;
//                size = pageNum;
//            }
//        } else {
//            size = 0;
//        }
//        
//        NSRange range = {(pageIndex-1) * pageNum ,  size};
//        NSMutableArray *retArray = [NSMutableArray arrayWithArray:[array subarrayWithRange:range]];
//        succBack(retArray,next);
//    };
//    
//    BOOL isWaitting = [go isGettingXWGLoveList];
//    if (!isWaitting && go.hadInitedXWGLoveList) {
//        SAFE_BLOCK_CALL(nextHandler, go.gXWGLoveList);
//    } else {
//        NillBlock_OBJ_BOOL handler = ^(NSObject *obj,BOOL result){
//            if (!result) {
//                SAFE_BLOCK_CALL(failBack, (NSError*)obj);
//            } else {
//                SAFE_BLOCK_CALL(nextHandler, go.gXWGLoveList);
//            }
//        };
//
//        [go.ownXWGLoveListHandlers addObject:[handler copy]];
//        if (!isWaitting) {
//            [go getOwnXWGLoveList];
//        }
//        return;
//    }
//}

//+(NSMutableArray*)XWGLoveList:(NillBlock_OBJ)succBack fail:(NillBlock_Error)failBack
//{
//    GlobalDataService *go = SC(GlobalDataService);
//    BOOL isWaitting = [go isGettingXWGLoveList];
//
//    if (!isWaitting && go.hadInitedXWGLoveList) {
//        return go.gXWGLoveList;
//    } else {
//        NillBlock_OBJ_BOOL handler = ^(NSObject *obj,BOOL result){
//            if (result) {
//                SAFE_BLOCK_CALL(succBack, obj);
//            } else{
//                SAFE_BLOCK_CALL(failBack, (NSError*)obj);
//            }
//        };
//
//        [go.ownXWGLoveListHandlers addObject:[handler copy]];
//        if (!isWaitting) {
//            [go getOwnXWGLoveList];
//        }
//        return nil;
//    }
//}

+(void)getXWGLoveStatus:(NSString*)goodId succ:(NillBlock_BOOL)succBack fail:(NillBlock_Error)failBack
{
    GlobalDataService *tSelf = GO(GlobalDataService);
    WSSyncDataObject *sdo = tSelf.syncObjs[kXWGLoveList];
    
    __block BOOL retValue = FALSE;

    NillBlock_OBJ findStatusBlock = ^(NSObject *obj){
        NSArray *array = (NSArray*)obj;
        if (IsSafeArray(array)) {
            for (GoodsInfo *good in array) {
                if ([good.id isEqualToString:goodId]) {
                    retValue = TRUE;
                    break;
                }
            }
        }
        if (succBack)  succBack(retValue);
    };
    
    if (sdo.status == SDUS_Done) {
        findStatusBlock(sdo.syncObj);
    } else {
        [self GetMyXWGLoveList:FALSE index:StartPageNo pagenum:LIST_PAGE_LimitLess_MUM succ:^(NSObject *obj, BOOL result) {
            findStatusBlock(obj);
        } fail:^(NSError *err) {
            findStatusBlock(nil);
        }];
    }
}

+(void)GetStoreSort:(BOOL)refresh
               succ:(NillBlock_Array)succBack
               fail:(NillBlock_Error)failBack
{
    GlobalDataService   *tSelf = SC(GlobalDataService);
    
    [tSelf SyncWith:kStoreSortList params:nil
            refresh:refresh
               succ:^(NSObject *obj){
                   WSSyncDataObject *sdo = (WSSyncDataObject*)obj;
                   if (succBack) succBack((NSArray*)sdo.syncObj);
               }
               fail:failBack];
}

//+(void)GetComments:(BOOL)refresh
//             store:(NSString*)storeId
//             index:(NSInteger)pIndex
//           pagenum:(NSInteger)pNum
//              succ:(NillBlock_OBBB)succBack
//              fail:(NillBlock_Error)failBack
//{
//    GlobalDataService   *tSelf = SC(GlobalDataService);
//    
//    [tSelf SyncWith:[NSString stringWithFormat:@"%@_%@",kStoreCommentList,storeId] params:[NSArray arrayWithObject:storeId]
//            refresh:refresh
//               succ:^(NSObject *obj){
//                   WSSyncDataObject *sdo = (WSSyncDataObject*)obj;
//                   //if (succBack) succBack((NSArray*)sdo.syncObj);
//               }
//               fail:failBack];
//
//}
/********************************************************/
/*******       Logon Info         ***********************/
/********************************************************/
#pragma mark -  Logon Info Services
#pragma mark -


+(BOOL)isLogoned
{
    return GO(GlobalDataService).gUserInfo?TRUE:FALSE;
}

+(WeiBo_Type)webForLogon
{
    return GO(GlobalDataService).gUserInfo.weiboType;
}

+(NSString*)token
{
    return SC(GlobalDataService).gToken;
}

+(NSString*)userName
{
    GKIDInfo *logonInfo = SC(GlobalDataService).gUserInfo;
    return logonInfo.name;
}
+(NSString*)userGKId
{
    GKIDInfo *logonInfo = SC(GlobalDataService).gUserInfo;
    return logonInfo.gkId;
}

+(NSString*)userPwd
{
    GKIDInfo *logonInfo = SC(GlobalDataService).gUserInfo;
    return logonInfo.gkpwd;
}

+(NSString*)userGKUId
{
    GKIDInfo *logonInfo = SC(GlobalDataService).gUserInfo;
    return logonInfo.id;
}

+(void)logonGK:(NSString*)iD pwd:(NSString*)pWd success:(NillBlock_Nill)sucCallback fail:(NillBlock_Error)failCallback
{
    [GKLogonService logonGK:iD pwd:pWd success:^(NSObject *obj){
        SC(GlobalDataService).gUserInfo = (GKIDInfo*)obj;
        [SC(GlobalDataService) checkWebtype];
        
        [[NSUserDefaults standardUserDefaults] setValue:iD forKeyPath:@"LastUser"];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGON_OK object:nil];
        
        [GKLogonService getToken:iD pwd:pWd succ:^(NSObject* obj){
            SC(GlobalDataService).gToken = (NSString*)obj;
            SC(GlobalDataService).isOffLine = FALSE;
        }fail:nil];
        
        SAFE_BLOCK_CALL_VOID(sucCallback);
    }fail:^(NSError *err){
        SAFE_BLOCK_CALL(failCallback, err);
    }];
}

+(void)logonGKWith3rdAccount:(NSString*)usid platform:(NSString*)_plat name:(NSString*)_name headUrl:(NSString*)_headIconUrl  success:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failCallback
{
    [GKLogonService logonGKWith3rdAccount:usid platform:_plat name:_name headUrl:_headIconUrl success:^(NSObject *obj) {
        SC(GlobalDataService).gUserInfo = (GKIDInfo*)obj;
        [SC(GlobalDataService) checkWebtype];
        SC(GlobalDataService).isOffLine = FALSE;

        SAFE_BLOCK_CALL(sucCallback, SC(GlobalDataService).gUserInfo);
        
        [[NSUserDefaults standardUserDefaults] setValue:SC(GlobalDataService).gUserInfo.gkId forKeyPath:@"LastUser"];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGON_OK object:nil];
    } fail:^(NSError *err) {
        SAFE_BLOCK_CALL(failCallback, err);
    }];
}

#pragma mark -
#pragma mark inside function -
-(void)checkWebtype
{
    if ([self.gUserInfo.gkId hasPrefix:SINA_TAG]) {
        self.gUserInfo.weiboType = WeiBo_Sina;
    } else if([self.gUserInfo.gkId hasPrefix:QQHOME_TAG]) {
        self.gUserInfo.weiboType = WeiBo_QQHome;
    } else if([self.gUserInfo.gkId hasPrefix:QQ_TAG]) {
        self.gUserInfo.weiboType = WeiBo_QQWB;
    } else if ([self.gUserInfo.gkId hasPrefix:RR_TAG]) {
        self.gUserInfo.weiboType = WeiBo_RR;

    }
}


//-(BOOL)isGettingCouponLoveList
//{
//    return self.processStatus & ( 1 << Status_GetCouponLoveList);
//}
//
//-(BOOL)isGettingXWGLoveList
//{
//    return self.processStatus & ( 1 << Status_GetXWGLoveList);
//}

-(BOOL)isGettingStoreFocusList
{
    return self.processStatus & ( 1 << Status_GetStoreFocusList);
}

//-(void)getOwnCouponLoveList
//{
//    WS_NillBlock_Error failBlock = ^(NSError* error){
//        self.processStatus &= ~(1 << Status_GetCouponLoveList);
//        
//        for (NillBlock_OBJ_BOOL block in self.ownCouponLoveListHandlers) {
//            block(error,FALSE);
//        }
//        [self.ownCouponLoveListHandlers removeAllObjects];
//    };
//    
//    NillBlock_OBJ sucBack = ^(NSObject *obj){
//        self.processStatus &= ~(1 << Status_GetCouponLoveList);
//        self.hadInitedCouponLoveList = TRUE;
//        
//        NSArray *array = (NSArray*)obj;
//        if (IsSafeArray(array)) {
//            [self.gCouponLoveList addObjectsFromArray:array];
////            self.gCouponLoveList = [NSMutableArray arrayWithArray:array];
//        }
//        for (NillBlock_OBJ_BOOL block in self.ownCouponLoveListHandlers) {
//            block(self.self.gCouponLoveList,TRUE);
//        }
//        [self.ownCouponLoveListHandlers removeAllObjects];
//        
//        [self checkFavouriteNum];
//    };
//    
//    self.processStatus |= (1 << Status_GetCouponLoveList);
//    
//    NSArray *array =  [GKOwnerService getCouponLoveList:1 num:9999 refresh:FALSE success:^(NSObject *obj, BOOL result) {
//        SAFE_BLOCK_CALL(sucBack,obj);
//    } fail:^(NSError *err) {
//        SAFE_BLOCK_CALL(failBlock, err);
//    }];
//    
//    if (array) {
//        SAFE_BLOCK_CALL(sucBack,array);
//    }
//}



//-(void)getOwnXWGLoveList
//{
//    WS_NillBlock_Error failBlock = ^(NSError* error){
//        self.processStatus &= ~(1 << Status_GetXWGLoveList);
//        for (NillBlock_OBJ_BOOL block in self.ownXWGLoveListHandlers) {
//            block(error,FALSE);
//        }
//        [self.ownXWGLoveListHandlers removeAllObjects];
//    };
//    
//    NillBlock_OBJ sucBack = ^(NSObject *obj){
//        self.processStatus &= ~(1 << Status_GetXWGLoveList);
//        self.hadInitedXWGLoveList = TRUE;
//        
//        NSArray *array = (NSArray*)obj;
//        if (IsSafeArray(array)) {
//            [self.gXWGLoveList addObjectsFromArray:array];
//        }
//        for (NillBlock_OBJ_BOOL block in self.ownXWGLoveListHandlers) {
//            block(self.self.gXWGLoveList,TRUE);
//        }
//        [self.ownXWGLoveListHandlers removeAllObjects];
//        
//        [self checkFavouriteNum];
//    };
//    
//    self.processStatus |= (1 << Status_GetXWGLoveList);
//    NSArray *array = [GKOwnerService getXWGGoodsLoveList:1 num:9999 success:^(NSObject *obj, BOOL result) {
//        SAFE_BLOCK_CALL(sucBack,obj);
//    } fail:^(NSError *err) {
//        SAFE_BLOCK_CALL(failBlock, err);
//    }];
//    
//    if (array) {
//        SAFE_BLOCK_CALL(sucBack,array);
//    }
//}

-(NSArray*)getNextListFrom:(NSArray*)oList index:(NSInteger)cpIndex num:(NSInteger)pNum
{
    
    if (!IsSafeArray(oList))  return Nil;
    
    int size = oList.count - (cpIndex - 1) * pNum; //剩余数目
    if (pNum < size) size = pNum;
    
    NSMutableArray *retArray = nil;
    if (size > 0) {
        NSRange range = {(cpIndex - 1) * pNum ,  size};
        retArray = [NSMutableArray arrayWithArray:[oList subarrayWithRange:range]];
    }
    return retArray;
}

-(BOOL)nextListAvailabled:(NSArray*)oList index:(NSInteger)cpIndex num:(NSInteger)pNum
{
    if (!IsSafeArray(oList))  return FALSE;
    
    int size = oList.count - cpIndex * pNum; //剩余数目
    return size > 0 ? TRUE : FALSE;
}

//-(void)checkFavouriteNum
//{
//    if (self.hadInitedCouponLoveList && self.hadInitedXWGLoveList) {
//        BOOL update = FALSE;
//        if (self.gUserInfo.coupon_bookmark_count != self.gCouponLoveList.count) {
//            self.gUserInfo.coupon_bookmark_count = self.gCouponLoveList.count;
//            update = TRUE;
//        }
//        if (self.gUserInfo.share_bookmark_count != self.gXWGLoveList.count) {
//            self.gUserInfo.share_bookmark_count = self.gXWGLoveList.count;
//            update = TRUE;
//        }
//        
//        if (update) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UserInfoUpdated object:Nil];
//        }
//    }
//}

#pragma mark -
#pragma mark network data adapter -
-(void)logonSync
{
    NSString *gkId = [[NSUserDefaults standardUserDefaults] stringForKey:@"LastUser"];

    if (IsSafeString(gkId)) {
        self.gUserInfo =  [GKIDInfo get:@"gkId" value:gkId];
        if (self.gUserInfo) {
            [GKLogonService LogonSync:self.gUserInfo.gkId pwd:self.gUserInfo.gkpwd succ:^(NSObject *obj) {

                [GKLogonService getToken:self.gUserInfo.gkId pwd:self.gUserInfo.gkpwd succ:^(NSObject* obj){
                    self.gToken = (NSString*)obj;
                }fail:nil];
                
                if (obj) {
                    self.gUserInfo = (GKIDInfo*)obj;
                    [self checkWebtype];
                } else {
                    self.isOffLine = TRUE;
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGON_OK object:nil];

            } fail:^(NSError *err) {
                self.gUserInfo = nil;
            }];
            
//            if (self.gUserInfo) {
//                [GKLogonService getToken:self.gUserInfo.gkId pwd:self.gUserInfo.gkpwd succ:^(NSObject* obj){
//                    self.gToken = (NSString*)obj;
//                }fail:nil];
//            }
        }
    }
}


#pragma mark -
#pragma mark notification handler -

-(void)updateCouponLoveList:(NSNotification*)notification
{
    Coupon *coupon = notification.object;

    BOOL loved = [notification.name isEqualToString:NOTIFICATION_COUPON_LOVED];
    
    WSSyncDataObject *sdo = self.syncObjs[kCouponLoveList];
    NSMutableArray *array = (NSMutableArray*)sdo.syncObj;
    if (!array) {
        array = [NSMutableArray array];
        self.syncObjs[kCouponLoveList] = array;
    }

    
    if (!loved) {
        for (Coupon *tcoupon  in array) {
            if ([tcoupon.id isEqualToString:coupon.id]) {
                [array removeObject:tcoupon];
                break;
            }
        }
        self.gUserInfo.coupon_bookmark_count--;
    } else {
        [array addObject:coupon];
      //  [self.gCouponLoveList addObject:coupon];
        self.gUserInfo.coupon_bookmark_count++;
    }
}

-(void)updateXWGLoveList:(NSNotification*)notification
{
     GoodsInfo *sGood = notification.object;
    
    BOOL loved = [notification.name isEqualToString:NOTIFICATION_GOOD_LOVED];
    
    WSSyncDataObject *sdo = self.syncObjs[kXWGLoveList];
    NSMutableArray *array = (NSMutableArray*)sdo.syncObj;
    if (!array) {
        array = [NSMutableArray array];
        self.syncObjs[kXWGLoveList] = array;
    }

    if (!loved) {
        for (GoodsInfo *dGood  in array) {
            if ([dGood.id isEqualToString:sGood.id]) {
                [array removeObject:dGood];
                break;
            }
        }
        self.gUserInfo.share_bookmark_count--;
    } else {
    //    [self.gXWGLoveList addObject:sGood];
        [array addObject:sGood];
        self.gUserInfo.share_bookmark_count++;
    }
}

-(void)focused:(NSNotification*)notification
{
    if ([notification.name isEqualToString:Notification_StoreFocus]){
        self.gUserInfo.store_follow_count++;
    } else {
        self.gUserInfo.store_follow_count--;
    }
}



#pragma mark -
#pragma mark WSSDO dataSource -
-(void)SDOSource:(WSSyncDataObject*)sdo
{
    if ([sdo.identifier isEqualToString:kCouponLoveList]) {
        [GKOwnerService getCouponLoveList:[sdo.params[0] intValue]  num:[sdo.params[1] intValue] refresh:sdo.refresh success:^(NSObject *obj, BOOL result) {
            [sdo syncOK:obj];
        } fail:^(NSError *err) {
            [sdo syncFail:err];
        }];
    } else if(([sdo.identifier isEqualToString:kXWGLoveList])) {
        [GKOwnerService getXWGGoodsLoveList:[sdo.params[0] intValue] num:[sdo.params[1] intValue] refresh:sdo.refresh success:^(NSObject *obj, BOOL result) {
            [sdo syncOK:obj];
        } fail:^(NSError *err) {
            [sdo syncFail:err];
        }];
    } else if([sdo.identifier isEqualToString:kStoreSortList]){
        [GKStoreSortListService getStoreSorts:^(NSArray *array) {
            [sdo syncOK:array];
        } fail:^(NSError *err) {
            [sdo syncFail:err];
        }];
    }
}

-(void)SDOSuccBack:(WSSyncDataObject*)sdo
{

}

-(void)SyncWith:(NSString*)identifier
         params:(NSArray*)params
        refresh:(BOOL)refresh
           succ:(NillBlock_OBJ)block
           fail:(NillBlock_Error)failBack
{
    
    WSSyncDataObject *sdo = self.syncObjs[identifier];
    BOOL needUpdate = FALSE;
    
    if (!sdo) {
        sdo = [[WSSyncDataObject alloc] initWithClass:[NSMutableArray class]];
        sdo.identifier = identifier;
        sdo.params = params;
        sdo.dataSource = self;
        sdo.refresh = refresh;
        self.syncObjs[identifier] = sdo;
    } else if(!refresh) {
        BOOL equal = TRUE;
        if (params && sdo.params) {
            for (int k = 0; k < sdo.params.count && equal; k++) {
                if ([sdo.params[k] isKindOfClass:[NSNumber class]] ) {
                    if([sdo.params[k] isEqualToNumber:params[k]])   continue;
                    else equal = FALSE;
                }
                if (([sdo.params[k] isKindOfClass:[NSString class]] )) {
                    if([sdo.params[k] isEqualToString:params[k]])   continue;
                    else equal = FALSE;
                }
            }
        }
        if (!equal && params) sdo.params = params;
        needUpdate = !equal;
    } else {
        sdo.refresh = TRUE;
    }
    
    switch (sdo.status) {
        case SDUS_Done:
            if (!refresh && !needUpdate) {
                block(sdo);
                break;
            }
        case SDUS_Fail:
        case SDUS_UnInited:
        case SDUS_Geting:
        {
            WSSyncDataObject *weakObj = sdo;
            [sdo addSyncHandler:^(NSObject *obj) {
                block(weakObj);
            } fail:^(NSError *err) {
                SAFE_BLOCK_CALL(failBack, err);
            }];
            
            if (sdo.status != SDUS_Geting) [sdo startSync:refresh];
            break;
        }
    }
}


@end

@interface WSSyncDataObject()
@property (nonatomic,strong) NSError *error;
@property (nonatomic,strong) NSMutableArray *handlers;

@end

@implementation WSSyncDataObject
-(id)initWithClassName:(NSString*)className
{
    self = [super init];
    if (self) {
        if (IsSafeString(className)) {
            Class class = NSClassFromString(className);
            if (class) {
                self.syncObj = [[class alloc] init];
            }
        }
    }
    return self;
}

-(id)initWithClass:(Class)class
{
    self = [super init];
    if (self) {
        if (class) {
            self.syncObj = [[class alloc] init];
        }
    }
    return self;
}

-(id)initWithObject:(NSObject*)object
{
    self = [super init];
    if (self) {
        self.syncObj = object;
    }
    return self;
}

-(void)startSync:(BOOL)refreshEnabled
{
    self.status = SDUS_Geting;
}

//-(void)startRefresh
//{
//    self.refresh = TRUE;
//    [self startSync:TRUE];
//}

-(void)setStatus:(SyncDataStatus)status
{
    _status = status;
    
    switch (status) {
        case SDUS_Done:
            self.refresh = FALSE;
            for(NillBlock_OBJ_BOOL block in self.handlers) block(self.syncObj,TRUE);
            [self.handlers removeAllObjects];
            break;
            
        case SDUS_Fail:
            self.refresh = FALSE;
            for(NillBlock_OBJ_BOOL block in self.handlers) block(self.error,FALSE);
            [self.handlers removeAllObjects];
            break;
            
        case SDUS_Geting:
            if (self.getBlock) {
                SAFE_BLOCK_CALL_VOID(self.getBlock);
            } else {
                if (self.dataSource && [self.dataSource respondsToSelector:@selector(SDOSource:)]) {
                    [self.dataSource performSelector:@selector(SDOSource:) withObject:self];
                }
            }
            break;
        default:
            break;
    }
}

-(void)addSyncHandler:(NillBlock_OBJ)succHandler fail:(NillBlock_Error)failHandler
{
    NillBlock_OBJ_BOOL handler = ^(NSObject *obj,BOOL result){
        if (!result) {
            SAFE_BLOCK_CALL(failHandler, (NSError*)obj);
        } else {
            if (!succHandler) {
                if (self.dataSource && [self.dataSource respondsToSelector:@selector(SDOSuccBack:)]) {
                    [self.dataSource performSelector:@selector(SDOSuccBack:) withObject:self];
                }
            } else {
                SAFE_BLOCK_CALL(succHandler, obj);
            }
        }
    };

    if (!self.handlers) self.handlers = [NSMutableArray array];
    [self.handlers addObject:[handler copy]];
}

-(void)syncAppendOK:(NSObject*)object
{
    NSMutableArray *array = self.syncObj ? (NSMutableArray*)self.syncObj : [NSMutableArray array] ;
    if ([object isKindOfClass:[NSArray class]]) {
        [array addObjectsFromArray:(NSArray*)object];
    } else {
        [array addObject:object];
    }
    [self syncOK:array];
}

-(void)syncOK:(NSObject*)object
{
    self.syncObj = object;
    self.status = SDUS_Done;
}

-(void)syncFail:(NSError*)error
{
    self.error = error;
    self.status = SDUS_Fail;
}
@end
