//
//  WS_MapViewCtrller.m
//  GS
//
//  Created by W.S. on 13-6-17.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "WS_MapViewCtrller.h"
#import "GS_GlobalObject.h"


@interface WS_MapViewCtrller ()

@end

@implementation WS_MapViewCtrller

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addBackItem:@"返回" action:nil];
    [self showSaveBtn:self.enabledSave];
    
    
    CLLocationCoordinate2D coordinate;                  //设定经纬度
    coordinate.latitude = self.bmLoc.latitude;         //纬度
    coordinate.longitude = self.bmLoc.longitude;;      //经度
    
    BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(coordinate, BMKCoordinateSpanMake(1.0,1.0));
    BMKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:NO];
    self.mapView.zoomLevel =15;
    
    
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
	annotation.coordinate = coordinate;
    annotation.title = @"可以拖动定位";
    self.mapView.delegate = self;
    
	[self.mapView addAnnotation:annotation];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showSaveBtn:(BOOL)_visible
{
    if (_visible) {
        if (!self.rightBtn) {
            [self addNavRightItem:@"保存" action:@selector(saveLoc)];
        }
    } else {
        self.navBar.topItem.rightBarButtonItem = nil;
        self.rightBtn = nil;
    }
}
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
	if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
		BMKPinAnnotationView *newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
		newAnnotation.pinColor = BMKPinAnnotationColorPurple;
		newAnnotation.animatesDrop = YES;
		newAnnotation.draggable = YES;
//        BMKPinAnnotationView *newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
//        ((BMKPinAnnotationView*)newAnnotation).animatesDrop = YES;
//        newAnnotation.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_location.png"]];//气泡框左侧显示的View,可自定义
//        
//        UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [selectButton setFrame:(CGRect){260,0,50,50}];
//        [selectButton setTitle:@"确定" forState:UIControlStateNormal];
//        newAnnotation.rightCalloutAccessoryView =selectButton;//气泡框右侧显示的View 可自定义
//        [selectButton setBackgroundColor:[UIColor redColor]];
//        [selectButton setShowsTouchWhenHighlighted:YES];
//        
//        newAnnotation.centerOffset = CGPointMake(0, (newAnnotation.frame.size.height * 0.5));//不知道干什么用的
//        newAnnotation.annotation = annotation;//绑定对应的标点经纬度
//        newAnnotation.canShowCallout = TRUE;//允许点击弹出气泡框
//        [newAnnotation setDraggable:YES];//允许用户拖动
//        [newAnnotation setSelected:YES animated:YES];//让标注处于弹出气泡框的状态
//     //   [selectButton addTarget:self action:@selector(Location_selectPointAnnotation:) forControlEvents:UIControlEventTouchUpInside];
//         {
//            CLLocationCoordinate2D coordinate = [newAnnotation.annotation coordinate];
//            NSLog(@"new = %f,%f",coordinate.latitude,coordinate.longitude);
//        }
		return newAnnotation;
	}
	return nil;
}
- (void)mapView:(BMKMapView *)mapView annotationView:(BMKAnnotationView *)view didChangeDragState:(BMKAnnotationViewDragState)newState
   fromOldState:(BMKAnnotationViewDragState)oldState
{
    if (newState == BMKAnnotationViewDragStateEnding) {
        self.bmLoc = [view.annotation coordinate];
        self.hasDraged = TRUE;
    }
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;
{
    NSLog(@"DDd");
}

-(void)saveLoc
{
//    CLLocation *loc = [[CLLocation alloc] initWithLatitude:((BMKPointAnnotation*)[self.mapView.annotations objectAtIndex:0]).coordinate.latitude longitude:((BMKPointAnnotation*)[self.mapView.annotations objectAtIndex:0]).coordinate.longitude];

        
        
        
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:self.bmLoc.latitude longitude:self.bmLoc.longitude];

        
        [[GS_GlobalObject GS_GObject] getLocationStrWithBaidu:loc succ:^(NSObject *obj){
//            self.strAddr = (NSString*)obj;
//            self.bmAddr = [[BMKAddrInfo alloc] init];
//            self.bmAddr.strAddr  = self.strAddr;
            self.bmAddr = (BMKAddrInfo*)obj;
            self.strAddr = self.bmAddr.strAddr;
            
            if (self.hasDraged) {
                self.realLoc = loc.coordinate;
                self.bmAddr.geoPt = self.realLoc;
                [[NSNotificationCenter defaultCenter] postNotificationName:WSNotification_SaveLocFromBMMap object:self.bmAddr];
                [self goback];


            } else {
        //        self.bmAddr.geoPt = self.realLoc;
                self.bmAddr.geoPt = self.bmLoc;

                [[NSNotificationCenter defaultCenter] postNotificationName:WSNotification_SaveLocFromBMMap object:self.bmAddr];
                [self goback];
            }
        }fail:^(NSError *err){
            [WS_GlobalObject showPopup:err.localizedDescription];
        }];
    
}
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    NSLog(@"select");
}


- (void)viewDidUnload {
    [self setMapView:nil];
    [super viewDidUnload];
}
@end
