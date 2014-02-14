//
//  RebateInfoView.m
//  GK
//
//  Created by apple on 13-4-14.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "RebateInfoView.h"
#import "NSObject+WSExpand.h"
#import "AppConstans.h"

#define Color_ListDescription "#999999"
#define Color_StoreDetail_ValidateTime "#fdb567"


@implementation RebateInfoView

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
    self.rebateContent.lineBreakMode = NSLineBreakByWordWrapping;
    self.rebateContent.numberOfLines = 0;
    
    self.backgroundColor = [UIColor clearColor];
    self.rebateLine.lineColor = [UIColor lightGrayColor];
    self.rebateLine.lineWidth = 3;
    
    self.rebateTitleLabel.font = FONT_NORMAL_18;
    
    self.couponTitleLabel.font = FONT_NORMAL_16;
    self.couponTitleLabel.textColor = [UIColor redColor];
    
    self.dateLabel.font = FONT_NORMAL_12;
    self.dateLabel.textColor = colorWithUtfStr(Color_StoreDetail_ValidateTime);
    
    self.rebateContent.font = FONT_NORMAL_12;
    self.rebateContent.textColor = [UIColor blackColor];
    
    
    self.noteLabel.font = FONT_NORMAL_12;
    self.noteLabel.textColor = colorWithUtfStr(Color_ListDescription);
    

    
    self.isAutoSize = TRUE;
    
}

-(void)setContent:(NSString*)content
{
    
    
    if (self.isAutoSize) {
        
        CGSize labsize = [content sizeWithFont:FONT_NORMAL_12 constrainedToSize:CGSizeMake(self.rebateContent.frame.size.width, 9999) lineBreakMode:WSLineBreakModeWordWrap()];
        float offset = labsize.height - self.rebateContent.frame.size.height;
        [self.rebateContent strechTo:CGSizeMake(self.rebateContent.frame.size.width, labsize.height)];
        [self.noteLabel move:offset direct:Direct_Down];
        
        CGSize nSize = CGSizeMake(self.frame.size.width, self.noteLabel.frame.origin.y + self.noteLabel.frame.size.height);
        [self strechTo:nSize];
      
    }
    self.rebateContent.text = content;
}

-(void)setNote:(NSString*)note
{
    
    
    if (self.isAutoSize) {
        
        CGSize labsize = [note sizeWithFont:FONT_NORMAL_12 constrainedToSize:CGSizeMake(self.noteLabel.frame.size.width, 9999) lineBreakMode:WSLineBreakModeWordWrap()];
        [self.noteLabel strechTo:CGSizeMake(self.noteLabel.frame.size.width, labsize.height)];
        
        CGSize nSize = CGSizeMake(self.frame.size.width, self.noteLabel.frame.origin.y + self.noteLabel.frame.size.height);
        [self strechTo:nSize];
        
    }
    self.noteLabel.text = note;
}

-(void)setStartDate:(NSString*)_startDate endData:(NSString*)_endDate
{
    NSString *title = [NSString stringWithFormat:@"促销有效期：%@ ~ %@",_startDate,_endDate];
    self.dateLabel.text = title;
}

-(void)setAdvImage:(NSURL*)imgUrl
{
    [self.advImgV showUrl:imgUrl];
    float offset = self.advImgV.frame.size.width/480.0f*220.0f;

    //[self.advImgV strechTo:CGSizeMake(self.advImgV.frame.size.width, offset)];
    [self.advImgBk strechTo:CGSizeMake(self.advImgBk.frame.size.width, offset)];
    self.advImgBk.image = [UIImage imageNamed:@"coupon_advImgBK"];
    
    CGRect rect =self.advImgBk.frame;
    rect.origin.x += 2;
    rect.origin.y += 2;
    rect.size.height -= 6;
    rect.size.width -= 4;
    self.advImgV.frame = rect;

    offset +=2;
    [self.couponTitleLabel move:offset direct:Direct_Down];
    [self.dateLabel move:offset direct:Direct_Down];

    [self.rebateContent move:offset direct:Direct_Down];
    [self.noteLabel move:offset direct:Direct_Down];
    
    CGSize nSize = CGSizeMake(self.frame.size.width, self.noteLabel.frame.origin.y + self.noteLabel.frame.size.height);
    [self strechTo:nSize];
    
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
