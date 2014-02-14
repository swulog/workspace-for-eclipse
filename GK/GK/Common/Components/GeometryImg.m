//
//  GeometryImg.m
//  BossE_V1
//
//  Created by 万松 on 12-10-14.
//
//

#import "GeometryImg.h"
#import "NSObject+GKExpand.h"

@implementation GeometryImg
@synthesize fillColor,lineColor,isVertical;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
     //   lineColor = [UIColor blackColor];
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

-(void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
}

-(id)init
{
    return [super init];
}

#pragma mark - property setter
-(void)setFillColor:(UIColor *)_fillColor
{
    fillColor = _fillColor;
    [self setNeedsDisplay];
}

-(void)setLineColor:(UIColor *)_lineColor
{
    lineColor = _lineColor;
    [self setNeedsDisplay];
}

#pragma mark - drawrect
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
  //  UIGraphicsBeginImageContext(CGSizeMake(rect.size.width, rect.size.height));
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
#if 0
    
    size_t num_locations = 2;
    CGFloat locations[2] = {1.0, 0.0};
    CGFloat components[8] = {0.353, 0.353, 0.353, 1.0, // Start color
        0.612, 0.612, 0.612, 1.0};  // End color
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSArray *_tabIconColors = [NSArray arrayWithObjects:(__bridge id)[colorWithUtfStr("#ff8282") CGColor],(__bridge id)[colorWithUtfStr("#ff8282") CGColor], nil];

    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)_tabIconColors, locations) ;
    
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, self.frame.size.height), CGPointMake(0, self.frame.origin.y), kCGGradientDrawsAfterEndLocation);
    
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
#else
    switch (self.type) {
        case Geometry_Line:
            CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
            CGContextSetLineWidth(context, self.lineWidth);
            CGContextBeginPath(context);
            CGContextMoveToPoint(context, 0, 0);
            if (!self.isVertical) {
                CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, 0);
            } else {
                CGContextAddLineToPoint(context, 0, rect.origin.y + rect.size.height);
            }
            CGContextClosePath(context);
            CGContextStrokePath(context);

            break;
        case Geometry_Ellipse:
        {
            NSInteger mode = -1;
            if (self.fillColor) {
                const float *colors = CGColorGetComponents(self.fillColor.CGColor);
                CGContextSetRGBFillColor(context,colors[0],colors[1],colors[2],colors[3]);
                mode = kCGPathFill;
            }
            if (self.lineColor) {
                const float *colors1 = CGColorGetComponents(self.lineColor.CGColor);
                CGContextSetLineWidth(context, 2);
                CGContextSetRGBStrokeColor(context, colors1[0],colors1[1],colors1[2],colors1[3]);
                mode = mode == kCGPathFill ? kCGPathFillStroke : kCGPathStroke;

            }
            
            CGContextBeginPath(context);
            CGContextMoveToPoint(context, 0, 0);
            CGRect rect1 = rect;
            rect1.origin.x +=1;
            rect1.size.width -=2;
            rect1.origin.y += 1;
            rect1.size.height -=2;
            CGContextAddEllipseInRect(context, rect1);
            
            
            
            
            CGContextClosePath(context);
//            CGColorRef backgroundShadow = [UIColor lightGrayColor].CGColor;
//            CGSize backgroundShadowOffset = CGSizeMake(-1, 0);
//            CGFloat backgroundShadowBlurRadius = 1;
//            CGContextSetShadowWithColor(context, backgroundShadowOffset, backgroundShadowBlurRadius, backgroundShadow);
            
            CGContextDrawPath(context, mode);
            
            break;

        }
        case Geometry_DotLine:
        {
            CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
            float lengths[] = {5,5};
    //        CGContextSetLineDash(context, 0, lengths,2);
            CGContextSetLineDash(context,2,lengths,2);
            CGContextSetLineWidth(context, 1);
            CGContextBeginPath(context);
            CGContextMoveToPoint(context, 0, 0);
            if (!self.isVertical) {
                CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, 0);
            } else {
                CGContextAddLineToPoint(context, 0, rect.origin.y + rect.size.height);
            }
            CGContextClosePath(context);
            CGContextStrokePath(context);
            
            break;
        }
            
        case Geometry_RradientRect:
        {
            size_t num_locations = 2;
            CGFloat locations[2] = {0.0, 1.0};
            CGFloat components[8] = {0.9, 0.9, 0.9, 1.0,    // Start color
                0.2, 0.2, 0.2, 0.8};    // End color
            
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGGradientRef gradient = self.radientColors ? CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)self.radientColors, locations) : CGGradientCreateWithColorComponents (colorSpace, components, locations, num_locations);
            
            CGRect p_clipRect = self.bounds;
            CGPoint startPoint,endPoint;
            if (self.radientDirect == RradientDirect_LeftToRight) {
                startPoint = p_clipRect.origin;
                endPoint = CGPointMake(CGRectGetMinX(p_clipRect), CGRectGetMaxY(p_clipRect));
            }

            CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsAfterEndLocation);
            
            
            CGColorSpaceRelease(colorSpace);
            CGGradientRelease(gradient);
        }
        default:
            break;
    }
#endif
  //  self.image = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRestoreGState(context);
 //   UIGraphicsEndImageContext();

}

- (NSArray *) radientColors
{
    return _radientColors ? @[(id)[[_radientColors objectAtIndex:0] CGColor], (id)[[_radientColors objectAtIndex:1] CGColor]] : nil;
}
@end
