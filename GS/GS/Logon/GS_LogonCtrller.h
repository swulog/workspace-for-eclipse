//
//  GS_LogonCtrller.h
//  GS
//
//  Created by W.S. on 13-6-4.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WS_BaseViewController.h"
#import "SSCheckBoxView.h"
@protocol LogonDelegate;

@interface GS_LogonCtrller : WS_BaseViewController
{
    UIView *focusField;
}
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UITextField *mobileField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (assign,nonatomic) id<LogonDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *checkBoxView;
@property (strong,nonatomic) SSCheckBoxView *checkBox;

- (IBAction)logonClick:(id)sender;
- (IBAction)forgotClick:(id)sender;
- (IBAction)registerClick:(id)sender;


@end
@protocol  LogonDelegate <NSObject>

@optional
-(void)logonOK;

@end