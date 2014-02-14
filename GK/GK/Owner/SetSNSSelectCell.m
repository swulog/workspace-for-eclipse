//
//  SetSNSSelectCell.m
//  GK
//
//  Created by W.S. on 13-11-7.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "SetSNSSelectCell.h"
#import "NSObject+GKExpand.h"
#import "ReferemceList.h"
#import "Constants.h"
#import "GKAppDelegate.h"
@implementation SetSNSSelectCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    UIColor *disabledColor = colorWithUtfStr(Color_PageCtrllerSelectedColor);
    UIColor *enabledColor = colorWithUtfStr(Color_PageCtrllerNormalColor);
    
    UIButton *btns[] = {self.sinaBtn,self.qqWbBtn,self.qqBtn,self.rrBtn};
    
    for (int k = 0; k < 4; k++) {
        if ([UMSocialAccountManager isOauthWithPlatform:GSNSS[k]]) {
            btns[k].backgroundColor = enabledColor;
        } else {
            btns[k].backgroundColor = disabledColor;
        }
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)sinaClick:(id)sender {
    [self OauthWtihSNS:0];
}

- (IBAction)qqwbClick:(id)sender {
    [self OauthWtihSNS:1];
}

- (IBAction)qqClick:(id)sender {
    [self OauthWtihSNS:2];
}

- (IBAction)rrClick:(id)sender {
    [self OauthWtihSNS:3];
}

-(void)OauthWtihSNS:(NSInteger)index
{
    
    if (!([UMSocialAccountManager isOauthWithPlatform:(NSString*)GSNSS[index]])) {
        
        NSString *platformName = (NSString*)GSNSS[index];
        
        [UMSocialControllerService defaultControllerService].socialUIDelegate = self;
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:platformName];
        snsPlatform.loginClickHandler(self.parentVC,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
               // UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:platformName];
                [self updateSnsStatus:index];
            }
        });
        
    } else {
        UIActionSheet *unOauthActionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"解除授权", nil];
        unOauthActionSheet.tag = index;
        unOauthActionSheet.destructiveButtonIndex = 0;

//        UIResponder <UIApplicationDelegate> *appDelegate = [[UIApplication sharedApplication] delegate];
//        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
//        if(keyWindow == nil){
//            if([appDelegate respondsToSelector:@selector(window)]) {
//                keyWindow = appDelegate.window;
//        }
//        }
//
//        if (keyWindow) {
//            [unOauthActionSheet showInView:keyWindow];
//
//        }
        [unOauthActionSheet showInView:APP_DELEGATE.window];
    }
}

-(void)updateSnsStatus:(NSInteger)index
{
    UIButton *btns[] = {self.sinaBtn,self.qqWbBtn,self.qqBtn,self.rrBtn};
    NSString *snss[] = {UMShareToSina,UMShareToTencent,UMShareToQzone,UMShareToRenren};
    
    UIColor *disabledColor = colorWithUtfStr(Color_PageCtrllerSelectedColor);
    UIColor *enabledColor = colorWithUtfStr(Color_PageCtrllerNormalColor);
    
    if ([UMSocialAccountManager isOauthWithPlatform:snss[index]]) {
        btns[index].backgroundColor = enabledColor;
    } else {
        btns[index].backgroundColor = disabledColor;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSString *platformType = GSNSS[actionSheet.tag];
        
        [[UMSocialDataService defaultDataService] requestUnOauthWithType:platformType completion:^(UMSocialResponseEntity *response) {
            [self updateSnsStatus:actionSheet.tag];
        }];
    }
   
}
@end
