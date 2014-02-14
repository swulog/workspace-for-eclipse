//
//  GKQRScanController.h
//  GK
//
//  Created by W.S. on 13-5-3.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GKBaseViewController.h"

@interface GKQRScanController : GKBaseViewController<ZBarReaderDelegate,UIAlertViewDelegate,ZBarReaderViewDelegate>
@property (weak, nonatomic) IBOutlet GeometryImg *L1;
@property (weak, nonatomic) IBOutlet GeometryImg *L2;
@property (weak, nonatomic) IBOutlet GeometryImg *L3;
@property (weak, nonatomic) IBOutlet GeometryImg *L4;

@property (weak, nonatomic) IBOutlet ZBarReaderView *readerView;

@property (weak, nonatomic) IBOutlet GeometryImg *VL1;
@property (weak, nonatomic) IBOutlet GeometryImg *VL2;
@property (weak, nonatomic) IBOutlet GeometryImg *VL3;
@property (weak, nonatomic) IBOutlet GeometryImg *VL4;

@property (weak, nonatomic) IBOutlet UIView *scanView;

@property (nonatomic,assign) id<ZBarReaderDelegate> readerDelegate;

@end


@interface UILabelWithQRScan : UILabel
@end