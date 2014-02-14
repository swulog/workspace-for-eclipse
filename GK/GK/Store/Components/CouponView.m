//
//  CouponView.m
//  GK
//
//  Created by W.S. on 13-10-30.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "CouponView.h"
#import "Constants.h"
#import "NSObject+GKExpand.h"
#import "ReferemceList.h"
#import "GlobalObject.h"

@interface CouponView()
@property (nonatomic,strong) Coupon *iCoupon;
@end

@implementation CouponView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


+(id)couponViewWithCoupon:(Coupon*)coupon
{
    CouponView *couponView  =   [[[NSBundle mainBundle] loadNibNamed:@"CouponView" owner:self options:Nil] objectAtIndex:0];
    couponView.iCoupon = coupon;
    [couponView initView];
    
    return couponView;
}

-(void)initView
{
    self.contrainerView.backgroundColor = colorWithUtfStr(CommonViewBGColor);
    self.nameBar.backgroundColor = colorWithUtfStr(CouponInfoC_NameBarBGColor);
    
    
    if (IsSafeString(self.iCoupon.image_url)) {
        [self.couponImgV showUrl:[NSURL URLWithString:self.iCoupon.image_url] activity:YES];
    } else {
        [self.couponImgV showDefaultImg:[UIImage imageNamed:CouponInfoC_NoCouponImgIcon]];
    }
    
    if (IsSafeString(self.iCoupon.title)) {
        self.couponNameLabel.text = self.iCoupon.title;
    }
    if (IsSafeString(self.iCoupon.store_name)) {
        self.storeNameLabel.text = self.iCoupon.store_name;
        self.storeNameLabel.textColor = colorWithUtfStr(CouponInfoC_NormalTextColor);
    }
    if (IsSafeString(self.iCoupon.start) && IsSafeString(self.iCoupon.end)) {
        NSString *startDateStr,*endDateStr;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        startDateStr = transDatetoChinaDateStr([formatter dateFromString:self.iCoupon.start]);
        endDateStr = transDatetoChinaDateStr([formatter dateFromString:self.iCoupon.end]);
        
        if (startDateStr && endDateStr) {
            self.validateDateLabel.text = [NSString stringWithFormat:@"促销有效期：%@ - %@",startDateStr,endDateStr];
            self.validateDateLabel.textColor = colorWithUtfStr(CouponInfoC_ValidateDateColor);
        }
    }
    
    if (IsSafeString(self.iCoupon.body)) {
        self.couponContentLabel.text = self.iCoupon.body;
        self.couponContentLabel.textColor = colorWithUtfStr(CouponInfoC_NormalTextColor);
    }
    if (IsSafeString(self.iCoupon.note)) {
        self.couponNoteLabel.text = self.iCoupon.note;
        self.couponNoteLabel.textColor = colorWithUtfStr(CouponInfoC_NormalTextColor);
    }
}

-(void)setLoveHandler:(void (^)(BOOL loved,NSInteger index)) loveHandler
{
    _loveHandler = loveHandler;
}

-(void)setLoveEnabled:(BOOL)enabled
{
    self.loveBtn.enabled = enabled;
}

- (IBAction)loveClick:(id)sender {
    if (self.loveHandler) {
        self.loveHandler(self.loved,self.tag);
    }
}

-(void)setLoved:(BOOL)loved
{
    if (_loved != loved) {
        _loved = loved;
        
        [self.loveBtn setImage:[UIImage imageNamed:_loved?CouponInfoC_LoveIcon:CouponInfoC_UnLoveIcon] forState:UIControlStateNormal];
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

@end
