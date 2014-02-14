//
//  UICityPicker.h
//  DDMates
//
//  Created by ShawnMa on 12/16/11.
//  Copyright (c) 2011 TelenavSoftware, Inc. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
typedef enum{
    PickerStyle_Normal,
    PickerStyle_Date
}PickerStyle;

@interface TSLocateView : UIActionSheet 
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIPickerView *locatePicker;
@property (strong, nonatomic) IBOutlet UIDatePicker *locateDatePicker;
@property (assign,nonatomic) PickerStyle style;
//@property (assign,nonatomic) id<UIPickerViewDelegate,UIPickerViewDataSource>pickDelegate;
//- (id)initWithTitle:(NSString *)title delegate:(id /*<UIActionSheetDelegate>*/)delegate;
- (id)initWithTitle:(NSString *)title delegate:(id<UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate>)delegate;

- (id)initWithTitle:(NSString *)title delegate:(id<UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate>)delegate style:(PickerStyle)sTyle;


- (void)showInView:(UIView *)view;
-(void)setTitle:(NSString*)tItle;
-(void)setPickWidth:(float)width;

- (IBAction)cancel:(id)sender ;
@end
