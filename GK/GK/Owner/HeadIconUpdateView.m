//
//  HeadIconUpdateView.m
//  GK
//
//  Created by W.S. on 13-11-6.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "HeadIconUpdateView.h"

@implementation HeadIconUpdateView

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
    self.backgroundColor = colorWithUtfStr(Color_PageCtrllerSelectedColor);
    self.photoBtn.backgroundColor = colorWithUtfStr(ResetPWDC_BtnBGColor);
    [self.photoBtn setHightedBGColor:[UIColor lightGrayColor]];
    self.cameraBtn.backgroundColor = colorWithUtfStr(LogonC_TextFieldTextColor);
    [self.cameraBtn setHightedBGColor:[UIColor lightGrayColor]];

    self.titleLabel.textColor = colorWithUtfStr(SortListC_NavPopViewFootColor);
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
