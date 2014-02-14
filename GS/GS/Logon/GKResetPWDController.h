//
//  GKResetPWDController.h
//  GK
//
//  Created by W.S. on 13-5-23.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "CInputAssistView.h"
#import "WS_BaseViewController.h"

@interface GKResetPWDController : WS_BaseViewController<CInputAssistViewDelgate>
{
    UIView *focusField;

    BOOL resetOK;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UITextField *valieCodeField;

@property (weak, nonatomic) IBOutlet UIButton *validateCodeBtn;
@property (weak, nonatomic) IBOutlet UIView *contentView;

- (IBAction)valiedateCodeBtnClick:(id)sender;

- (IBAction)logonBtnClick:(id)sender;

@end
