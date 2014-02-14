//
//  GKStoreTableCell.m
//  GK
//
//  Created by apple on 13-4-13.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GKStoreTableCell.h"
#import <QuartzCore/QuartzCore.h>
#import "NSObject+GKExpand.h"
#import "Constants.h"
#import "GlobalObject.h"
#import "ReferemceList.h"

#define DescriptionView_OrgX 115
#define DescriptionView_OrgY 8
#define DescriptionView_Width 190

@implementation GKStoreTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
   // self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self setRestorationIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

    }
    return self;
}


-(void)awakeFromNib
{
    self.backgroundColor  = colorWithUtfStr(CommonViewBGColor);
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    

    [self resetSelf];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetSelf) name:NOTIFICATION_HIDDEN_STORE_ICON object:nil];
    
    
}

-(void)resetSelf
{
    if ([GlobalObject getHiddenStoreIconConfig]) {
        self.storeIcon.hidden = YES;
        [self.descView moevrTo:CGPointMake(0, DescriptionView_OrgY)];
        [self.descView strechTo:CGSizeMake(self.frame.size.width, self.descView.frame.size.height)];
    } else {
        self.storeIcon.hidden = FALSE;
        [self.descView moevrTo:CGPointMake(DescriptionView_OrgX, DescriptionView_OrgY)];
        [self.descView strechTo:CGSizeMake(DescriptionView_Width,self.descView.frame.size.height)];
    }
    
    self.discussView.backgroundColor = colorWithUtfStr(StoreTableCellDiscussBgColir);
    self.loveView.backgroundColor =colorWithUtfStr(StoreTableCellLoveBgColir);
    
    self.storeNameLabel.textColor = colorWithUtfStr(StoreTableCellDarkColor);
    self.rebateLabel.textColor = colorWithUtfStr(StoreTableCellLightColor);
    self.storeAddressLabel.textColor = colorWithUtfStr(StoreTableCellDarkColor);
    self.distanceLabel.textColor = colorWithUtfStr(StoreTableCellDarkColor);
    
    self.storeIcon.userInteractionEnabled = FALSE;
}

-(void)hideDistanceField
{
    self.distanceIcon.hidden = YES;
    self.distanceLabel.hidden = YES;
    
    self.storeAddressLabel.hidden = FALSE;

}

-(void)showDistanceField
{
    self.distanceIcon.hidden = FALSE;
    self.distanceLabel.hidden = FALSE;
    
    self.storeAddressLabel.hidden = YES;
}

-(void)configWithReuseIdentify:(NSString*)identify
{
    [self setValue:identify forKey:@"reuseIdentifier"];
    
    if ([identify isEqualToString:@"GKStoreTableCell"]) {
        [self hideDistanceField];
    } else if([identify isEqualToString:@"GKFuJinTableCell"]) {
        [self showDistanceField];
    }
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{

    if (selected) {
        self.backgroundColor = colorWithUtfStr(Color_TableSelector);
        self.descView.backgroundColor =colorWithUtfStr(Color_TableSelector);
    }
    else {
        self.backgroundColor = colorWithUtfStr(CommonViewBGColor);
        self.descView.backgroundColor = [UIColor whiteColor];
        
    }
    [super setHighlighted:selected animated:animated];
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated;
{
    
    if (highlighted) {
        self.backgroundColor = colorWithUtfStr(Color_TableSelector);
        self.descView.backgroundColor =colorWithUtfStr(Color_TableSelector);
    }
    else {
        self.backgroundColor = colorWithUtfStr(CommonViewBGColor);
        self.descView.backgroundColor = [UIColor whiteColor];

    }
    [super setHighlighted:highlighted animated:animated];

}


- (void)drawRect:(CGRect)rect {
    if (self.isEditing) {
        [self.contentView move:40 direct:Direct_Right];
    }
}
@end
