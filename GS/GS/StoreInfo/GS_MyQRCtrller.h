//
//  GKQRViewController.h
//  GK
//
//  Created by apple on 13-4-14.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GS_MyQRCtrller.h"
//#import "ZBarSDK.h"
#import "WS_BaseViewController.h"
#import "GSStoreService.h"

@interface GS_MyQRCtrller : WS_BaseViewController
@property (strong,nonatomic) NSString *qrStr;
@property (strong,nonatomic) StoreInfo *store;

@property (weak, nonatomic) IBOutlet UIImageView *qrImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
-(id)initWithStore:(StoreInfo*)sTore;
- (IBAction)saveQR:(id)sender;

@end
