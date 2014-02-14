//
//  WS_GeneralTableFieldView.h
//  GS
//
//  Created by W.S. on 13-6-5.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSLocateView.h"

typedef enum{
    WS_FieldStyle_Text,
    WS_FieldStyle_DropBox,
    WS_FieldStyle_Picker,
    WS_FieldStyle_Label,
    WS_FieldStyle_DatePicker
}WS_FieldStyle;



@protocol WS_GeneralTableFieldDelegate;

@interface WS_GeneralTableFieldView : UIView <UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    WS_FieldStyle   style;
}

@property (assign,nonatomic) id<WS_GeneralTableFieldDelegate> delegate;

@property(nonatomic,strong) UILabel* fieldLabel;
@property (nonatomic,strong) UIView* fieldValueView;
@property (nonatomic,strong) NSString *fieldStr;
@property (nonatomic,strong) TSLocateView *pickView;
@property (nonatomic,strong) UIButton *accessBtn;


-(id)initWithType:(WS_FieldStyle)sTyle withRightBtn:(BOOL)withRightBtn delegate:(id<WS_GeneralTableFieldDelegate>)delegate;


-(void)setFieldName:(NSString*)title autoSize:(BOOL)autoSize;
-(void)setFieldValue:(NSString*)title;
-(void)setFieldValueColor:(UIColor*)corlor;
-(void)setFieldPlaceHolder:(NSString*)title;
-(void)unFocusTextField;
-(void)resignFocus;
@end



@protocol WS_GeneralTableFieldDelegate <UITextFieldDelegate>

@optional
-(void)pickerViewWillDidload:(WS_GeneralTableFieldView*)fieldView;

-(NSInteger)pickerViewSeletedRow:(WS_GeneralTableFieldView*)fieldView  component:(NSInteger)component;
-(NSString*)fieldView:(WS_GeneralTableFieldView*)fieldView  pickerViewSelected:(TSLocateView*)pickView;

- (NSInteger)fieldView:(WS_GeneralTableFieldView*)fieldView numberOfComponentsInPickerView:(UIPickerView *)pickerView;

- (NSInteger)fieldView:(WS_GeneralTableFieldView*)fieldView pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;


- (NSString *)fieldView:(WS_GeneralTableFieldView*)fieldView pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;

- (void)fieldView:(WS_GeneralTableFieldView*)fieldView actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
-(void)accessPerformed;

@end
