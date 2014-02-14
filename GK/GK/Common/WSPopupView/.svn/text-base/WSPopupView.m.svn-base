//
//  WSPopupView.m
//  GK
//
//  Created by W.S. on 13-10-17.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "WSPopupView.h"
#import "ReferemceList.h"
#import "Config.h"
#import "GKAppDelegate.h"

@interface WSPopupView()
@property (nonatomic,strong) UIView *popView;
@property (nonatomic,strong) UIView *maskView;
@property (nonatomic,strong) UIView *eventV;
@property (nonatomic,assign) WS_PopStyle style;
@property (nonatomic,strong) UITapGestureRecognizer *freeTap;
@end

@implementation WSPopupView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//        CGPoint buttonPoint = [self.popView convertPoint:point fromView:self];
//       if ([self.popView pointInside:buttonPoint withEvent:event]) {
//           UIView *v=[super hitTest:point withEvent:event];
//           NSLog(@"YES : %@",v);
//
//           return v;
//       } else {
//           NSLog(@"NO");
//           return self;
//       }
////    UIView *result = [super hitTest:point withEvent:event];
////    CGPoint buttonPoint = [self.popView convertPoint:point fromView:self];
////    if ([self.popView pointInside:buttonPoint withEvent:event]) {
////        return self.popView;
////    }
////    return result;
//}


//+(WSPopupView*)showPopupView:(UIView*)popupView at:(CGPoint)point mask:(CGRect)rect type:(WS_PopStyle)type
//{
//    UIWindow *window = [UIApplication sharedApplication].windows[0];
//    
//    WSPopupView *selfView = [[WSPopupView alloc] initWithFrame:window.frame];
//    selfView.backgroundColor = [UIColor clearColor];
//    selfView.style = type;
//    selfView.popView = popupView;
//    [window addSubview:selfView];
//    
//    if (!CGPointEqualToPoint(point, CGPointZero)) {
//        
//    }
//    
//    UIView *maskV = [[UIView alloc] initWithFrame:rect];
//    maskV.backgroundColor = [UIColor blackColor];
//    maskV.alpha = 0.0f;
//    selfView.maskView = maskV;
//    
//    rect.origin = CGPointZero;
//    UIView *eventV = [[UIView alloc] initWithFrame:rect];
//    eventV.backgroundColor = [UIColor clearColor];
//    selfView.eventV = eventV;
//    
//    [selfView addSubview:maskV];
//    [selfView addSubview:eventV];
//    [selfView addSubview:popupView];
//    
//    [selfView showTransform];
//    
//    return selfView;
//}

+(WSPopupView*)showPopupView:(UIView*)popupView mask:(CGRect)rect type:(WS_PopStyle)type
{
    UIWindow *window = [UIApplication sharedApplication].windows[0];

    WSPopupView *selfView = [[WSPopupView alloc] initWithFrame:window.frame];
    selfView.backgroundColor = [UIColor clearColor];
    selfView.style = type;
    selfView.popView = popupView;
    [window addSubview:selfView];

    UIView *maskV = [[UIView alloc] initWithFrame:rect];
    maskV.backgroundColor = [UIColor blackColor];
    maskV.alpha = 0.0f;
    selfView.maskView = maskV;
    
//    rect.origin = CGPointZero;
    UIView *eventV = [[UIView alloc] initWithFrame:window.frame];
    eventV.backgroundColor = [UIColor clearColor];
    selfView.eventV = eventV;
    
    [selfView addSubview:maskV];
    [selfView addSubview:eventV];
    [selfView addSubview:popupView];
    
    [selfView showTransform];
    
    return selfView;
}

-(void)show
{
    UIWindow *window = [UIApplication sharedApplication].windows[0];
    [window addSubview:self];
    
    [self showTransform];
}

-(void)showTransform
{
    void (^finishBlock)(BOOL finished)  = ^(BOOL finished){
        if (finished) {
            self.freeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
            [self.eventV addGestureRecognizer:self.freeTap];
        }

    };

    switch (self.style) {
        case WS_PopS_Down:
        {
            [self.popView layoutIfNeeded];
#if 1
            CGRect drect = self.popView.frame;
            CGRect orect = drect;
            orect.size = CGSizeMake(drect.size.width, 1);
            self.popView.frame = orect;
            [UIView animateWithDuration:CMM_AnimatePerior animations:^{
                self.maskView.alpha = 0.3f;
                self.popView.frame = drect;
            } completion:finishBlock];
#else
            CGAffineTransform transform1 = CGAffineTransformMakeScale(1, 0.01);
            CGAffineTransform transform2 = CGAffineTransformMakeTranslation(0, -self.popView.frame.size.height/2);
            CGAffineTransform transform = CGAffineTransformConcat(transform1, transform2);
            self.popView.transform = transform;
            
            [UIView animateWithDuration:CMM_AnimatePerior animations:^{
                self.maskView.alpha = 0.3f;
                self.popView.transform = CGAffineTransformIdentity;
            } completion:finishBlock];
#endif
            break;
        }
            
        case WS_PopS_Center:
        {
            CGAffineTransform transform = CGAffineTransformMakeScale(0, 0);
            self.popView.transform = transform;
            [UIView animateWithDuration:CMM_AnimatePerior animations:^{
                self.maskView.alpha = 0.3f;
                self.popView.transform = CGAffineTransformIdentity;
            } completion:finishBlock];
            break;
        }
            
        case WS_PopS_Up:
        {
            CGRect drect = self.popView.frame;
            CGRect orect = self.popView.frame;
            
            orect.origin.x = drect.origin.x;
            orect.origin.y = drect.origin.y + drect.size.height;
            orect.size = CGSizeMake(drect.size.width, 0);
            self.popView.frame = orect;
            self.popView.clipsToBounds = YES;
            [APP_DELEGATE.window addSubview:self.popView];
            [UIView animateWithDuration:CMM_AnimatePerior animations:^{
                self.maskView.alpha = 0.3f;
                self.popView.frame = drect;

            } completion:finishBlock];
            break;
        }
        default:
            break;
    }

}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];

    if (IsSafeArray(hitView.gestureRecognizers) || ([hitView isKindOfClass:[UIButton class]] && ((UIButton*)hitView).allTargets != NULL) ) {
        return hitView;
    } else{
        return self.eventV;
    }
}

-(void)tapped:(UITapGestureRecognizer*)recogonizer
{
    if ([self.delegate respondsToSelector:@selector(popViewWillDisappear)]) {
        [self.delegate performSelector:@selector(popViewWillDisappear)];
    }
    
    [self hide];
}

-(void)hide
{    
    switch (self.style) {
        case WS_PopS_Down:
        {
#if 1
            CGRect drect = self.popView.frame;
            CGRect orect = drect;
            orect.size = CGSizeMake(drect.size.width, 1);
            
            [UIView animateWithDuration:CMM_AnimatePerior animations:^{
                self.maskView.alpha = 0;
                self.popView.frame = orect;
            } completion:^(BOOL finished) {
                if (finished) {
                    self.popView.transform = CGAffineTransformIdentity;
                    [self removeFromSuperview];
                    self.popView.frame = drect;
                }
            }];
            
#else
            CGAffineTransform transform1 = CGAffineTransformMakeScale(1, 0.01);
            CGAffineTransform transform2 = CGAffineTransformMakeTranslation(0, -self.popView.frame.size.height/2);
            CGAffineTransform transform = CGAffineTransformConcat(transform1, transform2);
            
            [UIView animateWithDuration:CMM_AnimatePerior animations:^{
                self.maskView.alpha = 0;
                self.popView.transform = transform;
            } completion:^(BOOL finished) {
                if (finished) {
                    self.popView.transform = CGAffineTransformIdentity;
                    [self removeFromSuperview];
                }
            }];
#endif
            break;
        }
        case WS_PopS_Center:
        {
            CGAffineTransform transform = CGAffineTransformMakeScale(0, 0);
            [UIView animateWithDuration:CMM_AnimatePerior animations:^{
                self.maskView.alpha = 0;
                self.popView.transform = transform;
            } completion:^(BOOL finished) {
                if (finished) {
                    self.popView.transform = CGAffineTransformIdentity;
                    [self removeFromSuperview];
                }
            }];
            break;
        }
        case WS_PopS_Up:
        {
            CGRect drect = self.popView.frame;
            CGRect orect = self.popView.frame;
            
            orect.origin.x = drect.origin.x;
            orect.origin.y = drect.origin.y + drect.size.height;
            orect.size = CGSizeMake(drect.size.width, 0);
            
            
            [APP_DELEGATE.window addSubview:self.popView];
            [UIView animateWithDuration:CMM_AnimatePerior animations:^{
                self.maskView.alpha = 0;
                self.popView.frame = orect;
                
            } completion:^(BOOL finished) {
                if (finished) {
                    [self removeFromSuperview];
                }
            }
 ];
            break;
        }
        default:
            break;
    }
    
    [self.eventV removeGestureRecognizer:self.freeTap];
   
}

//-(void)layoutSubviews
//{
//    
//}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    
//    
//    
//}



@end
