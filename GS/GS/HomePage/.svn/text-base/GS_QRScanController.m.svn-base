//
//  GKQRScanController.m
//  GK
//
//  Created by W.S. on 13-5-3.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GS_QRScanController.h"

//#import "GlobalObject.h"

@interface GS_QRScanController ()

@end

@implementation GS_QRScanController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.fullScreenEnabled = TRUE;
          }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.backgroundView.hidden = YES;
    self.backgroundView = nil;
    self.view.backgroundColor = [UIColor clearColor];
    
    [self setNavTitle:@"扫一扫"];
    [self addBackItem:@"返回" action:@selector(goback)];

    for (UIView *v in self.scanView.subviews) {
        if ([v isKindOfClass:[GeometryImg class]]) {
            GeometryImg *gv = (GeometryImg*)v;
            gv.type = Geometry_Line;
            gv.lineWidth  = 3;
            gv.lineColor = [UIColor redColor];
            
            if (gv.tag>3) {
                gv.isVertical = TRUE;
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setL1:nil];
    [self setL2:nil];
    [self setL3:nil];
    [self setL4:nil];
    [self setVL1:nil];
    [self setVL2:nil];
    [self setVL3:nil];
    [self setVL4:nil];
    [self setScanView:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark event handler -
-(void)goback
{
//    [self dismissModalViewControllerAnimated:YES];
   // [self dismissViewControllerAnimated:YES completion:nil];
    [self.delegate performSelector:@selector(scanCancel)];
    
}


@end
