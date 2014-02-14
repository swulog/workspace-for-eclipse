//
//  GKStoreTableCell.m
//  GK
//
//  Created by apple on 13-4-13.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "OwnerCouponTableCell.h"
#import <QuartzCore/QuartzCore.h>
#import "NSObject+GKExpand.h"
#import "Constants.h"
#import "GlobalObject.h"
#import<CoreText/CoreText.h>


#define DescriptionView_OrgX 147
#define DescriptionView_Width 158

@implementation OwnerCouponTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
   // self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self setRestorationIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

    }
    return self;
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

-(void)awakeFromNib
{
    if (IOS_VERSION >= 7.0) self.separatorInset = UIEdgeInsetsZero;
    
//    UIColor *bgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"screen_backgroud"]];
//    [self setBackgroundView:[[UIView alloc] initWithFrame:self.frame]];
//    [self.backgroundView setBackgroundColor:bgColor];
//
    self.backgroundColor  = colorWithUtfStr(CommonViewBGColor);
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = colorWithUtfStr(Color_TableSelector);
    
    self.storeNameLabel.textColor = colorWithUtfStr(StoreInfoC_TopStatusTitleColor);
    self.couponNameLabel.textColor = colorWithUtfStr(HomePageC_NavbarCityColor);
    self.couponValidateLabel.textColor = colorWithUtfStr(StoreInfoC_TopStatusTitleColor);
    
    self.couponIcon.userInteractionEnabled = FALSE;
    
    [self layOut];

    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetSelf) name:NOTIFICATION_HIDDEN_STORE_ICON object:nil];

}

-(void)layOut
{
    if ([GlobalObject getHiddenStoreIconConfig]) {
        self.couponIcon.hidden = YES;
        [self.descView moevrTo:CGPointMake(0, 0)];
        [self.descView strechTo:CGSizeMake(self.frame.size.width, self.frame.size.height)];
    } else {
        self.couponIcon.hidden = FALSE;
        [self.descView moevrTo:CGPointMake(DescriptionView_OrgX, 0)];
        [self.descView strechTo:CGSizeMake(DescriptionView_Width,self.frame.size.height)];
    }

}

//-(void)setAttributedTextForRebrate:(NSAttributedString*)str
//{
////    if (IOS_VERSION >= 6.0) {
////        self.rebateLabel.attributedText = str;
////    } else
//    
//    {
//        
//        static NSString *layName = @"rebrate";
//        CATextLayer *textLayer;
//        for (CATextLayer *layer in self.descView.layer.sublayers) {
//            if ([layer.name isEqualToString:layName]) {
//                textLayer = layer;
//                break;
//            }
//        }
//        if (!textLayer) {
//            textLayer = [CATextLayer layer];
//            textLayer.name = layName;
//            textLayer.frame = self.rebateLabel.frame;            
//            [self.descView.layer addSublayer:textLayer];
//
//        }
//        textLayer.string = str;
//
//    }
//    
////    NSString *storeName = @"晋中拉面馆";
////    NSString *storeStr = [NSString stringWithFormat:@"%@提供",storeName];
////    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:storeStr];
////    [attriString addAttribute:(NSString *)kCTForegroundColorAttributeName
////                        value:(id)[UIColor redColor].CGColor
////                        range:NSMakeRange(0, storeName.length)];
//
//}

-(void)configWithReuseIdentify:(NSString*)identify
{
    [self setValue:identify forKey:@"reuseIdentifier"];
}

- (void)drawRect:(CGRect)rect {
    if (self.isEditing) {
        [self.contentView move:40 direct:Direct_Right];
    }
}
@end
