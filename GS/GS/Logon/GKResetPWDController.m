//
//  GKResetPWDController.m
//  GK
//
//  Created by W.S. on 13-5-23.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GKResetPWDController.h"
#import "GSLogonService.h"
#import "GS_GlobalObject.h"

#define ResetGetValidateCodeOKTip @"验证码已发送，请注意查收"
#define ResetOKTip @"修改密码成功"
#define LogonTipForFormatError @"输入错误，请重新输入"

@interface GKResetPWDController ()

@end

@implementation GKResetPWDController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        CGRect rect = self.backgroundView.frame;
//        rect.size.height -= 44;
//        [self.backgroundView setFrame:rect];
        
//        UIColor *bgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"logon_bg"]];
//        self.backgroundView.backgroundColor = bgColor;


    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavTitle:@"重设密码"];
    [self addBackItem:@"返回" action:nil] ;
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setPhoneField:nil];
    [self setPwdField:nil];
    [self setValieCodeField:nil];
    [self setValidateCodeBtn:nil];
    [self setContentView:nil];
    [super viewDidUnload];
}

- (IBAction)valiedateCodeBtnClick:(id)sender {
    NSString *phone =  self.phoneField.text;
    if(checkMobileNo(phone)){
        self.validateCodeBtn.enabled = FALSE;

        [GSLogonService GetVerifyCode:phone success:^(void){
            [GS_GlobalObject showPopup:ResetGetValidateCodeOKTip];
            [NSTimer scheduledTimerWithTimeInterval:60.0f target:self selector:@selector(enabledValideCodeBtn) userInfo:nil repeats:NO];
        }fail:^(NSError *err){
            [GS_GlobalObject showPopup:err.localizedDescription];
            self.validateCodeBtn.enabled = TRUE;

        }];
    } else {
        [GS_GlobalObject showPopup:@"请输入注册手机号"];
    }
}

- (IBAction)logonBtnClick:(id)sender {
    
    if(checkMobileNo(self.phoneField.text) && checkPWD(self.pwdField.text) && checkPWD(self.valieCodeField.text))
    {
        iStatus = WS_ViewStatus_Getting;
        [NSTimer scheduledTimerWithTimeInterval:0.26f target:self selector:@selector(showWatting) userInfo:nil repeats:NO];
        [GSLogonService UpdatePWD:self.phoneField.text verifyCode:self.valieCodeField.text npwd:self.pwdField.text success:^(NSObject *obj){
            iStatus = WS_ViewStatus_Normal;
            [self hideWaitting];
            [GS_GlobalObject showPopup:ResetOKTip];
            resetOK = true;
            [NSTimer scheduledTimerWithTimeInterval:0.26f target:self selector:@selector(goback) userInfo:nil repeats:NO];
        }fail:^(NSError *err){
            iStatus = WS_ViewStatus_GetFail;
            [self hideWaitting];
            [GS_GlobalObject showPopup:err.localizedDescription];
            
        }];
    } else {
        [GS_GlobalObject showPopup:LogonTipForFormatError];
    }

}


#pragma mark -
#pragma mark inside normal function -
-(void)enabledValideCodeBtn
{
    self.validateCodeBtn.enabled = TRUE;
}
//-(void)goback
//{
//    if (resetOK) {
//        NSArray *viewControls = self.navigationController.viewControllers;
//        
//        [self.navigationController popToViewController:[viewControls objectAtIndex:(viewControls.count - 2)] animated:YES];
//    } else {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}

#pragma mark -
#pragma mark text field delegate -
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (!textField.inputAccessoryView) {
        CInputAssistViewStyle style = CInputAssistViewNextHide;
        if (textField == self.valieCodeField) {
            style = CInputAssistViewPerDoneHide;
        } else if (textField == self.pwdField){
            style = CInputAssistViewPerNextHide;
        }
        textField.inputAccessoryView = [CInputAssistView createWithDelegate:self target:textField style:style];
    }
    
    focusField = textField;
    
    return TRUE;
}


-(void)closeKeyPad:(id)sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    tap.cancelsTouchesInView = FALSE;
    
    if ([focusField isKindOfClass:[UITextField class]]) {
        [focusField resignFirstResponder];
        focusField = nil;
    }
}

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
    if (aTextFiled == self.valieCodeField) {
        [self.pwdField becomeFirstResponder];
    } else {
        [self.phoneField becomeFirstResponder];
    }
}

-(void)inputAssistViewNextTapped:(UITextField*)aTextFiled
{
    if (aTextFiled == self.phoneField) {
        [self.pwdField becomeFirstResponder];
    } else {
        [self.valieCodeField becomeFirstResponder];
    }
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
