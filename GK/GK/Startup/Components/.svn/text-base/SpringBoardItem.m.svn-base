//
//  SpringBoardItem.m
//  BossE_V1
//
//  Created by 万松 on 12-10-12.
//
//

#import "SpringBoardItem.h"
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
#import "GeometryImg.h"

#define TitleLabel_Height 15
#define TitleLabel_Gap 12
CGPoint centerOfFrame(CGRect rect);

@interface SpringBoardItem()
{
    BOOL needUpdateLayot;
    CGPoint lastPoint;

}
@property(nonatomic,strong) UILabel  *itemTitleLabel;
@property(nonatomic,strong) UIImageView  *pbBtnBg;
@property(nonatomic,strong) UIImage *itemIcon;
@property(nonatomic,strong) NSString *title;
@property (nonatomic, assign) CGPoint lastCenter;
@property(nonatomic,strong) UIButton    *delBtn;

@property (nonatomic,assign) SpringBoardItemType itemType;

@end
@implementation SpringBoardItem

@synthesize deleteEnabled;
@synthesize badgeValue;

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.deleteEnabled = TRUE;
//        
//
//        
//    }
//    return self;
//}

-(id)initWithStyle:(SpringBoardItemType)type
{
    self = [super init];
    if (self) {
        self.itemType = type;
        self.deleteEnabled = TRUE;
        needUpdateLayot = TRUE;
        //self.clipsToBounds = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseDeleteBtnAnimation) name:Notification_APPEnterBackground object:nil];
        
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_APPEnterBackground object:nil];
}

-(void)setItemType:(SpringBoardItemType)itemType
{
    _itemType = itemType;

    if (itemType == SpringBoardItemLargeRectBtn) {
        
        if(!self.pbBtnBg) {
            self.pbBtnBg = [[UIImageView alloc] init];
            self.pbBtnBg.userInteractionEnabled = FALSE;

            [self addSubview:self.pbBtnBg];
        }
    }
}

-(void)setTag:(NSInteger)tag
{
    [super setTag:tag];
    self.springBtn.tag = tag;
}

-(void)setBadgeValue:(NSString *)_badgeValue
{
    badgeValue = _badgeValue;
    
    
    if (_badgeValue <= 0) {
        return;
    }
    GeometryImg *img = [[GeometryImg alloc] initWithFrame:CGRectMake(77, 5, 25, 25)];
    img.type = Geometry_Ellipse;
    img.lineColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
    img.fillColor = [UIColor redColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(78, 10, 23,15)];
    label.backgroundColor = [UIColor clearColor];
    [label setFont:[UIFont boldSystemFontOfSize:12.0f]];
    [label setTextColor:[UIColor whiteColor]];
    label.textAlignment = NSTextAlignmentCenter;
    [label setText:self.badgeValue];
    
    [self addSubview:img];
    [self addSubview:label];
}

-(void)setImage:(UIImage *)image title:(NSString*)title
{
    needUpdateLayot = TRUE;
    self.itemIcon = image;
    self.title = title;
}

-(void)setDeleteEnabled:(BOOL)canDelete
{
    deleteEnabled = canDelete;
    
    if (deleteEnabled) {
        if (!deleteRecognizer) {
            deleteRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandler:)];
            deleteRecognizer.allowableMovement = 10;
            //deleteRecognizer.minimumPressDuration = 1;
            if (self.itemType == SpringBoardItemLargeRectBtn) {
                [self addGestureRecognizer:deleteRecognizer];
            } else if(self.itemType == SpringBoardItemIconBtn){
                [self.springBtn addGestureRecognizer:deleteRecognizer];
            }
        }
    } else {
        if (deleteRecognizer) {
            if (self.itemType == SpringBoardItemLargeRectBtn) {
                [self removeGestureRecognizer:deleteRecognizer];
            } else if(self.itemType == SpringBoardItemIconBtn){
                [self.springBtn removeGestureRecognizer:deleteRecognizer];
            }
            deleteRecognizer = nil;
        }
    }
}

-(void)cancelDeleteAction
{
    self.btnState = BTN_Normal;
}

-(UILabel*)itemTitleLabel
{
    if (_itemTitleLabel) {
        return _itemTitleLabel;
    }
    
    if (self.title) {
        _itemTitleLabel = [[UILabel alloc] init];
        _itemTitleLabel.backgroundColor = [UIColor clearColor];
        [_itemTitleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_itemTitleLabel setTextColor:[UIColor darkGrayColor]];
        _itemTitleLabel.textAlignment = NSTextAlignmentCenter;
        [_itemTitleLabel setText:self.title];
        [self addSubview:_itemTitleLabel];
        //    _itemTitleLabel.clipsToBounds = FALSE;
        
    } else {
        _itemTitleLabel = nil;
    }
    return _itemTitleLabel;
}

-(UIButton*)springBtn
{
    if (_springBtn) {
        return _springBtn;
    }
    
    _springBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_springBtn setFrame:CGRectZero];
//    [_springBtn addTarget:self action:@selector(pressDown:forEvent:) forControlEvents:UIControlEventTouchDown];
//    [_springBtn addTarget:self action:@selector(pressUp:forEvent:) forControlEvents:UIControlEventTouchUpInside];
//    [_springBtn addTarget:self action:@selector(pressUp:forEvent:) forControlEvents:UIControlEventTouchUpOutside];
    
    [self addSubview:_springBtn];
    
    return _springBtn;
}


-(UIButton*)delBtn
{
    if (!_delBtn) {
        _delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_delBtn setImage:[UIImage imageNamed:@"HP_Del"] forState:UIControlStateNormal];
        CGPoint p = CGPointMake(self.frame.size.width - 15,  15);
        [_delBtn setFrame:CGRectMake(p.x - PBMenuItem_DelBtn_Width / 2 , p.y - PBMenuItem_DelBtn_Height /2 , PBMenuItem_DelBtn_Width, PBMenuItem_DelBtn_Height)];
        [_delBtn addTarget:self action:@selector(delAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_delBtn];
    }
    return _delBtn;
}

-(BOOL)isInsideDelBtn:(CGPoint)point
{
    UIView *view = [super hitTest:point withEvent:nil];
    if(self.deleteEnabled  && view == _delBtn) return TRUE;
    return FALSE;
}

-(void)setBtnState:(BTN_STATE)btnState
{
    if (_btnState == btnState) return;
    _btnState = btnState;
    
    switch (_btnState) {
        case BTN_Delete:
        {
            self.delBtn.hidden = FALSE;
            
            CATransition *transition=[CATransition animation];
            transition.duration = 0.2;
            transition.type = kCATransitionFade;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut] ;
            [self.delBtn.layer addAnimation:transition forKey:@"transition"];
            
            [self startDeleteBtnAnimation];
            break;
        }
            
        case BTN_Normal:
        {
            [self.delBtn.layer removeAllAnimations];
            [UIView animateWithDuration:0.2f animations:^{
                self.delBtn.alpha = 0;
            } completion:^(BOOL finished) {
                self.delBtn.hidden = TRUE;
                self.delBtn.alpha = 1;
            }];
            
            break;
        }
        
        default:
            break;
    }
}

-(void)setMovEnabled:(BOOL)movEnabled
{
    if (_movEnabled == movEnabled)  return;
    _movEnabled = movEnabled;
    _springBtn.highlighted = movEnabled;
    
    if (movEnabled) {
        [self executePreDelAnimation:nil];
    } else {
        [UIView animateWithDuration:0.30f animations:^{
            self.layer.transform = CATransform3DIdentity;
        }];
        if (self.delegate && [self.delegate respondsToSelector:@selector(SpringItemStopMove:)]) {
            [self.delegate performSelector:@selector(SpringItemStopMove:) withObject:self];
        }
    }
}

-(void)longPressHandler:(UILongPressGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:self.superview];

    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            lastPoint = point;
            [self preDeleteAction:nil];
            deleteRecognizer.cancelsTouchesInView = FALSE;
            self.springBtn.highlighted = TRUE;

            break;
        case UIGestureRecognizerStateChanged:
        {
            self.springBtn.highlighted = TRUE;
            deleteRecognizer.cancelsTouchesInView = TRUE;
            float offX = point.x - lastPoint.x;
            float offY = point.y - lastPoint.y;
            lastPoint = point;
            [self setCenter:CGPointMake(self.center.x + offX, self.center.y + offY)];
            if (self.delegate && [self.delegate respondsToSelector:@selector(SpringItemDMove:)]) {
                [self.delegate performSelector:@selector(SpringItemDMove:) withObject:self];
            }
            
//            if (self.center.y <= 850) {
//                if (self.frame.size.width != 100) {
//                    //down->up
//                    [self setLastCenter:CGPointMake(0, 0)];
//                    [self setLocation:up];
//                    [delegate arrangeDownButtonsWithButton:self andAdd:NO];
//                    [UIView animateWithDuration:.2 animations:^{
//                        [self setFrame:CGRectMake(self.center.x + offX - 50, self.center.y + offY - 50, 100, 100)];
//                    }];
//                }
//            }else{
//                if (self.frame.size.width != 80) {
//                    //up->down
//                    [self setLastCenter:CGPointMake(0, 0)];
//                    [self setLocation:down];
//                    [delegate arrangeUpButtonsWithButton:self andAdd:NO];
//                    [delegate setDownButtonsFrameWithAnimate:YES withoutShakingButton:self];
//                    [UIView animateWithDuration:.2 animations:^{
//                        [self setFrame:CGRectMake(self.center.x + offX - 40, self.center.y + offY - 40, 80, 80)];
//                    }];
//                }
//            }
//            lastPoint = point;
//            [delegate checkLocationOfOthersWithButton:self];
            break;
        }
        case UIGestureRecognizerStateEnded:
            [self setAlpha:1];
            if (self.movEnabled) {
                self.movEnabled = FALSE;
                
            }
            deleteRecognizer.cancelsTouchesInView = TRUE;
            NSLog(@"UIGestureRecognizerStateEnded");
            //            switch ( self.location) {
//                case up:
//                    self.location = up;
//                    [UIView animateWithDuration:.5 animations:^{
//                        if (self.lastCenter.x == 0) {
//                            [delegate arrangeUpButtonsWithButton:self andAdd:YES];
//                        }else{
//                            [self setFrame:CGRectMake(lastCenter.x - 50, lastCenter.y - 50, 100, 100)];
//                        }
//                        
//                    } completion:^(BOOL finished) {
//                        [self.layer setShadowOpacity:0];
//                    }];
//                    break;
//                case down:
//                    [self setLocation:down];
//                    [UIView animateWithDuration:0.5 animations:^{
//                        if (self.lastCenter.x == 0) {
//                            [delegate arrangeDownButtonsWithButton:self andAdd:YES];
//                        }else{
//                            [self setFrame:CGRectMake(lastCenter.x - 40, lastCenter.y - 40, 80, 80)];
//                        }
//                    } completion:^(BOOL finished) {
//                        [self.layer setShadowOpacity:0];
//                    }];
//                    break;
//                default:
//                    break;
//            }
            
            break;
        case UIGestureRecognizerStateCancelled:
            NSLog(@"UIGestureRecognizerStateCancelled");
            [self setAlpha:1];
            break;
        case UIGestureRecognizerStateFailed:
            NSLog(@"UIGestureRecognizerStateFailed");

            [self setAlpha:1];
            break;
        default:
            NSLog(@"DEFAULT");
            break;
    }
}


-(void)executePreDelAnimation:(void (^)(void))block
{
    self.layer.transform = CATransform3DMakeScale(1.2f, 1.2f, 1.f);
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:block];
    {
        CAKeyframeAnimation *expand = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        expand.keyTimes = @[@0.f,
                            @0.25f,
                            @0.6f];
        
        expand.values = @[@(1.0f),
                          @(0.8f),
                          @(1.2f)];
        expand.calculationMode = kCAAnimationCubic;
        expand.duration = 0.6f;
        [self.layer addAnimation:expand forKey:@"Expand"];
    }
    [CATransaction commit];
}

-(void)preDeleteAction:(id)sender
{
    self.springBtn.highlighted =TRUE;
    if (self.btnState != BTN_Delete)
    {
        self.btnState = BTN_Delete;
    }
    self.movEnabled = TRUE;
    if (self.delegate && [self.delegate respondsToSelector:@selector(SpringItemWillShowDeleteBtn:)]) {
        [self.delegate performSelector:@selector(SpringItemWillShowDeleteBtn:) withObject:self];
    }
}

-(void)startDeleteBtnAnimation
{
        [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_APPBecomeActive object:nil];
    
        CALayer*viewLayer=[self.delBtn layer];
        CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform"];
        animation.duration=0.2;
        animation.repeatCount = 100000;
        animation.autoreverses=YES;
        animation.fromValue=[NSValue valueWithCATransform3D:CATransform3DRotate
                             (viewLayer.transform, -0.3, 0.0, 0.0, 0.3)];
        animation.toValue=[NSValue valueWithCATransform3D:CATransform3DRotate
                           (viewLayer.transform, 0.3, 0.0, 0.0, 0.3)];
        [viewLayer addAnimation:animation forKey:@"wiggle"];
    

}

-(void)pauseDeleteBtnAnimation
{
    if (self.btnState == BTN_Delete ) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startDeleteBtnAnimation) name:Notification_APPBecomeActive object:nil];
    }
}

-(void)delAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(SpringItemDelete:)]) {
        [self.delegate performSelector:@selector(SpringItemDelete:) withObject:self];
    }
}

- (void)drawRect:(CGRect)rect
{
    float titleLabelY = 0;

    if(self.itemType == SpringBoardItemLargeRectBtn) {
        CGPoint centerP = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
        float width = rect.size.width / 2;
        [self.pbBtnBg setFrame:CGRectMake(0, 0, width, width)];
        [self.pbBtnBg setCenter:centerP];
        [self.pbBtnBg setImage:self.itemIcon];
        
        if (self.title)
            titleLabelY = self.pbBtnBg.frame.size.height + self.pbBtnBg.frame.origin.y - TitleLabel_Gap;
        
    } else if(self.itemType == SpringBoardItemIconBtn){
        CGSize size  = self.itemIcon.size;
        float  btnHeight = 0;
        if (self.title) {
            btnHeight = rect.size.height - (TitleLabel_Height + TitleLabel_Gap)  ;
            if (btnHeight  >= size.height ) {
                btnHeight = size.height;
            }
            btnHeight = MAX(btnHeight, 0);
        } else {
            btnHeight = rect.size.height;
        }
        float btnWidth = size.width * btnHeight / size.height;
        CGRect btnRect;
        btnRect.size  = CGSizeMake(btnWidth, btnHeight);
        btnRect.origin = CGPointMake(CGRectGetMidX(rect) - btnWidth / 2, (rect.size.height - btnHeight - (TitleLabel_Height + TitleLabel_Gap)) / 2 );
        [self.springBtn setFrame:btnRect];
        [self.springBtn setBackgroundImage:self.itemIcon forState:UIControlStateNormal];
        
        if (self.title) {
            titleLabelY = self.springBtn.frame.size.height + self.springBtn.frame.origin.y + TitleLabel_Gap;
        }

    }
    
    float y = titleLabelY;
    [self.itemTitleLabel setFrame:CGRectMake(0, y, self.frame.size.width, TitleLabel_Height)];
}
@end

CGPoint centerOfFrame(CGRect rect)
{
    CGPoint point = CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2);
    return point;
    
}


