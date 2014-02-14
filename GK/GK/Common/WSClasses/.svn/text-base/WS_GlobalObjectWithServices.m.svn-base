//
//  WS_GlobalObjectWithServices.m
//  GK
//
//  Created by W.S. on 13-7-26.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "WS_GlobalObjectWithServices.h"
#import "NetWorkClient.h"
#import "NSError+Description.h"
#import "WS_MapViewCtrller.h"

@implementation WS_GlobalObjectWithServices

#define  isSimulator (NSNotFound != [[[UIDevice currentDevice] model] rangeOfString:@"Simulator"].location)

#pragma mark -
#pragma mark Location Services -
+(BOOL)getCurrentLocation:(WS_NillBlock_CLLocation)locBlock fail:(WS_NillBlock_Error)failBack
{
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus]!= kCLAuthorizationStatusDenied) ) {
        [SC(WS_GlobalObjectWithServices) startUpLBSService];
        SC(WS_GlobalObjectWithServices).locationBlock = locBlock;
        SC(WS_GlobalObjectWithServices).locationFailBlock = failBack;

        return TRUE;
    } else {
        return FALSE;
    }
}

-(void)startUpLBSService
{
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 200.0f;//kCLDistanceFilterNone;
    }
    
    discarLocaInfo = FALSE;
    [self.locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (discarLocaInfo) {
        return;
    } else {
        discarLocaInfo = TRUE;
    }
        
    if(isSimulator){
        
        self.gpsLocation = [[CLLocation alloc] initWithLatitude:29.617788 longitude:106.498986];//[[CLLocation alloc] initWithLatitude:26.52516 longitude:106.70284];
    } else {
        self.gpsLocation = newLocation;
    }
    
    [self.locationManager stopUpdatingLocation];
    self.locationBlock(self.gpsLocation);
}


- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;
{
    NSLog(@"location services fail");
    
    if(isSimulator){
        self.gpsLocation = [[CLLocation alloc] initWithLatitude:29.617788 longitude:106.498986];
        [self.locationManager stopUpdatingLocation];
        self.locationBlock(self.gpsLocation);
    } else {
        self.locationFailBlock(error);
    }
}
#pragma mark -
#pragma mark Coordinate Transformation Services -

#define BMMAP_POS_CONVERT_URL  @"http://api.map.baidu.com/ag/coord/convert?from=0&to=4&x=%f&y=%f"

+(void)coordinate:(CLLocation*)_location to:(CoordinateSystem)coSys  success:(WS_NillBlock_CLLocation)sucCallback fail:(WS_NillBlock_Error)failCallback
{
    
    NSString *url ;
    
    if (coSys == CO_BAIDU) {
        url = [NSString stringWithFormat:BMMAP_POS_CONVERT_URL,_location.coordinate.longitude,_location.coordinate.latitude];
        
        [NetWorkClient requestURL:url withBody:nil method:HTTP_GET parser:^(NSObject *responseObj){
            NSDictionary *dict = (NSDictionary*)responseObj;
            NSString *xstr = [[NSString alloc] initWithData:[NSData  dataFromBase64String:(NSString*)[dict objectForKey:@"x"]] encoding:NSASCIIStringEncoding];
            NSString *ystr = [[NSString alloc] initWithData:[NSData  dataFromBase64String:(NSString*)[dict objectForKey:@"y"]] encoding:NSASCIIStringEncoding];
            
            double x = [xstr doubleValue];
            double y = [ystr doubleValue];
            CLLocation *loc = [[CLLocation alloc] initWithLatitude:y longitude:x];
            SAFE_BLOCK_CALL(sucCallback,loc);
        } fail:^(NSError *err){
            failCallback(err);
        }];
    } else {
        NSLog(@"the coordinateSystem hadn't releaized : %d",coSys);
    }
}

#pragma mark -
#pragma mark Baidu Map Services -
//+(void)setBaiduMapServiceKey:(NSString*)baidyKey
//{
//    GO(WS_GlobalObjectWithServices).baiduKey = baidyKey;
//}

-(BOOL)startUpBaiDuMapService
{
    BOOL ret = TRUE;
    if (!self.baiduMapManager) {
        self.baiduMapManager = [[BMKMapManager alloc] init];
        ret = [self.baiduMapManager start:self.baiduKey generalDelegate:nil];
        if (!ret) {
            self.baiduMapManager = nil;
        }
    }
    
    if (ret) {
        if (!self.baiduMapSearch) {
            self.baiduMapSearch = [[BMKSearch alloc] init];
            self.baiduMapSearch.delegate = self;
        }
    }
    return ret;
}

+(BOOL)getAddress:(CLLocation*)location with:(CoordinateSystem)coSys success:(WS_NillBlock_NSString)sucCallback fail:(WS_NillBlock_Error)failCallback
{
    if (coSys == CO_BAIDU) {
        if ([SC(WS_GlobalObjectWithServices) startUpBaiDuMapService]) {
            BOOL flag = [SC(WS_GlobalObjectWithServices).baiduMapSearch reverseGeocode:location.coordinate];
            [[self shareInstance] setBaiduAddressBlock: sucCallback];
            [[self shareInstance] setBaiduAddressFailBlock: failCallback];
            return flag;

        }
        return FALSE;
          } else {
        NSLog(@"the coordinateSystem hadn't releaized : %d",coSys);
        return FALSE;
    }
}

- (void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error
{
    if (error == 0) {
#if 0
        NSString *addrStr = result.strAddr;
        if (LocSave_CoordinateSystem == LOC_SAVE_WITH_BAIDU) {
            self.locationBlock(addrStr,self.baiduLocation);
        } else {
            self.locationBlock(addrStr,self.location);
        }
#else
        NSString *addrStr = result.strAddr;
        self.baiduAddressBlock(addrStr);
#endif
    } else {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"获取位置信息失败!", NSLocalizedDescriptionKey, nil];
        self.baiduAddressFailBlock([NSError errorWithDomain:@"WS Domain" code:error userInfo:userInfo]);
        NSLog(@"get baidu address fail:%d",error);
    }
}

+(UIViewController*)baiduMapViewController:(CLLocation*)baiduLoc
{
    [SC(WS_GlobalObjectWithServices) startUpBaiDuMapService];

    WS_MapViewCtrller *mapCtrller = [[WS_MapViewCtrller alloc] initWithLoction:baiduLoc];
    return mapCtrller;
}

#pragma mark -
#pragma mark TaoBao Services -

+(void)startupTBServices
{
    
   // TopIOSClient *topIOSClient = [TopIOSClient registerIOSClient:TB_APPKEY appSecret:TB_APPSecret callbackUrl:TB_APPCALLBACK needAutoRefreshToken:TRUE];
    
#if 0
    沙箱首页：http://www.tbsandbox.com
    Mini沙箱首页：http://mini.tbsandbox.com
    TOP访问入口HTTP：http://gw.api.tbsandbox.com/router/rest
    TOP访问入口HTTPS：https://gw.api.tbsandbox.com/router/rest
    容器授权入口TOP协议：http://container.api.tbsandbox.com/container
    容器授权入口OAuth2协议：https://oauth.tbsandbox.com/authorize
    沙箱分销商页面分销数据管理：http://fenxiao.tbsandbox.com/distributor/index.htm
    沙箱供应商页面分销数据管理：http://fenxiao.tbsandbox.com/supplier/index.htm
    物流宝联调平台物流宝数据管理：http://fbi.tbsandbox.com/
    支付宝沙箱页面支付宝接口数据准备：http://sandbox.alipaydev.com/
    
#endif
 
#ifdef TB_SANDBOX_TEST
    [topIOSClient setApiEntryUrl:@"http://gw.api.tbsandbox.com/router/rest"];
    [topIOSClient setAuthEntryUrl:@"https://oauth.tbsandbox.com/authorize"];
    [topIOSClient setAuthRefreshEntryUrl:@"https://oauth.tbsandbox.com/token"];
    [topIOSClient setTqlEntryUrl:@"http://gw.api.tbsandbox.com/tql/2.0/json"];
#endif
//    [TopAppConnector registerAppConnector:TB_APPKEY topclient:topIOSClient];
//    [TopAppService registerAppService:TB_APPKEY appConnector:[TopAppConnector getAppConnectorbyAppKey:TB_APPKEY]];

}

//+(TopIOSClient*)TBClient
//{
//    TopIOSClient *topIOSClient = [TopIOSClient getIOSClientByAppKey:TB_APPKEY];
//    if (!topIOSClient) {
//        [self startupTBServices];
//        topIOSClient = [TopIOSClient getIOSClientByAppKey:TB_APPKEY];
//    }
//    return topIOSClient;
//}
@end
