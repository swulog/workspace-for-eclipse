//
//  SetPWDEditCell.m
//  GK
//
//  Created by W.S. on 13-11-7.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "SetPWDEditCell.h"
#import "Constants.h"
#import "ReferemceList.h"
#import "CommonFunction.h"
#import "GlobalObject.h"



@interface SetPWDEditCell()
@property (nonatomic,assign) SEL saveHandler;
@end

@implementation SetPWDEditCell


-(void)awakeFromNib
{
    self.saveBtn.backgroundColor = colorWithUtfStr(XWGGGC_ImportTextColor);
    [self.saveBtn setHightedBGColor:colorWithUtfStr(PersonalCenterC_CellMSGBtnSelectedBGColor)];
    

}

- (IBAction)textReturnClick:(id)sender {
    
    if (sender == self.oldPWDField) {
        [self.modifiedPwdField becomeFirstResponder];
    } else {
        [self.saveBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

@end
