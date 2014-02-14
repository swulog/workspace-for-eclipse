//
//  NSObject+WSExpand.m
//  GK
//
//  Created by apple on 13-4-11.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "NSObject+WSExpand.h"
#import <QuartzCore/QuartzCore.h>
#import "NSData+MKBase64.h"
#import "AppConstans.h"
#import "APPConfig.h"




@implementation NSObject (WSExpand)

@end


@implementation UIView (WSExpand)


-(void)setFrame:(CGRect)frame animation:(BOOL)animated
{
    [UIView animateWithDuration:0.26f animations:^{
        [self setFrame:frame];
    }];
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
    [UIView animateWithDuration:0.26f animations:^{
        self.frame = rect;
        self.alpha = hide ? 0.0f : 1.0f;
    }];
}
@end

@implementation NSArray(WSExpand)

+(id)arrayWithCArray:(char**)strs len:(NSInteger)length
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:length];
    for (int  k = 0; k < length; k++) {
        [array addObject:[NSString stringWithUTF8String:strs[k]]];
    }
    return array;
}

@end


@implementation NSString(WSExpand)

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





@implementation UINavigationController(WSExpand)
- (void)pushAnimationDidStop {
}
//自定义动画弹出弹入
- (void)pushViewControllerAnimatedWithTransition: (UIViewController*)controller
     {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.26f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    transition.delegate = self;
    self.navigationBarHidden = YES;
    [self pushViewController:controller animated:NO];
    [self.view.layer addAnimation:transition forKey:nil];
}

- (UIViewController*)popViewControllerAnimatedWithTransition {
    UIViewController* poppedController = [self popViewControllerAnimated:NO];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.26f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromBottom;
    transition.delegate = self;
    self.navigationBarHidden = YES;
    [self.view.layer addAnimation:transition forKey:nil];

    return poppedController;
}


//在一个contentView里弹入弹出
-(void)pusInsidehViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIViewController *currentVc = [self.viewControllers lastObject];
    [currentVc.view.superview addSubview:viewController.view];
    
    if (animated) {

        [viewController.view setTransform:CGAffineTransformMakeTranslation(320, 0)];
        [UIView animateWithDuration:0.26f animations:^(void){
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
    
    [UIView animateWithDuration:0.26f animations:^(void){
        [preVc.view setTransform:CGAffineTransformMakeTranslation(0, 0)];
        [currentVc.view setTransform:CGAffineTransformMakeTranslation(320, 0)];
        
    }completion:^(BOOL finished){
        if (finished) {
            [currentVc.view removeFromSuperview];
        }
    }];
    
    
    return [self popViewControllerAnimated:FALSE];
}

////推出推入包括tabbar
//-(void)pusViewController:(UIViewController *)viewController andTab:(BOOL)pushTab animated:(BOOL)animated
//{
//    UIViewController *currentVc = [self.viewControllers lastObject];
//    //[self.view addSubview:viewController.view];
//    
//    
//    UIView *v = viewController.view;
//
//
//    if (pushTab) {
//        CGRect rect= v.frame;
//        [v strechTo:CGSizeMake(rect.size.width , rect.size.height +  44)];
//
//        
////        
////        [viewController.view setTransform:CGAffineTransformMakeTranslation(320, 0)];
////        [UIView animateWithDuration:2.26f animations:^(void){
////            [viewController.view setTransform:CGAffineTransformMakeTranslation(0, 0)];
////            [currentVc.view setTransform:CGAffineTransformMakeTranslation(-320, 0)];
////            
////        }completion:nil];
//
//    }
//    
//    return [self pushViewController:viewController animated:YES];
//
/////s[self pushViewController:viewController animated:animated];
//}

@end


@implementation UIImage (WSExpand)

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

@end

@implementation UIImageView (WSExpand)
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

@implementation UINavigationBar (WSExpand)
- (void)drawRect:(CGRect)rect
{
    UIImage *image = [UIImage imageNamed: NavBarBackgoundImg];
    //这个图片就是我们上面制作的图片，使用前需要在项目中把图片加载到工程中来。
    
    [image drawInRect:CGRectMake(0, 0, 320, 44)];
}

@end

@implementation GKLabel_Style0:UILabel
//-(void)awakeFromNib
//{
//    [super awakeFromNib];
//    self.textColor = colorWithUtfStr(Color_HeadPage_Menu);
//    self.font = [UIFont systemFontOfSize:14];
//}
@end

@implementation GKLabel_Style1:UILabel
//-(void)awakeFromNib
//{
//    [super awakeFromNib];
//    self.textColor = colorWithUtfStr(Color_ListDescription);
//    self.font = [UIFont systemFontOfSize:12];
//}
@end

@implementation GKNavigationBar

- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
}

@end

@implementation NSError (Description)

+ (NSError *)errorWithMsg:(NSString *)msg
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:msg?:@"发生错误!", NSLocalizedDescriptionKey, nil];
    return [NSError errorWithDomain:WS_ErrorDomain code:-1000 userInfo:userInfo];
}

+ (NSError *)errorWithMsg:(NSString *)msg code:(NSInteger)_code
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:msg?:@"发生错误!", NSLocalizedDescriptionKey, nil];
    return [NSError errorWithDomain:WS_ErrorDomain code:_code userInfo:userInfo];
}

@end

@implementation DownLineLabel : UILabel
- (void)drawRect:(CGRect)rect
{
    
    float width = self.frame.size.width;
    
    
    CGSize sizeToFit = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:WSLineBreakModeWordWrap()];
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
//    CGContextSetRGBStrokeColor(context, 207.0f/255.0f, 91.0f/255.0f, 44.0f/255.0f, 1.0f);
    
    CGContextSetRGBStrokeColor(context, 0, 0, 1.0f, 1.0f);

    CGContextSetLineWidth(context, 0.5f);
    
    CGContextMoveToPoint(context, (self.frame.size.width - sizeToFit.width )/ 2 , self.bounds.size.height - 1);
    CGContextAddLineToPoint(context,(self.frame.size.width + sizeToFit.width) / 2 , self.bounds.size.height -1);
    
//    CGContextMoveToPoint(context, 0, self.bounds.size.height - 1);
//    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height - 1);
    
    CGContextStrokePath(context);
    
    [super drawRect:rect];
    
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
