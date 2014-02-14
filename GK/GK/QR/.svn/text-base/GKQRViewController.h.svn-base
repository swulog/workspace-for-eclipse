//
//  GKQRViewController.h
//  GK
//
//  Created by apple on 13-4-14.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GKBaseViewController.h"
//#import "HJManagedImageV.h"
//#import "HJObjManager.h"
#import "GKLogonCtroller.h"
#import "WSLargeButton.h"


typedef enum
{
    QRCloseStyle_DismissDown,
    QRCloseStyle_PopRight
    
}QRCloseStyle;

@interface GKQRViewController : GKBaseViewController<ZBarReaderDelegate,UIAlertViewDelegate,GKLogonDelegate>
{
    BOOL isInLogon;
}

@property (weak, nonatomic) IBOutlet WSLargeButton *scanBtn;
@property (weak, nonatomic) IBOutlet UIImageView *qrImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic,assign) QRCloseStyle clsoeStyle;
@property (strong,nonatomic) NSString *qrStr;
@property (nonatomic,assign) BOOL isTab;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil needTab:(BOOL)nEedTab  closeStyle:(QRCloseStyle)style;


- (IBAction)scanClick:(id)sender;

@end

@interface UILabelWithQRView : UILabel

@end