//
//  GKQRScanController.h
//  GK
//
//  Created by W.S. on 13-5-3.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "WS_BaseViewController.h"
#import "AppHeader.h"



@protocol QRScanViewControllerDelegate;
@interface GS_QRScanController : WS_BaseViewController
@property (assign,nonatomic) id<QRScanViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet GeometryImg *L1;
@property (weak, nonatomic) IBOutlet GeometryImg *L2;
@property (weak, nonatomic) IBOutlet GeometryImg *L3;
@property (weak, nonatomic) IBOutlet GeometryImg *L4;


@property (weak, nonatomic) IBOutlet GeometryImg *VL1;
@property (weak, nonatomic) IBOutlet GeometryImg *VL2;
@property (weak, nonatomic) IBOutlet GeometryImg *VL3;
@property (weak, nonatomic) IBOutlet GeometryImg *VL4;

@property (weak, nonatomic) IBOutlet UIView *scanView;

@end


@protocol QRScanViewControllerDelegate <NSObject>

-(void)scanCancel;

@end