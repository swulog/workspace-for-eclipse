//
//  Constants.h
//  NXTGateway
//
//  Created by feinno on 12-9-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef NXTGateway_Constants_h
#define NXTGateway_Constants_h

/*****************************************************************/
/*            logon status define                                */
/*****************************************************************/
#pragma mark -
#pragma mark logon plattfom & status define  -

typedef enum{
    WeiBo_None = 0,
    WeiBo_Sina = 1,     //新浪
    WeiBo_QQWB,
    WeiBo_QQHome,       //QQ空间
    WeiBo_RR,            //QQ
    WeiBo_Total  = WeiBo_RR
    
}WeiBo_Type;

extern NSString *GSNSS[WeiBo_Total];

//#define GK_LOGON_WITH_GKID      1<<WeiBo_None
//#define GK_LOGON_WITH_SinaID    1<<WeiBo_Sina
//#define GK_LOGON_WITH_QQHomeID  1<<WeiBo_QQHome
//#define GK_LOGON_WITH_QQID      1<<WeiBo_QQ

/*****************************************************************/
/*            Font & Color Define                           */
/*****************************************************************/
#pragma mark -
#pragma mark Font & Color Define -
#define FONT_NORMAL_12  [UIFont systemFontOfSize:12]
#define FONT_NORMAL_13  [UIFont systemFontOfSize:13]
#define FONT_NORMAL_11  [UIFont systemFontOfSize:11]
#define FONT_NORMAL_21  [UIFont systemFontOfSize:21]

#define FONT_NORMAL_18 [UIFont systemFontOfSize:18]
#define FONT_NORMAL_14  [UIFont systemFontOfSize:14]
#define FONT_BOLD_14 [UIFont boldSystemFontOfSize:14]
#define FONT_BOLD_16 [UIFont boldSystemFontOfSize:16]

#define Color_HeadPage_MenuText [UIColor colorWithRed:66.0/255.0 green:66.0/255.0 blue:66.0/255.0 alpha:1.0f]
#define Color_ListDescriptionText [UIColor colorWithRed:99.0/255.0 green:99.0/255.0 blue:9.0/255.0 alpha:1.0f]

#define Color_HeadPage_Menu "#666666"
#define Color_ListDescription "#999999"
#define Color_TableSelector "#d2d4e2"//"#e6effa"
#define Color_GroupTableSelector "#6d819b"
#define Color_TabSeleteorText "#99ccff"
#define Color_TabUnSeleteorText "#8e96a9"
#define Color_StoreDetail_ValidateTime "#fdb567"
#define Color_TabSelectedColor  "#EF5A62"//"#ff8282"


/*****************************************************************/
/*            Notifcation Name Define                            */
/*****************************************************************/
#pragma mark -
#pragma mark Notifcation Name Define -

#define NOTIFICATION_LOGON_OK @"NotificationLogonOK"
#define NOTIFICATION_ExitLogon @"NotificationExitLogon"
#define NOTIFICATION_UserInfoUpdated @"NotificationUserInfoUpdated"
#define NOTIFICATION_CityUpdate @"NotificationCityUpdated"

#define NOTIFICATION_HIDDEN_STORE_ICON @"NotificationHiddenStoreIcon"
#define NOTIFICATION_SELECT_PIC  @"NotifcationSelectedPicture"

#define NOTIFICATION_LocationDefinedStoreSortsChanged @"NotificationLocationDefinedSortsChanged"

#define  Notification_StoreFocus  @"NotificationStoreFocusd"
#define  Notification_StoreUnFocus  @"NotificationStoreUnFocusd"

#define  NOTIFICATION_GOOD_LOVED  @"NotificationGoddLoved"
#define  NOTIFICATION_GOOD_UNLOVED  @"NotificationGoddUnLoved"

#define  NOTIFICATION_COUPON_LOVED  @"NotificationCouponLoved"
#define  NOTIFICATION_COUPON_UNLOVED  @"NotificationCouponUnLoved"

#define Notification_APPEnterBackground @"NotificationEnterBackground"
#define Notification_APPBecomeActive @"NotificationActived"

#define Notification_CommentRelease @"NotificationCommentRelease"
#pragma mark -
#pragma mark Constants Define -

#define NOT_DEFINED -1

/*****************************************************************/
/*            Device Marco Define                                */
/*****************************************************************/
#pragma mark -
#pragma mark Device Marco -

#define  isSimulator (NSNotFound != [[[UIDevice currentDevice] model] rangeOfString:@"Simulator"].location)
#define  isIpad ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
#define  isIphone ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)

#define  isRetina_640X1136 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136),\
                            [[UIScreen mainScreen] currentMode].size) : NO) 

#define  isRetina_640X960 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), \
                            [[UIScreen mainScreen] currentMode].size) : NO)

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

extern float appScreenHeight,appStatusHeight;
#define APP_SCREEN_HEIGHT appScreenHeight
#define APP_SCREEN_WIDTH 320
#define APP_STATUSBAR_HEIGHT  appStatusHeight
#define APP_FRAME CGRectMake(0,APP_STATUSBAR_HEIGHT,APP_SCREEN_WIDTH,APP_SCREEN_HEIGHT)
#define APP_NAVBAR_HEIGHT 44
#define APP_TABBAR_HEIGHT 40

#define APP_DELEGATE ((GKAppDelegate*)[UIApplication sharedApplication].delegate)

#pragma mark - 
#pragma mark common macro define -



#define JSP_PROPERTY_DEFINE(...) @synthesize(__VA_ARGS__)

/*****************************************************************/
/*            Error MSG Define                                   */
/*****************************************************************/
#pragma mark -
#pragma mark Error MSG Define -

#define GK_ERROR_DOMAIN @"GK DOMAIN"
#define GK_ERROR_FOCUS_STATUS_EXCEPTION 1000

typedef enum{
    ERR_MSG = 1,
    
    ERR_CODE_START,
    NET_SERVER_ERROR = ERR_CODE_START,
    PARSE_ERROR,
    DATA_FORMAT_NOT_MATCH,
    OTHER_ERROR,
    REGISTER_ERROR,
    LOCATION_ERROR,
    PWD_ID_ERROR,
    WS_RegisterError,
    WS_VerifyCodeErr,
    WS_ERR_HADFOCUSED,
    WSError_NetWorkException
}ErrorCode;

extern const char* ErrorDesc[];








#pragma mark -
#pragma mark Type Define -
@class StoreInfo;
typedef void (^NillBlock_IStoreInfo)(StoreInfo *storeInfo);
@class GKIDInfo;
typedef void (^NillBlock_GKIDInfo)(GKIDInfo *idInfo);

typedef void (^NillBlock_Array)(NSArray *array);
typedef void (^NillBlock_Nill)(void);
typedef void (^NillBlock_BOOL)(BOOL);
typedef void (^NillBlock_Sender)(id sender);
typedef void (^NillBlock_Double)(double);


typedef void (^NillBlock_Error)(NSError *err);
typedef void (^NillBlock_Str)(NSString *string);

typedef void (^NillBlock_OBJ)(NSObject *obj);
typedef void (^NillBlock_OBJ_BOOL)(NSObject *obj,BOOL result);
typedef void (^NillBlock_2OBJ)(NSObject *obj1,NSObject *obj2);

typedef void (^Block_JsonParser)(NSObject *dataDict);
typedef void (^Block_JsonParser_Body_Header)(NSObject *dataDict,NSDictionary *headers);

typedef NSArray* (^Block_Dealize_Parser)(NSArray *array);
typedef UITableViewCell* (^Block_CreateCell)(NSString *identify);

typedef void (^NillBlock_OBBB) (NSObject *obj,BOOL nextEnabled,BOOL isOffLine,BOOL isCache);
#pragma mark - 
#pragma mark Sample Macro Define -
#define SAFE_BLOCK_CALL(b,p) (b==nil?:b(p))
#define SAFE_BLOCK_CALL_VOID(b) (b==nil?:b())

//#define MF_Png(imageName) [Utilities getImageWithName:imageName]
#define APP_DocPath() [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Documents"]
#define IsSafeString(a) ((a)&& (![a isEqual:[NSNull null]]) &&(a.length>0))
#define SafeString(a) (((a==nil)||((a).length==0))?@"":(a))

#define IsSafeArray(a) ((a)&&(a.count>0))

#define UpdateStatus(name,value) ((name)|(1<<(value)))
#define IsInStatus(name,value) ((name)&(1<<(value)))
#define RestoreStatus(name,value) ((name)&~(1<<(value)))

#define AddNotification(notifiName,notifiSelector) [[NSNotificationCenter defaultCenter] addObserver:self selector:(notifiSelector) name:(notifiName) object:nil]
//#define SAFE_NFSSTRING_SET(a) (((a==nil)||((a).length==0))?@"":(a))
#endif
