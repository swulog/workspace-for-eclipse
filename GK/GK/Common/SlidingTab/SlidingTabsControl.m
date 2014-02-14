//
//  SlidingTabsControl.m
//  SlidingTabs
//
//  Created by Mathew Piccinato on 5/12/11.
//  Copyright 2011 Constructt. All rights reserved.
//

#import "SlidingTabsControl.h"
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
#import "NSObject+GKExpand.h"
#import "GKAppDelegate.h"

@implementation SlidingTabsControl

#define Tag_DropArrow_Start 1100
#define Tag_Label_Start 1000

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

//-(void)awakeFromNib
//{
//    self.backgroundColor = [UIColor blueColor];
//}



-(void)initWithCount:(NSUInteger)tabCount drop:(BOOL)enbaled delegate:(NSObject<SlidingTabsControlDelegate> *)slidingTabsControlDelegate
{
    _delegate = slidingTabsControlDelegate;
    self.selectTabIndex = 0;
    self.backgroundColor = [UIColor clearColor];
    self.needDropArraow = enbaled;
    
    CGFloat horizontalOffset = 0;
    CGFloat buttonWidth = (320.0 / tabCount);
    CGFloat buttonHeight = 44;
    
    _buttons = [[NSMutableArray alloc] initWithCapacity:tabCount];

    for (int k = 0; k < tabCount; k++) {
        horizontalOffset = buttonWidth *k ;
        UILabel *label ;
        if ([_delegate respondsToSelector:@selector(labelFor:atIndex:)]) {
            label = [_delegate labelFor:self atIndex:k];
        } else {
            UIImageView *bgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slideTabBg"]];
            [bgV setFrame:CGRectMake(horizontalOffset, 0, buttonWidth, buttonHeight)];
            [self addSubview:bgV];
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(horizontalOffset, 0, buttonWidth, buttonHeight)];
            label.backgroundColor = [UIColor clearColor];
            if ([_delegate respondsToSelector:@selector(titleFor:atIndex:)]) {
                label.text = [_delegate titleFor:self atIndex:k];
            } else {
                label.text = @"";
            }
        }
        label.font = [UIFont fontWithName:@"Arial-BoldMT" size:16.0f];
        label.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.35];
        label.shadowOffset = CGSizeMake(0, -1.0);
        label.textColor = self.selectTabIndex == k ? colorWithUtfStr(Color_TabSeleteorText) :colorWithUtfStr(Color_TabUnSeleteorText);
        label.textAlignment = NSTextAlignmentCenter;
        label.frame = CGRectMake((int)horizontalOffset, 0, buttonWidth, buttonHeight);
        [label setTag:k+Tag_Label_Start];
        label.backgroundColor = [UIColor clearColor];
        [self addSubview:label];

        if (self.needDropArraow) {
            UIButton *arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [arrowBtn setTag:(Tag_DropArrow_Start+k)];
            
            [arrowBtn setFrame:CGRectMake(horizontalOffset+buttonWidth- 40, 17, 10, 10)];

            [arrowBtn setBackgroundImage:[UIImage imageNamed:@"drop_arrow_unSeleted"] forState:UIControlStateNormal];
            [arrowBtn setBackgroundImage:[UIImage imageNamed:@"down_arrow_Seleted"] forState:UIControlStateHighlighted];
            [self addSubview:arrowBtn];
            
            if (self.selectTabIndex == k) {
                [arrowBtn setHighlighted:YES];
            }
        }
        
        
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(horizontalOffset, 0.0, buttonWidth, buttonHeight)];
        button.backgroundColor = [UIColor clearColor];
        // Register for touch events
        [button addTarget:self action:@selector(touchDownAction:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchUpOutside];
        [button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchDragOutside];
        [button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchDragInside];
        
        // Add the button to our buttons array
        [_buttons addObject:button];
        [self addSubview:button];
        
    }
    
    if ([_delegate respondsToSelector:@selector(maskViewFor:)]) {
        nTab = [_delegate maskViewFor:self];
        [nTab setFrame:CGRectMake(0, 0, buttonWidth, 44)];
    } else{
        nTab = [[UIView alloc] initWithFrame:CGRectMake(0, 0, buttonWidth, 44)];
        nTab.backgroundColor = [UIColor colorWithRed:40.0/255.0 green:96.0/255.0 blue:(float)0xee/(float)0xff alpha:0.5];
    }
    

    [self addSubview:nTab];
}



-(void)initWithTabCount_Ex:(NSUInteger)tabCount
               delegate:(NSObject <SlidingTabsControlDelegate>*)slidingTabsControlDelegate
{
    {
        // Set the delegate
        _delegate = slidingTabsControlDelegate;
        self.selectTabIndex = 0;
        // Set our frame
      //  self.frame = CGRectMake(0, 44, 320, 40);
     //   self.backgroundColor = [UIColor darkGrayColor];
        self.backgroundColor = [UIColor clearColor];
        CGPoint p = CGPointMake(self.frame.origin.x, self.frame.origin.y);
        p = [self convertPoint:p toView:APP_DELEGATE.window];
        
        
        // Initalize the array we use to store our buttons
        _buttons = [[NSMutableArray alloc] initWithCapacity:tabCount];
        
        // horizontalOffset tracks the proper x value as we add buttons as subviews
        CGFloat horizontalOffset = 0;
        CGFloat buttonWidth = (320.0 / tabCount);
        CGFloat buttonHeight = 40;
        
        // Draw our tab!
        _tab = [[SlidingTabsTab alloc] initWithFrame:CGRectMake(-5, 0, buttonWidth+10.0, buttonHeight)];
        
    //    nTab = [[UIView alloc] initWithFrame:CGRectMake(-5, 0, buttonWidth+10.0, 44)];
        nTab = [[UIView alloc] initWithFrame:CGRectMake(0, 0, buttonWidth, 44)];

        nTab.backgroundColor = [UIColor colorWithRed:40.0/255.0 green:96.0/255.0 blue:(float)0xee/(float)0xff alpha:0.5];
        [self addSubview:nTab];
        
      //  [self addSubview:_tab];
        
        // Iterate through each segment
        for (NSUInteger i = 0 ; i < tabCount ; i++)
        {
            // Get the label for the segment
            UILabel *label = [_delegate labelFor:self atIndex:i];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont fontWithName:@"Arial-BoldMT" size:16.0f];
//            label.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.35];
//            label.shadowOffset = CGSizeMake(0, -1.0);
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.frame = CGRectMake((int)horizontalOffset, 0, buttonWidth, buttonHeight);
            [label setTag:i+Tag_Label_Start];
            [self addSubview:label];
            
            // Create a button
            UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(horizontalOffset, 0.0, buttonWidth, buttonHeight)];
            // Register for touch events
            [button addTarget:self action:@selector(touchDownAction:) forControlEvents:UIControlEventTouchDown];
            [button addTarget:self action:@selector(touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
            [button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchUpOutside];
            [button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchDragOutside];
            [button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchDragInside];
            
            // Add the button to our buttons array
            [_buttons addObject:button];
            
            // Set the button's x offset
            button.frame = CGRectMake(horizontalOffset, 0.0, button.frame.size.width, button.frame.size.height);
            
            // Add the button as our subview
           [self addSubview:button];
            
            // Add the divider unless we are at the last segment
            if (i != tabCount - 1)
            {
                //UIImageView* divider = [[[UIImageView alloc] initWithImage:dividerImage] autorelease];
                //divider.frame = CGRectMake(horizontalOffset + segmentsize.width, 0.0, dividerImage.size.width, dividerImage.size.height);
                //[self addSubview:divider];
            }
            
            // Advance the horizontal offset
            horizontalOffset = horizontalOffset + buttonWidth;
            
            
        }
    }

}

- (id) initWithTabCount:(NSUInteger)tabCount
                   delegate:(NSObject <SlidingTabsControlDelegate>*)slidingTabsControlDelegate
{
    if ((self = [super init]))
//    {
//        // Set the delegate
//        _delegate = slidingTabsControlDelegate;
//        
//        // Set our frame
//        self.frame = CGRectMake(0, 0, 320, 40);
//        self.backgroundColor = [UIColor darkGrayColor];
//        
//        // Initalize the array we use to store our buttons
//        _buttons = [[NSMutableArray alloc] initWithCapacity:tabCount];
//        
//        // horizontalOffset tracks the proper x value as we add buttons as subviews
//        CGFloat horizontalOffset = 0;
//        CGFloat buttonWidth = (320.0 / tabCount);
//        CGFloat buttonHeight = 40;
//        
//        // Draw our tab!
//        _tab = [[SlidingTabsTab alloc] initWithFrame:CGRectMake(-5, 0, buttonWidth+10.0, buttonHeight)];
//        [self addSubview:_tab];
//        
//        // Iterate through each segment
//        for (NSUInteger i = 0 ; i < tabCount ; i++)
//        {
//            // Get the label for the segment
//            UILabel *label = [_delegate labelFor:self atIndex:i];
//            label.backgroundColor = [UIColor clearColor];
//            label.font = [UIFont fontWithName:@"Arial-BoldMT" size:16.0f];
//            label.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.35];
//            label.shadowOffset = CGSizeMake(0, -1.0);
//            label.textColor = [UIColor whiteColor];
//            label.textAlignment = NSTextAlignmentCenter;
//            label.frame = CGRectMake((int)horizontalOffset, 0, buttonWidth, buttonHeight);
//            [self addSubview:label];
//            
//            // Create a button
//            UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(horizontalOffset, 0.0, buttonWidth, buttonHeight)];
//            
//            // Register for touch events
//            [button addTarget:self action:@selector(touchDownAction:) forControlEvents:UIControlEventTouchDown];
//            [button addTarget:self action:@selector(touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
//            [button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchUpOutside];
//            [button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchDragOutside];
//            [button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchDragInside];
//            
//            // Add the button to our buttons array
//            [_buttons addObject:button];
//            
//            // Set the button's x offset
//            button.frame = CGRectMake(horizontalOffset, 0.0, button.frame.size.width, button.frame.size.height);
//            
//            // Add the button as our subview
//            [self addSubview:button];
//            
//            // Add the divider unless we are at the last segment
//            if (i != tabCount - 1)
//            {
//                //UIImageView* divider = [[[UIImageView alloc] initWithImage:dividerImage] autorelease];
//                //divider.frame = CGRectMake(horizontalOffset + segmentsize.width, 0.0, dividerImage.size.width, dividerImage.size.height);
//                //[self addSubview:divider];
//            }
//            
//            // Advance the horizontal offset
//            horizontalOffset = horizontalOffset + buttonWidth;
//            
//           
//        }
//    }
    
    {
        [self initWithTabCount_Ex:tabCount delegate:slidingTabsControlDelegate];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
#if 0
    // Set background gradient
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGGradientRef glossGradient;
    CGColorSpaceRef rgbColorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = { 80.0/255.0f, 80.0/255.0f, 80.0/255.0f, 1.0,  // Start color
                              40.0/255.0f, 40.0/255.0f, 40.0/255.0f, 1.0 }; // End color
    
    rgbColorspace = CGColorSpaceCreateDeviceRGB();
    glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
    
    CGRect currentBounds = self.bounds;
    CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0.0f);
    CGPoint midCenter = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetMaxY(currentBounds));
    CGContextDrawLinearGradient(currentContext, glossGradient, topCenter, midCenter, 0);
    
    CGGradientRelease(glossGradient);
    CGColorSpaceRelease(rgbColorspace);
    
    // Draw Button dividers
    for (int i = 0; i < [_buttons count]; i++) {
        CGFloat buttonWidth = (320.0 / [_buttons count]);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 1.0);
        CGContextSetStrokeColorWithColor(context, [UIColor darkGrayColor].CGColor);;
        CGContextSetShadow(context, CGSizeMake (0, 0), 0.0);
        
        CGContextSaveGState(context);
        
        CGContextMoveToPoint(context, buttonWidth * i, 0);
        CGContextAddLineToPoint(context, buttonWidth * i, 40.0);
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFillStroke);
        
        CGContextRestoreGState(context);
    }
    
    // Add a shadow to top
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:85.0/255.0f green:85.0/255.0f blue:85.0/255.0f alpha:1.0].CGColor);
    CGContextSetShadow(context, CGSizeMake (0, 0), 5.0);
    
    CGContextSaveGState(context);
    
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, self.frame.size.width, 0);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGContextRestoreGState(context);
#endif
}

- (void)touchDownAction:(UIButton*)button
{
    if ([_delegate respondsToSelector:@selector(touchDownAtTabIndex:)])
        [_delegate touchDownAtTabIndex:[_buttons indexOfObject:button]];
}

- (void)touchUpInsideAction:(UIButton*)button
{
    // Determine where tab should go
    CGFloat segmentCount = [_buttons count];
    CGFloat buttonWidth = (320.0 / segmentCount);
    CGFloat buttonIndex = [_buttons indexOfObject:button];
    CGFloat newPosition = (buttonWidth * buttonIndex);
    
    UILabel *label = (UILabel*)[self viewWithTag:(buttonIndex + Tag_Label_Start)];
    UILabel *oldLabel = (UILabel*)[self viewWithTag:(self.selectTabIndex+Tag_Label_Start)];
    
    UIButton *curBtn = (UIButton*)[self viewWithTag:(buttonIndex+Tag_DropArrow_Start)];
    UIButton *oldBtn = (UIButton*)[self viewWithTag:(self.selectTabIndex+Tag_DropArrow_Start)];
    
    self.selectTabIndex = buttonIndex;
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
  //  [_tab setFrame:CGRectMake(newPosition, 0, _tab.frame.size.width, _tab.frame.size.height)];
    [nTab setFrame:CGRectMake(newPosition, 0, nTab.frame.size.width, nTab.frame.size.height)];
    oldLabel.textColor =colorWithUtfStr(Color_TabUnSeleteorText);
    label.textColor = colorWithUtfStr(Color_TabSeleteorText);

    [oldBtn setHighlighted:FALSE];
    [curBtn setHighlighted:YES];

    
    [UIView commitAnimations];

    if ([_delegate respondsToSelector:@selector(touchUpInsideTabIndex:)])
        [_delegate touchUpInsideTabIndex:[_buttons indexOfObject:button]];
}

- (void)otherTouchesAction:(UIButton*)button
{

}

-(void)setSlideTitle:(NSString*)_title for:(NSInteger)index
{
    UILabel *label = (UILabel*)[self viewWithTag:Tag_Label_Start+index ];
    label.text = _title;
    
}

-(UIButton*)selectedBtn
{
    return [_buttons objectAtIndex:self.selectTabIndex];
}
@end
