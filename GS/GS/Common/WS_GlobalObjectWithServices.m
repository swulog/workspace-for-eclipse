//
//  WS_GlobalObjectWithServices.m
//  GS
//
//  Created by W.S. on 13-6-7.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "WS_GlobalObjectWithServices.h"
#import "WS_BaseViewController.h"
#import "WS_MapViewCtrller.h"

@implementation WS_GlobalObjectWithServices

//@dynamic locationManager,locationBlock,localtionServiceFailBlock,discarLocaInfo;
//@dynamic mapManager,mapSearch,locationStrBlock,locationStrFailBlock;



#pragma mark -
#pragma mark location Services -
/*****************************************************************/
/*           Location Services                                   */
/*****************************************************************/
-(void)startUpLBSService
{
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;//kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 200.0f;//kCLDistanceFilterNone;
    }
    
    self.discarLocaInfo = FALSE;
    [self.locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (self.discarLocaInfo) {
        return;
    }

    //确保每次获取只执行一次
    self.discarLocaInfo = TRUE;

    CLLocation *cLocation ;
    
    if(isSimulator){
        cLocation = [[CLLocation alloc] initWithLatitude:29.617788 longitude:106.498986];
        //cLocation = [[CLLocation alloc] initWithLatitude:26.52516 longitude:106.70284];
    } else {
        cLocation = newLocation;
    }
    
    [self.locationManager stopUpdatingLocation];

    self.locationBlock(cLocation);
    
}


- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;
{
    NSLog(@"获取地理信息失败");
    NSError *err= WSErrorWithCode(WS_LocationGetFail);
    SAFE_BLOCK_CALL(self.localtionServiceFailBlock, err);
    
}

-(BOOL)getCurrentLocation:(NillBlock_OBJ)locBlock fail:(NillBlock_Error)failBack 
{
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationBlock = locBlock;
        self.localtionServiceFailBlock = failBack;

        if (isSimulator) {
            self.discarLocaInfo = FALSE;
            [self locationManager:nil didUpdateToLocation:nil fromLocation:nil];
        } else {
            [self startUpLBSService];
        }
        
        return TRUE;
    }
    return FALSE;
}

/*****************************************************************/
/*           Baidu Map Services                                  */
/*****************************************************************/
#pragma mark -
#pragma mark map services -
-(BOOL)startUpMapService
{
    BOOL ret = TRUE;
    if (!self.mapManager) {
        self.mapManager = [[BMKMapManager alloc] init];
        
        ret = [self.mapManager start:BMMAP_APPKEY generalDelegate:nil];
        if (!ret) {
            NSLog(@"Map services fail");
            self.mapManager = nil;
        }
    }
    
    return ret;
}

-(BOOL)getBaiduPosition:(CLLocation*)orgLoc succ:(NillBlock_OBJ)locBlock fail:(NillBlock_Error)failBack
{
    BOOL ret = TRUE; //for future network judge
    
    [self tranformWithBM:orgLoc toBM:TRUE success:^(NSObject *obj){
        SAFE_BLOCK_CALL(locBlock, obj);
    }fail:^(NSError *err){
        SAFE_BLOCK_CALL(failBack, err);
    }];
    
    return ret;
}

-(void)tranformWithBM:(CLLocation*)_location toBM:(BOOL)toBM  success:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failCallback
{
    NSString *url = [NSString stringWithFormat:BMMAP_POS_CONVERT_URL,toBM?GPS_CO_Code:BAIDU_CO_Code,toBM?BAIDU_CO_Code:GPS_CO_Code,_location.coordinate.longitude,_location.coordinate.latitude];
    
    [NetWorkClient requestURL:url withBody:nil method:HTTP_GET parser:^(NSObject *responseObj){
        NSDictionary *dict = (NSDictionary*)responseObj;
        NSString *xstr = [[NSString alloc] initWithData:[NSData  dataFromBase64String:(NSString*)[dict objectForKey:@"x"]] encoding:NSASCIIStringEncoding];
        double x = [xstr doubleValue];
        
        NSString *ystr = [[NSString alloc] initWithData:[NSData  dataFromBase64String:(NSString*)[dict objectForKey:@"y"]] encoding:NSASCIIStringEncoding];
        double y = [ystr doubleValue];
        
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:y longitude:x];
        SAFE_BLOCK_CALL(sucCallback,loc);
    } fail:^(NSError *err){
        if ([err.domain isEqualToString:WS_ErrorDomain] && err.code == (WS_NetError + WS_ErrorDomainStart)) {
            SAFE_BLOCK_CALL(failCallback, err);
        } else {
            SAFE_BLOCK_CALL(failCallback, WSErrorWithCode(WS_LocationGetFail));
        }        
    }];
}


-(BOOL)getLocationStrWithBaidu:(CLLocation*)location succ:(NillBlock_OBJ)sucCallback  fail:(NillBlock_Error)failCallback
{
    
    if(![self startUpMapService]){
        SAFE_BLOCK_CALL(failCallback, WSErrorWithCode(WS_BaiDuMapServiceFail));
        return FALSE;
    }

    if (!self.mapSearch) {
        self.mapSearch = [[BMKSearch alloc] init];
        self.mapSearch.delegate = self;
    }
    
    self.isGeocode = FALSE;

    BOOL flag = [self.mapSearch reverseGeocode:location.coordinate];

    if (!flag) {
        SAFE_BLOCK_CALL(failCallback, WSErrorWithCode(WS_LocationError));
    }
    
    self.locationStrBlock = sucCallback;
    self.locationStrFailBlock = failCallback;
    
    return flag;
}

-(BOOL)getLocationXYWithBaidu:(NSString*)addressStr succ:(NillBlock_OBJ)sucCallback  fail:(NillBlock_Error)failCallback
{
    
    if(![self startUpMapService]){
        SAFE_BLOCK_CALL(failCallback, WSErrorWithCode(WS_BaiDuMapServiceFail));
        return FALSE;
    }
    
    if (!self.mapSearch) {
        self.mapSearch = [[BMKSearch alloc] init];
        self.mapSearch.delegate = self;
    }
    
    NSString *cityStr;
    NSRange range  =  [addressStr rangeOfString:@"市"];
    if (range.length == 0) {
        return FALSE;
    } else {
        NSRange range1 = [addressStr rangeOfString:@"省"];
        if (range.length == 0) {
            cityStr = [addressStr substringToIndex:range.length];
        } else {
            int length = range.location - range1.location - 1;
            range.location = range1.location + 1;
            range.length = length;
            cityStr = [addressStr substringWithRange:range];
        }
    }
    
    self.isGeocode = TRUE;
    BOOL flag = [self.mapSearch geocode:addressStr withCity:cityStr];
    
    if (!flag) {
        SAFE_BLOCK_CALL(failCallback, WSErrorWithCode(WS_LocationError));
    }
    
    self.locationStrBlock = sucCallback;
    self.locationStrFailBlock = failCallback;
    
    return flag;
}

//-(void)showCurrentPositionInsideMap:(UIViewController*)pVc
//{
//    if (!self.mapManager) {
//        [self startUpMapService];
//    }
//    
//    BMKMapView* mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
//    mapView.frame = CGRectMake(0, 44, mapView.frame.size.width, mapView.frame.size.height);
//    mapView.showsUserLocation = YES;                //设置为可以显示用户位置
//
//    
//    WS_BaseViewController *cVc  = [[WS_BaseViewController alloc] initNibWithStyle:WS_ViewStyleWithNavBar];
//    [cVc addBackItem:@"返回" action:nil];
//   // [cVc viewDidLoad];
//    [cVc.view addSubview:mapView];
////    CLLocationCoordinate2D coordinate;                  //设定经纬度
////    coordinate.latitude = curPos.coordinate.latitude;         //纬度
////    coordinate.longitude = curPos.coordinate.longitude;;      //经度
//    
//    BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(mapView.userLocation.location.coordinate, BMKCoordinateSpanMake(1.0,1.0));
//    BMKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
//    [mapView setRegion:adjustedRegion animated:NO];
//    mapView.zoomLevel =15;
//  //  [pVc.navigationController pushViewController:cVc animated:YES];
//    showModalViewCtroller(pVc, cVc, YES);
//}

-(void)pushOwnPositionInsideMap:(CLLocation*)curPos gpsLoc:(CLLocation*)_orgLoc in:(UIViewController*)pVc title:(NSString*)_title enabledSave:(BOOL)_showSave
{
    if (!self.mapManager) {
        [self startUpMapService];
    }
#if 1
    WS_MapViewCtrller *mapCtrller = [[WS_MapViewCtrller alloc] initNibWithStyle:WS_ViewStyleWithNavBar];
    mapCtrller.bmLoc = curPos.coordinate;
    mapCtrller.realLoc = _orgLoc.coordinate;
    mapCtrller.enabledSave = _showSave;
    if (pVc.navigationController) {
        [pVc.navigationController pushViewController:mapCtrller animated:YES];
    } else {
        showModalViewCtroller(pVc, mapCtrller, YES);
    }
    
    [mapCtrller setNavTitle:_title];


#else
  
    BMKMapView* mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    self.mapView = mapView;
    
#define kDuration 0.3
    
    
    //        CATransition *animation = [CATransition  animation];
    //        animation.delegate = self;
    //        animation.duration = kDuration;
    //        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //        animation.type = kCATransitionPush;
    //        animation.subtype = kCATransitionFromTop;
    //        [mapView setAlpha:1.0f];
    //        [mapView.layer addAnimation:animation forKey:@"DDLocateView"];
    
    mapView.frame = CGRectMake(0, 44, mapView.frame.size.width, mapView.frame.size.height);
    
 //   mapView.showsUserLocation = YES;                //设置为可以显示用户位置
    CLLocationCoordinate2D coordinate;                  //设定经纬度
    coordinate.latitude = curPos.coordinate.latitude;         //纬度
    coordinate.longitude = curPos.coordinate.longitude;;      //经度
    
    BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(coordinate, BMKCoordinateSpanMake(1.0,1.0));
    BMKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
    [mapView setRegion:adjustedRegion animated:NO];
    mapView.zoomLevel =15;
    
    
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
	annotation.coordinate = coordinate;
    mapView.delegate = self;
    
	[mapView addAnnotation:annotation];
    
    WS_BaseViewController *cVc  = [[WS_BaseViewController alloc] initNibWithStyle:WS_ViewStyleWithNavBar];
    [cVc viewDidLoad];
    [cVc se:@"定位商店地址"];
    [cVc addBackItem:@"返回" action:nil];
    [cVc addNavRightItem:@"保存" action:@selector(saveLoc)];
    [cVc.view addSubview:mapView];
    self.mapViewCtroller = cVc;
    showModalViewCtroller(pVc, cVc, YES);

    //[pVc.navigationController pushViewController:cVc animated:YES];
#endif
    
}


#pragma mark -
#pragma mark baidu map delegate -


- (void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error
{
	if (error == 0) {
#if 1
        SAFE_BLOCK_CALL(self.locationStrBlock, result);
#else
        if (self.isGeocode) {
            CLLocation *loc = [[CLLocation alloc] initWithLatitude:result.geoPt.latitude longitude:result.geoPt.longitude];
            SAFE_BLOCK_CALL(self.locationStrBlock, loc);
        } else {
            SAFE_BLOCK_CALL(self.locationStrBlock, result.strAddr);
        }
#endif
	} else {
        NSError *err = WSErrorWithCode(WS_LocationError);
        SAFE_BLOCK_CALL(self.locationStrFailBlock, err);
    }
}
//- (void)onGetTransitRouteResult:(BMKPlanResult*)result errorCode:(int)error
//{
//}
//
//- (void)onGetDrivingRouteResult:(BMKPlanResult*)result errorCode:(int)error
//{
//}
//
//- (void)onGetWalkingRouteResult:(BMKPlanResult*)result errorCode:(int)error
//{
//}
//
//- (void)onGetPoiResult:(NSArray*)poiResultList searchType:(int)type errorCode:(int)error
//{
//}
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
	if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
		BMKPinAnnotationView *newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
		newAnnotation.pinColor = BMKPinAnnotationColorPurple;
		newAnnotation.animatesDrop = YES;
		newAnnotation.draggable = YES;
		
		return newAnnotation;
	}
	return nil;
}

//-(void)showOwnPosition:(CLPlacemark*)curPos in:(UIView*)view
//{
//    if (!self.mapManager) {
//        [self startUpMapService];
//    }
//    
//    BMKMapView* mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
//    {
//#define kDuration 0.3
//        
//        
//        CATransition *animation = [CATransition  animation];
//        animation.delegate = self;
//        animation.duration = kDuration;
//        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        animation.type = kCATransitionPush;
//        animation.subtype = kCATransitionFromTop;
//        [mapView setAlpha:1.0f];
//        [mapView.layer addAnimation:animation forKey:@"DDLocateView"];
//        
//        mapView.frame = CGRectMake(0, view.frame.size.height - mapView.frame.size.height, mapView.frame.size.width, mapView.frame.size.height);
//        
//        
//        mapView.showsUserLocation = YES;                //设置为可以显示用户位置
//        CLLocationCoordinate2D coordinate;                  //设定经纬度
//        coordinate.latitude = curPos.location.coordinate.latitude;         //纬度
//        coordinate.longitude = curPos.location.coordinate.longitude;;      //经度
//        
//        BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(coordinate, BMKCoordinateSpanMake(1.0,1.0));
//        BMKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
//        [mapView setRegion:adjustedRegion animated:YES];
//        
//        [view addSubview:mapView];
//        
//    }
//}
@end
