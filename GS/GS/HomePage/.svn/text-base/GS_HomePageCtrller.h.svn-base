//
//  GS_HomePageCtrller.h
//  GS
//
//  Created by W.S. on 13-6-4.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "WS_BaseViewController.h"
#import "AppHeader.h"
#import "GSStoreService.h"
#import "GS_QRScanController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "GKImgCroperViewController.h"

@interface GS_HomePageCtrller : WS_BaseViewController<ZBarReaderDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,QRScanViewControllerDelegate,GKImgCroperDelegate>
{
    SystemSoundID soundID;
}

@property (strong,nonatomic) NSArray *iStoreList;
@property (strong,nonatomic) StoreInfo *iStore;
@property (strong,nonatomic) NSMutableArray *iStorePhotoes;

@property (weak, nonatomic) IBOutlet UILabel *storNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *focusCountLabel;

//@property (strong,nonatomic) HJObjManager *bannerManager;
@property (weak, nonatomic) IBOutlet WSImageView *bannerImgV;
@property (weak, nonatomic) IBOutlet UIButton *bannerBtn;
//@property (weak, nonatomic) IBOutlet UIImageView *bannerImg;
@property (nonatomic,strong ) UIImagePickerController *imgPicker;
@property (strong,nonatomic) UIImage *updatedImg;
//@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
//@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (nonatomic,strong) UIViewController *cameroOverlayViewController;
@property (nonatomic,strong) NSString *qrStr;

@property (weak, nonatomic) IBOutlet UIScrollView *imgScrollV;
@property (weak, nonatomic) IBOutlet UILabel *uploadLabel1;
@property (weak, nonatomic) IBOutlet UILabel *uploadLabel2;



@property (weak, nonatomic) IBOutlet UIImageView *homePageBg;
@property (weak, nonatomic) IBOutlet UIButton *scanBtn;

- (IBAction)scanClick:(id)sender;
- (IBAction)releaseClick:(id)sender;
- (IBAction)QRClick:(id)sender;
- (IBAction)discountClick:(id)sender;
- (IBAction)updateIconClick:(id)sender;




@end
