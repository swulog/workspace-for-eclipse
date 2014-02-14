//
//  WS_MapViewCtrller.m
//  GS
//
//  Created by W.S. on 13-6-17.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "WS_MapViewCtrller.h"
//#import "GS_GlobalObject.h"


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

-(id)initWithLoction:(CLLocation*)curLoc
{
    self = [self initWithNibName:@"WS_MapViewCtrller" bundle:nil style:VIEW_WITH_NAVBAR];
    if (self) {
        self.orgBMLoc = curLoc;
        self.destBMLoc =CLLocationCoordinate2DMake(self.orgBMLoc.coordinate.latitude, self.orgBMLoc.coordinate.longitude);
    }
    
      return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [self addBackItem:@"返回"];
    [self addBackItem];
    [BMKMapView class];
    self.mapView.showsUserLocation = YES;
    
    CLLocationCoordinate2D coordinate;                  //设定经纬度
    coordinate.latitude = self.destBMLoc.latitude;         //纬度
    coordinate.longitude = self.destBMLoc.longitude;;      //经度
    
    BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(coordinate, BMKCoordinateSpanMake(1.0,1.0));
    BMKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:NO];
    self.mapView.zoomLevel =15;
    
    
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
	annotation.coordinate = coordinate;
    if (self.editEnabled)        annotation.title = @"可以拖动定位";
	[self.mapView addAnnotation:annotation];
    
    self.mapView.delegate = self;

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
	if ([annotation isKindOfClass:[BMKPointAnnotation class]] && self.editEnabled) {
		BMKPinAnnotationView *newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
		newAnnotation.pinColor = BMKPinAnnotationColorPurple;
		newAnnotation.animatesDrop = YES;
		newAnnotation.draggable = YES;

		return newAnnotation;
	}
	return nil;
}

- (void)mapView:(BMKMapView *)mapView annotationView:(BMKAnnotationView *)view didChangeDragState:(BMKAnnotationViewDragState)newState
   fromOldState:(BMKAnnotationViewDragState)oldState
{
    if (newState == BMKAnnotationViewDragStateEnding) {
        self.destBMLoc = [view.annotation coordinate];
        self.hadDraged = TRUE;
    }
}

- (void)viewDidUnload {
    [self setMapView:nil];
    [super viewDidUnload];
}
@end
