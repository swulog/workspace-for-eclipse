//
//  APPConfig.h
//  GS
//
//  Created by W.S. on 13-6-4.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#ifndef GS_APPConfig_h
#define GS_APPConfig_h


#define WS_Net
#define WS_Zbar
#define WS_BaiDuService
#define WS_GlobarSerices



#if 0
#define GS_DevelopEnvironment
#endif

#ifdef GS_DevelopEnvironment
#define TEST_FOR_URL_WATCH
#endif

#ifdef GS_DevelopEnvironment
#define TEST_PHASE
#endif

#define GS_APPID @"668880513"
#define APP_VERSION_URL @"http://itunes.apple.com/lookup?id=" GS_APPID
#define APP_DOWNLOAD_URL @"https://itunes.apple.com/cn/app/gui-ke-shang-hu-ban/id668880513?ls=1&mt=8" 

#ifdef GS_DevelopEnvironment
#define ServerHost @"api.gsw100.com"
#else
#define ServerHost @"www.vipguike.com"
#endif

#define GK_QRTAG @"http://www.vipguike.com/download"
#define GK_STORE_TAG GK_QRTAG @"?store-id="
#define GK_CUSTOMER_TAG GK_QRTAG @"?id="

#define BMMAP_APPKEY @"FF30F7BFD672985F32DE5C4582EFAC8E9212BF78"
#define UMENG_APPKEY @"52004def56240b103b017353"

#define GSCACHE_EXPIRD_PERIOD 8 //小时
#define GK_CITY_GuiZHou_ID   @"292"

//百度纠偏
#define BAIDU_CO_Code 4
#define GPS_CO_Code 0
#define BMMAP_POS_CONVERT_URL  @"http://api.map.baidu.com/ag/coord/convert?from=%d&to=%d&x=%f&y=%f"

//商户相册
#define STORE_PHOTO_MAX_NUM 4


#pragma mark -
#pragma mark view config -
//背景图片
#define GeneralBackgoundImg @"background"

//navBar 设置
#define NavBarBackgoundImg @"navBarBg"
#define NavBarBackImg @"navBarBackBtnBg"

#define LIST_PAGE_MAX_MUM 10

/*****************************************************************/
/*            Url Define                                         */
/*****************************************************************/
//登录
#define GS_LOGON_URL @"http://" ServerHost @"/api/store/login"
//获取Token
#define GS_TOKEN_URL @"http://" ServerHost @"/api/authorizations"
//重设密码
#define GS_UPDATE_PWD_URL  @"http://" ServerHost @"/api/user/password"
//注册
#define GS_REGISTER_URL  @"http://" ServerHost @"/api/register/%@"
//获取验证码
#define GS_VERIFY_URL  @"http://" ServerHost @"/api/phone/%@/verify"
//经营类别
#define GS_SORT_URL @"http://" ServerHost @"/api/taxonomies/%@"
//商店资料查看
#if 0
#define GS_STORE_INFO_URL @"http://" ServerHost @"/api/user/%@/stores"  //将被废弃
#else
#define GS_STORE_INFO_URL @"http://" ServerHost @"/api/user/stores"
#endif
//商店相册数据接口
#define GS_STORE_PIC_INFO_URL @"http://" ServerHost @"/api/store/%@/photos"

//商店资料状态
#define GS_STORE_STATUS_URL @"http://" ServerHost @"/api/store/%@/pending"
//商店资料修改
#define GS_STORE_UPDATE_URL @"http://" ServerHost @"/api/store/%@"
//修改商店形象图片
#define GS_STORE_UPDATE_ICON_URL @"http://" ServerHost @"/api/store/%@/image"
//获取城市ID
#define CITY_ID_URL @"http://" ServerHost @"/api/city/%@"
//获取区县ID
#define DISTRICT_ID_URL @"http://" ServerHost @"/api/city/%@/district/%@"

//扫码
#define GS_STORE_SCAN_URL @"http://" ServerHost @"/api/store/%@/consume/%@"
//发布促销
#define GS_COUPON_RELEASE_URL @"http://" ServerHost @"/api/coupon"
//促销列表
#define GS_COUPON_LIST_URL @"http://" ServerHost @"/api/store/%@/coupons/%@?page=%d&per_page=%d"
//撤销促销
#define GS_COUPON_REVOKE_URL @"http://" ServerHost @"/api/coupon/%@/revoke"
//删除编辑促销
#define GS_COUPON_EDIT_URL @"http://" ServerHost @"/api/coupon/%@"
#define GS_COUPON_DEL_URL GS_COUPON_EDIT_URL
#endif
