//
//  GKStoreTableCell.m
//  GK
//
//  Created by apple on 13-4-13.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "OwnerXWGTableCell.h"
#import <QuartzCore/QuartzCore.h>
#import "NSObject+GKExpand.h"
#import "Constants.h"
#import "GlobalObject.h"
#import<CoreText/CoreText.h>


#define DescriptionView_OrgX 80
#define DescriptionView_Width 225

@implementation OwnerXWGTableCell

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
    
    self.backgroundColor  = colorWithUtfStr(CommonViewBGColor);
    UIView *selectView = [[UIView alloc] initWithFrame:self.frame];
    selectView.alpha = 0.0f;
    selectView.backgroundColor = colorWithUtfStr(Color_TableSelector);;
    self.selectedBackgroundView = selectView;

    
    self.priceLabel.textColor = colorWithUtfStr(HomePageC_NavbarCityColor);
    self.goodNameLabel.textColor = colorWithUtfStr(StoreInfoC_TopStatusTitleColor);
    
    self.storeIcon.userInteractionEnabled = FALSE;
    
    [self layOut];
}

-(void)layOut
{
    if ([GlobalObject getHiddenStoreIconConfig]) {
        self.storeIcon.hidden = YES;
        [self.descView moevrTo:CGPointMake(0, 0)];
        [self.descView strechTo:CGSizeMake(self.frame.size.width, self.frame.size.height)];
    } else {
        self.storeIcon.hidden = FALSE;
        [self.descView moevrTo:CGPointMake(DescriptionView_OrgX, 0)];
        [self.descView strechTo:CGSizeMake(DescriptionView_Width,self.frame.size.height)];
    }
}

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
