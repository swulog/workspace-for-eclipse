//
//  WS_GlobalObjectWithServices.h
//  GK
//
//  Created by W.S. on 13-7-26.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "WS_GlobalObject.h"
#import "BMapKit.h"
#import "TopIOSClient.h"
#import "TopAppConnector.h"
#import "TopAppService.h"

typedef void (^WS_NillBlock_CLLocation)(CLLocation *location) ;
typedef void (^WS_NillBlock_Error)(NSError *error) ;
typedef void (^WS_NillBlock_NSString)(NSString *string) ;

typedef enum{
    CO_BAIDU
}CoordinateSystem;

@interface WS_GlobalObjectWithServices : WS_GlobalObject<CLLocationManagerDelegate,BMKSearchDelegate>
{
    BOOL discarLocaInfo;
}
@property (nonatomic,copy)      WS_NillBlock_CLLocation     locationBlock;
@property (nonatomic,copy)      WS_NillBlock_Error          locationFailBlock;
@property (nonatomic,strong)    CLLocationManager           *locationManager;
@property (nonatomic,strong)    CLLocation                  *gpsLocation;
+(BOOL)getCurrentLocation:(WS_NillBlock_CLLocation)locBlock fail:(WS_NillBlock_Error)failBack;
+(void)coordinate:(CLLocation*)_location to:(CoordinateSystem)coSys  success:(WS_NillBlock_CLLocation)sucCallback fail:(WS_NillBlock_Error)failCallback;


@property (strong,nonatomic)    NSString                    *baiduKey;
@property (strong,nonatomic)    BMKMapManager               *baiduMapManager;
@property (strong,nonatomic)    BMKSearch                   *baiduMapSearch;
@property (strong,nonatomic)    WS_NillBlock_NSString       baiduAddressBlock;
@property (nonatomic,copy)      WS_NillBlock_Error          baiduAddressFailBlock;
//+(void)setBaiduMapServiceKey:(NSString*)baidyKey;
+(BOOL)getAddress:(CLLocation*)location with:(CoordinateSystem)coSys success:(WS_NillBlock_NSString)sucCallback fail:(WS_NillBlock_Error)failCallback;
+(UIViewController*)baiduMapViewController:(CLLocation*)baiduLoc;


//taobao services
//+(void)startupTBServices;
//+(TopIOSClient*)TBClient;

@end
