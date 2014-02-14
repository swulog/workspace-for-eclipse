//
//  GS_HomePageCtrller.m
//  GS
//
//  Created by W.S. on 13-6-4.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GS_HomePageCtrller.h"
#import "GS_SetCtrller.h"
#import "GS_QRScanController.h"
#import "GS_GlobalObject.h"
#import "GS_MyQRCtrller.h"
#import "GS_CouponReleaseCtrller.h"
#import "GS_CouponManageCtrller.h"
#import "GS_PhotoPreviewCtrller.h"
#import "GSPhotoUploadCtrller.h"

#define HEADER_ICON_SHEET_TAG 2000


@interface GS_HomePageCtrller ()
@property (nonatomic,assign) BOOL isPickStorePhotoes;
@property (nonatomic,strong) GSPhotoUploadCtrller *photoUploadCtrller;
@end

@implementation GS_HomePageCtrller

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
    [self setNavTitle:@"商户管理"];
    [self addNavRightItem:@"设置" action:@selector(setClick)];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    //    self.bannerManager = [[HJObjManager alloc] initWithLoadingBufferSize:6 memCacheSize:20];
    //    NSString *cacheDirectoryStoreIcon = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Library/Caches/imgCache/Banner"]];
    //    HJMOFileCache *fileCache = [[HJMOFileCache alloc] initWithRootPath:cacheDirectoryStoreIcon];
    //    self.bannerManager.fileCache = fileCache;
    //    fileCache.fileCountLimit = 10;
    //    fileCache.fileAgeLimit = 60 * 60 * 24 * 7;
    //    [fileCache trimCacheUsingBackgroundThread];
    
    
    [self.bannerImgV showDefaultImg:[UIImage imageNamed:@"homePageDefaultBanner"]];
    

    
    // self.bannerImgV.defaultImg = [UIImage imageNamed:@"homePageDefaultBanner"];
    // self.bannerImgV.contentMode = UIViewContentModeScaleAspectFill;
    
    self.imgPicker = [[UIImagePickerController alloc] init];
    self.imgPicker.delegate = self;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStoreInfo:) name:NOTIFICATION_STORE_UPDATE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStoreInfo:) name:NOTIFICATION_STORE_SAVEOK object:nil];
    
  //  self.iStoreList = [GSStoreService getStoreInfo:[GS_GlobalObject GS_GObject].ownIdInfo.id ];
    
#if 1
    self.iStoreList = [GSStoreService getStoreInfo:[GS_GlobalObject GS_GObject].ownIdInfo.id ];
    if (self.iStoreList) {
        self.iStore = [self.iStoreList objectAtIndex:0];
        [GS_GlobalObject GS_GObject].iStore = self.iStore;
        [self refreshPhotoes];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_STORE_UPDATE object:self.iStore];
    } else if([GS_GlobalObject GS_GObject].gToken){
        self.iStoreList =  [GSStoreService getStoreInfo:[GS_GlobalObject GS_GObject].ownIdInfo.id refreshed:FALSE succ:^(NSArray* storeArray){
            self.iStoreList = storeArray;
            self.iStore = [self.iStoreList objectAtIndex:0];
            [GS_GlobalObject GS_GObject].iStore = self.iStore;
            [self refreshPhotoes];

            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_STORE_UPDATE object:self.iStore];
            [self refreshSelf];
        }fail:nil];
    } else {
        [[GS_GlobalObject GS_GObject] addObserver:self forKeyPath:@"gToken" options:NSKeyValueObservingOptionNew context:nil];
    }
    
#else
    self.iStoreList =  [GSStoreService getStoreInfo:[GS_GlobalObject GS_GObject].ownIdInfo.id refreshed:FALSE succ:^(NSArray* storeArray){
        self.iStoreList = storeArray;
        self.iStore = [self.iStoreList objectAtIndex:0];
        [GS_GlobalObject GS_GObject].iStore = self.iStore;
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_STORE_UPDATE object:self.iStore];
        [self refreshSelf];
    }fail:nil];
    
    if (self.iStoreList) {
        self.iStore = [self.iStoreList objectAtIndex:0];
        [GS_GlobalObject GS_GObject].iStore = self.iStore;
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_STORE_UPDATE object:self.iStore];
    }
#endif
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePhotoes:) name:NOTIFCATION_PHOTOED_UPDATE object:nil];
    [self refreshSelf];
    
    //    NSURL *filePath   = [[NSBundle bundleWithIdentifier:@"com.apple.UIKit"] URLForResource:@"sms-received1" withExtension: @"caf"];
    //    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_STORE_UPDATE object:nil];
    
    [self setBannerImgV:nil];
    [self setStorNameLabel:nil];
    [self setBannerBtn:nil];
    [self setUserCountLabel:nil];
    [self setTradeCountLabel:nil];
    [self setFocusCountLabel:nil];
    [self setImgScrollV:nil];
    [self setHomePageBg:nil];
    [self setScanBtn:nil];
    [self setUploadLabel1:nil];
    [self setUploadLabel2:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark event handler -
-(void)setClick
{
    GS_SetCtrller *vc = [[GS_SetCtrller alloc] initNibWithStyle:WS_ViewStyleWithNavBar];
    [self pushViewControler:vc withNavBar:YES  animated:YES];
}

- (IBAction)scanClick:(id)sender {
    [self scanQR];
}

- (IBAction)releaseClick:(id)sender {
    GS_CouponReleaseCtrller *vc = [[GS_CouponReleaseCtrller alloc] initNibWithStyle:WS_ViewStyleWithNavBar];
    vc.storeId = self.iStore.id;
    showModalViewCtroller(self, [[UINavigationController alloc ] initWithRootViewController:vc], YES);
}

- (IBAction)QRClick:(id)sender {
    GS_MyQRCtrller *vc = [[GS_MyQRCtrller alloc] initWithStore:self.iStore];
    showModalViewCtroller(self, vc, YES);
}

- (IBAction)discountClick:(id)sender {
    
    GS_CouponManageCtrller *vc = [[GS_CouponManageCtrller alloc]  initWithID:self.iStore.id];
    
    showModalViewCtroller(self, [[UINavigationController alloc] initWithRootViewController:vc], YES);

}

#define ACTION_TakePicture 0
#define ACTION_SelPicture 1
- (IBAction)updateIconClick:(id)sender {
    if (sender  != self.bannerBtn) {
        self.isPickStorePhotoes = TRUE;
    } else {
        self.isPickStorePhotoes = false;
    }
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [sheet setTag:HEADER_ICON_SHEET_TAG];
    [sheet showInView:APP_DELEGATE.window];
    
}

//- (IBAction)saveClick:(id)sender {
////    [GS_GlobalObject showPopup:@"正在保存头像"];
////    [GSStoreService updateHeadIcon:self.updatedImg storeID:self.iStore.id success:^(NSObject *obj){
////        self.iStore = (StoreInfo*)obj;
////        [self refreshSelf];
////     //   self.bannerImgV.defaultImg = self.updatedImg;
////        self.updatedImg = nil;
////    //    self.bannerImg.image = nil;
////
////    }fail:^(NSError *err){
////    }];
//}

- (IBAction)cancelClick:(id)sender {
    
}

-(void)gotoPhotoPreviw:(id)sender
{
    WSImageView *imgV = sender;
    
    int focus =  imgV.tag;
    
    GS_PhotoPreviewCtrller *vc  = [[GS_PhotoPreviewCtrller alloc] initWtihPhotoList:self.iStorePhotoes offset:focus];
    
    [self presentViewController:vc animated:YES completion:nil];
    
}

#pragma mark -
#pragma mark inside function -


-(void)updateStoreInfo:(NSNotification*)notification
{
    StoreInfo *store = notification.object;
    
    if (store != self.iStore) {
        if ([self.iStore.id isEqualToString:store.id]) {
            self.iStore = store;
            [GS_GlobalObject GS_GObject].iStore = self.iStore;
            [self refreshSelf];
        }
    }
}

-(void)refreshSelf
{
    if(self.iStore){
        StoreInfo *store  = self.iStore;


        if (store.image_url && [store.image_url length] > 0) {
            [self.bannerImgV showUrl:[NSURL URLWithString:store.image_url]];
        }


        self.storNameLabel.text = store.name;
        self.userCountLabel.text = [NSString stringWithFormat:@"会员数 %d",self.iStore.user_count];
        self.focusCountLabel.text = [NSString stringWithFormat:@"粉丝数 %d",self.iStore.follow_count];
        self.tradeCountLabel.text = [NSString stringWithFormat:@"交易数 %d",self.iStore.deal_count];
    }
    
}
    
    
-(void)updateIcon:(NSNotification*)notifcation
{
   // [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_SELECT_PIC object:nil];
    
    UIImage *img = [notifcation object];
    //    self.bannerImg.contentMode = UIViewContentModeScaleAspectFill;
    //    self.bannerImg.image = img;
    self.updatedImg = img;
//    self.bannerImgV.defaultImg = img;
    [self.bannerImgV showDefaultImg:img];
    
    [GS_GlobalObject showPopup:@"正在保存商店形象图片"];
    UIImage *uploadImg = [self.updatedImg scaleToSize:CGSizeMake(128, 128)];

    [GSStoreService updateHeadIcon:uploadImg storeID:self.iStore.id success:^(NSObject *obj){
        self.iStore = (StoreInfo*)obj;
      //  [self refreshSelf];
        self.updatedImg = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_STORE_UPDATE object:self.iStore];
        [GS_GlobalObject showPopup:@"保存成功"];

    }fail:^(NSError *err){
        [GS_GlobalObject showPopup:@"保存失败，请稍候再试"];
        
    }];
}

-(void)refreshPhotoes
{
    NSArray *array = [GSStoreService getStorePhotoes:self.iStore.id refreshed:FALSE succ:^(NSArray *array) {
        self.iStorePhotoes = [NSMutableArray arrayWithArray: array];
        [self showPhotoes];
    } fail:^(NSError *err) {
        self.iStorePhotoes = nil;
    }];
    
    
    if (array && array.count > 0 ) {
        self.iStorePhotoes = [NSMutableArray arrayWithArray:array];
        [self showPhotoes];
    } else {
        self.uploadLabel1.hidden = TRUE;
        self.uploadLabel2.hidden = TRUE;
    }
}

-(void)updatePhotoes:(NSNotification*)notification
{
    NSMutableArray *array = notification.object;
    self.iStorePhotoes = array;
    [self showPhotoes];
}

-(void)showPhotoes
{
    if (!self.iStorePhotoes) {
        return ;
    }
    
    NSMutableArray *storePhotoes  = [NSMutableArray arrayWithArray:self.iStorePhotoes];
    int delCount = 0;
    for (int k = 0;k<storePhotoes.count;k++) {
        StorePhotos *photo = storePhotoes[k];
        if (!IsSafeString(photo.default_image)) {
            [self.iStorePhotoes removeObjectAtIndex:k-delCount];
            delCount++;
        }
    }
    storePhotoes = nil;
    
    [self.iStorePhotoes sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        StorePhotos *photo1 = (StorePhotos*)obj1;
        StorePhotos *photo2 = (StorePhotos*)obj2;
        
        return [photo1.name compare:photo2.name];
    }];
    
    float offsetX = 0;
    CGRect rect = CGRectMake(0, 0, 65 , 65);
    int index = 0;
    
    
    [self.imgScrollV.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (StorePhotos *photo in self.iStorePhotoes) {
        
        if (IsSafeString(photo.thumbnail_image)) {
            rect.origin.x += offsetX;
            UIView *v = [[UIView alloc] initWithFrame:rect];
            
            CGRect innerRect = CGRectMake(0, 0, 65 , 65);
            UIImageView *bkV = [[UIImageView alloc] initWithFrame:innerRect];
            [bkV setImage:[UIImage imageNamed:@"storePicBK"]];
            [v addSubview:bkV];
            WSImageView *imgV = [[WSImageView alloc] initWithFrame:CGRectInset(innerRect,1,1)];
            [imgV showUrl:[NSURL URLWithString:photo.thumbnail_image]];
            [imgV setTag:index];
            [imgV addTarget:self action:@selector(gotoPhotoPreviw:) forControlEvents:UIControlEventTouchUpInside];
            
            [v addSubview:imgV];
            
            [self.imgScrollV addSubview:v];
            
            offsetX = 8 + 65;
            index++;
        }
    }
    
    if (index < 4) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"storePicAdd"] forState:UIControlStateNormal];
        rect.origin.x += offsetX;
        [btn setFrame:rect];
        [btn addTarget:self action:@selector(updateIconClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.imgScrollV addSubview:btn];
        index++;
    }
    
    if (index < 3) {
        self.uploadLabel1.hidden = FALSE;
        self.uploadLabel2.hidden = FALSE;
    } else {
        self.uploadLabel1.hidden = TRUE;
        self.uploadLabel2.hidden = TRUE;
    }
}

-(void)updatePhoto:(UIImage*)img
{
    [self uploadPhoto:img];
    [self showNewPhoto:img];
}

-(void)showNewPhoto:(UIImage*)img
{
    
}

-(void)uploadPhoto:(UIImage*)img
{
    float rebrate = 320.0f / img.size.width ;
    img = [img scale:rebrate];
    
    BOOL hadAdded = FALSE;
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:4];
    for (int k = 0 ; k < 4; k++) {
        StoreUploadPhoto *uPhoto = [[StoreUploadPhoto alloc] init];
        uPhoto.name = [NSString stringWithFormat:@"p%d",k+1];
        if (self.iStorePhotoes && self.iStorePhotoes.count > k) {
            uPhoto.id =((StorePhotos*) self.iStorePhotoes[k]).id;
            uPhoto.image_data = nil;
        } else {
            if (!hadAdded) {
                hadAdded = TRUE;
                uPhoto.id = @"0";
                NSData *postData = UIImageJPEGRepresentation(img, 0.5);
                uPhoto.image_data = [postData base64EncodedString];
            } else {
                uPhoto.id = @"0";
                uPhoto.image_data = nil;
            }
        }
        [array addObject:uPhoto];
    }
    
    [GSStoreService uploadStorePhotoes:self.iStore.id  photes:array succ:^(NSArray *array) {
        self.iStorePhotoes = [NSMutableArray arrayWithArray:array];
        [self showPhotoes];
        [self.photoUploadCtrller.view removeFromSuperview];
        self.photoUploadCtrller =nil;
    } fail:^(NSError *err) {
        [GS_GlobalObject showPopup:err.localizedDescription];
        [self.photoUploadCtrller.view removeFromSuperview];
        self.photoUploadCtrller =nil;
    }processHandler:^(double process) {
        [self.photoUploadCtrller.progressView setProgress:process];
        NSLog(@"%f",process);
    } ];
    
}


-(void)showTipDialog:(NSString*)title
{
       MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithWindow:APP_WINDOW];
        [self.view addSubview:HUD];
        HUD.labelText = title;
        HUD.mode = MBProgressHUDModeText;
        HUD.animationType = MBProgressHUDAnimationZoomIn;
        //指定距离中心点的X轴和Y轴的偏移量，如果不指定则在屏幕中间显示
        //    HUD.yOffset = 150.0f;
        //    HUD.xOffset = 100.0f;
        
        [HUD showAnimated:YES whileExecutingBlock:^{
            sleep(2);
        } completionBlock:^{
            [HUD removeFromSuperview];
        }];  

}

-(void)scanQR
{
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMask(UIInterfaceOrientationPortrait);
    reader.showsZBarControls = FALSE;
    reader.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    ZBarImageScanner *scanner = reader.scanner;
    GS_QRScanController *vc = [[GS_QRScanController alloc ] initNibWithStyle:WS_ViewStyleWithNavBar];
    reader.cameraOverlayView = vc.view;
    self.cameroOverlayViewController = vc;
    vc.delegate = self;
    
    CGRect r =CGRectMake(vc.scanView.frame.origin.y/vc.view.frame.size.height, 1-(vc.scanView.frame.origin.x + vc.scanView.frame.size.width)/APP_FRAME.size.width, vc.scanView.frame.size.height/vc.view.frame.size.height, vc.scanView.frame.size.width/vc.view.frame.size.width);
    reader.scanCrop = r;
    
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];

    showModalViewCtroller(self, reader, YES);
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"gToken"]) {
        
        
        self.iStoreList =  [GSStoreService getStoreInfo:[GS_GlobalObject GS_GObject].ownIdInfo.id refreshed:FALSE succ:^(NSArray* storeArray){
            self.iStoreList = storeArray;
            self.iStore = [self.iStoreList objectAtIndex:0];
            [GS_GlobalObject GS_GObject].iStore = self.iStore;
            [self refreshPhotoes];

            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_STORE_UPDATE object:self.iStore];
            [self refreshSelf];
        }fail:nil];
    
        [[GS_GlobalObject GS_GObject] removeObserver:self forKeyPath:@"gToken"];
    }
}

#pragma mark -
#pragma mark Zbar delegate -
-(void)scanCancel
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void) readerControllerDidFailToRead: (ZBarReaderController*) reader
                             withRetry: (BOOL) retry
{
    [GS_GlobalObject showPopup:@"无法识别的二维码"];
}

- (void) qrScanResult: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    
    //    UIImage *image =
    //    [info objectForKey: UIImagePickerControllerOriginalImage];
    
    NSLog(@"QR Scan Success");
    
    
    //判断是否包含 头'http:'
    NSString *regex = @"HTTP+:[^\\s]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    NSString *itune = @"itms-apps+:[^\\s]*";
    NSPredicate *itunePre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",itune];
    
    NSString *itune_ex = @"itms+:[^\\s]*";
    NSPredicate *itunePre_ex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",itune_ex];
    
    //判断是否包含 头'ssid:'
    NSString *ssid = @"SSID+:[^\\s]*";;
    NSPredicate *ssidPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ssid];
    
    NSString *txt =  symbol.data ;
    self.qrStr = [txt uppercaseString];
    
    if ([predicate evaluateWithObject:self.qrStr] || [itunePre_ex evaluateWithObject:self.qrStr] || [itunePre evaluateWithObject:self.qrStr]) {
        
        //贵客标志检测
        NSString *gkRegex = [NSString stringWithFormat:@"%@+[^\\s]*",[GK_QRTAG uppercaseString]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",gkRegex];
        
        if ([predicate evaluateWithObject:self.qrStr]) {
            [reader dismissModalViewControllerAnimated: YES];

            if ([self.qrStr hasPrefix:[GK_STORE_TAG uppercaseString]]) {

                [GS_GlobalObject showPopup:@"好友功能尚未开放，敬请期待"];
            } else if([self.qrStr hasPrefix:[GK_CUSTOMER_TAG uppercaseString]]) {
                NSString *userId =  [self.qrStr substringFromIndex:GK_CUSTOMER_TAG.length];
                [GSStoreService scan:userId withStore:self.iStore.id success:^(NSObject *obj){
//                    [GS_GlobalObject showPopup:@"验证成功"];
                    [self showTipDialog:@"    验证成功    "];
                    AudioServicesPlaySystemSound(1108);
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                    self.iStore = (StoreInfo*)obj;
                    [self refreshSelf];
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_STORE_REFRESH object:self.iStore];
                }fail:^(NSError *err){

                    [GS_GlobalObject showPopup:@"认证失败，请重新扫描"];
                }];
//                [self focusStore:storeId];

            } else {
                [GS_GlobalObject showPopup:@"不支持的二维码格式"];
            }
            
        } else {
            [reader dismissModalViewControllerAnimated: YES];

            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil
                                                            message:@"确定调用浏览器以访问一个外部地址么？"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
            alert.tag=1;
            [alert show];
        }
 
    }
    else if([ssidPre evaluateWithObject:self.qrStr]){
        [reader dismissModalViewControllerAnimated: YES];

        NSArray *arr = [txt componentsSeparatedByString:@";"];
        
        NSArray * arrInfoHead = [[arr objectAtIndex:0] componentsSeparatedByString:@":"];
        
        NSArray * arrInfoFoot = [[arr objectAtIndex:1] componentsSeparatedByString:@":"];
        
        
        txt=
        [NSString stringWithFormat:@"ssid: %@ \n password:%@",
         [arrInfoHead objectAtIndex:1],[arrInfoFoot objectAtIndex:1]];
        
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:txt
                                                        message:@"密码已经复制，你可以粘贴在任何你想要使用的地方"
                                                       delegate:self
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:@"nil", nil];
        
        alert.tag=2;
        [alert show];
        
        UIPasteboard *pasteboard=[UIPasteboard generalPasteboard];
        //        然后，可以使用如下代码来把一个字符串放置到剪贴板上：
        pasteboard.string = [arrInfoFoot objectAtIndex:1];
        

    } else {
        [reader dismissModalViewControllerAnimated: YES];

        //显示文本信息
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil
                                                        message:txt
                                                       delegate:self
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:nil];
        
        alert.tag=3;
        [alert show];

    }
}


#pragma mark -
#pragma mark alert View delegate -
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:  //确定
            
            if ([self.qrStr rangeOfString:[@"itunes.apple.com/gb/app" uppercaseString]].length == 0) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.qrStr]];
            } else {
                NSString *url;
                if ([self.qrStr hasPrefix:[@"http:" uppercaseString]]) {
                    url = [self.qrStr stringByReplacingOccurrencesOfString:@"HTTP:" withString:@"items:"];
                } else {
                    url = self.qrStr;
                }
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            }
            
            
            break;
        default:
            break;
    }
}
#pragma mark -
#pragma mark action sheet delegate -
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == HEADER_ICON_SHEET_TAG){
        switch (buttonIndex) {
            case ACTION_TakePicture:
                self.imgPicker.allowsEditing = NO;
                self.imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                
                [self presentViewController:self.imgPicker animated:YES completion:nil];
                break;
            case ACTION_SelPicture:
            {
                self.imgPicker.allowsEditing = NO;
                self.imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                
                [self presentViewController:self.imgPicker animated:YES completion:nil];
            }
                break;
            default:
                break;
        }
    }
    
}
#pragma mark -
#pragma mark phone picker delegate -

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (self.imgPicker == picker && !self.isPickStorePhotoes) {
        UIImage *img = [[info objectForKey:UIImagePickerControllerOriginalImage] fixOrientation];
        
        //  GKImgCroperViewController *vc = [[GKImgCroperViewController alloc ] initWithNibName:@"GKImgCroperViewController" bundle:nil];
        
        GKImgCroperViewController *vc = [[GKImgCroperViewController alloc] initWithImg:img];
        vc.delegate = self;
        //  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
        
        //   [self presentViewController:navigationController animated:YES completion:nil];
        //    [self dismissModalViewControllerAnimated:YES];
        // [self.navigationController pushViewController:vc animated:YES];
        [self dismissViewControllerAnimated:NO completion:^{
            showModalViewCtroller(self, vc, YES);
        }];
        
     //   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateIcon:) name:NOTIFICATION_SELECT_PIC object:nil];
    } else if(self.imgPicker == picker){
        UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage] ;
        [self dismissViewControllerAnimated:NO completion:^{
      //      [self showMaskView:nil];
            self.photoUploadCtrller = [[GSPhotoUploadCtrller alloc] initWithImg:img];
     //       vc.view.center = APP_WINDOW.center;
            [APP_WINDOW addSubview:self.photoUploadCtrller.view];
       //     [self uploadPhoto:img];
        }];
        

   //     [self updatePhoto:img];
    }else {
      //  picker.sourceType =    UIImagePickerControllerSourceTypeCamera;
        [self qrScanResult:picker didFinishPickingMediaWithInfo:info];
    }
}
    
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_SELECT_PIC object:nil];
    [self dismissModalViewControllerAnimated:YES];
}

-(void)saveImage:(UIImage *)img
{
    self.updatedImg = img;
    //    self.bannerImgV.defaultImg = img;
    [self.bannerImgV showDefaultImg:img];
    
    [GS_GlobalObject showPopup:@"正在保存商店形象图片"];
    UIImage *uploadImg = [self.updatedImg scaleToSize:CGSizeMake(128, 128)];
    
    [GSStoreService updateHeadIcon:uploadImg storeID:self.iStore.id success:^(NSObject *obj){
        self.iStore = (StoreInfo*)obj;
        //  [self refreshSelf];
        self.updatedImg = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_STORE_UPDATE object:self.iStore];
        [GS_GlobalObject showPopup:@"保存成功"];
        
    }fail:^(NSError *err){
        [GS_GlobalObject showPopup:@"保存失败，请稍候再试"];
        
    }];
}
@end
