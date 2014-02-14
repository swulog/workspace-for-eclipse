//
//  GS_LogonCtrller.m
//  GS
//
//  Created by W.S. on 13-6-4.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GS_LogonCtrller.h"
#import "GS_StoreDetailCtrller.h"
#import "GSLogonService.h"
#import "GS_GlobalObject.h"
#import "GKResetPWDController.h"
#import "TPCDivineAlertView.h"

#define LogonTipForFormatError @"手机号或密码输入错误"
#define LogonTipForLincense @"您必须接受贵客商户服务协议方可登录"
#define RegisterOKTip @"初始密码已通过短信发送到您的手机"// @"恭喜您已经成功注册为贵客用户"

@interface GS_LogonCtrller ()

@end

@implementation GS_LogonCtrller

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

    [self setNavTitle:@"贵客商户版"];
    
    self.checkBox = [[SSCheckBoxView alloc] initWithFrame:self.checkBoxView.frame style:kSSCheckBoxViewStyleGlossy checked:YES];
    [self.checkBox setText:@"接受贵客商户服务协议"];
    [self.checkBox setTextColor:[UIColor redColor]];

    [self.contentView addSubview:self.checkBox];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect rect = self.checkBox.frame;
    rect.origin.x += 30;
    rect.size.width -= 30;
    [btn setFrame:rect];
    [self.contentView addSubview:btn];
    [btn addTarget:self action:@selector(showLicense) forControlEvents:UIControlEventTouchUpInside];
                     
                     
    self.checkBoxView.backgroundColor = [UIColor clearColor];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCheckBoxView:nil];
    [self setMobileField:nil];
    [self setPwdField:nil];
    [self setRegisterBtn:nil];
    [self setContentView:nil];
    [super viewDidUnload];
}


-(void)viewWillAppear:(BOOL)animated
{
    
    if (IOS_VERSION < 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
    }else{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark -
#pragma mark event handler -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        self.checkBox.checked = TRUE;
    } else {
        self.checkBox.checked = FALSE;
    }
}

-(void)showLicense
{
    NSString *filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"License"];
    //NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSError *err;
    NSString *license =  [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&err];
    
    
    if (IOS_VERSION >= 7.0) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"贵客商户服务协议"
                              message:license
                              delegate:self
                              cancelButtonTitle:@"拒绝"
                              otherButtonTitles:@"接受", nil];
        [alert show];
        
    } else {
        
        TPCDivineAlertView *alert = [[TPCDivineAlertView alloc]
                                     initWithTitle:@"贵客商户服务协议"
                                     message:license
                                     delegate:self
                                     cancelButtonTitle:@"拒绝"
                                     otherButtonTitles:@"接受", nil];
        [alert setLandscapeOrientation:NO];
        [alert setFrame:CGRectMake(5, 5, 310, 400)];
        [alert show];
    }
    
    //    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"'贵客'优惠发布协议" message:@"我的收藏" delegate:self cancelButtonTitle:@"接受" otherButtonTitles:@"拒绝", nil];
    //    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    //    UITextField *textField = [alert textFieldAtIndex:0];
    //    textField.keyboardType = UIKeyboardTypeDefault;
    //    [alert addSubview:textField];
    //    [alert show];
    
    
}

- (IBAction)logonClick:(id)sender {
    
    if (!self.checkBox.checked) {
        [GS_GlobalObject showPopup:LogonTipForLincense];
        return;
    }
    
    if(checkMobileNo(self.mobileField.text) && checkPWD(self.pwdField.text))
    {
        iStatus = WS_ViewStatus_Getting;
        [NSTimer scheduledTimerWithTimeInterval:0.26f target:self selector:@selector(showWatting) userInfo:nil repeats:NO];
        
        [GSLogonService logon:self.mobileField.text pwd:self.pwdField.text succ:^(NSObject *obj){
            iStatus = WS_ViewStatus_Normal;
            [self hideWaitting];
            
            [WS_GlobalObject showPopup:@"登录成功，正在跳转..."];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(logonOK)]) {
                [self.delegate performSelector:@selector(logonOK)];
            }

        }fail:^(NSError *err){
            
            [WS_GlobalObject showPopup:err.localizedDescription];
            iStatus = WS_ViewStatus_GetFail;
            [self hideWaitting];

        }];
        
        } else {
        [GS_GlobalObject showPopup:LogonTipForFormatError];
    }

    

}

- (IBAction)forgotClick:(id)sender {
    GKResetPWDController *vc = [[GKResetPWDController alloc] initNibWithStyle:WS_ViewStyleWithNavBar];
    showModalViewCtroller(self, vc, YES);
//    if (self.navigationController) {
//        [self.navigationController pushViewController:vc animated:YES];
//    } else if(self.parentViewController.navigationController){
//        [self.parentViewController.navigationController pushViewController:vc animated:YES];
//        
//    }
}

- (IBAction)registerClick:(id)sender {
    NSString *phone =  self.mobileField.text;
    
    if(checkMobileNo(phone)){
        self.registerBtn.enabled = FALSE;

        [GSLogonService Register:phone success:^(void){
            [GS_GlobalObject showPopup:RegisterOKTip];
            self.registerBtn.enabled = FALSE;
            [NSTimer scheduledTimerWithTimeInterval:60.0f target:self selector:@selector(enabledRegister) userInfo:nil repeats:NO];
        }fail:^(NSError *err){
            [GS_GlobalObject showPopup:err.localizedDescription];
            self.registerBtn.enabled = TRUE;

        }];
    } else {
        [GS_GlobalObject showPopup:@"请输入手机号"];
    }

}

-(void)enabledRegister
{
    self.registerBtn.enabled = TRUE;
}
#pragma mark -
#pragma mark text field delegate -
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (!textField.inputAccessoryView) {
        CInputAssistViewStyle style = CInputAssistViewNextHide;
        if (textField == self.pwdField) {
            style = CInputAssistViewPerDoneHide;
        }
        textField.inputAccessoryView = [CInputAssistView createWithDelegate:self target:textField style:style];
    }
    
    focusField = textField;
    
    return TRUE;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//-(void)closeKeyPad:(id)sender
//{
//    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
//    tap.cancelsTouchesInView = FALSE;
//    
//    if ([focusField isKindOfClass:[UITextField class]]) {
//        [focusField resignFirstResponder];
//        focusField = nil;
//    }
//}

-(void)keyboardWillChangeFrame:(NSNotification *)notification
{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_2
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
#endif
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_3_2
        NSValue *keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
#else
        NSValue *keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardBoundsUserInfoKey];
#endif
        
        CGRect keyboardBounds;
        [keyboardBoundsValue getValue:&keyboardBounds];
        
        CGPoint point =  CGPointMake(focusField.frame.origin.x, focusField.frame.origin.y);
        CGPoint absPoint = [focusField.superview convertPoint:point toView:nil];
        
        float diff = absPoint.y + focusField.frame.size.height - keyboardBounds.origin.y;
        CGRect rect = self.contentView.frame;
        
        rect.origin.y -= diff +7;
        
            if (rect.origin.y > 44) {
                rect.origin.y = 44;
            }
                
        
        [UIView animateWithDuration:0.26f animations:^{
            [self.contentView setFrame:rect];
        }completion:^(BOOL isfinished){
            
        }];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_2
    }
#endif
}


-(void)keyboardWillHide:(NSNotification *)notification
{
#if 0
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    //CGPoint toPoint = self.scrollView.contentOffset;
    //toPoint.y -= scrollViewOffset;
    
    //CGPoint point = CGPointMake(focusField.frame.origin.x, focusField.frame.origin.y);
    //        CGPoint absPoint = [focusField.superview convertPoint:point toView:self.contentView];
    
    //      toPoint.y += absPoint.y;
    //     [self.scrollView setContentOffset:toPoint];
    
    [self resetSelf];
    
    CGRect rect = self.scrollView.frame;
    rect.origin.y = 0;
    
    [UIView animateWithDuration:0.26f animations:^{
        [self.scrollView setFrame:rect];
    }completion:^(BOOL isfinished){
        
    }];
    
#endif
    return;
    
}


-(void)inputAssistViewPerviousTapped:(UITextField*)aTextFiled
{
    [self.mobileField becomeFirstResponder];
}
-(void)inputAssistViewNextTapped:(UITextField*)aTextFiled
{
    [self.pwdField becomeFirstResponder];
}
-(void)inputAssistViewCancelTapped:(UITextField*)aTextFiled
{
    [aTextFiled resignFirstResponder];
}
-(void)inputAssistViewDoneTapped:(UITextField*)aTextFiled
{
    [aTextFiled resignFirstResponder];
}

@end
