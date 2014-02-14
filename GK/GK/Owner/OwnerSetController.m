//
//  OwnerSetControllerViewController.m
//  GK
//
//  Created by W.S. on 13-5-28.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "OwnerSetController.h"
#import "GlobalObject.h"

#import "HeadIconUpdateView.h"
#import "SetPWDEditCell.h"
#import "SetNickEditCell.h"
#import "SetSNSSelectCell.h"
#import "WSPopupView.h"
#import "SetAboutView.h"
#import "GKImgCroperViewController.h"
#import "MMProgressHUD.h"

typedef enum{
    Group0_Start,
    Field_HeadIcon = Group0_Start,
    Group0_Over,
    Group0_Num = Group0_Over - Group0_Start,
    
    Group1_Start = Group0_Over,
    Field_PWD = Group1_Start,
    Field_PWD_Edit,
    Field_NickName,
    Field_NickName_Edit,
    Group1_Over,
    Group1_Num = Group1_Over - Group1_Start,
    
    Group2_Start = Group1_Over,
    Field_SNS = Group2_Start,
    Field_SNS_Select,
    Group2_Over,
    Group2_Num = Group2_Over - Group2_Start,
    
    Group3_Start = Group2_Over,
    Field_CacheClear = Group3_Start,
    Field_HidePic,
    Field_About,
    Group3_Over,
    Group3_Num = Group3_Over - Group3_Start,
    
    Field_Over = Group3_Over
}Owner_Field;


enum {
    GROUP_HeadIconEdit,
    GROUP_UserInfoEdit,
    GROUP_SNSShareEdit,
    GROUP_SystemConfig,
    
    GROUP_Total
};

#define FieldHeight_HeadIcon 80
#define FieldHeight_PwdEdit 160
#define FieldHeight_NickEdit 110
#define FieldHeight_SNSSelect 70
#define TableDefailtRowHeight 40

#define Owner_Set_HiddenStorePIC_String  @"隐藏商家图片"

#define PhotoBtnTag 0
#define CameraBtnTag 1

#define Owner_UpdatePWD_FormatError_Tip @"密码格式不正确，请重新输入"
#define Owner_UpdatePWD_PWDUnmatched_Tip @"旧密码不正确，请重新输入"
#define Owner_UpdatePWD_PWDNotModified_Tip @"没有改变，请重新输入"

#define Set_UpdateNick_NameNillTip @"昵称不能为空"
enum{
    Edit_None,
    Edit_PWD,
    Edit_Name,
    Edit_SNS
};

static int nums[] = {Group0_Num,Group1_Num,Group2_Num,Group3_Num};

@interface OwnerSetController()
{
    MBProgressHUD *HUD ;
    NSInteger editStatus;
    double uplodeProgress;
}
@property (nonatomic,strong) UIView *editView;
@property (nonatomic,strong) WSPopupView *popAboutView;

@property (nonatomic,strong ) UIImagePickerController *imgPicker;
@property (nonatomic,strong) UIImage *selHeadIcon;

@end

@implementation OwnerSetController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil style:VIEW_WITH_NAVBAR];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"设置"];
    [self addBackItem];
    
    self.contentTable.backgroundView = nil;
    self.contentTable.backgroundColor = self.view.backgroundColor;
    
    if (IOS_VERSION >= 7.0) {
        [self.contentTable setContentInset:UIEdgeInsetsMake(-20, 0, 0, 0)];
    }
    
    self.contentTable.separatorColor = [UIColor whiteColor];
    //self.contentTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];

    HUD = nil;
    [self setContentTable:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark event handler -
- (IBAction)updatePWDClick:(id)sender {
    NSString *tipStr = nil;
    SetPWDEditCell *pwdEditView = (SetPWDEditCell*)self.editView;
    
    while (1) {
        //检查密码格式
        if (!checkPWD(pwdEditView.oldPWDField.text)) {
            tipStr = Owner_UpdatePWD_FormatError_Tip;
            break;
        }
        
        if (!checkPWD(pwdEditView.modifiedPwdField.text)) {
            tipStr = Owner_UpdatePWD_FormatError_Tip;
            break;
        }
        
        if(![pwdEditView.oldPWDField.text isEqualToString:[GlobalDataService userPwd]]){
            tipStr = Owner_UpdatePWD_PWDUnmatched_Tip;
            break;
        }
        
        if ([pwdEditView.oldPWDField.text isEqualToString:pwdEditView.modifiedPwdField.text]) {
            tipStr = Owner_UpdatePWD_PWDNotModified_Tip;
            break;
        }
        
        break;
    }
    
    if (tipStr) {
        [self showTopPop:tipStr];
    } else {
        pwdEditView.saveBtn.enabled = FALSE;

        self.status = VIEW_PROCESS_GETTING;
        [NSTimer scheduledTimerWithTimeInterval:CMM_AnimatePerior target:self selector:@selector(showWatting) userInfo:nil repeats:NO];
        [GKLogonService UpdatePWD:[GlobalDataService userGKId] verifyCode:[GlobalDataService userPwd] npwd:pwdEditView.modifiedPwdField.text success:^(NSObject *obj){
            self.status = VIEW_PROCESS_NORMAL;
            [self hideWaitting];
            [self showTopPop:@"保存成功"];
            
            editStatus = Edit_None;
            [self hideCellAnimation:[NSIndexPath indexPathForRow:Field_PWD_Edit - Group1_Start inSection:GROUP_UserInfoEdit]];
        }fail:^(NSError *err){
            pwdEditView.saveBtn.enabled = TRUE;

            self.status = VIEW_PROCESS_FAIL;
            [self hideWaitting];
            [self showTopPop:err.localizedDescription];
        }];
    }
}

-(void)updateNickClick{
    
    NSString *name = [GlobalDataService userName];
    SetNickEditCell *nickEditView = (SetNickEditCell*)self.editView;

    if (!IsSafeString(nickEditView.nickField.text)) {
        [self showTopPop:Set_UpdateNick_NameNillTip];
        return;
    }
    
    if ([nickEditView.nickField.text isEqualToString:name]) {
        editStatus = Edit_None;
        [self hideCellAnimation:[NSIndexPath indexPathForRow:Field_NickName_Edit - Group1_Start - 1 inSection:GROUP_UserInfoEdit]];
        return;

    }
    
    nickEditView.saveBtn.enabled = FALSE;
    
    self.status = VIEW_PROCESS_GETTING;
    [NSTimer scheduledTimerWithTimeInterval:CMM_AnimatePerior target:self selector:@selector(showWatting) userInfo:nil repeats:NO];
    [GKOwnerService updateName:nickEditView.nickField.text success:^{
        self.status = VIEW_PROCESS_NORMAL;
        [self hideWaitting];
        [self showTopPop:@"保存成功"];
        
        editStatus = Edit_None;
        [self hideCellAnimation:[NSIndexPath indexPathForRow:Field_NickName_Edit - Group1_Start - 1 inSection:GROUP_UserInfoEdit]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UserInfoUpdated object:Nil];
    }fail:^(NSError *err){
        nickEditView.saveBtn.enabled = TRUE;
        
        self.status = VIEW_PROCESS_FAIL;
        [self hideWaitting];
        [self showTopPop:err.localizedDescription];
    }];
}

#pragma mark - 
#pragma mark Inside normal function -
//-(void)updateSwitchAtIndexPath:(id)sender
//{
//    UISwitch *iswitch = (UISwitch*)sender;
//    
//    [GlobalObject setHiddenStoreIcon:iswitch.on];
//}

//- (IBAction)exitClick:(id)sender {
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"您确定退出么？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定", nil];
//    
//    [sheet showInView:APP_DELEGATE.window];
//
//}

-(NSInteger)transToIndex:(NSIndexPath*)indexPath
{
    NSInteger retIndex = 0;
    for (int k = 0; k < indexPath.section; k++) {
        retIndex += nums[k];
    }
    
    if (indexPath.section == GROUP_UserInfoEdit) {
        if (![self willEditPWD] && ![self willEditName]) {
            retIndex += 2 * indexPath.row;
        } else{
            retIndex += indexPath.row;
            if(([GlobalDataService webForLogon] == WeiBo_None) && [self willEditName]) {
                if (indexPath.row > 0) {
                    retIndex++;
                }
            }
        }
        if ([GlobalDataService webForLogon] != WeiBo_None) {
            retIndex += 2;
        }
    }    else {
        retIndex += indexPath.row;
    }
    
    return retIndex;
}

-(BOOL)willEditName
{
    return editStatus & (1 << Edit_Name);
}

-(BOOL)willEditPWD
{
    return editStatus & (1 << Edit_PWD);
}

-(BOOL)willSelectSNS
{
    return editStatus & (1 << Edit_SNS);
}

-(void)showCellAnimation:(UIView*)cell
{
    CGRect srect = cell.frame;
    CGRect drect = srect;
    srect.size = CGSizeMake(srect.size.width, 0);
    cell.clipsToBounds = YES;
    cell.frame = srect;
    
    [cell setFrame:drect animation:YES completion:nil];
    
//    CGAffineTransform transform1 = CGAffineTransformMakeScale(1, 0);
//    CGAffineTransform transform2 = CGAffineTransformMakeTranslation(0, -cell.frame.size.height/2);
//    CGAffineTransform transform = CGAffineTransformConcat(transform1, transform2);
//    cell.transform = transform;
//    
//    [UIView animateWithDuration:CMM_AnimatePerior animations:^{
//        cell.transform = CGAffineTransformIdentity;
//    } completion:^(BOOL finished) {
//        NSLog(@"%@",cell);
//    }];

}
-(void)hideCellAnimation:(NSIndexPath*)delRow
{
    [self.contentTable beginUpdates];
    [self.contentTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:delRow] withRowAnimation:UITableViewRowAnimationFade];
    
    CGRect drect = self.editView.frame;
    drect.size = CGSizeMake(drect.size.width, 0);
    
    [UIView animateWithDuration:CMM_AnimatePerior animations:^{
        self.editView.frame = drect;
    }];
    
//    CGAffineTransform transform1 = CGAffineTransformMakeScale(1, 0.0001);
//    CGAffineTransform transform2 = CGAffineTransformMakeTranslation(0, -self.editView.frame.size.height/2);
//    CGAffineTransform transform = CGAffineTransformConcat(transform1, transform2);
//    
//    [UIView animateWithDuration:CMM_AnimatePerior animations:^{
//        self.editView.transform = transform;
//    } completion:nil];
    [self.contentTable endUpdates];
}

-(void)showAbout
{
    if (!self.popAboutView) {
        SetAboutView *v =  [SetAboutView XIBView];
        CGRect rect = CGRectMake(0, APP_STATUSBAR_HEIGHT + APP_NAVBAR_HEIGHT, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - (APP_STATUSBAR_HEIGHT + APP_NAVBAR_HEIGHT));
        v.center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
        UITapGestureRecognizer *tap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
        [v addGestureRecognizer:tap];
        self.popAboutView = [WSPopupView showPopupView:v  mask:rect type:WS_PopS_Center];
    } else {
        [self.popAboutView show];
    }

}

-(void)tapped
{
    [self.popAboutView hide];
    self.popAboutView = nil;
}

-(void)showPicPicker:(id)sender
{
    int buttonIndex = ((UIButton*)sender).tag;
    
    if (!self.imgPicker) {
        self.imgPicker = [[UIImagePickerController alloc] init];
        self.imgPicker.delegate = self;
        self.imgPicker.allowsEditing = NO;
    }
    
    switch (buttonIndex) {
        case CameraBtnTag:
            self.imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        case PhotoBtnTag:
            self.imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
        default:
            break;
    }
    
    [self.navigationController presentViewController:self.imgPicker animated:YES completion:nil];
}


-(void)clearDBCompleted
{
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleFade];
    [MMProgressHUD showProgressWithStyle:MMProgressHUDProgressStyleRadial title:@"清除缓存" status:@"正在清除" task:^{
        float progress = 0.0f;
        while (progress < 1.0f) {
            progress += 0.01f;
            
            if (![NSThread isMainThread]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MMProgressHUD updateProgress:progress];
                });
            } else{
                [MMProgressHUD updateProgress:progress];
            }
            usleep(10000);
        }
    }];
    
    [[MMProgressHUD sharedHUD] setProgressCompletion:^{
        [MMProgressHUD dismissWithSuccess:@"清除完成"];
    }];

//    HUD = [[MBProgressHUD alloc] initWithView:APP_DELEGATE.window];
//	[APP_DELEGATE.window addSubview:HUD];
//	
//	HUD.mode = MBProgressHUDModeDeterminate;
//	
//	HUD.delegate = self;
//	HUD.labelText = @"正在清除";
//	
//	// myProgressTask uses the HUD instance to update progress
//	[HUD showWhileExecuting:@selector(myProgressTask:) onTarget:self withObject:HUD animated:YES];
}

- (void)myProgressTask:(MBProgressHUD*)hud {
	// This just increases the progress indicator in a loop
    
    
	float progress = 0.0f;
	while (progress < 1.0f) {
		progress += 0.01f;
		hud.progress = progress;
		usleep(10000);
	}
    __block UIImageView *imageView;
//	dispatch_sync(dispatch_get_main_queue(), ^{
//		UIImage *image = [UIImage imageNamed:@"37x-Checkmark.png"];
//		imageView = [[UIImageView alloc] initWithImage:image];
//	});
    UIImage *image = [UIImage imageNamed:@"37x-Checkmark.png"];
    imageView = [[UIImageView alloc] initWithImage:image];
	hud.customView = imageView;
	hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = nil;
	//hud.labelText = @"完成";
	sleep(3);
}

- (void)uploadPhotoTask:(MBProgressHUD*)hud {
	// This just increases the progress indicator in a loop
    
    
	float progress = 0.0f;
	while (progress < 1.0f) {
		hud.progress = progress;
        if (progress < 0.75f || uplodeProgress >= 100.0f ) {
            progress += 0.01f;

        }
		usleep(10000);
	}
    __block UIImageView *imageView;
	dispatch_sync(dispatch_get_main_queue(), ^{
		UIImage *image = [UIImage imageNamed:@"37x-Checkmark.png"];
		imageView = [[UIImageView alloc] initWithImage:image];
        [self.contentTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:Field_HeadIcon - Group0_Start inSection:GROUP_HeadIconEdit]] withRowAnimation:UITableViewRowAnimationFade];
	});
	hud.customView = imageView;
	hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = nil;
    
	sleep(1);

}

#pragma mark -
#pragma mark actionsheet delegate -
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 0) {
//        
//        if ([GlobalDataService webForLogon] != WeiBo_None) {
//            [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:nil];
//            [[UMSocialDataService defaultDataService] requestUnBindToSnsWithCompletion:nil];
//        }
//        
//        [GlobalDataService resetDataService];
//        [GKCommentService restCommentService];
//        
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LastUser"];
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ExitLogon object:nil];
//        
//        [self.navigationController popToRootViewControllerAnimated:NO];
//    }
//
//}
#pragma mark -
#pragma mark table datasource & delegate  -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return GROUP_Total ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == GROUP_UserInfoEdit) {
        if([GlobalDataService webForLogon] == WeiBo_None) {
            return !([self willEditName] || [self willEditPWD]) ? (nums[section] - 2 ): (nums[section] - 1 );
        } else {
           return  !([self willEditName] || [self willEditPWD]) ? (nums[section] - 3 ): (nums[section] - 2 );
        }
    } else if(section == GROUP_SNSShareEdit){
        if ([self willSelectSNS]) {
            return nums[section];
        } else {
            return nums[section] - 1;
        }
    } else {
        return nums[section];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableString *cellIdentifier = [NSMutableString stringWithString:@"OwnerSettingCell"] ;
    [cellIdentifier appendFormat:@"%d",indexPath.section];
    

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        UIView *selectV = [[UIView alloc] initWithFrame:cell.frame];
        selectV.backgroundColor = colorWithUtfStr(Color_TableSelector);
        cell.selectedBackgroundView = selectV;
        
        if (IOS_VERSION >= 7.0) cell.separatorInset = UIEdgeInsetsZero;
        else cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];

    }
    
    NSInteger index = [self transToIndex:indexPath];
    NSString *title = Nil;
    switch (index) {
        case Field_HeadIcon:
        {
            HeadIconUpdateView *v = [HeadIconUpdateView XIBView];
            if (IOS_VERSION < 7.0) {
                float x,width;
                
                width = TableCMMRowWidth;
                x = (tableView.frame.size.width - width ) /2;
                CGRect rect = v.frame;
                rect.origin.x = x;
                rect.size.width = width;
                v.frame = rect;
            }
            
            [cell addSubview:v];

            GKIDInfo *info = GO(GlobalDataService).gUserInfo;
            UIImage *defaultImg = [UIImage imageNamed:PersonalCenterC_DefaultIcon];
            if (IsSafeString(info.avatar_url)) {
                [v.headIconBtb showUrl:[NSURL URLWithString:info.avatar_url] activity:YES palce:defaultImg];
            } else{
                [v.headIconBtb showDefaultImg:defaultImg];
            }
            
            v.photoBtn.tag = PhotoBtnTag;
            [v.photoBtn addTarget:self action:@selector(showPicPicker:) forControlEvents:UIControlEventTouchUpInside];
            
            v.cameraBtn.tag = CameraBtnTag;
            [v.cameraBtn addTarget:self action:@selector(showPicPicker:) forControlEvents:UIControlEventTouchUpInside];
            
          
            break;
        }
        case Field_PWD:
            title = @"修改密码";
        case Field_NickName:
            if (!title) title = @"修改昵称";
        case Field_SNS:
            if (!title) title = @"绑定社交账号";
        case Field_CacheClear:
            if (!title) title = @"清除缓存";
        case Field_About:
            if (!title) title = @"关于贵客";
        case Field_HidePic:
        {
            if (!title) {
                title = [GlobalObject getHiddenStoreIconConfig] ? @"显示商家图片" : @"隐藏商家图片";
            }
            
            UILabel *label;
            if (IOS_VERSION >= 7.0) {
                label = cell.textLabel;
                cell.backgroundColor = colorWithUtfStr(StoreInfoC_TopStatusBgColor);
            } else {
                float heigth = [self tableView:tableView heightForRowAtIndexPath:indexPath];
                label = [[UILabel alloc] initWithFrame:CGRectMake((tableView.frame.size.width - TableCMMRowWidth)/2,0, TableCMMRowWidth, indexPath.row == 0 ? heigth :(heigth-1))];
                label.backgroundColor = colorWithUtfStr(StoreInfoC_TopStatusBgColor);
                [cell addSubview:label];
            }

            label.text = title;
            label.textColor = colorWithUtfStr(Color_PageCtrllerNormalColor);
            label.font = FONT_NORMAL_13;
            label.textAlignment = NSTextAlignmentCenter;
            break;
        }
        case Field_NickName_Edit:
        case Field_PWD_Edit:
        case Field_SNS_Select:
        {
            UIView *v ;
            if (index == Field_NickName_Edit) {
                v = [SetNickEditCell XIBView];
                [((SetNickEditCell*)v).saveBtn addTarget:self action:@selector(updateNickClick) forControlEvents:UIControlEventTouchUpInside];
            } else if(index == Field_SNS_Select){
                v = [SetSNSSelectCell XIBView];
                ((SetSNSSelectCell*)v).parentVC = self;
            } else if(index == Field_PWD_Edit){
                v = [SetPWDEditCell XIBView];
                [((SetPWDEditCell*)v).saveBtn addTarget:self action:@selector(updatePWDClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            if (IOS_VERSION < 7.0) {
                float x,width;
                
                width = TableCMMRowWidth;
                x = (tableView.frame.size.width - width ) /2;
                CGRect rect = v.frame;
                rect.origin.x = x;
                rect.size.width = width;
                v.frame = rect;
            }

            [cell addSubview:v];
//            CGRect rect = cell.frame;
//            rect.size = v.frame.size;
            cell.frame = v.frame;
            self.editView =v;
            [self showCellAnimation:v];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            break;
        }
        default:
            break;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [self transToIndex:indexPath];
    if (index == Field_HeadIcon) {
        return FieldHeight_HeadIcon;
    } else if(index == Field_PWD_Edit){
        return FieldHeight_PwdEdit;
    } else if (index == Field_NickName_Edit){
        return FieldHeight_NickEdit;
    } else if(index == Field_SNS_Select){
        return FieldHeight_SNSSelect;
    } else{
        return TableDefailtRowHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [self transToIndex:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    
    switch (index) {
        case Field_NickName:
        case Field_PWD:
        case Field_SNS:
        {
            NSIndexPath *delRow = nil;
            NSIndexPath *inserRow = nil;
            
            NSInteger delRowIndex = NOT_DEFINED;
            NSInteger delSection = GROUP_UserInfoEdit;
            
            NSInteger insertRowIndex = indexPath.row + 1;
            
            if ([self willEditName]) {
                delRowIndex = [GlobalDataService webForLogon] ? 1 : 2 ;
            } else if([self willEditPWD]){
                delRowIndex = Field_PWD_Edit - Group1_Start;
            } else if([self willSelectSNS]) {
                delRowIndex = Field_SNS_Select - Group2_Start;
                delSection = GROUP_SNSShareEdit;
            }
            
            if (delRowIndex != NOT_DEFINED) {
                delRow = [NSIndexPath indexPathForRow:delRowIndex inSection:delSection];
                if (delRowIndex == insertRowIndex && delSection == indexPath.section) {
                    insertRowIndex = NOT_DEFINED; //收缩表格
                    editStatus = Edit_None;
                } else {
                    if (index == Field_NickName && delSection == GROUP_UserInfoEdit) {
                        insertRowIndex--;
                    }
                }
            }
            
            if (insertRowIndex != NOT_DEFINED) {
                editStatus = 1 << (index == Field_NickName ? Edit_Name : (index == Field_SNS ? Edit_SNS : Edit_PWD));
                inserRow = [NSIndexPath indexPathForRow:insertRowIndex inSection:indexPath.section];
            }
            
            [tableView beginUpdates];
            if (delRow) {
                [self hideCellAnimation:delRow];
            }
            if (inserRow) {
                [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:inserRow] withRowAnimation:UITableViewRowAnimationNone];
            }
            [tableView endUpdates];
            break;
        }
        case Field_About:
        {
            [self showAbout];
            break;
        }
        case Field_HidePic:
        {
            BOOL hided = [GlobalObject getHiddenStoreIconConfig];
            [GlobalObject setHiddenStoreIcon:!hided];
            [self showTopPop:hided?@"已经显示商家图片":@"已经隐藏商家图片"];
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case Field_CacheClear:
        {
            [self clearDBCompleted];
            [DataBaseClient clearDB:DB1Name];
            break;
        }
        default:
            break;
    }
}



#pragma mark -
#pragma mark notification handler -
-(void)keyboardWillChangeFrame:(NSNotification *)notification
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {

        NSValue *keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];

        
        CGRect keyboardBounds;
        [keyboardBoundsValue getValue:&keyboardBounds];
        
        CGPoint point =  self.editView.frame.origin;
        point.y += self.editView.frame.size.height;
        
        CGPoint absPoint = [self.editView.superview convertPoint:point toView:nil];
        
        float diff = absPoint.y  - keyboardBounds.origin.y;
        if (diff > 0) {
            CGPoint p = self.contentTable.contentOffset;
            p.y += diff;
            [self.contentTable setContentOffset:p animated:YES];
        }
    }
}

-(void)updateIcon:(NSNotification*)notifcation
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    UIImage *img = [notifcation object];
    self.selHeadIcon = [img scaleToSize:CGSizeMake(128, 128)];

    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleFade];
    [MMProgressHUD showProgressWithStyle:MMProgressHUDProgressStyleRadial title:@"上传头像" status:@"正在上传" task:^{
        float progress = 0.0f;
        while (progress < 1.0f) {
            if (progress < 0.75f || uplodeProgress >= 100.0f ) {
                progress += 0.01f;
            }
            
            if (![NSThread isMainThread]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MMProgressHUD updateProgress:progress];
                });
            } else{
                [MMProgressHUD updateProgress:progress];
            }
            usleep(10000);
        }
    }];
    
    [[MMProgressHUD sharedHUD] setProgressCompletion:^{
        [MMProgressHUD dismissWithSuccess:@"上传完成"];
        [self.contentTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:Field_HeadIcon - Group0_Start inSection:GROUP_HeadIconEdit]] withRowAnimation:UITableViewRowAnimationFade];
    }];

    uplodeProgress = 0.0f;
    [GKOwnerService updateHeadIcon:self.selHeadIcon success:^{
        uplodeProgress = 100;
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UserInfoUpdated object:Nil];
    } fail:^(NSError *err) {
        [self showTopPop:err.localizedDescription];
        self.selHeadIcon = nil;
        [MMProgressHUD dismiss];
    } progress:^(double progress) {
        uplodeProgress = progress;
    }];


}

#pragma mark -
#pragma mark image picker delegate -
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated

{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    
    UINavigationBar *bar = navigationController.navigationBar;
    UIImage * backgroundImage = IOS_VERSION >= 7.0 ? [UIImage imageNamed:NavBarBgWithStatusBar_IOS7] : NavBg();
    if ([bar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [bar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    
    UINavigationItem *item = viewController.navigationItem;
    if (!item.titleView) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        label.textColor = colorWithUtfStr(NavBarTitleColor);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = FONT_NORMAL_21;
        label.backgroundColor = [UIColor clearColor];
        
        item.titleView = label;
        
        if (item == bar.topItem) {
            label.text = @"照片";
        } else {
            label.text = @"存储的照片";
            UIImage *backImg ;
            backImg = [UIImage imageNamed:NavBarLeftArrow];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, NavBarLeftArrowWidth, NavBarLeftArrowheight);
            [btn setImage:backImg forState:UIControlStateNormal];
            [btn addTarget:navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
            viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        }
    }
    UIImage *backImg ;
    backImg = [UIImage imageNamed:NavBarCloseIcon];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, NavBarCloseIconWidth, NavBarCloseIconWidth);
    [btn setImage:backImg forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(imagePickerControllerDidCancel) forControlEvents:UIControlEventTouchUpInside];


    item.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
   // item.backBarButtonItem = nil;
    
}


//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    UINavigationItem *item =  navigationController.navigationBar.backItem;
//    if (item) {
//        UIImage *backImg ;
//        backImg = [UIImage imageNamed:NavBarLeftArrow];
//        
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.frame = CGRectMake(0, 0, 10, APP_NAVBAR_HEIGHT);
//        [btn setImage:backImg forState:UIControlStateNormal];
//        
//        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
////        item  = nil;
////        [item.backBarButtonItem setCustomView:nil];
////        [item.backBarButtonItem setCustomView:btn];
//    }
//}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *img = [[info objectForKey:UIImagePickerControllerOriginalImage] fixOrientation];
    GKImgCroperViewController *vc = [[GKImgCroperViewController alloc] initWithImg:img];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateIcon:) name:NOTIFICATION_SELECT_PIC object:nil];
    
}

- (void)imagePickerControllerDidCancel{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
