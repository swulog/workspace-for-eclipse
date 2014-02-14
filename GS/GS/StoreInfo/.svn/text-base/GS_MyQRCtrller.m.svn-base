//
//  GKQRViewController.m
//  GK
//
//  Created by apple on 13-4-14.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GS_MyQRCtrller.h"
#import "QRCodeGenerator.h"
#import "GS_GlobalObject.h"

@interface GS_MyQRCtrller ()

@end

@implementation GS_MyQRCtrller

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(id)initWithStore:(StoreInfo*)sTore
{
    self = [self initNibWithStyle:WS_ViewStyleWithNavBar];
    if(self){
        self.store= sTore;
    }
    return self;
}

- (IBAction)saveQR:(id)sender {
    UIImageWriteToSavedPhotosAlbum(self.qrImgV.image, nil, nil,nil);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"导出成功"
                                                    message:@"您可在照片中查看"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavTitle:@"本店二维码"];
    [self addBackItem:@"返回" action:nil];

    self.nameLabel.text = self.store.name;
    [self showQRImg];
}



- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark inside functiom -

-(void)showQRImg
{    
    NSString *userUID = self.store.id;
    NSString *gkUserQRStr = [NSString stringWithFormat:GK_STORE_TAG @"%@",userUID];
    
    self.qrImgV.image = [QRCodeGenerator qrImageForString:gkUserQRStr imageSize:self.qrImgV.bounds.size.width];

}



@end
