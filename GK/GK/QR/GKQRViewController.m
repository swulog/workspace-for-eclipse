//
//  GKQRViewController.m
//  GK
//
//  Created by apple on 13-4-14.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GKQRViewController.h"
#import "GlobalObject.h"
#import "GKQRScanController.h"
#import "GKStoreSortListService.h"
#import "GKLogonCtroller.h"


@interface GKQRViewController ()
@property (nonatomic,strong) GKQRScanController *cameroOverlayViewController;
//@property (nonatomic,strong) ZBarReaderViewController *qrScanViewController;
@end

@implementation GKQRViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil style:VIEW_WITH_NAVBAR];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil needTab:(BOOL)nEedTab closeStyle:(QRCloseStyle)style
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil style:VIEW_WITH_NAVBAR];
    if (self) {
        // Custom initialization
        self.isTab = nEedTab;
        self.clsoeStyle = style;
//        if (self.isTab) {
//            self.tabImageName = [NSString stringWithUTF8String:tabImgNames[GKTAB_QR]];
//          //  self.tabTitle = [NSString stringWithUTF8String:tabTitles[GKTAB_QR]];
//        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"二维码"];
    
    if (!self.isTab) {
        if (self.clsoeStyle == QRCloseStyle_DismissDown) {
            [self addBackItemWithCloseImg:nil];
        } else {
            [self addBackItem];
        }
    }
    
    [[UILabelWithQRView appearance] setTextColor:colorWithUtfStr(StoreInfoC_TopStatusTitleColor)];
    self.nameLabel.textColor = colorWithUtfStr(StoreInfoC_TableCellTitleColor);
    self.nameLabel.text = [GlobalDataService userName];
    
    self.scanBtn.backgroundColor = colorWithUtfStr(PersonalCenterC_BtnBGColor);
    [self.scanBtn setTitleColor:colorWithUtfStr(QRC_BtnTitleColor) forState:UIControlStateNormal];
    [self.scanBtn setHightedBGColor:colorWithUtfStr(PersonalCenterC_BtnSelectedColor)];
    
    [self showQRImg];
}

- (void)viewDidUnload {
    
    [self setQrImgV:nil];
    [super viewDidUnload];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)scanClick:(id)sender {
    [self scanQR];
}

-(void)scanQR
{
#if  1
    if (!self.cameroOverlayViewController) {
        GKQRScanController *vc = [[GKQRScanController alloc ] initWithNibName:@"GKQRScanController" bundle:nil];
        self.cameroOverlayViewController = vc;
        vc.readerDelegate = self;
    }

    [self presentFullViewController:self.cameroOverlayViewController animated:YES completion:nil];
#else
    if (!self.qrScanViewController) {
        ZBarReaderViewController *reader = [ZBarReaderViewController new];
        reader.readerDelegate = self;
        reader.supportedOrientationsMask = ZBarOrientationMaskAll;
        reader.showsZBarControls = FALSE;
        ZBarImageScanner *scanner = reader.scanner;
        
        GKQRScanController *vc = [[GKQRScanController alloc ] initWithNibName:@"GKQRScanController" bundle:nil];
        reader.cameraOverlayView = vc.view;  //[self setOverlayPickerView];
        CGRect r =CGRectMake(vc.scanView.frame.origin.y/vc.view.frame.size.height, 1-(vc.scanView.frame.origin.x + vc.scanView.frame.size.width)/320., vc.scanView.frame.size.height/vc.view.frame.size.height, vc.scanView.frame.size.width/vc.view.frame.size.width);
        reader.scanCrop = r;
        self.cameroOverlayViewController = vc;
        [scanner setSymbology: ZBAR_I25
                       config: ZBAR_CFG_ENABLE
                           to: 0];
        
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        reader.wantsFullScreenLayout = FALSE;
        self.qrScanViewController = reader;
    }

    [self presentFullViewController:self.qrScanViewController animated:YES completion:nil];
#endif
//    [APP_DELEGATE.window.rootViewController presentViewController: reader animated: YES completion:nil];
 //   [self presentFullScreenViewController:reader animated:YES completion:nil];

}

#pragma mark -
#pragma mark inside functiom -


-(void)focusStore:(NSString*)_storeId
{
    self.status = VIEW_PROCESS_GETTING;
    [NSTimer scheduledTimerWithTimeInterval:CMM_AnimatePerior target:self selector:@selector(showWatting) userInfo:nil repeats:NO];
    
    [GKStoreSortListService focusStore:_storeId isFocus:FALSE success:^(void){
        AudioServicesPlaySystemSound(1108);
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        self.status = VIEW_PROCESS_NORMAL;
        [self hideWaitting];
        
        [GlobalObject showPopup:@"关注成功"];
        if (!self.isTab) {
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_StoreFocus object:_storeId];
        }
    }fail:^(NSError *err){
        self.status = VIEW_PROCESS_NORMAL;
        [self hideWaitting];
        
        [GlobalObject showPopup:err.localizedDescription];
    }];
}


-(void)showQRImg
{
    NSString *userUID = [GlobalDataService userGKUId];
    NSString *gkUserQRStr = [NSString stringWithFormat:GK_CUSTOMER_TAG @"%@",userUID];
    
    self.qrImgV.image = [QRCodeGenerator qrImageForString:gkUserQRStr imageSize:self.qrImgV.bounds.size.width];
}

#pragma mark -
#pragma mark Zbar delegate -
- (void) readerControllerDidFailToRead: (ZBarReaderController*) reader
                             withRetry: (BOOL) retry
{
    [GlobalObject showPopup:@"无法识别的二维码"];
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    
    NSLog(@"QR Scan Success");
    
    [reader dismissViewControllerAnimated:YES completion:nil];
    
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
            if ([self.qrStr hasPrefix:[GK_STORE_TAG uppercaseString]]) {
                NSString *storeId =  [self.qrStr substringFromIndex:GK_STORE_TAG.length];
                [self focusStore:storeId];
            } else if([self.qrStr hasPrefix:[GK_CUSTOMER_TAG uppercaseString]]) {
                [GlobalObject showPopup:@"好友功能尚未开放，敬请期待"];
            } else {
                NSLog(@"不支持的二维码格式");
                [GlobalObject showPopup:@"不支持的二维码格式"];
            }
            
        } else {
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
            
            if ([self.qrStr rangeOfString:[@"itunes.apple.com/" uppercaseString]].length == 0) {
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


@end
@implementation UILabelWithQRView

@end