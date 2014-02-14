//
//  GS_EditCtrller.h
//  GS
//
//  Created by W.S. on 13-6-22.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "WS_BaseViewController.h"

typedef enum{
    EditStyle_TextField,
    EditStyle_TextView
}EditStyle;
@protocol EditCtrllerDelegate ;
@interface GS_EditCtrller : WS_BaseViewController
{
    EditStyle style;
}
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (assign,nonatomic) NSInteger maxChar;
@property (assign,nonatomic) id<EditCtrllerDelegate> delegate;
-(id)initWithStyle:(EditStyle)sTyle delegate:(id<EditCtrllerDelegate>)dElegate;
-(void)setText:(NSString*)text;

@end
@protocol EditCtrllerDelegate <NSObject>

@optional
-(void)saveText:(NSString*)text;

@end