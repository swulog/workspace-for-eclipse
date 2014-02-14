//
//  CommentCell.m
//  GK
//
//  Created by W.S. on 13-12-6.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "CommentCell.h"
#import "ReferemceList.h"
#define GoodCommentTag 1
#define BadCommentTag 0

#define NameLabelWdith 116
#define NameLabelHeight 21

#define CommentLabelWidth 273
#define CommentLabeHeight 36
#define MinCommentLabelLineNumn 2

#define SelfMinHeight 75

@interface CommentCell()
{
    
}
@property (nonatomic,strong)     UITapGestureRecognizer *tap;
@end

@implementation CommentCell


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
    self.nameLabel.textColor = colorWithUtfStr(LogonC_TextFieldTextColor);
    self.dateLabel.textColor = colorWithUtfStr(SortListC_ButtonTextColor);
    self.commentLabel.textColor = colorWithUtfStr(SortListC_ButtonTextColor);
    
    [self.commentLabel setVerticalAlignment:VerticalAlignmentTop];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setAttributedName:(NSAttributedString*)str
{
    self.nameLabel.attributedText = str;
    _attributedName = str;
}

-(void)setRankTag:(int)rankTag
{
    if (!self.attributedName) {
        if (rankTag == BadCommentTag) {
            self.nameLabel.textColor = colorWithUtfStr(SortListC_ButtonHightedColor);
        } else if(rankTag == GoodCommentTag){
            self.nameLabel.textColor = colorWithUtfStr(LogonC_TextFieldTextColor);
        }
    }

}

-(void)setComment:(NSString *)comment
{
    [self.commentLabel strechTo:CGSizeMake(self.commentLabel.frame.size.width, CommentLabeHeight)];
    self.commentLabel.text = comment;
    [self setNeedsLayout];
}

-(void)setName:(NSString *)name
{
    [self.nameLabel strechTo:CGSizeMake(self.nameLabel.frame.size.width, NameLabelHeight)];

    self.nameLabel.text = name;
    [self setNeedsLayout];
}

-(void)layoutSubviews
{
//    [self.nameLabel sizeToFit];
//    [self.dateLabel sizeToFit];

    float offset = 0;
    int height = CommentLabeHeight;
    
    CGSize maxSize = CGSizeMake(self.commentLabel.frame.size.width, 9999);
    CGSize labelSize = [self.commentLabel.text sizeWithFont:self.commentLabel.font constrainedToSize:maxSize lineBreakMode: NSLineBreakByTruncatingTail];
    
    if (labelSize.height > CommentLabeHeight) {
        if (self.dropEnabeld) {
            offset = lrintf(labelSize.height- CommentLabeHeight);
            height =  lrintf(labelSize.height);
        }
        _expandValidate = TRUE;
    } else {
        _expandValidate = FALSE;
    }
    [self.commentLabel strechTo:CGSizeMake(self.commentLabel.frame.size.width, height)];

    if (self.dropEnabeld) {
        [self strechTo:CGSizeMake(self.frame.size.width, SelfMinHeight + offset)];
    }
}
@end



@implementation myUILabel
@synthesize verticalAlignment = verticalAlignment_;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.verticalAlignment = VerticalAlignmentMiddle;
    }
    return self;
}

- (void)setVerticalAlignment:(VerticalAlignment)verticalAlignment {
    verticalAlignment_ = verticalAlignment;
    [self setNeedsDisplay];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    switch (self.verticalAlignment) {
        case VerticalAlignmentTop:
        {
            CGSize maxSize = CGSizeMake(self.frame.size.width, 9999);
            CGSize labelSize = [self.text sizeWithFont:self.font constrainedToSize:maxSize lineBreakMode: NSLineBreakByTruncatingTail];
            if (self.frame.size.height > CommentLabeHeight) {
                textRect.size.height = lrintf(labelSize.height);
            } else {
                textRect = [super textRectForBounds:bounds limitedToNumberOfLines:MinCommentLabelLineNumn];
            }
            textRect.origin.y = bounds.origin.y;
            break;
        }
        case VerticalAlignmentBottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
            break;
        case VerticalAlignmentMiddle:
            // Fall through.
        default:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
    }
    return textRect;
}

-(void)drawTextInRect:(CGRect)requestedRect {
    CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:actualRect];
}


@end
