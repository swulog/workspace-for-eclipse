//
//  CouponView.h
//  GK
//
//  Created by W.S. on 13-10-30.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSImageView.h"
#import "GKStoreSortListService.h"

@interface CouponView : UIView

@property (weak, nonatomic) IBOutlet WSImageView *couponImgV;
@property (weak, nonatomic) IBOutlet UIView *nameBar;
@property (weak, nonatomic) IBOutlet UILabel *couponNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *loveBtn;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *validateDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponNoteLabel;

@property (weak, nonatomic) IBOutlet UIView *contrainerView;

@property (nonatomic,assign) BOOL loved;
@property (nonatomic,copy) void (^loveHandler)(BOOL loved,NSInteger index) ;

+(id)couponViewWithCoupon:(Coupon*)coupon;

- (IBAction)loveClick:(id)sender;
-(void)setLoveEnabled:(BOOL)enabled;

@end
