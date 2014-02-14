//
//  SetNickEditCell.m
//  GK
//
//  Created by W.S. on 13-11-7.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "SetNickEditCell.h"
#import "NSObject+GKExpand.h"
#import "ReferemceList.h"

@implementation SetNickEditCell

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
    self.saveBtn.backgroundColor = colorWithUtfStr(XWGGGC_ImportTextColor);
    [self.saveBtn setHightedBGColor:colorWithUtfStr(PersonalCenterC_CellMSGBtnSelectedBGColor)];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)returnClick:(id)sender {
    [self.saveBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
}
@end
