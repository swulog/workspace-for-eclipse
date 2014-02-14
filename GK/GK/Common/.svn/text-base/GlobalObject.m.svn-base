    //
//  GlobalObject.m
//  NXTGateway
//
//  Created by feinno on 12-9-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GlobalObject.h"
#import "GKStoreSortListService.h"
#import "GKBaseViewController.h"
#import "WS_MapViewCtrller.h"
//#import "GKLogonService.h"
#import "GlobalDataService.h"
#import "GKLogonService.h"

float appScreenHeight;
float appStatusHeight;

NSString* GSNSS[WeiBo_Total];

NSString* const kListIdentifier[] = {@"OwnerCouponList",
    @"OwnerXWGItemList"};

/*DB目前3个阶段 1.无DB 2.1.0阶段:1个DB 3.2.0阶段 2个DB*/
typedef NS_ENUM(NSInteger, DBStep){
    DBStep0,    //无DB
    DBStep1,    //1个DB
    DBStep2     //2个阶段
};

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)


@interface GlobalObject()
@property (nonatomic,assign) NSInteger initStatus;
@property (nonatomic,strong) NSMutableArray *addrHandlers;
@property (nonatomic,strong) NSMutableArray *cityIdHandlers;
@property (assign,nonatomic) BOOL isRefreshLocation;

@property (nonatomic,strong) NSMutableArray *locateStoreSorts;
@property (nonatomic,strong) NSMutableArray *totalCustStoreSorts;
@property (nonatomic,strong) WSPlistManager *customStoreSortsManager;

@end


@implementation GlobalObject

#pragma mark -
#pragma mark init -

+(void)initAPP
{
    appStatusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
//    if (IOS_VERSION >= 7.0) {
//        appScreenHeight = [UIScreen mainScreen].bounds.size.height;
//    } else {
//        appScreenHeight = [UIScreen mainScreen].bounds.size.height - appStatusHeight;
//    }
    appScreenHeight = [UIScreen mainScreen].bounds.size.height;
    [self initUiAppearce];

    
    //初始化友盟服务
    [self initUMService];
    
    //检测客户端版本
    [self checkAppVersionForAppStore];
    
    //检测缓存版本
    [self checkCacheVersion];
    
    //获取城市列表
    //[GKLogonService getCityLIist:nil fail:nil];
    
    //发送统计信息
    [self sendStatisticsInfo];
    
    
    
    
    GO(GlobalObject).baiduKey= BMMAP_APPKEY;
    GO(GlobalObject).cityIdHandlers = [NSMutableArray arrayWithCapacity:4];
    GO(GlobalObject).addrHandlers = [NSMutableArray arrayWithCapacity:4];
    [GO(GlobalObject) initCityId];
    
    
    
    [GlobalDataService startUpDataService];
//    if ([GlobalDataService isLogoned]) {
//        [self bindToSNS];
//    }
}



/********************************************************/
/*******       cityId && Location ***********************/
/********************************************************/
#pragma mark -  CityID && Location Services
#pragma mark -

-(void)initCityId
{
    self.cityId = [[NSUserDefaults standardUserDefaults] valueForKey:@"lastCityId"];
    self.cityName = [[NSUserDefaults standardUserDefaults] valueForKey:@"lastCityName"];
    if (!self.cityId) {
        [self initCityAndAddress];
    }
}

-(void)setCityId:(NSString *)cityId name:(NSString*)cityName
{
    _cityId = cityId;
    _cityName = cityName;
    
    [[NSUserDefaults standardUserDefaults] setValue:cityName forKey:@"lastCityName"];

    if (![_cityId isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"lastCityId"]]) {
        [[NSUserDefaults standardUserDefaults] setValue:cityId forKey:@"lastCityId"];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CityUpdate object:nil];
    }
}

-(void)initCityAndAddress
{
    NillBlock_Nill failBlock = ^{
        self.curAddr = [[BMKAddrInfo alloc] init];
        double lastLatitude = [[NSUserDefaults standardUserDefaults] doubleForKey:@"lastLatitude"];
        double lastLongitude =[[NSUserDefaults standardUserDefaults] doubleForKey:@"lastLongitude"];
        if (lastLatitude !=0 && lastLongitude != 0) {
            CLLocationCoordinate2D geopt = {lastLatitude,lastLongitude};
            self.curAddr.geoPt = geopt;
        }
        self.curAddr.strAddr = [[NSUserDefaults standardUserDefaults] stringForKey:@"lastAddr"];
        if (!self.cityId) {
            self.cityId = GK_Default_CityId;
            self.cityName = GK_Default_CityName;
        }
        
        self.initStatus &= ~(1<<GO_INIT_STATUS_GETCITY);
        for (NillBlock_OBJ_BOOL block in self.cityIdHandlers) {
            block(self.cityId,TRUE);
        }
        [self.cityIdHandlers removeAllObjects];

    };
    
    
    if (!([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus]!= kCLAuthorizationStatusDenied) ))
    {
        if (IsSafeString(self.curAddr.strAddr)) {
            [self initCityIdWithAddrStr:self.curAddr.strAddr];
        } else {
            SAFE_BLOCK_CALL_VOID(failBlock);
        }
    } else {
        [self initCurAddress:^(NSObject *obj) {
            if (!self.cityId) {
                if (IsSafeString(((BMKAddrInfo*)obj).strAddr)) {
                    [self initCityIdWithAddrStr:(((BMKAddrInfo*)obj).strAddr)];
                } else {
                    SAFE_BLOCK_CALL_VOID(failBlock);
                }
            }
        } fail:^(NSError *err) {
            SAFE_BLOCK_CALL_VOID(failBlock);
        }];
    }
}

-(void)initCityIdWithAddrStr:(NSString*)addrStr
{
    NillBlock_OBJ citySucBlock = ^(NSObject* obj){
        if (obj && [obj isKindOfClass:[City class]]) {
            self.cityId = ((City*)obj).id;
            self.cityName = ((City*)obj).name;
        } else if(obj) {
            self.cityId = (NSString*)obj;
       //     self.cityName = cityName;
        } else {
            self.cityId = [[NSUserDefaults standardUserDefaults] valueForKey:@"lastCityId"];
            self.cityName = [[NSUserDefaults standardUserDefaults] valueForKey:@"lastCityName"];
        }
        
        [[NSUserDefaults standardUserDefaults] setValue:self.cityId forKey:@"lastCityId"];
        [[NSUserDefaults standardUserDefaults] setValue:self.cityName forKey:@"lastCityName"];

        self.initStatus &= ~(1<<GO_INIT_STATUS_GETCITY);
        for (NillBlock_OBJ_BOOL block in self.cityIdHandlers) {
            block(self.cityId,TRUE);
        }
        [self.cityIdHandlers removeAllObjects];
    };
    
    if (IsSafeString(addrStr)) {
        NSRange range = [addrStr rangeOfString:@"市"];
        __block NSString *cityName;
        if (range.length > 0) {
            NSRange range1 = [addrStr rangeOfString:@"省"];
            if (range1.length > 0) {
                range.length = range.location - range1.location - range1.length + range.length;
                range.location = range1.location + range1.length;
            } else {
                range.length = range.location + range.length;
                range.location = 0;
            }
            cityName = [addrStr substringWithRange:range];
            
            City *city = [GKLogonService getCityId:cityName success:^(NSObject* obj){
                SAFE_BLOCK_CALL(citySucBlock, obj);
            }fail:^(NSError *err){
                self.initStatus &= ~(1<<GO_INIT_STATUS_GETLOC);
                self.cityId = [[NSUserDefaults standardUserDefaults] valueForKey:@"lastCityId"];
                self.cityName = [[NSUserDefaults standardUserDefaults] valueForKey:@"lastCityName"];
                if (!self.cityId) {
                    self.cityId = GK_Default_CityId;
                    self.cityName = GK_Default_CityName;
                    
                    [[NSUserDefaults standardUserDefaults] setValue:self.cityId forKey:@"lastCityId"];
                    [[NSUserDefaults standardUserDefaults] setValue:self.cityName forKey:@"lastCityName"];
                }
                for (NillBlock_OBJ_BOOL block in self.cityIdHandlers) {
                    block(self.cityId,TRUE);
                }
                [self.cityIdHandlers removeAllObjects];
                
            }];
            
            if (city) {
                SAFE_BLOCK_CALL(citySucBlock, city);
            } else {
                self.initStatus |= (1<<GO_INIT_STATUS_GETCITY);
            }
        } else {
            SAFE_BLOCK_CALL(citySucBlock, nil);
        }
    } else {
        SAFE_BLOCK_CALL(citySucBlock, nil);
    }
}

-(void)initCurAddress:(NillBlock_OBJ)succBack fail:(NillBlock_Error)failBack
{
    WS_NillBlock_Error refreshFailBlock = ^(NSError* error){
        self.initStatus &= ~(1<<GO_INIT_STATUS_GETLOC);
        for (NillBlock_OBJ_BOOL block in self.addrHandlers) {
            block(error,FALSE);
        }
        [self.addrHandlers removeAllObjects];
        
        SAFE_BLOCK_CALL(failBack, error);
    };
    
    WS_NillBlock_CLLocation coordinateBlock = ^(CLLocation *location){
        [[self class] getAddress:location with:CO_BAIDU success:^(NSString *string) {
            self.initStatus &= ~(1<<GO_INIT_STATUS_GETLOC);
            
            self.curAddr = [[BMKAddrInfo alloc] init];
            self.curAddr.strAddr = string;
            self.curAddr.geoPt = location.coordinate;
            
            [[NSUserDefaults standardUserDefaults] setDouble:self.curAddr.geoPt.latitude forKey:@"lastLatitude"];
            [[NSUserDefaults standardUserDefaults] setDouble:self.curAddr.geoPt.longitude forKey:@"lastLongitude"];
            [[NSUserDefaults standardUserDefaults] setValue:self.curAddr.strAddr forKey:@"lastAddr"];
            
            for (NillBlock_OBJ_BOOL block in self.addrHandlers) {
                block(self.curAddr,TRUE);
            }
            [self.addrHandlers removeAllObjects];
            SAFE_BLOCK_CALL(succBack, self.curAddr);

        } fail:^(NSError *error) {
            SAFE_BLOCK_CALL(refreshFailBlock, error);
        }];
    };
    
    self.initStatus |= (1<<GO_INIT_STATUS_GETLOC);
    [[self class] getCurrentLocation:^(CLLocation *location) {
        [[self class] coordinate:location to:CO_BAIDU success:^(CLLocation *location) {
            coordinateBlock(location);
        } fail:^(NSError *error) {
            SAFE_BLOCK_CALL(refreshFailBlock, error);
        }];
    } fail:^(NSError *error) {
        SAFE_BLOCK_CALL(refreshFailBlock, error);
    }];
}

/***************************************************/

+(NSString*)getCityIdForExtraUser:(NillBlock_OBJ)succBack fail:(NillBlock_Error)failBack
{
    if (IsSafeString(GO(GlobalObject).cityId)) {
        return GO(GlobalObject).cityId;
    }
    
    NillBlock_OBJ_BOOL handler = ^(NSObject *obj,BOOL result){
        if (result) {
            SAFE_BLOCK_CALL(succBack, obj);
        } else{
            SAFE_BLOCK_CALL(failBack, (NSError*)obj);
        }
    };
    [GO(GlobalObject).cityIdHandlers addObject:[handler copy]];
    return nil;
}

+(BMKAddrInfo*)getCurLocForExtraUser:(BOOL)forcedRefreh succ:(NillBlock_OBJ)succBack fail:(NillBlock_Error)failBack
{
    BOOL isWaitting = FALSE;
    GlobalObject *go = GO(GlobalObject);
    
    int curStatus  =  go.initStatus & (1<<GO_INIT_STATUS_GETLOC);
    if (curStatus !=0) {
        isWaitting =  TRUE;         //正在获取地理信息
    }
    
    if (!isWaitting) {
        if (!forcedRefreh) {
            return go.curAddr;
        }
        if (!([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus]!= kCLAuthorizationStatusDenied) )) {
            return  forcedRefreh?nil:go.curAddr;
        }
    }
    
    NillBlock_OBJ_BOOL handler = ^(NSObject *obj,BOOL result){
        if (result) {
            SAFE_BLOCK_CALL(succBack, obj);
        } else{
            SAFE_BLOCK_CALL(failBack, (NSError*)obj);
        }
    };
    [go.addrHandlers addObject:handler];
    if (!isWaitting) {
        [go initCurAddress:nil  fail:nil];
    }
    
    return nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:  //确定
        {
            NSURL *url = [NSURL URLWithString:APP_DOWNLOAD_URL];
            [[UIApplication sharedApplication] openURL:url];
            
            break;
        }
        default:
            break;
    }
}
#pragma mark -
#pragma mark  user setting configure -
+(void)SNSSyncClose:(NSString*)snsName
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] valueForKey:@"SNSSyncConfig"]];
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
    }
    
    dict[snsName] = [NSNumber numberWithInt:1];
    [[NSUserDefaults standardUserDefaults] setValue:dict forKey:@"SNSSyncConfig"];
}

+(void)SNSSyncOpen:(NSString*)snsName
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] valueForKey:@"SNSSyncConfig"]];
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
    }
    
    dict[snsName] = [NSNumber numberWithInt:0];
    [[NSUserDefaults standardUserDefaults] setValue:dict forKey:@"SNSSyncConfig"];
}

+(BOOL)SNSSyncClosed:(NSString*)snsName
{
    NSDictionary *array = [[NSUserDefaults standardUserDefaults] valueForKey:@"SNSSyncConfig"];
    if (array) {
        if (array[snsName]) {
            return [array[snsName] intValue];
        }
    }
    return FALSE;
}

+(void)setHiddenStoreIcon:(BOOL)hIdden
{
    [[NSUserDefaults standardUserDefaults] setBool:hIdden forKey:@"HiddenStoreIcon"];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HIDDEN_STORE_ICON object:[NSNumber numberWithBool:hIdden]];
    
}

+(BOOL)getHiddenStoreIconConfig
{
  return   [[NSUserDefaults standardUserDefaults] boolForKey:@"HiddenStoreIcon"];
}

+(void)setLocStoreSorts:(NSArray*)sorts
{
    WSPlistManager *manager = [self customStoreSortsManager];
    [manager setValue:sorts forKey:@"LocateStoreSorts"];
    GlobalObject *tSelf = GO(GlobalObject);
    tSelf.locateStoreSorts = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LocationDefinedStoreSortsChanged object:nil];
}

+(NSMutableArray*)totalCustStoreSorts
{
    GlobalObject *tSelf = GO(GlobalObject);
    
    if (tSelf.totalCustStoreSorts) {
        return tSelf.totalCustStoreSorts;
    }
    
    WSPlistManager *manager = [self customStoreSortsManager];
    NSArray *array = [manager valueForKey:@"CustomStoreSorts"];
    NSMutableArray *sorts = [NSMutableArray arrayWithCapacity:array.count];
    for (int k = 0; k < array.count; k++) {
        NSArray *groupSort = array[k];
        NSMutableArray *groupSortArray = [NSMutableArray array];
        [sorts addObject:groupSortArray];
        for (NSDictionary *dict in groupSort) {
            CustomStoreSort *sort = [[CustomStoreSort alloc] init];
            [sort Deserialize:dict];
            [groupSortArray addObject:sort];
        }
    }
    
    tSelf.totalCustStoreSorts = sorts;
    return sorts;
}

+(NSMutableArray*)locateStoreSorts
{
    GlobalObject *tSelf = GO(GlobalObject);
    if (tSelf.locateStoreSorts) {
        return tSelf.locateStoreSorts;
    }
    
    WSPlistManager *manager = [self customStoreSortsManager];
    NSMutableArray *selectedSorts = [manager valueForKey:@"LocateStoreSorts"];
    tSelf.locateStoreSorts = selectedSorts;
    return selectedSorts;
}

+(WSPlistManager*)customStoreSortsManager
{
    return [WSPlistManager createForPlistFile:@"CustomStoreSort"];
}

+(NSDate*)dateForListRefresh:(NSString*)listIdentifier
{
    WSPlistManager *manager = [WSPlistManager createForPlistFile:@"UserAction"];
    NSDictionary *dict = [manager valueForKey:@"ListRefrehAction"];
    return  [dict valueForKey:listIdentifier];
}

+(void)dateToListRefresh:(NSString*)listIdentifier date:(NSDate*)date
{
    WSPlistManager *manager = [WSPlistManager createForPlistFile:@"UserAction"];
    NSDictionary *dict = [manager valueForKey:@"ListRefrehAction"];
    [dict setValue:date forKey:listIdentifier];
}
#pragma mark -
#pragma mark location Services -
+(void)pushOwnPositionInsideMap:(CLLocation*)curPos in:(UIViewController*)pVc title:(NSString*)_title
{
    WS_MapViewCtrller *mapCtrller = (WS_MapViewCtrller*)[[self class] baiduMapViewController:curPos];
    [mapCtrller setTitle:_title];
    [pVc.navigationController pushViewController:mapCtrller animated:YES];
}


#pragma mark -
#pragma mark backgroud taks Services -
+(void)ExeSelectorOnBgTask:(dispatch_block_t)block
{
    dispatch_async(kBgQueue, block) ;
}

#pragma mark -
#pragma mark inside function -
-(void)bindToSNS
{
    if ([GlobalDataService webForLogon]!=WeiBo_None) {
        [[UMSocialDataService defaultDataService] requestBindToSnsWithType:GSNSS[[GlobalDataService webForLogon]-1] completion:nil];

    }
}

+(void)sendStatisticsInfo
{
    GlobalObject *tSelf = GO(GlobalObject);
    
    [GlobalObject ExeSelectorOnBgTask:^{
        tSelf.statisticsPlistManager = [WSPlistManager createForPlistFile:@"Statistics"];
        if (tSelf.statisticsPlistManager) {
            BOOL needSend = TRUE;
            
            NSDate *date = [NSDate date];
            NSString *curDateStr = transDateToFormatStr(date, @"yyyymmdd");
            NSString *createDateStr = [tSelf.statisticsPlistManager valueForKey:@"CreateDate"];
            
            if (IsSafeString(createDateStr))
                if ([createDateStr compare:curDateStr] == NSOrderedSame) needSend = FALSE;
            
            if (needSend) {
                [GKStoreSortListService sendStatistics:^{
                    [tSelf.statisticsPlistManager empty];
                    [tSelf.statisticsPlistManager setValue:curDateStr forKey:@"CreateDate"];
                    [tSelf.statisticsPlistManager setValue:[NSNumber numberWithInt:1] forKey:@"lunchCount"];
                }fail:^(NSError *err){
                    int lunchCount = [((NSNumber*)[tSelf.statisticsPlistManager valueForKey:@"lunchCount"]) intValue];
                    lunchCount++;
                    [tSelf.statisticsPlistManager setValue:[NSNumber numberWithInt:lunchCount] forKey:@"lunchCount"];
                }];
            } else{
                int lunchCount = [((NSNumber*)[tSelf.statisticsPlistManager valueForKey:@"lunchCount"]) intValue];
                lunchCount++;
                [tSelf.statisticsPlistManager setValue:[NSNumber numberWithInt:lunchCount] forKey:@"lunchCount"];
            }
        }
    }];
}



+(DBStep)checkDBVersion
{
    NSObject *verIdentity = [[NSUserDefaults standardUserDefaults] valueForKey:@"DBVer"]; /*DBStep2标记*/
    if (verIdentity)    return DBStep2;
    
    verIdentity = [[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentDBVersion"]; /*DBStep1标记*/
    if (verIdentity)    return DBStep1;
    
    return DBStep0;
}

+(void)checkCacheVersion
{
    BOOL db1Clear = TRUE;
    BOOL db2Clear = TRUE;
    
    DBStep step = [self checkDBVersion];
    if (step == DBStep2) {
        NSDictionary *dbVers =  [[NSUserDefaults standardUserDefaults] valueForKey:@"DBVer"];
        NSString *db1Ver = dbVers[@"DB_1"];
        NSString *db2Ver = dbVers[@"DB_2"];
        
        NSDictionary *dbMinVers = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"DB Supported Min Version"];
        NSString *db1MinVer = dbMinVers[@"DB_1"];
        NSString *db2MinVer = dbMinVers[@"DB_2"];
        
        if ([db1Ver compare:db1MinVer] >= NSOrderedSame)    db1Clear = FALSE;
        if ([db2Ver compare:db2MinVer] >= NSOrderedSame)    db2Clear = FALSE;
    }
    
    if (db1Clear || db2Clear) {
        NSString *new = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSDictionary *newVers = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:new,new,nil] forKeys:[NSArray arrayWithObjects:@"DB_1",@"DB_2",nil]];
        [[NSUserDefaults standardUserDefaults] setValue:newVers forKey:@"DBVer"];
        
        if (db1Clear)   [DataBaseClient clearDB:DB1Name];
        if (db2Clear)   [DataBaseClient clearDB:DB0Name];
    }
}


+(void)checkAppVersionForAppStore
{
    [GKLogonService GetAppInfo:^(NSObject *obj) {
        AppInfo *appinfo = (AppInfo*)obj;
        NSString *curVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        
        if ([curVersion compare:appinfo.storeVersion] < NSOrderedSame) {
            NSString *updateContent =[NSString stringWithFormat:@"检测到新版本%@，为了您更好的使用体验，请尽快升级到新版本",appinfo.storeVersion];
            UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle:@"有新版本了!"
                                                                  message:updateContent
                                                                 delegate:GO(GlobalObject)       //委托给Self，才会执行上面的调用
                                                        cancelButtonTitle:@"以后再说"
                                                        otherButtonTitles:@"马上更新",nil];
            [updateAlert show];
        }
    } fail:nil];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

+(void)initUMService
{
    NSString *channgel = @"App Store" ;
    if (isSimulator) channgel = @"MACTEST";
    else {
#ifdef TEST_PHASE
        channgel =  @"IPHONETEST";
#endif
    }
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:REALTIME channelId: channgel];

   // [UMSocialData openLog:YES];
    
    [UMSocialData setAppKey:UMENG_APPKEY];
    [UMSocialConfig setWXAppId:WX_APPKEY url:GK_WebSite];
    [UMSocialConfig setSupportSinaSSO:YES];
    [UMSocialConfig setSupportQzoneSSO:YES importClasses:@[[QQApiInterface class],[TencentOAuth class]]];
    [UMSocialConfig setFinishToastIsHidden:YES position:UMSocialiToastPositionTop];

    //UMSocialWXMessageTypeImage 为纯图片类型
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeApp;
    [UMSocialConfig setNavigationBarConfig:^(UINavigationBar *bar,UIButton *closeButton,UIButton *backButton,UIButton *postButton,UIButton *refreshButton,UINavigationItem * navigationItem){
        UIImage * backgroundImage  = Nil;
        if (IOS_VERSION >= 7.0) {
            backgroundImage = [UIImage imageNamed:NavBarBgWithStatusBar_IOS7];
        } else {
            backgroundImage = NavBg();
        }
        if ([bar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
            [bar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        }
        
        UILabel *label = (UILabel*)navigationItem.titleView;
        if (label) {
            label.text = @"贵客";
            label.textColor = colorWithUtfStr(NavBarTitleColor);
            label.textAlignment = NSTextAlignmentCenter;
            label.font = FONT_NORMAL_21;
        }
        
        if (closeButton)
        {
            UIImage *backImg  = [UIImage imageNamed:NavBarCloseIcon];
            CGSize imgSize = backImg.size;
            CGRect rect = CGRectZero;
            rect.size = imgSize;
            closeButton.frame = rect;
            [closeButton setImage:backImg forState:UIControlStateNormal];
            [closeButton setBackgroundImage:nil forState:UIControlStateNormal];
        }
    }];

    GSNSS[0] = UMShareToSina;
    GSNSS[1] = UMShareToTencent;
    GSNSS[2] = UMShareToQzone;
    GSNSS[3] = UMShareToRenren;
}

+(void)initUiAppearce
{

}

@end

@implementation CustomStoreSort



@end
