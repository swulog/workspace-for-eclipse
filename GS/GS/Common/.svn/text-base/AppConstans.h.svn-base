//
//  AppConstans.h
//  GS
//
//  Created by W.S. on 13-6-4.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#ifndef GS_AppConstans_h
#define GS_AppConstans_h

#import "GSAppDelegate.h"

typedef enum{    
    WS_ErrorCode_Start,
    WS_NetError = WS_ErrorCode_Start,
    WS_DataParseError,
    WS_DataUnMatched,
    WS_UndifinedError,
    WS_RegisterError,
    WS_LocationGetFail,
    WS_PWDIDError,
    WS_LocationError,
    WS_BaiDuMapServiceFail,
    WS_VerifyCodeErr,
    
    WS_ErrorCode_Over
}WS_ErrorCode;

extern const char* WS_ErrorDesc[];
#define WS_ErrorDomain @"WS ErrorDomain"
#define WS_ErrorDomainStart  2000

#define DBName @"GSDB"

#pragma mark -
#pragma mark Notifcation Name Define -

#define NOTIFICATION_LOGON_OK @"NotificationLogonOK"
#define NOTIFICATION_LOGON_FAIL @"NotificationLogonFail"

#define NOTIFICATION_STORE_UPDATE @"NotificationStoreUpdate"
#define NOTIFICATION_STORE_REFRESH @"NotificationStoreRefresh"
//#define NOTIFICATION_SELECT_PIC  @"NotifcationSelectedPicture"
#define NOTIFICATION_LOC_UPDATE @"NotificationUpdateLication"
#define NOTIFICATION_STORE_SAVEOK @"NotificationStoreSaveOK"
#define NOTIFCATION_LOGOFF  @"NotificationLogOffOK"
#define NOTIFCATION_PHOTOED_UPDATE  @"NotificationPhotoesUpdated"

#pragma mark -
#pragma mark devices & version macro define -
/*****************************************************************/
/*            evices & version macro                             */
/*****************************************************************/
//device macro
#define  isSimulator (NSNotFound != [[[UIDevice currentDevice] model] rangeOfString:@"Simulator"].location)
#define  isIpad ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
#define  isIphone ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)

#define  isRetina_640X1136 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define  isRetina_640X960 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define APP_DELEGATE ((GSAppDelegate*)[UIApplication sharedApplication].delegate)
#define APP_WINDOW APP_DELEGATE.window

#define APP_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height - [UIApplication sharedApplication].statusBarFrame.size.height
#define APP_FRAME CGRectMake(0,[UIApplication sharedApplication].statusBarFrame.size.height,320,APP_SCREEN_HEIGHT)

//document macro
#define APP_DocPath() [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Documents"]


#pragma mark -
#pragma mark Font Define -
/*****************************************************************/
/*            font define                                        */
/*****************************************************************/
#define FONT_NORMAL_12  [UIFont systemFontOfSize:12]
#define FONT_NORMAL_14  [UIFont systemFontOfSize:14]
#define FONT_NORMAL_18  [UIFont systemFontOfSize:18]
#define FONT_BOLD_18    [UIFont boldSystemFontOfSize:18]

#define FONT_NORMAL_16  [UIFont systemFontOfSize:16]
#define FONT_NORMAL_13  [UIFont systemFontOfSize:13]

#define FONT_BOLD_14 [UIFont boldSystemFontOfSize:14]

#pragma mark -
#pragma mark Type Define -
/*****************************************************************/
/*            block type define                                  */
/*****************************************************************/

typedef void (^NillBlock_Array)(NSArray *array);
typedef void (^NillBlock_Nill)(void);
typedef void (^NillBlock_BOOL)(BOOL);
typedef void (^NillBlock_Sender)(id sender);
typedef void (^NillBlock_Double)(double process);
typedef NSString* (^StrBlock_Dict) (NSDictionary* postDataDict);

//typedef void (^NillBlock_Location)(CLPlacemark *placeMark);
typedef void (^NillBlock_Error)(NSError *err);
typedef void (^NillBlock_Str)(NSString *string);


//normal block for return object
typedef void (^NillBlock_OBJ)(NSObject *obj);
typedef void (^NillBlock_2OBJ)(NSObject *obj1,NSObject *obj2);

typedef void (^Block_JsonParser)(NSObject *dataDict);
typedef NSArray* (^Block_Dealize_Parser)(NSArray *array);

#pragma mark -
#pragma mark Sample Macro Define -
/*****************************************************************/
/*            usually marco define                               */
/*****************************************************************/
#define SAFE_BLOCK_CALL(b,p) (b==nil?:b(p))
#define SAFE_BLOCK_CALL_VOID(b) (b==nil?:b())

#define NSStringSafeFormat(a) (a&&a.length>0?a:@"")
#define IsSafeString(a) ((a)&&(a).length>0)
//constans trans
/*****************************************************************/
/*            method & constans transform for ios6               */
/*****************************************************************/
extern int WSLineBreakModeWordWrap();
extern int WSTextAlignmentLeft();
extern void showModalViewCtroller(UIViewController* pvc, UIViewController* vc, BOOL animated);

#endif
