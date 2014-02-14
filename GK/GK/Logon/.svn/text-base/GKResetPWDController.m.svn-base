//
//  GKResetPWDController.m
//  GK
//
//  Created by W.S. on 13-5-23.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GKResetPWDController.h"
#import "GKLogonService.h"
#import "GlobalObject.h"

#define ResetGetValidateCodeOKTip @"验证码已发送，请注意查收"
#define ResetOKTip @"修改密码成功"
#define LogonTipForFormatError @"输入错误，请重新输入"

@interface GKResetPWDController ()

@end

@implementation GKResetPWDController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil style:VIEW_WITH_NAVBAR];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"找回密码"];
    [self addBackItem:nil img:nil action:@selector(goback)];
    
    self.validateCodeBtn.backgroundColor = colorWithUtfStr(ResetPWDC_BtnBGColor);
    self.logonBtn.backgroundColor = colorWithUtfStr(ResetPWDC_BtnBGColor);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (isRetina_640X960) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (isRetina_640X960) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    }
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

        [GKLogonService GetVerifyCode:phone success:^(void){
            [GlobalObject showPopup:ResetGetValidateCodeOKTip];
            [NSTimer scheduledTimerWithTimeInterval:60.0f target:self selector:@selector(enabledValideCodeBtn) userInfo:nil repeats:NO];
        }fail:^(NSError *err){
            [GlobalObject showPopup:err.localizedDescription];
            self.validateCodeBtn.enabled = TRUE;

        }];
    } else {
        [GlobalObject showPopup:@"请输入注册手机号"];
    }

}

- (IBAction)logonBtnClick:(id)sender {
    
    if(checkMobileNo(self.phoneField.text) && checkPWD(self.pwdField.text) && checkPWD(self.valieCodeField.text))
    {
        self.status = VIEW_PROCESS_GETTING;
        [NSTimer scheduledTimerWithTimeInterval:CMM_AnimatePerior target:self selector:@selector(showWatting) userInfo:nil repeats:NO];
        [GKLogonService UpdatePWD:self.phoneField.text verifyCode:self.valieCodeField.text npwd:self.pwdField.text success:^(NSObject *obj){
            self.status = VIEW_PROCESS_NORMAL;
            [self hideWaitting];
            [GlobalObject showPopup:ResetOKTip];
            resetOK = true;
            [NSTimer scheduledTimerWithTimeInterval:CMM_AnimatePerior target:self selector:@selector(goback) userInfo:nil repeats:NO];
        }fail:^(NSError *err){
            self.status = VIEW_PROCESS_FAIL;
            [self hideWaitting];
            [GlobalObject showPopup:err.localizedDescription];
            
        }];
    } else {
        [GlobalObject showPopup:LogonTipForFormatError];
    }
}


#pragma mark -
#pragma mark inside normal function -
-(void)enabledValideCodeBtn
{
    self.validateCodeBtn.enabled = TRUE;
}

-(void)goback
{
    if (self.navigationController) {
        if (resetOK) {
            NSArray *viewControls = self.navigationController.viewControllers;
            
            [self.navigationController popToViewController:[viewControls objectAtIndex:(viewControls.count - 2)] animated:YES];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark -
#pragma mark text field delegate -


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

    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        
        NSValue *keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];

        CGRect keyboardBounds;
        [keyboardBoundsValue getValue:&keyboardBounds];
        
        CGPoint point =  focusField.frame.origin;
        CGPoint absPoint = [focusField.superview convertPoint:point toView:nil];
        
        float diff = absPoint.y + focusField.frame.size.height - keyboardBounds.origin.y;
        CGRect rect = self.contentView.frame;
        rect.origin.y -= diff +7;

        if (diff > 0) {
            if (rect.origin.y > APP_NAVBAR_HEIGHT) {
                rect.origin.y = APP_NAVBAR_HEIGHT;
            }
        } else {
            if (rect.origin.y > APP_STATUSBAR_HEIGHT + APP_NAVBAR_HEIGHT) {
                rect.origin.y = APP_STATUSBAR_HEIGHT + APP_NAVBAR_HEIGHT;
            }
        }
        [UIView animateWithDuration:CMM_AnimatePerior animations:^{
            [self.contentView setFrame:rect];
        }completion:nil];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (isRetina_640X960) {
        if (!textField.inputAccessoryView) {
            CInputAssistViewStyle style = CInputAssistViewNextHide;
            if (textField == self.pwdField) {
                style = CInputAssistViewPerDoneHide;
            } else if (textField == self.valieCodeField){
                style = CInputAssistViewPerNextHide;
            }
            textField.inputAccessoryView = [CInputAssistView createWithDelegate:self target:textField style:style];
        }
    }
    
    focusField = textField;
    
    return TRUE;
}


-(void)inputAssistViewPerviousTapped:(UITextField*)aTextFiled
{
    if (aTextFiled == self.pwdField) {
        [self.valieCodeField becomeFirstResponder];
    } else {
        [self.phoneField becomeFirstResponder];
    }
}

-(void)inputAssistViewNextTapped:(UITextField*)aTextFiled
{
    if (aTextFiled == self.phoneField) {
        [self.valieCodeField becomeFirstResponder];
    } else {
        [self.pwdField becomeFirstResponder];
    }
}

-(void)inputAssistViewCancelTapped:(UITextField*)aTextFiled
{
    [aTextFiled resignFirstResponder];
}

-(void)inputAssistViewDoneTapped:(UITextField*)aTextFiled
{
    [aTextFiled resignFirstResponder];
    [self logonBtnClick:Nil];
}

@end
