//
//  UICityPicker.m
//  DDMates
//
//  Created by ShawnMa on 12/16/11.
//  Copyright (c) 2011 TelenavSoftware, Inc. All rights reserved.
//

#import "TSLocateView.h"
#import "AppConstans.h"
#define kDuration 0.3

@implementation TSLocateView

@synthesize titleLabel;
@synthesize locatePicker;

- (id)initWithTitle:(NSString *)title delegate:(id<UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate>)delegate
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"TSLocateView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.delegate = delegate;
        self.titleLabel.text = title;
        self.locatePicker.dataSource = delegate;
        self.locatePicker.delegate = delegate;
        if (IOS_VERSION < 7.0) {
            self.backView.hidden = YES;
        }

    }
    return self;
}
- (id)initWithTitle:(NSString *)title delegate:(id<UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate>)delegate style:(PickerStyle)sTyle
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"TSLocateView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.delegate = delegate;
        self.titleLabel.text = title;
        self.style = sTyle;
        self.backgroundColor = [UIColor redColor];
        if (self.style == PickerStyle_Date) {
            CGRect rect = self.locatePicker.frame;
            self.locateDatePicker = [[UIDatePicker alloc] initWithFrame:rect];
            
            self.locatePicker = nil;

            
            
            self.locateDatePicker.datePickerMode = UIDatePickerModeDate;
            self.locateDatePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
            
//            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:@"zh_CN"];
//            //     calendar set
//            [self.locateDatePicker setCalendar:calendar];
//            [self.locateDatePicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
//            [self.locateDatePicker setAccessibilityLanguage:@"Chinese"];
            
            [self addSubview:self.locateDatePicker];
        } else {
            self.locatePicker.dataSource = delegate;
            self.locatePicker.delegate = delegate;
        }
        
        if (IOS_VERSION < 7.0) {
            self.backView.hidden = YES;
        }
    }
    return self;
}

- (void)showInView:(UIView *) view
{
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    [self setAlpha:1.0f];
    [self.layer addAnimation:animation forKey:@"DDLocateView"];
    
    self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [view addSubview:self];
}

-(void)setTitle:(NSString*)tItle
{
    self.titleLabel.text = tItle;
}

-(void)setPickWidth:(float)width
{
    UIView *v = self.style == PickerStyle_Normal ? self.locatePicker : self.locateDatePicker;
    
    CGRect rect = v.frame;
    CGPoint center = v.center;
    rect.size.width = width;
    [v setFrame:rect];
    [v setCenter:center];
    
//    if (self.style == PickerStyle_Normal) {
//        [self.locatePicker setFrame:rect];
//        [self.locatePicker setCenter:center];
//    } else {
//        [self.locateDatePicker setFrame:rect];
//        [self.locateDatePicker setCenter:center];
//    }

}

#pragma mark - Button lifecycle

- (IBAction)cancel:(id)sender {
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"TSLocateView"];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
    if(self.delegate) {
        [self.delegate actionSheet:self clickedButtonAtIndex:0];
    }
}

- (IBAction)locate:(id)sender {
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"TSLocateView"];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
    if(self.delegate) {
        [self.delegate actionSheet:self clickedButtonAtIndex:1];
    }
    
}


@end
