//
//  GKViewController.m
//  GK
//
//  Created by apple on 13-4-7.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GKViewController.h"
#import "UMSocialIconActionSheet.h"
#import "ZBarSDK.h"
#import "Constants.h"

@interface GKViewController ()

@end



@implementation GKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)shareTest:(id)sender {
//    [UMSocialData setAppKey:@"5163c13d56240b6c6700315c"];
//    UMSocialIconActionSheet *iconActionSheet = [[UMSocialControllerService defaultControllerService] getSocialIconActionSheetInController:self];
//    iconActionSheet.snsNames = [NSArray arrayWithObject:UMShareToSina];
//    
//    UIViewController *rootViewController = [[[UIApplication sharedApplication] delegate] window].rootViewController;
//    [iconActionSheet showInView:rootViewController.view];
            
    [UMSocialSnsService presentSnsController:self appKey:@"5163c13d56240b6c6700315c" shareText:@"test" shareImage:nil shareToSnsNames:[NSArray arrayWithObject:UMShareToSina] delegate:self];
    
}

- (IBAction)rdAccountLogon:(id)sender {
    
    UIViewController *vc =  [[UMSocialControllerService defaultControllerService] getSocialOauthController:UMShareToSina];
    [UMSocialData setAppKey:@"5163c13d56240b6c6700315c"];

    if (IOS_VERSION > 6.0) {
        [self presentViewController:vc animated:YES completion:nil];
    }else {
        [self presentModalViewController:vc animated:YES];
    }
}

- (IBAction)accountInfo:(id)sender {
   // [UMSocialDataService defaultDataService] requestSnsInformation:<#(NSString *)#> completion:<#^(UMSocialResponseEntity *response)completion#>
    NSDictionary *dict =  [UMSocialData defaultData].socialAccount;
  //  NSLog(dict);
}

- (IBAction)accountConfig:(id)sender {

    UIViewController *vc = [[UMSocialControllerService defaultControllerService] getSnsAccountController];
    if (IOS_VERSION > 6.0) {
        [self presentViewController:vc animated:YES completion:nil];
    }else {
        [self presentModalViewController:vc animated:YES];
    }
    [[UMSocialDataService defaultDataService] requestBindToSnsWithType:UMShareToSina completion:nil];
    
}

- (IBAction)scanQR:(id)sender {
    
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    [self presentModalViewController: reader
                            animated: YES];

}

- (IBAction)unBind:(id)sender {
    [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:^(UMSocialResponseEntity *response){
        NSLog(@"response is %@",response);
    }];
}

#pragma mark -
#pragma mark Zbar delegate -
- (void) readerControllerDidFailToRead: (ZBarReaderController*) reader
                             withRetry: (BOOL) retry
{
    NSLog(@"readerControllerDidFailToRead");
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    
//    UIImage *image =
//    [info objectForKey: UIImagePickerControllerOriginalImage];
    
    [reader dismissModalViewControllerAnimated: YES];
    
    //判断是否包含 头'http:'
    NSString *regex = @"http+:[^\\s]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    //判断是否包含 头'ssid:'
    NSString *ssid = @"ssid+:[^\\s]*";;
    NSPredicate *ssidPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ssid];
    
    NSString *txt =  symbol.data ;
    
    if ([predicate evaluateWithObject:txt]) {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil
                                                        message:@"It will use the browser to this URL。"
                                                       delegate:nil
                                              cancelButtonTitle:@"Close"
                                              otherButtonTitles:@"Ok", nil];
        alert.delegate = self;
        alert.tag=1;
        [alert show];
        
        
        
    }
    else if([ssidPre evaluateWithObject:txt]){
        
        NSArray *arr = [txt componentsSeparatedByString:@";"];
        
        NSArray * arrInfoHead = [[arr objectAtIndex:0] componentsSeparatedByString:@":"];
        
        NSArray * arrInfoFoot = [[arr objectAtIndex:1] componentsSeparatedByString:@":"];
        
        
        txt=
        [NSString stringWithFormat:@"ssid: %@ \n password:%@",
         [arrInfoHead objectAtIndex:1],[arrInfoFoot objectAtIndex:1]];
        
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:txt
                                                        message:@"The password is copied to the clipboard , it will be redirected to the network settings interface"
                                                       delegate:nil
                                              cancelButtonTitle:@"Close"
                                              otherButtonTitles:@"Ok", nil];
        
        
        alert.delegate = self;
        alert.tag=2;
        [alert show];
               
        UIPasteboard *pasteboard=[UIPasteboard generalPasteboard];
        //        然后，可以使用如下代码来把一个字符串放置到剪贴板上：
        pasteboard.string = [arrInfoFoot objectAtIndex:1];
        
        
    } else {
        //显示文本信息
    
    }
}

#pragma mark -
#pragma mark alert View delegate -
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{}
- (void)alertViewCancel:(UIAlertView *)alertView
{}
@end
