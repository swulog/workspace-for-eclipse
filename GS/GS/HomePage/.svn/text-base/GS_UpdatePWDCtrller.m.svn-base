//
//  UpdatePWDController.m
//  GK
//
//  Created by W.S. on 13-5-27.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GS_UpdatePWDCtrller.h"
#import "GS_GlobalObject.h"
#import "GSLogonService.h"
//#import "GlobalObject.h"
//#import "GKLogonService.h"

@interface GS_UpdatePWDCtrller ()

@end

#define Owner_UpdatePWD_FormatError_Tip @"密码格式不正确，请重新输入"
#define Owner_UpdatePWD_PWDUnmatched_Tip @"旧密码不正确，请重新输入"
#define Owner_UpdatePWD_PWDNotModified_Tip @"没有改变，请重新输入"
#define Owner_UpdatePWD_OK_Tip @"修改成功"

@implementation GS_UpdatePWDCtrller

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

    [self setNavTitle:@"修改密码"];
    [self addBackItem:@"返回" action:nil];

//    UIColor *bgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"logon_bg"]];
//    self.backgroundView.backgroundColor = bgColor;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setOldPwdField:nil];
    [self setUpdatedPwdField:nil];
    [super viewDidUnload];
}
#pragma mark -
#pragma mark inside normal function -
- (IBAction)updatePWDClick:(id)sender {
    NSString *tipStr = nil;
    
    while (1) {
        //检查密码格式
        if (!checkPWD(self.oldPwdField.text)) {
            tipStr = Owner_UpdatePWD_FormatError_Tip;
            break;
        }
        
        if (!checkPWD(self.updatedPwdField.text)) {
            tipStr = Owner_UpdatePWD_FormatError_Tip;
            break;
        }
        
        if(![self.oldPwdField.text isEqualToString:[GS_GlobalObject GS_GObject].ownIdInfo.gspwd]){
            tipStr = Owner_UpdatePWD_PWDUnmatched_Tip;
            break;
        }
        
        if ([self.oldPwdField.text isEqualToString:self.updatedPwdField.text]) {
            tipStr = Owner_UpdatePWD_PWDNotModified_Tip;
            break;
        }
        
        break;
    }
    
    if (tipStr) {
        [GS_GlobalObject showPopup:tipStr];
    } else {
        iStatus = WS_ViewStatus_Getting;
        self.updateBtn.enabled = FALSE;
        [NSTimer scheduledTimerWithTimeInterval:0.26f target:self selector:@selector(showWatting) userInfo:nil repeats:NO];
        
        [GSLogonService UpdatePWD:[GS_GlobalObject GS_GObject].ownIdInfo.gsId verifyCode:[GS_GlobalObject GS_GObject].ownIdInfo.gspwd npwd:self.updatedPwdField.text success:^(NSObject *obj){
            iStatus = WS_ViewStatus_Normal;
            [self hideWaitting];
            
            self.updateBtn.enabled = TRUE;
            [GS_GlobalObject showPopup:Owner_UpdatePWD_OK_Tip];
            [NSTimer scheduledTimerWithTimeInterval:0.26f block:^(NSTimeInterval time){
                [self goback];
            }repeats:NO];
        }fail:^(NSError *err){
            iStatus = WS_ViewStatus_GetFail;
            [self hideWaitting];
            
            self.updateBtn.enabled = TRUE;
            [GS_GlobalObject showPopup:err.localizedDescription];
        }];
    }
}

#pragma mark -
#pragma mark uitextfield delegate -

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    if (textField == self.oldPwdField) {
//        [self.updatedPwdField becomeFirstResponder];
//        return FALSE;
//    }
    [textField resignFirstResponder];
    return true;
}
@end
