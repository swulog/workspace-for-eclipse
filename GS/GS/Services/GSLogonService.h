//
//  GKLogonService.h
//  GK
//
//  Created by apple on 13-4-16.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSObject.h"
#import "AppConstans.h"

@class GSIDInfo;
@interface GSLogonService : NSObject

+(GSIDInfo*)getUserInfo:(NSString*)GKID;
+(void)saveUserInfo:(GSIDInfo*)iDinfo;
+(void)getToken:(NSString*)iD pwd:(NSString*)pWd succ:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failCallback;

+(BOOL)logon:(NSString*)iD pwd:(NSString*)pWd succ:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failCallback;
+(void)UpdatePWD:(NSString*)_phoneNum verifyCode:(NSString*)code npwd:(NSString*)_npwd  success:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failCallback;
+(void)Register:(NSString*)_phoneNum success:(NillBlock_Nill)sucCallback fail:(NillBlock_Error)failCallback;
+(void)GetVerifyCode:(NSString*)_phoneNum success:(NillBlock_Nill)sucCallback fail:(NillBlock_Error)failCallback;
+(void)GetAppInfo:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failCallback;
//+(void)updateUser:(NSString*)iD pwd:(NSString*)pwd;
//+(void)updateUser:(NSString*)iD QR:(UIImage*)img;



@end





@interface GSIDInfo : GSObject

@property (strong,nonatomic) NSString *gsId;
@property (strong,nonatomic) NSString *gspwd;
@property (assign,nonatomic) BOOL hasLogoned;

@property (assign,nonatomic) BOOL exist;
@property (strong,nonatomic) NSString *store_id;

@property (strong,nonatomic) NSString *id;
@property (strong,nonatomic) NSString *avatar_url;
@property (strong,nonatomic) NSString *name;

@end

@interface AppInfo : NSObject
@property (strong,nonatomic) NSString *storeVersion;
@property (strong,nonatomic) NSString *storeReleaseNotes;
@end

