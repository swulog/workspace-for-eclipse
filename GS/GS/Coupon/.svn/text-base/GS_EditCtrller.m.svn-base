//
//  GS_EditCtrller.m
//  GS
//
//  Created by W.S. on 13-6-22.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GS_EditCtrller.h"

@interface GS_EditCtrller ()
@property (nonatomic,strong) NSString *content;
@end

@implementation GS_EditCtrller

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithStyle:(EditStyle)sTyle delegate:(id<EditCtrllerDelegate>)dElegate
{
    self = [self initNibWithStyle:WS_ViewStyleWithNavBar];
    
    if (self) {
        style = sTyle;
        self.delegate = dElegate;

    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addBackItem:@"返回" action:nil];
    
    if (style == EditStyle_TextField) {
        [self.textField becomeFirstResponder];
        [self.textView removeFromSuperview];
        self.textView = nil;
        [self addNavRightItem:@"保存" action:@selector(save)];
        
        if (IOS_VERSION >= 7.0) {
            self.textField.text = self.content;
        }
        
    } else {
        [self.textView becomeFirstResponder];
        self.textView.backgroundColor = [UIColor clearColor];
        self.textField.frame = self.textView.frame;
        [self.view bringSubviewToFront:self.textView];
        [self addNavRightItem:@"保存" action:@selector(save)];
        self.textField = nil;
        
        if (IOS_VERSION >= 7.0) {
            self.textView.text = self.content;
        }
    }

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)save
{
    if ([self.delegate respondsToSelector:@selector(saveText:)]) {
        [self.delegate performSelector:@selector(saveText:) withObject:style==EditStyle_TextField?self.textField.text:self.textView.text];
    }
    
    [self goback];
}
- (void)viewDidUnload {
    [self setTextView:nil];
    [self setTextField:nil];
    [super viewDidUnload];
}

-(void)setText:(NSString*)text
{
    if (IOS_VERSION >= 7.0) {
        self.content = text;
    } else {
        if (style == EditStyle_TextField) {
            self.textField.text = text;
        } else {
            self.textView.text = text;
        }
    }


}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self save];
    
    return TRUE;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
         int MAX_CHARS = self.maxChar;
    
         NSMutableString *newtxt = [NSMutableString stringWithString:textField.text];
    
         [newtxt replaceCharactersInRange:range withString:string];

         return ([newtxt length] <= MAX_CHARS);
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    int MAX_CHARS = self.maxChar;
    
    NSMutableString *newtxt = [NSMutableString stringWithString:textView.text];
    
    [newtxt replaceCharactersInRange:range withString:text];
    
    return ([newtxt length] <= MAX_CHARS);

}

@end
