//
//  NSObject+GKExpand.m
//  GK
//
//  Created by apple on 13-4-11.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "NSObject+GKExpand.h"
#import "NSData+MKBase64.h"
#import "Config.h"
#import <QuartzCore/QuartzCore.h>
#import "GKBaseViewController.h"
#import "ReferemceList.h"
#import "GKAppDelegate.h"

@implementation NSObject (GKExpand)

@end



@implementation UIView (GKExpand)
-(void)setFrame:(CGRect)frame animation:(BOOL)animated completion:(NillBlock_BOOL)completion
{
    if (!animated) {
        [self setFrame:frame];
    } else {
        [UIView animateWithDuration:CMM_AnimatePerior animations:^{
            self.frame = frame;
        } completion:completion];
    }
}

-(void)move:(float)offset direct:(Direction)direction
{
    CGRect rect = self.frame;
    
    switch (direction) {
        case Direct_Down:
            rect.origin.y += offset;
            break;
            
        case Direct_Up:
            rect.origin.y -= offset;
            break;
        
        case Direct_Left:
            rect.origin.x -= offset;
            break;
            
        case Direct_Right:
            rect.origin.x += offset;
            break;

    }
    
    self.frame = rect;

}
-(void)moveUp:(NSNumber*)offset
{
    [self move:[offset floatValue] direct:Direct_Up];
}

-(void)moveDown:(NSNumber*)offset
{
    [self move:[offset floatValue] direct:Direct_Down];
}

-(void)move:(float)offset direct:(Direction)direction animation:(BOOL)animated
{
    CGRect rect = self.frame;
    
    switch (direction) {
        case Direct_Down:
            rect.origin.y += offset;
            break;
            
        case Direct_Up:
            rect.origin.y -= offset;
            break;
            
        case Direct_Left:
            rect.origin.x -= offset;
            break;
            
        case Direct_Right:
            rect.origin.x += offset;
            break;
            
    }
    BOOL hide = TRUE;
    
    if (self.superview) {
        CGRect sRect = self.superview.frame;
        sRect.origin.x = 0;
        sRect.origin.y = 0;
        
        if(CGRectIntersectsRect(sRect,rect)) hide = FALSE;
    }
    [UIView animateWithDuration:CMM_AnimatePerior animations:^{
        self.frame = rect;
        self.alpha = hide ? 0.0f : 1.0f;
    }];
}

-(void)moevrTo:(CGPoint)nPoint
{
    CGRect rect = self.frame;
    rect.origin.x = nPoint.x;
    rect.origin.y = nPoint.y;
    
    [self setFrame:rect];
}

-(void)strechTo:(CGSize)nSize
{
    float widtih = nSize.width;
    float height = nSize.height;
    
    CGRect rect = self.frame;
    rect.size.width = widtih ;
    rect.size.height =height ;
    
    self.frame = rect;
}

-(void)strech:(float)offset direct:(Direction)direction animation:(BOOL)animated
{
    CGRect rect = self.frame;
    
    switch (direction) {
        case Direct_Down:
            rect.size.height += offset;
            break;
            
        case Direct_Up:
            rect.origin.y -= offset;
            rect.size.height += offset;
            break;
            
        case Direct_Left:
            rect.origin.x -= offset;
            rect.size.width += offset;
            break;
            
        case Direct_Right:
            rect.size.width += offset;
            break;
            
    }

    if (animated) {
        [UIView animateWithDuration:CMM_AnimatePerior animations:^{
            self.frame = rect;
        }];
    } else {
        self.frame = rect;
    }
}

-(float)reAliginWith:(UILabel*)label idirect:(Direction)direction gap:(float)gap
{
    float offset = 0;

    switch (direction) {
        case Direct_Down:
        {
            if (IsSafeString(label.text) && !label.hidden) {
                CGSize labsize = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(label.frame.size.width, 9999) lineBreakMode:NSLineBreakByWordWrapping];
                offset = labsize.height  - label.frame.size.height ;
                offset = offset > 0 ? offset :0;
                [label strechTo:CGSizeMake(label.frame.size.width, label.frame.size.height + offset)];
            } else {
                offset = label.frame.origin.y - self.frame.origin.y;
            }
            
            if (gap!= NOT_DEFINED && !label.hidden) {
                offset = label.frame.origin.y + label.frame.size.height;
                offset += gap;
                offset =offset-self.frame.origin.y;
            } 
            [self move:offset direct:Direct_Down];
            break;
        }
        case Direct_Up:
            break;
            
        case Direct_Left:
        {
            if (IsSafeString(label.text)) {
                CGSize labsize = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(label.frame.size.width, 9999) lineBreakMode:NSLineBreakByWordWrapping];
                offset = labsize.width  - label.frame.size.width ;
            } else {
                offset = -label.frame.size.width;
            }
            
            [label strechTo:CGSizeMake(label.frame.size.width + offset, label.frame.size.height)];
            [label move:-offset direct:Direct_Right];
            [self move:-offset direct:Direct_Right];
            
            break;
        }
            break;
            
        case Direct_Right:
        {
            if (IsSafeString(label.text)) {
                CGSize labsize = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(label.frame.size.width, 9999) lineBreakMode:NSLineBreakByWordWrapping];
                offset = labsize.width  - label.frame.size.width ;
            } else {
                offset = -label.frame.size.width;
            }
            
            [label strechTo:CGSizeMake(label.frame.size.width + offset, label.frame.size.height)];
            [self move:offset+2 direct:Direct_Right];
            
            break;
        }
    }
    return offset;
}

-(id)viewForClassName:(NSString*)className
{
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:NSClassFromString(className)]) {
            return v;
        }
    }
    return nil;
}
//#define kWSHidden @"WSHidden"

-(void)setHidden:(BOOL)hidden animation:(BOOL)animation
{
    if (!animation) {
        [self setHidden:hidden];
    } else {
        
        float alpha = self.alpha;
        if (!hidden) {
            self.alpha  = 0.0f;
            self.hidden = FALSE;
        }
        
        [UIView animateWithDuration:CMM_AnimatePerior animations:^{
            self.alpha = hidden ? 0.0f : alpha;
        } completion:^(BOOL finished) {
            if (finished) {
                self.alpha = alpha;
                self.hidden = hidden;
            }
        }];
        
    }
}

-(void)resetrAutoresizingMask
{
    self.autoresizingMask = UIViewAutoresizingNone;
}



@end

@implementation NSArray(GKExpand)

+(id)arrayWithCArray:(char**)strs len:(NSInteger)length
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:length];
    for (int  k = 0; k < length; k++) {
        [array addObject:[NSString stringWithUTF8String:strs[k]]];
    }
    return array;
}

@end


@implementation NSString(GKExpand)

-(NSString*)stringEncodeBase64
{
    size_t outLen;
    char *outStr =  mk_NewBase64Encode(self.UTF8String, strlen(self.UTF8String), FALSE, &outLen);
    if (outLen > 0) {
        return [NSString stringWithUTF8String:outStr];
    } else {
        return nil;
    }
    
}

@end

@implementation UIViewController (GKExpand)
-(void)presentFullViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion;
{
    UIViewController *rvc = APP_DELEGATE.window.rootViewController;
    if (rvc.presentedViewController) {
        [self presentViewController:viewControllerToPresent animated:flag completion:completion];
    } else {
        [rvc presentViewController:viewControllerToPresent animated:flag completion:completion];
    }
}

-(void)dismissFullViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    if (self.presentedViewController) {
        [self dismissViewControllerAnimated:flag completion:completion];
    } else if(self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:flag completion:completion];
    } else {
        UIViewController *rvc = APP_DELEGATE.window.rootViewController;
        [rvc dismissViewControllerAnimated:flag completion:completion];
    }
}

-(void)presentTransparentViewController:(UIViewController*)vc
{
    UIViewController *rvc = APP_DELEGATE.window.rootViewController;

    [rvc addChildViewController:vc];
    [rvc.view addSubview:vc.view];
}

-(void)dismissTransparentViewController
{
//    UIViewController *rvc = APP_DELEGATE.window.rootViewController;

    [self.view removeFromSuperview];
    [self removeFromParentViewController];

}

@end

#if 0
@implementation UINavigationController(GKExpand)
@dynamic finishBlock;

- (void)pushViewController: (UIViewController*)controller
    animatedWithTransition: (UIViewAnimationTransition)_transition {
#if  1
    CATransition *transition = [CATransition animation];
    transition.duration = CMM_AnimatePerior;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    self.navigationBarHidden = YES;
    [self pushViewController:controller animated:NO];
    [self.view.layer addAnimation:transition forKey:nil];
#else
    [self pushViewController:controller animated:NO];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:10];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(pushAnimationDidStop)];
    [UIView setAnimationTransition:transition forView:self.view cache:YES];
    [UIView commitAnimations];
#endif
}

- (void)pushViewControllerAnimatedWithTransition: (UIViewController*)controller
     {
#if  1
         GKBaseViewController *currentVc = [self.viewControllers lastObject];
         [currentVc.view.superview addSubview:controller.view];
         float height =currentVc.view.frame.size.height;
         [controller.view setTransform:CGAffineTransformMakeTranslation(0,height)];
         if ([controller isKindOfClass:[GKBaseViewController class]]) {
             ((GKBaseViewController*)controller).customNavigatorAni = TRUE;
         }
         
         currentVc.customNavigatorAni  = TRUE;
         
         
         [UIView animateWithDuration:CMM_AnimatePerior animations:^(void){
             [controller.view setTransform:CGAffineTransformMakeTranslation(0, 0)];
         }completion:^(BOOL finished){
             if (finished) {
                 [self pushViewController:controller animated:FALSE];
                 [controller viewWillAppear:YES];
             }
         }];
         
         return;
#elif 0
    CATransition *transition = [CATransition animation];
    transition.duration = 2.26f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionMoveIn;
         transition.subtype = kCATransitionFromTop;//kCATransitionFromTop;
    transition.delegate = self;
    self.navigationBarHidden = YES;
    [self pushViewController:controller animated:NO];
    [self.view.layer addAnimation:transition forKey:nil];
#else
    [self pushViewController:controller animated:NO];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:10];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(pushAnimationDidStop)];
    [UIView setAnimationTransition:transition forView:self.view cache:YES];
    [UIView commitAnimations];
#endif
}

- (UIViewController*)popViewControllerAnimatedWithTransition {
    
    
    
 //   UIViewController* poppedController = [self popViewControllerAnimated:NO];
#if  1
    
    GKBaseViewController *currentVc = [self.viewControllers lastObject];
    float height =currentVc.view.frame.size.height;

//    if (self.viewControllers[0] == currentVc) {
//        CGRect rect = currentVc.view.frame;
//        rect.origin.y = rect.size.height;
//        [UIView animateWithDuration:CMM_AnimatePerior animations:^(void){
//            currentVc.view.frame = rect;
//            //[currentVc.view setTransform:CGAffineTransformMakeTranslation(0, height)];
//        }completion:^(BOOL finished){
//            if (finished) {
//                [self popViewControllerAnimated:NO];
//                [currentVc viewWillDisappear:YES];
//            }
//        }];
//    } else
    
    
    {
        UIViewController *preVc = [self.viewControllers objectAtIndex:self.viewControllers.count - 2];
        [currentVc.view.superview insertSubview:preVc.view belowSubview:currentVc.view];
        [UIView animateWithDuration:CMM_AnimatePerior animations:^(void){
            [currentVc.view setTransform:CGAffineTransformMakeTranslation(0, height)];
        }completion:^(BOOL finished){
            if (finished) {
                [self popViewControllerAnimated:NO];
                [currentVc viewWillDisappear:YES];
                GKBaseViewController *currentVc = [self.viewControllers lastObject];
                currentVc.customNavigatorAni = FALSE;

            }
        }];

    }
    

    
    

    return currentVc;
#elif 0
    CATransition *transition = [CATransition animation];
    transition.duration = 2.26f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromBottom;
    transition.delegate = self;
    self.navigationBarHidden = YES;
    [self.view.layer addAnimation:transition forKey:nil];
#else
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:CMM_AnimatePerior];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(pushAnimationDidStop)];
    [UIView setAnimationTransition:transition forView:self.view cache:NO];
    [UIView commitAnimations];
#endif
   // return poppedController;
}
- (UIViewController*)popViewControllerAnimatedWithTransition:(UIViewAnimationTransition)_transition {
    UIViewController* poppedController = [self popViewControllerAnimated:NO];

#if  1
    CATransition *transition = [CATransition animation];
    transition.duration = CMM_AnimatePerior;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromBottom;
    transition.delegate = self;
    self.navigationBarHidden = YES;
    [self.view.layer addAnimation:transition forKey:nil];
#else
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:CMM_AnimatePerior];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(pushAnimationDidStop)];
    [UIView setAnimationTransition:transition forView:self.view cache:NO];
    [UIView commitAnimations];
#endif
    return poppedController;
}

-(void)pusInsidehViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIViewController *currentVc = [self.viewControllers lastObject];
    [currentVc.view.superview addSubview:viewController.view];
    
    if (animated) {
#if 0
        [UIView beginAnimations:@"viewDisappearFromRight" context:nil];
        [currentVc.view setTransform:CGAffineTransformMakeTranslation(-320, 0)];
        [UIView setAnimationDuration:0.3];
      //  [currentVc.view setAlpha:0];
        [UIView commitAnimations];

        [viewController.view setTransform:CGAffineTransformMakeTranslation(320, 0)];
        [UIView beginAnimations:@"viewAppearFromRight" context:nil];
        [UIView setAnimationDuration:0.3];
    //    [viewController.view setAlpha:1.0];
        [viewController.view setTransform:CGAffineTransformMakeTranslation(0, 0)];
        [UIView commitAnimations];

#endif
        [viewController.view setTransform:CGAffineTransformMakeTranslation(320, 0)];
        [UIView animateWithDuration:CMM_AnimatePerior animations:^(void){
            [viewController.view setTransform:CGAffineTransformMakeTranslation(0, 0)];
            [currentVc.view setTransform:CGAffineTransformMakeTranslation(-320, 0)];

        }completion:nil];

	}
    return [self pushViewController:viewController animated:FALSE];


}
-(UIViewController*)popInsideViewControllerAnimated:(BOOL)animated
{
    UIViewController *currentVc = [self.viewControllers lastObject];
 //   [currentVc.view removeFromSuperview];
    
    UIViewController *preVc = [self.viewControllers objectAtIndex:self.viewControllers.count - 2];
#if 0
    if (animated) {
       	[UIView beginAnimations:@"viewDisappearFromLeft" context:nil];
        [currentVc.view setTransform:CGAffineTransformMakeTranslation(320, 0)];
        [preVc.view setTransform:CGAffineTransformMakeTranslation(-320, 0)];

        [UIView setAnimationDuration:0.3];
        [preVc.view setTransform:CGAffineTransformMakeTranslation(0, 0)];

//        [currentVc.view setAlpha:0];
//        [preVc.view setAlpha:1];
        [UIView commitAnimations];
        }
#endif
        [UIView animateWithDuration:CMM_AnimatePerior animations:^(void){
            [preVc.view setTransform:CGAffineTransformMakeTranslation(0, 0)];
            [currentVc.view setTransform:CGAffineTransformMakeTranslation(320, 0)];
            
        }completion:^(BOOL finished){
            if (finished) {
                [currentVc.view removeFromSuperview];
            }
        }];
        
	
    
    return [self popViewControllerAnimated:FALSE];
}


-(UIViewController*)popViewControllerWithAnimation:(NavigationAnimation)animationType finished:(void (^)()) finishBlock
{
    UIViewController *currentVc = [self.viewControllers lastObject];
    UIViewController *preVc = [self.viewControllers objectAtIndex:self.viewControllers.count - 2];
    
    [currentVc.view.superview insertSubview:preVc.view belowSubview:currentVc.view];
    switch (animationType) {
        case NavigationAnimation_AlphaAnimation:
        {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            animation.fromValue = [NSNumber numberWithFloat:1.0f];
            animation.toValue = [NSNumber numberWithFloat:0.0f];
            animation.duration = 1.0f;
            animation.delegate = self;
            [currentVc.view.layer addAnimation:animation forKey:nil];
            self.finishBlock = finishBlock;
            break;
        }
        default:
            break;
    }
    return currentVc;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        [self popViewControllerAnimated:NO];
        if (self.finishBlock) {
            self.finishBlock();
        }
    }
}

static char kFinishBlock;
-(void (^)()) finishBlock
{
    return objc_getAssociatedObject(self, &kFinishBlock);

}

-(void) setFinishBlock:(void (^)())finishBlock
{
    objc_setAssociatedObject(self, &kFinishBlock, finishBlock, OBJC_ASSOCIATION_COPY);
}
@end
#endif

@implementation UIImage (GKExpand)

+(UIImage*)getImgFromFile:(NSString*)imgName
{
    NSString *path = [APP_DocPath() stringByAppendingFormat:@"/%@", imgName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSAssert(path != nil, @"%@", path);
        return nil;
    }
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return image;
}

- (UIImage *)fixOrientation
{
    //    UIImage *src = [[UIImage alloc] initWithCGImage: self.CGImage
    //                                              scale: 1.0
    //                                        orientation: UIImageOrientationRight];
    //
    //    return src;
    {
        
        // No-op if the orientation is already correct
        if (self.imageOrientation == UIImageOrientationUp) return self;
        
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        CGAffineTransform transform = CGAffineTransformIdentity;
        
        switch (self.imageOrientation) {
            case UIImageOrientationDown:
            case UIImageOrientationDownMirrored:
                transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
                transform = CGAffineTransformRotate(transform, M_PI);
                break;
                
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
                transform = CGAffineTransformTranslate(transform, self.size.width, 0);
                transform = CGAffineTransformRotate(transform, M_PI_2);
                break;
                
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
                transform = CGAffineTransformTranslate(transform, 0, self.size.height);
                transform = CGAffineTransformRotate(transform, -M_PI_2);
                break;
            default:
                break;
        }
        
        switch (self.imageOrientation) {
            case UIImageOrientationUpMirrored:
            case UIImageOrientationDownMirrored:
                transform = CGAffineTransformTranslate(transform, self.size.width, 0);
                transform = CGAffineTransformScale(transform, -1, 1);
                break;
                
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRightMirrored:
                transform = CGAffineTransformTranslate(transform, self.size.height, 0);
                transform = CGAffineTransformScale(transform, -1, 1);
                break;
            default:
                break;
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                                 CGImageGetBitsPerComponent(self.CGImage), 0,
                                                 CGImageGetColorSpace(self.CGImage),
                                                 CGImageGetBitmapInfo(self.CGImage));
        CGContextConcatCTM(ctx, transform);
        switch (self.imageOrientation) {
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
                // Grr...
                CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
                break;
                
            default:
                CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
                break;
        }
        
        // And now we just create a new UIImage from the drawing context
        CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
        UIImage *img = [UIImage imageWithCGImage:cgimg];
        CGContextRelease(ctx);
        CGImageRelease(cgimg);
        return img;
    }
    
}
- (UIImage *)scaleToSize:(CGSize)reSize

{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [self drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
    
}
-(UIImage *)scale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width * scaleSize, self.size.height * scaleSize));
    [self drawInRect:CGRectMake(0, 0, self.size.width * scaleSize, self.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
    
}

+(id) imageWithUIView:(UIView*) view{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef currnetContext = UIGraphicsGetCurrentContext();
    //[view.layer drawInContext:currnetContext];
    [view.layer renderInContext:currnetContext];
    // 从当前context中创建一个改变大小后的图片
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    return image;
}
@end

@implementation UIImageView (GKExpand)
-(void)compressToRect:(CGRect)rect
{
    float horScale = self.frame.size.width / rect.size.width;
    float verScale = self.frame.size.height / rect.size.height;
    
//    CGRect = CGRectInset(rect, <#CGFloat dx#>, <#CGFloat dy#>)

    if (verScale <=1 && horScale <= 1) {
        self.center = CGRectCenter(rect);
        return;
    }
    
    CGRect newRect = rect;
    if (verScale >= horScale) {
        newRect.size.width = self.frame.size.width / verScale;
    } else {
        newRect.size.height = self.frame.size.height / horScale;
    }
    
    UIGraphicsBeginImageContext(newRect.size);
    [self.image drawInRect:newRect];
    UIImage *scaleImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.frame = newRect;
    self.center = CGRectCenter(rect);
    self.image = scaleImg;

}
@end

@implementation UINavigationBar (GKExpand)
- (void)drawRect:(CGRect)rect
{
    [NavBg() drawInRect:rect];
}

@end

@implementation GKLabel_Style0:UILabel
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.textColor = colorWithUtfStr(Color_HeadPage_Menu);
    self.font = [UIFont systemFontOfSize:14];
}
@end

@implementation GKLabel_Style1:UILabel
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.textColor = colorWithUtfStr(Color_ListDescription);
    self.font = [UIFont systemFontOfSize:12];
    self.textAlignment = NSTextAlignmentLeft;
}
@end

//@implementation GKNavigationBar
//
//- (void)drawRect:(CGRect)rect {
//    
//    [super drawRect:rect];
//    
//}
//
//@end

@implementation DownLineLabel : UILabel
//@synthesize downLineColor;
//static char kDownLineColor;

//-(void)setDownLineColor:(UIColor *)lineColor
//{
//    //objc_setAssociatedObject(self, &kDownLineColor, lineColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}

//-(UIColor*)downLineColor
//{
//    return objc_getAssociatedObject(self, &kDownLineColor);
//}

- (void)drawRect:(CGRect)rect
{
    
    float width = self.frame.size.width;
    
    CGSize sizeToFit = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 207.0f/255.0f, 91.0f/255.0f, 44.0f/255.0f, 1.0f);

    if (!self.downLineColor) {
        CGContextSetRGBStrokeColor(context, 0, 0, 1.0f, 1.0f);

    } else{
        float red,green,blue,alpha;
        [self.downLineColor getRed:&red green:&green blue:&blue alpha:&alpha];
        CGContextSetRGBStrokeColor(context,red,green,blue,alpha);
    }

    CGContextSetLineWidth(context, 0.5f);
    
    CGContextMoveToPoint(context, (self.frame.size.width - sizeToFit.width )/ 2 , self.bounds.size.height - 1);
    CGContextAddLineToPoint(context,(self.frame.size.width + sizeToFit.width) / 2 , self.bounds.size.height -1);
    
//    CGContextMoveToPoint(context, 0, self.bounds.size.height - 1);
//    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height - 1);
    
    CGContextStrokePath(context);
    
    [super drawRect:rect];
    
}

@end

@implementation XIBView

+(id)XIBView
{
    id obj = [[[NSBundle mainBundle] loadNibNamed:[NSString stringWithUTF8String:object_getClassName(self)] owner:self options:nil] objectAtIndex:0];
    return obj;
}
@end

CGPoint CGRectCenter(CGRect rect)
{
    return CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2);
}

char* strlwr( char* str )
{
    char* orig = str;
    // process the string
    for ( ; *str != '\0'; str++ )
        *str = tolower(*str);
    return orig;
}

int hexstrtoint(char *s)
{
    int  i, n;
    
    i = 0;
    
    char *str = strlwr(s);
    
    for (n = 0; str[i] != '\0'; i++)
        if (str[i] >= '0' && str[i] <= '9')
            n = n * 16 + (str[i] - '0');
        else if (str[i] >= 'a' && str[i] <= 'f')
            n = n * 16 + (str[i] - 'a' + 10);
        else if (str[i] >= 'a' && str[i] <= 'f')
            n = n * 16 + (str[i] - 'a' + 10);
        else
            break;
    return n;
}

float redColor(char* colStr) //以#开头
{
    char redStr[3] = {0};
    
    redStr[0] = colStr[1];
    redStr[1] = colStr[2];
    
    float xx = hexstrtoint(redStr);
    return  xx;
}


float greenColor(char* colStr) //以#开头
{
    char greenStr[3] ={0};
    
    greenStr[0] = colStr[3];
    greenStr[1] = colStr[4];
    
    float xx = hexstrtoint(greenStr);
    return  xx;}

float blueColor(char* colStr) //以#开头
{
    char blueStr[3] ={0};
    
    blueStr[0] = colStr[5];
    blueStr[1] = colStr[6];
    
    float xx = (float)hexstrtoint(blueStr);
    return  xx;
}

UIColor* colorWithUtfStr(char *colStr)
{
   // return [UIColor colorWithRed:153.0/255.0 green:204.0/255.0 blue:1.0 alpha:1.0];
    return [UIColor colorWithRed:redColor(colStr)/255.0 green:greenColor(colStr)/255.0 blue:blueColor(colStr)/255.0 alpha:1];
}


