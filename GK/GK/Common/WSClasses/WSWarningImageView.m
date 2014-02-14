//
//  WSWarningImageView.m
//  GK
//
//  Created by W.S. on 13-11-28.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "WSWarningImageView.h"
#import "Constants.h"
#import "NSObject+GKExpand.h"

#define Img2TitleGap 20

@interface WSWarningImage()
{
    BOOL   needLayOut;
}
@property (nonatomic,strong) UILabel *warningLabel;
@property (nonatomic,strong) UIImage *warningImage;
@property (nonatomic,strong) UIImageView *warningImgV;
@end

@implementation WSWarningImage

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.img2TitleGap = Img2TitleGap;
        needLayOut = TRUE;
    }
    return self;
}

-(id)initWithTitle:(NSString*)title font:(UIFont*)font color:(UIColor*)color
{
    self = [self initWithFrame:CGRectZero];
    if (self) {
        self.warningTitle = title;
        self.warningFont = font ? font : FONT_NORMAL_13 ;
        self.warningColor = color ? color : colorWithUtfStr("#ff8282");
    }
    return self;
}

-(id)initWithTitle:(NSString*)title
{
    return [self initWithTitle:title font:nil color:nil];
}

+(UIImage*)ImageForWarning:(NSString*)title font:(UIFont*)font color:(UIColor*)color
{
    WSWarningImage *v = [[WSWarningImage alloc] initWithTitle:title font:font color:color];
    [v layout];
    return [UIImage imageWithUIView:v];
}

-(UILabel*)warningLabel
{
    if (!_warningLabel) {
        _warningLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _warningLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_warningLabel];
    }
    return _warningLabel;
}

-(UIImageView*)warningImgV
{
    if (!_warningImgV) {
        _warningImage = [UIImage imageNamed:@"CMM_WarningIcon.png"];;
        _warningImgV = [[UIImageView alloc] initWithImage:self.warningImage];
        CGRect rect ;
        rect.origin = CGPointZero;
        rect.size = _warningImage.size;
        [_warningImgV setFrame:rect];
        [self addSubview:_warningImgV];
    }
    return _warningImgV;
}

-(void)layout
{
    needLayOut = FALSE;
    
    CGSize size = CGSizeZero;;
    float height = self.warningImgV.frame.size.height;
    float width = self.warningImgV.frame.size.width;
    
    if (IsSafeString(self.warningTitle)) {
        self.warningLabel.text = self.warningTitle;
        self.warningLabel.textColor = self.warningColor;
        self.warningLabel.font = self.warningFont;
        
        size = [self.warningLabel.text sizeWithFont:self.warningLabel.font constrainedToSize:CGSizeMake(9999, 9999) lineBreakMode:NSLineBreakByWordWrapping];
        [self.warningLabel strechTo:size];

        
        width = MAX(size.width, self.warningImgV.frame.size.width);
        height += self.img2TitleGap + size.height;
        
        float x = (width - self.warningImgV.frame.size.width )/ 2 ;
        [self.warningImgV move:x direct:Direct_Right];
        [self.warningLabel move:(self.warningImgV.frame.size.height + self.img2TitleGap) direct:Direct_Down];
    }
    
    self.frame = CGRectMake(0, 0, width, height);
}

-(void)layoutSubviews
{
    if (needLayOut) {
        [self layout];
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
