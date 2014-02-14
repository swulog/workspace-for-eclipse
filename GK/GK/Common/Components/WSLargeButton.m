//
//  WSLargeButton.m
//  
//
//  Created by 万松 on 12-10-12.
//
//

#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
#import "GeometryImg.h"
#import "WSLargeButton.h"


typedef enum{
    BTN_Normal,
    BTN_Delete,
    BTN_Delete_Hide
}BTN_STATE;

@interface WSLargeButton()
{
    BTN_STATE       state;
    UIButton        *delBtn;
    UILongPressGestureRecognizer *deleteRecognizer;
}

@property (nonatomic,strong) GeometryImg *bdageView;
@property (nonatomic,strong) UILabel *bdageLabel;
@end


@implementation WSLargeButton

-(void)setNormalBGColor:(UIColor *)normalBGColor
{
    _normalBGColor = normalBGColor;
    
    self.backgroundColor = normalBGColor;
}

-(void)setHightedBGColor:(UIColor *)hightedBGColor
{
    _hightedBGColor = hightedBGColor;
    
    if (hightedBGColor) {
        self.normalBGColor = self.backgroundColor;
        
        [self addTarget:self action:@selector(pressDown:forEvent:) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(pressUp:forEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(pressUp:forEvent:) forControlEvents:UIControlEventTouchUpOutside];
    }
}

-(void)setSelectedColor:(UIColor *)selectedColor
{
    _selectedColor = selectedColor;
}


-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (!_normalBGColor)
        _normalBGColor = self.backgroundColor;
    
    if (self.selectedColor) {
        self.backgroundColor = selected ? self.selectedColor : self.normalBGColor;
    }
}

-(void)pressDown:(id)sender forEvent:(UIEvent*)event
{
//    if (state == BTN_Delete) {
//        state = BTN_Delete_Hide;
//    }

    self.backgroundColor = self.hightedBGColor;
   // [self layoutIfNeeded];
}

-(void)pressUp:(id)sender forEvent:(UIEvent*)event
{
//    if (state == BTN_Delete_Hide) {
//        [self cancelDeleteAction];
//    }
    self.backgroundColor = self.normalBGColor;
}

-(void)setBadgeValue:(NSString *)badgeValue
{
    _badgeValue = badgeValue;
    
  //  GeometryImg *img = [[GeometryImg alloc] initWithFrame:CGRectMake(77, 5, 25, 25)];
    if (!self.bdageView) {
        GeometryImg *img = [[GeometryImg alloc] initWithFrame:CGRectZero];
        img.type = Geometry_Ellipse;
    //    img.lineColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
        img.fillColor = [UIColor redColor];
        self.bdageView = img;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        [label setFont:[UIFont systemFontOfSize:13.0f]];
        [label setTextColor:[UIColor whiteColor]];
        label.textAlignment = NSTextAlignmentCenter;
        [label setText:self.badgeValue];
        self.bdageLabel = label;
        
        [self.bdageView addSubview:label];
        [self addSubview:self.bdageView];
    }
}


//-(void)setCanDeleteAction:(BOOL)canDelete
//{
//    canDeleteAction = canDelete;
//    
//    if (canDeleteAction) {
//        if (!deleteRecognizer) {
//            deleteRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteAction:)];
//            [self addGestureRecognizer:deleteRecognizer];
//            deleteRecognizer.allowableMovement = NO;
//            deleteRecognizer.minimumPressDuration = 1;
//        }
//    } else {
//        if (deleteRecognizer) {
//            [self removeGestureRecognizer:deleteRecognizer];
//            deleteRecognizer = nil;
//        }
//    
//    }
//}
//-(void)cancelDeleteAction
//{
//    state = BTN_Normal;
//    [delBtn.layer removeAllAnimations];
//    delBtn.hidden = TRUE;
//}
//
//-(void)deleteAction:(id)sender
//{
//    deleteRecognizer.cancelsTouchesInView = FALSE;
//   
//    if (state == BTN_Delete) {
//     //   deleteRecognizer.cancelsTouchesInView = FALSE;
//        return;
//    }
//    state = BTN_Delete;
//    deleteRecognizer.cancelsTouchesInView = TRUE;
//
//    [self setBackgroundColor:PBMenuItem_BGColor];
//    if (!delBtn) {
//        delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [delBtn setImage:[UIImage imageNamed:@"del"] forState:UIControlStateNormal];
//        CGPoint p = CGPointMake(self.frame.size.width - 20,  20);
//        [delBtn setFrame:CGRectMake(p.x - PBMenuItem_DelBtn_Width / 2 , p.y - PBMenuItem_DelBtn_Height /2 , PBMenuItem_DelBtn_Width, PBMenuItem_DelBtn_Height)];
//        [self addSubview:delBtn];
//        [delBtn addTarget:self action:@selector(delAction) forControlEvents:UIControlEventTouchUpInside];
//        
//    } else {
//        delBtn.hidden  = FALSE;
//    }
//    
//    CALayer*viewLayer=[delBtn layer];
//    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform"];
//    animation.duration=0.2;
//    animation.repeatCount = 100000;
//    animation.autoreverses=YES;
//    animation.fromValue=[NSValue valueWithCATransform3D:CATransform3DRotate
//                            (viewLayer.transform, -0.3, 0.0, 0.0, 0.3)];
//    animation.toValue=[NSValue valueWithCATransform3D:CATransform3DRotate
//                            (viewLayer.transform, 0.3, 0.0, 0.0, 0.3)];
//    [viewLayer addAnimation:animation forKey:@"wiggle"];
//
//    NSLog(@"delete");
//    
//}
//-(void)delAction
//{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(willDeletePBButton:)]) {
//        [self.delegate performSelector:@selector(willDeletePBButton:) withObject:self];
//    }
//}
//
//-(void)canSelect
//{
//    [self setBackgroundColor:PBMenuItem_BGColor];
//}

-(void)layoutSubviews
{
#define BadgeGap 3
#define BadgeRadius 28
    
    [super layoutSubviews];
    
    if (self.bdageView) {
        CGRect titleRect = self.titleLabel.frame;
        CGRect bdageRect = CGRectZero;
        bdageRect.origin = CGPointMake(titleRect.origin.x + titleRect.size.width + BadgeGap, (self.frame.size.height - BadgeRadius) /2);
        bdageRect.size = CGSizeMake(BadgeRadius, BadgeRadius);
        self.bdageView.frame = bdageRect;
        self.bdageView.fillColor = self.badgeFillColor;
        
        bdageRect.origin = CGPointZero;
        self.bdageLabel.frame = bdageRect;
    }

    
    
}
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
// - (void)drawRect:(CGRect)rect
// {
//     [super drawRect:rect];
//     
//     CGRect rect = self.titleLabel.frame;
// }

@end

