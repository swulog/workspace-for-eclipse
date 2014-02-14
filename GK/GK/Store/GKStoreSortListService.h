//
//  GKStoreSortListService.h
//  GK
//
//  Created by apple on 13-4-17.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

//#import <Foundation/Foundation.h>
//#import "Config.h"
//#import "WSObject.h"
//#import "Constants.h"
//#import "GKObject.h"
#import "Singleton.h"
#import "Appheader.h"
#import "WSBaseNetWorkService.h"


@class Coupon;
@class Region;


@interface GKStoreSortListService : WSBaseNetWorkService
+(WSNetServicesReault*)getStoreList:(NSInteger)_sortId  city:(NSString*)_cityId region:(NSString*)regsionId loc:(CLLocationCoordinate2D)_location sortWith:(NSString*)_sortKey distance:(float)_distance  index:(int)_pageNo num:(int)_pageNum success:(NillBlock_OBJ_BOOL)sucCallback fail:(NillBlock_Error)failCallback;
//+(BOOL)getStoreList:(NSInteger)sOrteId isDistance:(BOOL)nEedDostance success:(NillBlock_Array)sucCallback fail:(NillBlock_Error)failCallback;


+(StoreInfo*)getStoreDetail:(NSString*)sToredId from:(NSString*)adv success:(NillBlock_IStoreInfo)sucCallback fail:(NillBlock_Error)failCallback;
+(NSArray*)getCounponList:(NSString*)sToredId success:(NillBlock_Array)sucCallback fail:(NillBlock_Error)failCallback;
+(void)focusStore:(NSString*)sToredId isFocus:(BOOL)_isFocus  success:(NillBlock_Nill)sucCallback fail:(NillBlock_Error)failCallback;
+(void)getFocusStatus:(NSString*)sToredId user:(NSString*)iD  success:(NillBlock_BOOL)sucCallback fail:(NillBlock_Error)failCallback;
+(NSArray*)getRegionList:(NSString*)pRegionId success:(NillBlock_Array)sucCallback fail:(NillBlock_Error)failCallback
;
+(BOOL)searchStore:(NSString*)keyword city:(NSString*)_cityId index:(int)_pageNo num:(int)_pageNum success:(NillBlock_OBJ_BOOL)sucCallback fail:(NillBlock_Error)failCallback;
;


+(NSArray*)getSearchHotKyes:(NSString*)cityId succ:(NillBlock_OBJ)succBack fail:(NillBlock_Error)failBack;

+(void)sendStatistics:(NillBlock_Nill)sucCallback fail:(NillBlock_Error)failCallback;

+(NSArray*)getStorePhotoes:(NSString*)storeId refreshed:(BOOL)forceUpdate succ:(NillBlock_Array)sucCallback fail:(NillBlock_Error)failCallback;

+(void)loveCoupon:(NSString*)couponId isLoved:(BOOL)_isLove  success:(NillBlock_Nill)sucCallback fail:(NillBlock_Error)failCallback;

+(NSArray*)getStoreSorts:(NillBlock_Array)sucCallback fail:(NillBlock_Error)failCallback;

//+(void)GetCommentList:(NSString*)storeId
//              refresh:(BOOL)refresh
//                index:(int)_pageNo
//                  num:(int)_pageNum
//                 succ:(NillBlock_OBBB)sucCallback
//                 fail:(NillBlock_Error)failCallback;
@end

typedef enum{
    CouponStatus_Pengding,
    CouponStatus_Normal,
    CouponStatus_Expired
}CouponStatus;
@interface Coupon : GKObject
@property (strong,nonatomic) NSString *body;
@property (strong,nonatomic) NSString *start,*end;
@property (strong,nonatomic) NSString *id; //促销ID
@property (strong,nonatomic) NSString *image_url;
@property (strong,nonatomic) NSString *note;
@property (assign,nonatomic) CouponStatus status;
@property (strong,nonatomic) NSString *store_id;
@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *store_name;
@property (strong,nonatomic) NSString *store_image_url;
@property (strong,nonatomic) NSString *created;

@end


@interface Region : GKObject
@property(strong,nonatomic) NSString *id; //促销ID
@property(strong,nonatomic) NSString *name; //区县名称
@property (strong,nonatomic) NSString *city_id;
//@property(strong,nonatomic) NSArray *childRegion; //留待以后使用
@end


@interface StoreInfo : GKObject
@property(strong,nonatomic) NSString *address;
@property (assign,nonatomic)NSInteger  coupons_count;           //优惠劵数量
@property(strong,nonatomic) NSString *coupon_title;       //优惠标题

@property(assign,nonatomic) NSInteger deal_count ;//门店消费总数
@property(assign,nonatomic) float discount;             //基础折扣率
@property(assign,nonatomic) NSInteger district_id;         //区域ID
@property(strong,nonatomic) NSString *hours;             //营业时间
@property(strong,nonatomic) NSString *id; // store id
@property (strong,nonatomic) NSString *image_url;
@property (assign,nonatomic) double latitude;
@property (assign,nonatomic) double longitude;
@property(strong,nonatomic) NSString* name;
@property(strong,nonatomic) NSString *owner_id;
@property(strong,nonatomic) NSString *phone;
@property(assign,nonatomic) NSInteger taxo_id;         //分类ID
@property(strong,nonatomic) NSString *updated_at;
@property(assign,nonatomic) NSInteger user_count;            //商户Fans数目
@property(assign,nonatomic) NSInteger follow_count;
@property(assign,nonatomic) NSInteger comment_count;

@property(assign,nonatomic) float distance;         //距离,程序计算的临时数据

//@property(strong,nonatomic) Coupon *coupon;             //促销信息
//@property(strong,nonatomic) NSString *coupon_id;         //促销信息ID
@end

@interface StoreSort : GKObject
@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *image_url;
@property (nonatomic,strong) NSString *parent_cid;
@property (nonatomic,strong) NSString *city_id;

@property (nonatomic,strong) NSString *weight;
@property (nonatomic,strong) NSMutableArray *children;

-(void)save;
@end

@interface StorePhotos : GKObject
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *id;
@property(nonatomic,strong) NSString *default_image;
@property(nonatomic,strong) NSString *thumbnail_image;
@property(nonatomic,strong) NSString *storeId;
@end
@interface CouponLove : GKObject
@property(nonatomic,strong) NSString *id;
@property(nonatomic,strong) NSString *couponId;
@end
//@interface StoreCoupon : GKObject
//@property(nonatomic,strong) NSString *storeId;
//@property(nonatomic,strong) NSString *couponId;
//@end

@interface SearchHotKey : GKObject
@property (nonatomic,strong) NSString *key;
@property (nonatomic,strong) NSString *cityId;
@end



