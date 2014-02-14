//
//  WS_MapViewCtrller.h
//  GS
//
//  Created by W.S. on 13-6-17.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "WS_BaseViewController.h"
#import "BMapKit.h"

@interface WS_MapViewCtrller : WS_BaseViewController<BMKMapViewDelegate>

@property (nonatomic,assign) Boolean enabledSave;
@property (assign,nonatomic) BOOL hasDraged;
@property (assign,nonatomic) CLLocationCoordinate2D realLoc;
@property (assign,nonatomic) CLLocationCoordinate2D bmLoc;
@property (strong,nonatomic) NSString *strAddr;

@property (strong,nonatomic) BMKAddrInfo *bmAddr;
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@end
