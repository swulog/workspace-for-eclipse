//
//  SetAboutView.m
//  GK
//
//  Created by W.S. on 13-11-7.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "SetAboutView.h"

@implementation SetAboutView

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
    self.backgroundColor = colorWithUtfStr("#fdeb75");
    [[UILabelWithAboutView appearance] setTextColor:colorWithUtfStr("#e0a82e")];
    NSString *curVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.verLabel.text = [NSString stringWithFormat:@"贵客-个人版 V%@",curVersion];
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


@implementation UILabelWithAboutView



@end
