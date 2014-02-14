//
//  WS_GlobalObjectWithServices.h
//  GS
//
//  Created by W.S. on 13-6-7.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "WS_GlobalObject.h"
#import "AppHeader.h"


#define WSNotification_SaveLocFromBMMap @"WSNotification_SaveLocFromBMMap"


@interface WS_GlobalObjectWithServices:WS_GlobalObject <CLLocationManagerDelegate,BMKSearchDelegate,BMKMapViewDelegate>



#pragma mark -
#pragma mark location service -
//@property(nonatomic,strong)  CLLocation *location;
//@property(nonatomic,strong)  CLPlacemark *iPlace;
@property(nonatomic,strong)  CLLocationManager *locationManager;
@property(nonatomic,copy)    NillBlock_OBJ  locationBlock;
@property(nonatomic,copy)    NillBlock_Error localtionServiceFailBlock;
@property(assign,nonatomic)  BOOL discarLocaInfo;

-(BOOL)getCurrentLocation:(NillBlock_OBJ)locBlock fail:(NillBlock_Error)failBack;


#pragma mark -
#pragma mark baidu map services -
@property (nonatomic,strong) BMKMapManager *mapManager;
//@property (nonatomic,strong) CLLocation *baiduLocation;
@property (strong,nonatomic) BMKSearch* mapSearch;
@property (copy,nonatomic) NillBlock_OBJ locationStrBlock;
@property (nonatomic,copy) NillBlock_Error locationStrFailBlock;
@property (nonatomic,strong) BMKMapView *mapView;
@property (nonatomic,strong) UIViewController *mapViewCtroller;
@property (nonatomic,assign) BOOL isGeocode;

//-(void)showOwnPosition:(CLPlacemark*)curPos in:(UIView*)view;
-(void)pushOwnPositionInsideMap:(CLLocation*)curPos gpsLoc:(CLLocation*)_orgLoc in:(UIViewController*)pVc  title:(NSString*)_title enabledSave:(BOOL)_showSave;
//-(void)showCurrentPositionInsideMap:(UIViewController*)pVc;

-(BOOL)getBaiduPosition:(CLLocation*)orgLoc succ:(NillBlock_OBJ)locBlock fail:(NillBlock_Error)failBack;
-(BOOL)getLocationStrWithBaidu:(CLLocation*)location succ:(NillBlock_OBJ)sucCallback  fail:(NillBlock_Error)failCallback;
-(BOOL)getLocationXYWithBaidu:(NSString*)addressStr succ:(NillBlock_OBJ)sucCallback  fail:(NillBlock_Error)failCallback;
-(void)tranformWithBM:(CLLocation*)_location toBM:(BOOL)toBM  success:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failCallback;

@end
