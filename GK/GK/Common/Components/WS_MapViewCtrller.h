//
//  WS_MapViewCtrller.h
//  GS
//
//  Created by W.S. on 13-6-17.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "BMapKit.h"
#import "GKBaseViewController.h"
@interface WS_MapViewCtrller : GKBaseViewController<BMKMapViewDelegate>
-(id)initWithLoction:(CLLocation*)curLoc;

@property (nonatomic,assign) BOOL   editEnabled;
@property (assign,nonatomic) BOOL   hadDraged;

@property (strong,nonatomic) CLLocation *orgBMLoc;
@property (assign,nonatomic) CLLocationCoordinate2D destBMLoc;
//@property (strong,nonatomic) NSString *strAddr;

//@property (strong,nonatomic) BMKAddrInfo *bmAddr;
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@end
