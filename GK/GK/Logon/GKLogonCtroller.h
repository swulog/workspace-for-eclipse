//
//  GKLogonCtroller.h
//  GK
//
//  Created by apple on 13-4-16.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GKBaseViewController.h"


@protocol GKLogonDelegate <NSObject>

@optional
-(void)logonSuccess;
-(BOOL)logonCancel;
@end

@interface GKLogonCtroller : GKBaseViewController<UMSocialUIDelegate,WSPopupDelete>
{
    UIView *focusField;
}
@property (assign,nonatomic) id<GKLogonDelegate> logonDelegate;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *TopLogonView;

@property (weak, nonatomic) IBOutlet UITextField *mobildField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet GeometryImg *splitLine;
@property (weak, nonatomic) IBOutlet GeometryImg *splitLine2;

@property (weak, nonatomic) IBOutlet GeometryImg *BottomLogonView;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (nonatomic,assign) BOOL closeEnabled;

-(id)initWithCloseBtn:(BOOL)closeEnabled;

- (IBAction)weiBoClick:(id)sender;
- (IBAction)logonClick:(id)sender;
- (IBAction)registerClick:(id)sender;
- (IBAction)forgotClick:(id)sender;
- (IBAction)homeClick:(id)sender;


//tipView
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (strong, nonatomic) IBOutlet UIView *tipView;

@end


@interface UIButtonWithLonC : UIButton
@end
@interface UITextField (GKLogonCtroller)
@end
