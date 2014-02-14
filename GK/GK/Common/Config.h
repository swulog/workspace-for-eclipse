//
//  Config.h
//  GK
//
//  Created by apple on 13-4-7.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#ifndef GK_Config_h
#define GK_Config_h

#pragma mark -
#pragma mark switch for test -

#if 0
#define __OPTIMIZE__  //for NSLog....
#endif

#if 0
#define TEST_PHASE
#endif

#if 0
#define STARTUP_VIEW_TEST  //for startup flow view
#endif

#if 0
#define TEST_URL //目前是测试环境的地址
#endif

#if 0
#define TEST_FOR_URL_WATCH
#endif

#if 0
#define TABBAR_WITH_CUSTOM
#endif


#pragma mark -
#pragma mark some configuration for the app -

#define CORE_TEXT

#ifndef __OPTIMIZE__
# define NSLog(...) NSLog(__VA_ARGS__)
#else
# define NSLog(...) {}
#endif

#define StartPageNo 1


#define UnDefinedCityId     @"-1"
#ifdef TEST_PHASE
#define GK_Default_CityId   @"22"
#define GK_Default_CityName @"重庆"
#else
#define GK_Default_CityId   @"292"
#define GK_Default_CityName @"贵阳"
#endif


#define StoreSortIdForBeauty  26
#define StoreSortPIdForBeauty 8

#define DB0Name @"GKBaseDB"
#define DB1Name @"GKDB"

#define GS_APPID @"680993772"
#define APP_VERSION_URL @"http://itunes.apple.com/lookup?id=" GS_APPID
#define APP_DOWNLOAD_URL @"https://itunes.apple.com/cn/app/gui-ke-shang-hu-ban/id680993772?ls=1&mt=8" 

enum{
  LOC_SAVE_WITH_BAIDU,
  LOC_SAVE_WITH_GPS
};

#define  LocSave_CoordinateSystem LOC_SAVE_WITH_BAIDU

#pragma mark -
#pragma mark the application configuration -

#define CMM_AnimatePerior 0.35f
#define TableCMMRowWidth 290
#define WSRefreshTableTextColor "#81d8cf"
#define WSRefreshTableArrowEnabeld 0

#define WX_APPKEY @"wx1b1ed04625409aa7"
#define UMENG_APPKEY @"5163c13d56240b6c6700315c"
#define BMMAP_APPKEY @"FF30F7BFD672985F32DE5C4582EFAC8E9212BF78" //@"700a563a044e61cbf75ed131251c8c02"   //

//百度纠偏
#define BMMAP_POS_CONVERT_URL  @"http://api.map.baidu.com/ag/coord/convert?from=0&to=4&x=%f&y=%f"

//#define TB_SANDBOX_TEST
#ifdef TB_SANDBOX_TEST
#define TB_APPKEY @"1021590960"
#define TB_APPSecret @"sandboxefa647626508674caa09037f4"
#define TB_APPCALLBACK @"http://www.vipguike.com"
#else
#define TB_APPKEY @"21590960"
#define TB_APPSecret @"94c5ef3efa647626508674caa09037f4"
#define TB_APPCALLBACK @"TBCallGK://"

#endif
//#define TBK_SEARCH_API @"taobao.taobaoke.items.get"

#define TOPSort_PID @"0"

typedef enum{
    StoreSort_ALL,
    StoreSort_CANYIN = 6,
    StoreSort_YULE = 5,
    StoreSort_YUNDONG = 7,
    StoreSort_SHENGHUO = 8,
    StoreSort_GOUWU = 9
    
}StoreTopSort;
#define StoreTopSortNum 5
extern int getSortIndex(StoreTopSort sort);
//extern  char *STORE_SORT_EN[] ;
extern  char *STORE_SORT[StoreTopSortNum];
extern  char *StoreSortIcon[];

extern  int StoreSortIndex[];

extern  char *StoreList_Option[4];
extern  char *NearStoreList_Option[3];
extern  int NearStoreList_DistanceScope[4];

typedef enum {
    GKTAB_Home,
    GKTAB_Near,
    GKTAB_XWG,
    GKTAB_Theme,
    GKTAB_Owner,
    
    GKTabItemCount
}GKTabItem;

extern  char *tabTitles[GKTabItemCount];
extern  char *tabImgNames[GKTabItemCount];

#define LICENSE_TEXT @"本优惠最终解释权归商家所有"

#define SINA_TAG @"WEIBO"
#define QQHOME_TAG @"QH"
#define QQ_TAG @"QQ"
#define RR_TAG @"RR"


//#define GK_ID_ForStore       @"Store user"
//#define GK_ID_ForCustomer    GK_ID_ForStore

#define LIST_PAGE_MAX_MUM 10
#define LIST_PAGE_LimitLess_MUM 9999

#define XWG_LIST_PAGE_MAX_MUM 30

//商户相册
#define STORE_PHOTO_MAX_NUM 4

//缓存周期设定

#define CACHE_CLEAR_INTERVAL (2 * 60 * 60)
#define REGION_CACHE_CLEAR_INTERVAL (2 * 24 * 60 * 60)
#define SearchHotKeyCacheClearInterval (2 * 24 * 60 * 60)
#define StoreSortCacheClearTimeInterval (7 * 24 * 60 * 60)
#define CityCacheClearTimeInterval SearchHotKeyCacheClearInterval
#define GoodSortCacheClearTimeInterval StoreSortCacheClearTimeInterval
#define ADVCacheClearTimeInterval (2 * 60 * 60)
#define CommentCacheClearTimeInterval (7 * 24 * 60 * 60)

#define USER_CACHE_VALIDATE_PEROID REGION_CACHE_CLEAR_INTERVAL

#define XWG_GOOD_URL_CACHE_PEROID REGION_CACHE_CLEAR_INTERVAL
#define XWG_GOOD_LOVE_CACHE_PEROID XWG_GOOD_URL_CACHE_PEROID


//超时设定
#pragma mark - 
#pragma mark - timerout for net connect
#define TimerOutForLogonSync (1 * 1000) //1s


#define GK_WebSite @"http://m.vipguike.com"
//url 定义
#pragma mark -
#pragma mark  the url for the app -

#ifdef TEST_URL
#define BASE_URL @"api.gsw100.com"
#else
#define BASE_URL @"www.vipguike.com"
#endif



#define GK_QRTAG @"http://www.vipguike.com/download"
#define GK_STORE_TAG GK_QRTAG @"?store-id="
#define GK_CUSTOMER_TAG GK_QRTAG @"?id="

#define GK_STORE_DOWNLOAD_URL @"http://" BASE_URL @"/download/store"
#define GK_STORE_APPSTORE_URL @"https://itunes.apple.com/cn/app/gui-ke-shang-hu-ban/id668880513?ls=1&mt=8"



//商户分类列表
#define STORE_SORT_LIST_URL  @"http://" BASE_URL @"/api/taxonomy/%d/stores"
//商户分类
#define STORE_SORTS_URL  @"http://" BASE_URL @"/api/taxonomies/0"



//商户详细信息(包括最细促销信息)
#define STORE_INFO_URL  @"http://" BASE_URL @"/api/store/%@"
//商店促销信息
#define COUPON_INFO_URL  @"http://" BASE_URL @"/api/store/%@/coupons"
//促销收藏信息
#define COUPON_LOVE_URL  @"http://" BASE_URL @"/api/user/bookmark/coupon/%@"
//促销收藏列表
#define COUPON_LOVE_LIST_URL  @"http://" BASE_URL @"/api/bookmark/coupons?per_page=%d&page=%d"

//商店相册数据接口
#define GK_STORE_PIC_INFO_URL @"http://" BASE_URL @"/api/store/%@/photos"
//登陆贵客
#define GK_LOGON_URL @"http://" BASE_URL @"/api/user"

//评论
#define GK_Comment_URL @"http://" BASE_URL @"/api/store/%@/comment"

#define GK_OwnerComment_URL @"http://" BASE_URL @"/api/user/store/comments"


//关注商户
#define STORE_FOCUS_URL @"http://" BASE_URL @"/api/user/followed/%@"
//广告海报列表
#define ADV_BANNER_URL @"http://" BASE_URL @"/api/adverts"
//主题广告列表
#define ThemeADV_URL @"http://" BASE_URL @"/api/adv_block/stores"
//广告统计
#define ADV_STATISTICS_URL @"http://" BASE_URL @"/api/statistic"
//获取城市区县
#define CITY_AREA_URL @"http://" BASE_URL @"/api/city/%@/districts"
//获取城市ID
#define CITY_ID_URL @"http://" BASE_URL @"/api/city/%@"
//获取城市列表
#define CITY_LIST_URL @"http://" BASE_URL @"/api/client/cities"

//搜索
#define COUPON_SEARCH_URL @"http://" BASE_URL @"/api/stores/%@"
//注册
#define GK_REGISTER_URL  @"http://" BASE_URL @"/api/register/%@"
//获取验证码
#define GK_VERIFY_URL  @"http://" BASE_URL @"/api/phone/%@/verify"
//获取Token
#define GS_TOKEN_URL @"http://" BASE_URL @"/api/authorizations"
//重设密码
#define GK_UPDATE_PWD_URL  @"http://" BASE_URL @"/api/user/password"
//新浪登陆
#define GK_3RD_LOGON_URL  @"http://" BASE_URL @"/api/partner_login/%@/%@"
//关注列表
#define USER_FOCUS_LIST_URL  @"http://" BASE_URL @"/api/follows?per_page=%d&page=%d"
//修改昵称
#define USER_NAME_UPDATE_URL @"http://" BASE_URL @"/api/user/%@"
//上传头像
#define USER_HEADICON_UPDATE_URL @"http://" BASE_URL @"/api/user/%@/avatar"
//用户资料
#define USER_INFO_URL  @"http://" BASE_URL @"/api/user/%@"

//商户最新促销信息(暂时停用)
#define STORE_COUPON_INFO_URL  @"http://" BASE_URL @"/api/store/%@/late"
//搜索关键字
#define STORE_SEARCH_HOTKEY_URL @"http://" BASE_URL @"/api/hotkeywords/%@"


//促销详细信息(暂时停用)
//#define COUPON_INFO_URL  @"http://" BASE_URL @"/api/store/%@/coupon/%@"

//享网购列表
#define XWG_LIST_URL @"http://" BASE_URL @"/api/share/list"
//享网购商品详情
#define XWG_DETAIL_URL @"http://" BASE_URL @"/api/share/%@"
//享网购收藏商品
#define XWG_LOVE_URL    @"http://" BASE_URL @"/api/user/bookmark/share/%@"
//享网购收藏列表
#define XWG_LOVE_LIST_URL @"http://" BASE_URL @"/api/bookmark/shares?per_page=%d&page=%d"
//享网购编辑推荐
#define XWG_EDITOR_LIST_URL @"http://" BASE_URL @"/api/share/editor/list"
//享网购分类列表
#define XWG_GoodSort_URL @"http://" BASE_URL @"/api/share_catalog/list"


#endif
