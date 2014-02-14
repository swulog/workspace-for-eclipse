//
//  GKQRScanController.m
//  GK
//
//  Created by W.S. on 13-5-3.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GKQRScanController.h"
#import "GlobalObject.h"

#define NDEBUG

@interface GKQRScanController ()

@end

@implementation GKQRScanController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil style:VIEW_WITH_NAVBAR];
    if (self) {
        // Custom initialization
      }
    return self;
}

-(void)goback
{
    [self dismissFullViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[UILabelWithQRScan appearance] setTextColor:colorWithUtfStr(Color_PageCtrllerNormalColor)];
    
    self.backgroundView.hidden = YES;
    //self.view.backgroundColor = [UIColor clearColor];
    
    [self setTitle:@"扫一扫"];
    [self addBackItemWithCloseImg:nil];
    
    [ZBarReaderView class];
    self.readerView.readerDelegate = self;
    self.readerView.tag = 99999999;
    ZBarImageScanner *scanner = self.readerView.scanner;
    [scanner setSymbology: 0
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    [scanner setSymbology: ZBAR_QRCODE
                   config: ZBAR_CFG_ENABLE
                       to: 1];
    
    
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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.readerView start];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.readerView stop];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) readerView: (ZBarReaderView*) view
                didReadSymbols: (ZBarSymbolSet*) syms
                fromImage: (UIImage*) img
{
    
    [self.readerDelegate
     imagePickerController: (UIImagePickerController*)self
     didFinishPickingMediaWithInfo:
     [NSDictionary dictionaryWithObjectsAndKeys:
      img, UIImagePickerControllerOriginalImage,
      syms,ZBarReaderControllerResults,
      nil]];

    
    for(ZBarSymbol *sym in syms) {
        [view stop];
        [self closeCameraScanner];
    }
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
#pragma mark inside function -
-(void)closeCameraScanner{
    
    UIView * v = [self.view viewWithTag:99999999];
    if (nil != v) {
        [v removeFromSuperview];
    }
    
    [self.view endEditing:YES];
}

@end

@implementation UILabelWithQRScan



@end
