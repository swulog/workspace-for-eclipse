//
//  WS_GeneralTableFieldView.m
//  GS
//
//  Created by W.S. on 13-6-5.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "WS_GeneralTableFieldView.h"
#import "AppConstans.h"
#import "NSObject+WSExpand.h"
#import "AppHeader.h"

#define FieldTitleFont [UIFont systemFontOfSize:14]
#define FieldValueFont [UIFont systemFontOfSize:14]

#define FieldWidth 290
#define FieldHeight 44
#define FieldTitleWidth 60
#define FieldTitleHeight 20
#define FieldTitleOffset2Value 0
#define FieldValue2Btn 5
#define FieldValueHeight 30
#define FieldBtnWidth 48
#define FieldBtnHeight 31
#define PickerFieldBackImg @"dropBoxBtn"
#define FieldBtnBg @"logon_register"

@implementation WS_GeneralTableFieldView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.fieldLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (FieldHeight - FieldTitleHeight) >> 1, FieldTitleWidth, FieldTitleHeight)];
        self.fieldLabel.font = FieldTitleFont;
        self.fieldLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.fieldLabel];
        
    }
    return self;
}

-(id)initWithType:(WS_FieldStyle)sTyle withRightBtn:(BOOL)withRightBtn delegate:(id<WS_GeneralTableFieldDelegate>)delegate
{
    self = [self initWithFrame:CGRectMake(0, 0, FieldWidth, FieldHeight)];
    
    if (self) {
        style = sTyle;
        self.delegate = delegate;
        
        float x = self.fieldLabel.frame.origin.x + self.fieldLabel.frame.size.width + FieldTitleOffset2Value;
        float width = FieldWidth - x - 10 -  (withRightBtn?(FieldValue2Btn+FieldBtnWidth):0);
        
        switch (style) {
            case WS_FieldStyle_Text:
            {
                UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(x, (FieldHeight - FieldValueHeight) >> 1, width, FieldValueHeight)];
                textField.borderStyle = UITextBorderStyleRoundedRect;
                textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                textField.font = FieldValueFont;
                textField.delegate =self.delegate;
                textField.returnKeyType = UIReturnKeyDone;
                self.fieldValueView = textField;
                
                break;
            }
            case WS_FieldStyle_DropBox:
                
                
                break;
                
            case WS_FieldStyle_Picker:
            case WS_FieldStyle_DatePicker:
            {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setBackgroundImage:[UIImage imageNamed:PickerFieldBackImg] forState:UIControlStateNormal];
                [btn setFrame:CGRectMake(x, (FieldHeight - FieldValueHeight) >> 1, width, FieldValueHeight)];
                [btn setTitle:@"" forState:UIControlStateNormal];
                btn.titleLabel.font = FieldValueFont;
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(showPicker) forControlEvents:UIControlEventTouchUpInside];
                btn.contentHorizontalAlignment  = UIControlContentHorizontalAlignmentLeft;
                btn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
                self.fieldValueView = btn;
                
                break;
            }
            case WS_FieldStyle_Label:
            {
                UILabel *valueLable = [[UILabel alloc] initWithFrame:CGRectMake(x, (FieldHeight - FieldValueHeight) >> 1, width, FieldValueHeight)];
                valueLable.backgroundColor = [UIColor clearColor];
                valueLable.enabled = FALSE;
//                textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//                textField.font = FieldValueFont;
//                textField.delegate =self.delegate;
//                textField.returnKeyType = UIReturnKeyDone;
                self.fieldValueView = valueLable;
                
                break;
            }
//            case WS_FieldStyle_DatePicker:
//            {
//                UIDatePicker *picker =[[UIDatePicker alloc] init];
//                picker.minimumDate = picker.date;
//                picker.datePickerMode = UIDatePickerModeDate;
//                
//            //    picker.locale =
//                break;
//            }
            default:
                break;
        }
        
        if (withRightBtn) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(x+width+FieldValue2Btn, ((FieldHeight - FieldBtnHeight) >> 1)+1, FieldBtnWidth, FieldValueHeight)];
            [btn setBackgroundImage:[UIImage imageNamed:FieldBtnBg] forState:UIControlStateNormal];
            [self addSubview:btn];
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
            self.accessBtn = btn;
            [self.accessBtn addTarget:self.delegate action:@selector(accessPerformed) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [self addSubview:self.fieldValueView];
    }
    
    return self;
}

-(void)setFieldName:(NSString*)title autoSize:(BOOL)autoSize
{
    self.fieldLabel.text = title;
    
    if (autoSize) {
        CGSize size = [title sizeWithFont:FieldTitleFont];
        
        NSInteger height= self.fieldLabel.frame.size.height;
        
        [self.fieldLabel strechTo:CGSizeMake(size.width, height)];
    }
    
}
-(void)setFieldValueColor:(UIColor*)corlor
{
    if (style == WS_FieldStyle_Text ) {
        [((UITextField*)self.fieldValueView) setTextColor:corlor];
    } else if(style == WS_FieldStyle_Label) {
        [((UILabel*)self.fieldValueView) setTextColor:corlor];
    }
}

-(void)setFieldValue:(NSString*)title
{
    self.fieldStr = title;
    
    switch (style) {
        case WS_FieldStyle_Text:
            ((UITextField*)self.fieldValueView).text = title;
            break;
        case WS_FieldStyle_Picker:
        case WS_FieldStyle_DatePicker:
            [((UIButton*)self.fieldValueView) setTitle:title forState:UIControlStateNormal];
            break;
        case WS_FieldStyle_Label:
            ((UILabel*)self.fieldValueView).text = title;
            break;
        default:
            break;
    }
}

-(void)setFieldPlaceHolder:(NSString*)title
{
    if ([self.fieldValueView isKindOfClass:[UITextField class] ]) {
        ((UITextField*)self.fieldValueView).placeholder = title;
    }
}

-(void)unFocusTextField
{
    if ([self.fieldValueView isKindOfClass:[UITextField class]]) {
        [((UITextField*)self.fieldValueView) resignFirstResponder];
    }
}

-(void)resignFocus
{
    if ([self.fieldValueView isKindOfClass:[UITextField class]]) {
        [((UITextField*)self.fieldValueView) resignFirstResponder];
    } else if([self.fieldValueView isKindOfClass:[UIButton class]]){
        if (style == WS_FieldStyle_Picker || style == WS_FieldStyle_DatePicker ) {
            [self.pickView cancel:nil];
        }
    }

}

#pragma mark -
#pragma mark inside function -
-(void)showPicker
{
    TSLocateView *pickView =[[TSLocateView alloc] initWithTitle:@"请选择" delegate:self style:style==WS_FieldStyle_DatePicker?PickerStyle_Date:PickerStyle_Normal];
    CGRect rect = APP_FRAME;
#define PICK_HEIGHT 260
    rect.size.height = PICK_HEIGHT;
    rect.origin.y = APP_FRAME.size.height - PICK_HEIGHT + APP_FRAME.origin.y;
    [pickView  setFrame:rect];
    
    if (style ==WS_FieldStyle_DatePicker ) {
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        [pickView.locateDatePicker setLocale:locale];
    } else {
        pickView.locatePicker.showsSelectionIndicator = YES;

    }
 
    if (self.pickView) {
        [self.pickView cancel:nil];
    }
    
    self.pickView = pickView;
    if ([self.delegate respondsToSelector:@selector(pickerViewWillDidload:)]) {
        [self.delegate performSelector:@selector(pickerViewWillDidload:) withObject:self];
    }
    if (style ==WS_FieldStyle_DatePicker ) {
        [self.delegate pickerViewSeletedRow:self component:0];
    } else {
    for (int k = 0; k < self.pickView.locatePicker.numberOfComponents; k++) {
        [self.pickView.locatePicker selectRow:[self.delegate pickerViewSeletedRow:self component:k]  inComponent:k animated:NO];
        
    }
    }
    [pickView showInView:APP_WINDOW];
}


#pragma mark -
#pragma mark picker view -
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    NSInteger ret = [self.delegate fieldView:self numberOfComponentsInPickerView:pickerView];
    

    return ret;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger ret = [self.delegate fieldView:self pickerView:pickerView numberOfRowsInComponent:component];
    
//    if ([self.delegate respondsToSelector:@selector(pickerViewSeletedRow:component:)]) {
//        [pickerView selectRow:[self.delegate pickerViewSeletedRow:self component:component]  inComponent:component animated:NO];
////        for (int k = 0; k < pickerView.numberOfComponents; k++) {
////            [pickerView selectRow:[self.delegate pickerViewSeletedRow:self component:k]  inComponent:k animated:NO];
////            
////        }
//        
//    }
    
    return ret;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.delegate fieldView:self pickerView:pickerView titleForRow:row forComponent:component];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self setFieldValue:[self.delegate fieldView:self pickerViewSelected:self.pickView]];
    }
}
#pragma mark -
#pragma mark text field delegate -
//
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    return [self.delegate textFieldShouldBeginEditing:textField];
//}
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    
//    return [];
//}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//    
//
//}


@end
