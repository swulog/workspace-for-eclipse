//
//  XWGGoodDetailCtrller.h
//  GK
//
//  Created by W.S. on 13-8-28.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GKBaseViewController.h"
#import "GKXWGService.h"
#import "GKLogonCtroller.h"
#import "WSScrollContentView.h"

@interface XWGGoodDetailCtrller : GKBaseViewController<UMSocialUIDelegate,GKLogonDelegate>
{
    GoodsInfo *iGood;
    BOOL        loveStatus;
}

-(id)initWithGood:(GoodsInfo*)good;

@property (weak, nonatomic) IBOutlet WSImageView *imgV;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet WSScrollContentView *scrollContentV;

@property (weak, nonatomic) IBOutlet UIView *bottomCView;
@property (weak, nonatomic) IBOutlet UILabel *shareTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *sharerLabel;
@property (weak, nonatomic) IBOutlet UILabel *loveLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *toolBar;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (weak, nonatomic) IBOutlet UIButton *loveBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIView *imgBottomBK;

- (IBAction)buyClick:(id)sender;
- (IBAction)shareClick:(id)sender;
- (IBAction)loveClick:(id)sender;
- (IBAction)goback:(id)sender;

@end


@interface UILabelWithGoodDeatil : UILabel
@end