//
//  GKLogonCtroller.m
//  GK
//
//  Created by apple on 13-4-16.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GKLogonCtroller.h"
#import "GlobalObject.h"
#import "GKLogonService.h"
#import "GKResetPWDController.h"
@interface GKLogonCtroller ()
@property (nonatomic,strong) WSPopupView *popView;
@property (nonatomic,strong) NSString *logonPlatName;
@end

@implementation GKLogonCtroller

#define LogonTipForQR @"享受优惠请先登录"
#define LogonTipForFocus @"您需要先登录"
#define LogonTipForOwnerTab @"您还没登录"

#define Logon_Offset_WithTab 20

#define RegisterOKTip @"恭喜您已经成功注册为贵客用户" // @"恭喜您成功注册为贵客用户,初始密码已经通过短信发送到您的注册号码上，请注意查收"
#define LogonTipForFormatError @"请检查您输入的手机号码和密码是否正确"
#define NoMobileTipForRigister @"输入手机号码后点击立即注册按钮，我们将把初始密码以短信形式发送至您的手机"


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil style:VIEW_WITH_NAVBAR];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
        self.closeEnabled = TRUE;
    }
    return self;
}

-(id)initWithCloseBtn:(BOOL)closeEnabled
{
    self = [self initWithNibName:@"GKLogonCtroller" bundle:nil];
    if (self) {
        self.closeEnabled = closeEnabled;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[UIButtonWithLonC appearance] setBackgroundColor:colorWithUtfStr(LogonC_ButtonBgColor)];
    [[UIButtonWithLonC appearance] setTitleColor:colorWithUtfStr(LogonC_ButtonTextColor) forState:UIControlStateNormal];
    [self setTitleWithGKLog];
    if (self.closeEnabled)    [self addBackItemWithCloseImg:@selector(homeClick:)];

    self.splitLine.lineWidth = 2;
    self.splitLine.lineColor = colorWithUtfStr(LogonC_TextFieldTextColor);
    self.splitLine2.lineWidth = 2;
    self.splitLine2.lineColor = colorWithUtfStr(LogonC_TextFieldTextColor);

    self.BottomLogonView.type = Geometry_RradientRect;
    [self.BottomLogonView setRadientColors:@[colorWithUtfStr(LononC_BottomBgStartCorlor),colorWithUtfStr(LononC_BottomBgEndCorlor)]];
    
    UITapGestureRecognizer *clickRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyPad:)];
    [clickRecognizer setNumberOfTapsRequired:1];
    [self.contentView addGestureRecognizer:clickRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMobildField:nil];
    [self setPwdField:nil];
    [self setSplitLine:nil];
    [self setSplitLine2:nil];
    [self setContentView:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark event handler -
-(void)logonWith3rdAccount:(NSDictionary*)dict plat:(NSString*)platName
{
    if ([platName isEqualToString:UMShareToSina]) {
        NSString *usid = [[dict objectForKey:@"sina"] objectForKey:@"usid"];
        NSString *name = [[dict objectForKey:@"sina"] objectForKey:@"username"];
        NSString *iconUrl = [[dict objectForKey:@"sina"] objectForKey:@"icon"];
        //   NSString *usid = [NSString stringWithFormat:@"%@%@",SINA_TAG,str];
        
        //  [self.logonDelegate logonSuccess];
        
        self.status = VIEW_PROCESS_GETTING;
        [NSTimer scheduledTimerWithTimeInterval:CMM_AnimatePerior target:self selector:@selector(showWatting) userInfo:nil repeats:NO];

        [GlobalDataService logonGKWith3rdAccount:usid platform:SINA_TAG name:name headUrl:iconUrl success:^(NSObject *obj) {
            [GKLogonService getToken:[GlobalDataService userGKId] pwd:[GlobalDataService userPwd] succ:^(NSObject *obj){
                GO(GlobalDataService).gToken = (NSString*)obj;
            }fail:nil];
            self.status = VIEW_PROCESS_NORMAL;
            [self hideWaitting];
            [GlobalObject showPopup:@"成功登录"];
            [NSTimer scheduledTimerWithTimeInterval:CMM_AnimatePerior target:self.logonDelegate selector:@selector(logonSuccess) userInfo:nil repeats:NO];
        }fail:^(NSError *err){
            self.status = VIEW_PROCESS_FAIL;
            [self hideWaitting];
            [GlobalObject showPopup:err.localizedDescription];
        }];
    }
    
}




- (IBAction)weiBoClick:(id)sender {
    
    self.logonPlatName = UMShareToSina;
    
    if ([UMSocialAccountManager isOauthWithPlatform:UMShareToSina]) {
        [[UMSocialDataService defaultDataService] requestSocialAccountWithCompletion:^(UMSocialResponseEntity *accountResponse){
            //[self didFinishGetUMSocialDataInViewController:accountResponse];
            [self logonWith3rdAccount:[accountResponse.data objectForKey:@"accounts"] plat:UMShareToSina];
        }];
    } else {
        UMSocialControllerService *umService = [ [UMSocialControllerService alloc] initWithUMSocialData:[UMSocialData defaultData]];
        umService.socialUIDelegate = self;
        UINavigationController *vc = [umService getSocialOauthController:UMShareToSina];
        
        [self presentViewController:vc animated:YES completion:nil];

    }
    
//    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
//    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response)
//                                  {
//                                      NSLog(@"response is %@",response);
//                                  });
}


- (IBAction)logonClick:(id)sender {
    
    if(checkMobileNo(self.mobildField.text) && checkPWD(self.pwdField.text))
    {
        [self.pwdField resignFirstResponder];
        [self.mobildField resignFirstResponder];
        self.status = VIEW_PROCESS_GETTING;
        [NSTimer scheduledTimerWithTimeInterval:CMM_AnimatePerior target:self selector:@selector(showWatting) userInfo:nil repeats:NO];
        [GlobalDataService logonGK:self.mobildField.text pwd:self.pwdField.text success:^(void){
            self.status = VIEW_PROCESS_NORMAL;
            [self hideWaitting];
            [GlobalObject showPopup:@"成功登录"];
            [NSTimer scheduledTimerWithTimeInterval:CMM_AnimatePerior target:self.logonDelegate selector:@selector(logonSuccess) userInfo:nil repeats:NO];
        }fail:^(NSError *err){
            self.status = VIEW_PROCESS_FAIL;
            [self hideWaitting];
            [GlobalObject showPopup:err.localizedDescription];
        }];
    } else {
        [GlobalObject showPopup:LogonTipForFormatError];
    }
}

- (IBAction)registerClick:(id)sender {
    NSString *phone =  self.mobildField.text;
    if(checkMobileNo(phone)){
        [GKLogonService Register:phone success:^(void){
            [GlobalObject showPopup:RegisterOKTip];
            self.registerBtn.enabled = FALSE;
            [NSTimer scheduledTimerWithTimeInterval:60.0f target:self selector:@selector(enabledRegister) userInfo:nil repeats:NO];
        }fail:^(NSError *err){
            [GlobalObject showPopup:err.localizedDescription];
        }];
    } else {
        if (!self.popView) {
            self.tipView.backgroundColor = colorWithUtfStr( LogonC_ButtonBgColor);
            
            self.tipLabel.numberOfLines = 0;
            self.tipLabel.lineBreakMode = NSLineBreakByCharWrapping;
            self.tipLabel.text = NoMobileTipForRigister;
            self.tipLabel.font = FONT_NORMAL_13;
            self.tipLabel.textColor = colorWithUtfStr(LogonC_ButtonTextColor);
            
            CGSize labsize = [self.tipLabel.text sizeWithFont:self.tipLabel.font constrainedToSize:CGSizeMake(self.tipLabel.frame.size.width, 9999) lineBreakMode:self.tipLabel.lineBreakMode];
            CGPoint p = self.tipLabel.center;
            labsize.height+=1;
            [self.tipLabel strechTo:labsize];
            self.tipLabel.center = p;
            CGRect rect = self.tipView.frame;
            rect.origin.x = (APP_SCREEN_WIDTH -  rect.size.width) /2;
            rect.origin.y = 90;
            self.tipView.frame = rect;
            
           UITapGestureRecognizer *tap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
           [self.tipView addGestureRecognizer:tap];
            
            self.popView = [WSPopupView showPopupView:self.tipView  mask:CGRectMake(0, 64, 320, 568-64) type:WS_PopS_Center];
            self.popView.delegate = self;
        } else {
            [self.popView show];
        }

    }
}

-(void)tapped
{
    [self.popView hide];
}

-(void)enabledRegister
{
    self.registerBtn.enabled = TRUE;
}

- (IBAction)forgotClick:(id)sender {
    GKResetPWDController *vc = [[GKResetPWDController alloc] initWithNibName:@"GKResetPWDController" bundle:nil];
    if (self.navigationController) {
        [self.navigationController pushViewController:vc animated:YES];
    } else if(self.parentViewController.navigationController){
        [self.parentViewController.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)homeClick:(id)sender {
    BOOL goon = TRUE;
    if (self.logonDelegate && [self.logonDelegate respondsToSelector:@selector(logonCancel)]) {
        goon = [self.logonDelegate logonCancel];
    }
    if (goon) {
        if (!self.navigationController || self.navigationController.viewControllers[0] == self) {
            if (self.presentParentVc) {
                [self.presentParentVc dismissFullScreenViewControllerAnimated:WSDismissStyle_T2DAnimation completion:nil];
            } else {
                [self dismissViewControllerAnimated:YES
                                         completion:nil];
            }
        } else {
            //[self.navigationController popViewControllerAnimatedWithTransition];
        }
    }
    
}

-(BOOL)popViewClicked
{
    return TRUE;
}

#pragma mark -
#pragma mark text field delegate -
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    focusField = textField;

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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

#pragma mark -
#pragma mark UMService delegate -

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    if (response.responseCode == UMSResponseCodeSuccess) {
        //only for sina
        NSDictionary *dict = response.data;
        [self logonWith3rdAccount:dict plat:self.logonPlatName];
    }
}
@end
#pragma mark - NSObject Expand
#pragma mark -
@implementation UIButtonWithLonC
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.titleLabel.font = FONT_NORMAL_13;
}
@end

@implementation UITextField (GKLogonCtroller)
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.textColor = colorWithUtfStr(LogonC_TextFieldTextColor);
    self.font = FONT_NORMAL_13;
}
@end
