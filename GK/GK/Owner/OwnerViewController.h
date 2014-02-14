//
//  OwnerViewController.h
//  GK
//
//  Created by W.S. on 13-5-7.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GKBaseViewController.h"
#import "GKLogonCtroller.h"
#import "Appheader.h"
#import <MessageUI/MessageUI.h>




@interface OwnerViewController : GKBaseViewController<GKLogonDelegate,UIActionSheetDelegate,MFMessageComposeViewControllerDelegate>{
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet WSImageView *iconImg;
@property (weak, nonatomic) IBOutlet WSLargeButton *favouriteBtn;
@property (weak, nonatomic) IBOutlet WSLargeButton *focusBtn;


- (IBAction)favouriteClick:(id)sender;
- (IBAction)focusClick:(id)sender;

//- (IBAction)btnTouchDown:(id)sender;
//- (IBAction)btnTouchUpOustSide:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *gkLogContrainView;
@property (strong, nonatomic) IBOutlet UIView *gkLogView;
@property (weak, nonatomic) IBOutlet WSLargeButton *gkLog_LogonBtn;
@property (weak, nonatomic) IBOutlet UIView *gkLog_LogonBtnDBK;
- (IBAction)logonClick:(id)sender;

@end
