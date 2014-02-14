//
//  CommonHeader.h
//  GS
//
//  Created by W.S. on 13-6-4.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#ifndef GS_APPHeader_h
#define GS_APPHeader_h

#import "AppConstans.h"
#import "APPConfig.h"

#import "GSAppDelegate.h"

#import "NSObject+WSExpand.h"
#import "BlocksKit.h"

#ifdef WS_Net
#import "MKNetworkKit.h"
#import "NetWorkClient.h"
#endif

#ifdef WS_Zbar
#import "ZBarSDK.h"  //CoreVideo， AVFoundation CoreMedia libiconv.dylib QuartzCore
#endif



#ifdef WS_GlobarSerices
#import <CoreLocation/CoreLocation.h>

#ifdef WS_BaiDuService
//CoreLocation.framework和QuartzCore.framework、OpenGLES.framework、SystemConfiguration.framework
//修改任意一个标准m文件为mm文件
//XCode的Project -> Edit Active Target -> Build -> Search Path -> Library Search Paths中添加您的静态库目录，"$(SRCROOT)/../libs/Release$(EFFECTIVE_PLATFORM_NAME)"
#import "BMapKit.h"

#endif
#endif

#import "WS_GeneralTableFieldView.h"


#import "TSLocateView.h"
#import "CInputAssistView.h"
#import "SlidingTabsControl.h"
//#import "HJManagedImageV.h"
//#import "HJObjManager.h"
#import "WSImageView.h"

#import "GeometryImg.h"
#import "MBProgressHUD.h"

#import "CommonCFunction.h"


//#import "GS_GlobalObject.h"
#endif
