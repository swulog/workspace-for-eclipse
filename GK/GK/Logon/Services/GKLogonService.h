//
//  GKLogonService.h
//  GK
//
//  Created by apple on 13-4-16.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

//#import <Foundation/Foundation.h>
//#import "Config.h"
//#import "Constants.h"
//#import "WSObject.h"
#import "Appheader.h"


@class City;
@class GKIDInfo;

@interface GKLogonService : NSObject
///+(GKIDInfo*) getUserInfo:(NSString*)GKID;
//+(NSString*)getUserQRImg:(NSString*)GKID;

//+(void)saveUserInfo:(GKIDInfo*)iDinfo;
//+(void)updateUser:(NSString*)iD pwd:(NSString*)pwd;
//+(void)updateUser:(NSString*)iD QR:(UIImage*)img;
+(BOOL)logonGK:(NSString*)iD pwd:(NSString*)pWd  success:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failCallback;
+(void)LogonSync:(NSString*)gkId pwd:(NSString*)gkpwd succ:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failBack;
+(void)logonGKWith3rdAccount:(NSString*)usid platform:(NSString*)_plat name:(NSString*)_name headUrl:(NSString*)_headIconUrl  success:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failCallback;
+(void)GetAppInfo:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failCallback;
+(NSArray*)getAdvInfo:(NSString*)cityId succ:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failCallback;
+(NSArray*)getThemeAdvInfo:(NSString*)cityId refresh:(BOOL)forced succ:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failCallback;
+(void)Register:(NSString*)_phoneNum success:(NillBlock_Nill)sucCallback fail:(NillBlock_Error)failCallback;
+(void)GetVerifyCode:(NSString*)_phoneNum success:(NillBlock_Nill)sucCallback fail:(NillBlock_Error)failCallback;
+(void)UpdatePWD:(NSString*)_phoneNum verifyCode:(NSString*)code npwd:(NSString*)_npwd  success:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failCallback;
+(void)getToken:(NSString*)iD pwd:(NSString*)pWd succ:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failCallback;
+(City*)getCityId:(NSString*)name success:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failCallback;
+(NSArray*)getCityLIist:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failCallback;
+(void)getBaiduLocation:(CLLocation*)_location success:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failCallback;
@end





@interface GKIDInfo : GKObject
@property(strong,nonatomic) NSString *gkId;
@property(strong,nonatomic) NSString *gkpwd;
@property(strong,nonatomic) NSString *weiboId;
@property(assign,nonatomic) WeiBo_Type weiboType;

@property(strong,nonatomic) NSString *id;
@property(strong,nonatomic) NSString *avatar_url;
@property(strong,nonatomic) NSString *login;
@property(strong,nonatomic) NSString *name;
@property(strong,nonatomic) NSString *type;
@property(assign,nonatomic) NSInteger follow_count; //关注数量
@property(assign,nonatomic) NSInteger fans_count; //丝数量
@property(assign,nonatomic) NSInteger store_follow_count; //商户关注数量
@property(assign,nonatomic) NSInteger coupon_bookmark_count; //优惠信息收藏数量
@property(assign,nonatomic) NSInteger share_bookmark_count; //享网购商品收藏数量


//@property(assign,nonatomic) NSInteger logonStatus;
//@property(strong,nonatomic) UIImage  *headIcon;
//@property(strong,nonatomic) NSString *headNativeName;


@end

@interface GKAdvInfo : GKObject
@property (strong,nonatomic) NSString *id;
@property (strong,nonatomic) NSString *image_url;
@property (strong,nonatomic) NSString *store_id;
//@property (strong,nonatomic) UIImage *adv_picture_data;
@property (strong,nonatomic) NSString *city_id;


@end
/* id 广告主键 title 广告标题 image_url 广告图片url地址 city_id 城市主键ID store_id: 商户主键ID*/
@interface GKThemeAdvInfo : GKObject
@property (strong,nonatomic) NSString *id;
@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *image_url;
@property (strong,nonatomic) NSString *url;
@property (strong,nonatomic) NSString *store_id;
@property (strong,nonatomic) NSString *city_id;

@end

@interface City : GKObject
@property (strong,nonatomic) NSString *id;
@property (strong,nonatomic) NSString *name;
@end

@interface AppInfo : NSObject
@property (strong,nonatomic) NSString *storeVersion;
@property (strong,nonatomic) NSString *storeReleaseNotes;
@end
