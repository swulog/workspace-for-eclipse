//
//  GSStoreService.h
//  GS
//
//  Created by W.S. on 13-6-8.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSObject.h"
#import "AppConstans.h"


@class StoreInfo;
@class City;
@class District;

@interface GSStoreService : NSObject
+(NSArray*)getStoreSort:(BOOL)forceUpdate succ:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failCallback;
+(NSArray*)getStoreSort;

+(NSArray*)getStoreInfo:(NSString*)userId;
+(void)saveStoreInfo:(StoreInfo*)_storeInfo  succ:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failCallback;
+(void)getStoreStatus:(NSString*)_storeId  succ:(NillBlock_BOOL)sucCallback fail:(NillBlock_Error)failCallback;
+(NSArray*)getStoreInfo:(NSString*)userId refreshed:(BOOL)forceUpdate succ:(NillBlock_Array)sucCallback fail:(NillBlock_Error)failCallback;

+(NSArray*)getStorePhotoes:(NSString*)storeId refreshed:(BOOL)forceUpdate succ:(NillBlock_Array)sucCallback fail:(NillBlock_Error)failCallback;
+(void)updateStorePhotoes:(NSString*)storeId photes:(NSArray*)photoes succ:(NillBlock_Array)sucCallback fail:(NillBlock_Error)failCallback;
+(void)uploadStorePhotoes:(NSString*)storeId photes:(NSArray*)photoes succ:(NillBlock_Array)sucCallback fail:(NillBlock_Error)failCallback processHandler:(NillBlock_Double)processHandler;

+(void)updateHeadIcon:(UIImage*)_image storeID:(NSString*)_storeId  success:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failCallback;
+(void)scan:(NSString*)_consumerId withStore:(NSString*)_storeId  success:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failCallback;

+(City*)getCityId:(NSString*)name success:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failCallback;
+(District*)getDistrictId:(NSString*)cityId disctrictName:(NSString*)name success:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failCallback;
@end

@interface StoreSort : GSObject
@property(nonatomic,strong) NSString *id;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *image_url;
@end

@interface StoreInfo : GSObject<NSCopying>
@property(nonatomic,strong) NSString *id;
@property(nonatomic,strong) NSString *owner_id;
@property(nonatomic,strong) NSString *taxo_id;
@property(nonatomic,strong) NSString *region_id;
@property(nonatomic,strong) NSString *city_id;
@property(nonatomic,strong) NSString *districtId;

@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *image_url;
@property(nonatomic,assign) float longitude;
@property(nonatomic,assign) float latitude;
@property(nonatomic,strong) NSString *address;
@property(nonatomic,strong) NSString *phone;
@property(nonatomic,strong) NSString *hours;
@property(nonatomic,strong) NSString *discount;

@property(nonatomic,strong) NSString *coupon_title;
@property(nonatomic,strong) NSString *coupon_id;
@property(nonatomic,assign) NSInteger coupon_count;

@property(nonatomic,assign) NSInteger deal_count;
@property(nonatomic,assign) NSInteger user_count;
@property(nonatomic,assign) NSInteger follow_count;
@end

@interface StorePhotos : GSObject
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *id;
@property(nonatomic,strong) NSString *default_image;
@property(nonatomic,strong) NSString *thumbnail_image;
@property(nonatomic,strong) NSString *storeId;
@end

@interface StoreUploadPhoto : GSObject
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *id;
@property(nonatomic,strong) NSString *image_data;
@end

@interface City : GSObject
@property (strong,nonatomic) NSString *id;
@property (strong,nonatomic) NSString *name;
@end

@interface District : GSObject
@property (strong,nonatomic) NSString *id;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *city_id;
@end