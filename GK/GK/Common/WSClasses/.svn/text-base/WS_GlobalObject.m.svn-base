//
//  WS_GlobalObject.m
//  GS
//
//  Created by W.S. on 13-6-7.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "WS_GlobalObject.h"
#import "AppHeader.h"
#import "GKAppDelegate.h"

@implementation WS_GlobalObject


#pragma mark -
#pragma mark waitting screen
/*****************************************************************/
/*           waitting screen                                     */
/*****************************************************************/
//waitting view
+(void)showWaitting:(UIView*)_view
{
    WS_GlobalObject *go = GO(WS_GlobalObject);
    go.waittingParentView = _view;
    [MBProgressHUD showHUDAddedTo:_view animated:YES];
}

+(void)showTopWaitting
{
    [self showWaitting:APP_DELEGATE.window];
//    WS_GlobalObject *go = GO(WS_GlobalObject);
//    go.waittingParentView = APP_DELEGATE.window;
//    [MBProgressHUD showHUDAddedTo:go.waittingParentView  animated:YES];
}


+(void)hideWaitting
{
    WS_GlobalObject *go = GO(WS_GlobalObject);
    [MBProgressHUD hideHUDForView:go.waittingParentView animated:YES];
}



#pragma mark -
#pragma mark popup info
/*****************************************************************/
/*           popup info                                          */
/*****************************************************************/

+(void)showPopup:(NSString*)_message
{
#define POPUP_GAP 3
#define POPUP_CELL_HEIGHT 15
    
    
    WS_GlobalObject *go = GO(WS_GlobalObject);
    
    if(go.popMsgArray.count == 1) {
        [go.popTimer invalidate];
        go.popTimer = nil;
        [go.popView removeFromSuperview];
        [go.popMsgArray removeObjectAtIndex:0];
        
        go.popMsgArray = nil;
        go.popView = nil;
    }
    
    if (!go.popView) {
        go.popView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, [UIScreen mainScreen].bounds.size.width, 1)];
        //go.popView.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
        
        go.popView.backgroundColor =   [colorWithUtfStr(StatusBarBgColor) colorWithAlphaComponent:0.8f];     //[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
        [APP_DELEGATE.window addSubview:go.popView];
        [APP_DELEGATE.window bringSubviewToFront:go.popView];
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:go action:@selector(hidePopup)];
        [tapRecognizer setNumberOfTapsRequired:1];
        [go.popView addGestureRecognizer:tapRecognizer];
        
        if (!go.popMsgArray) {
            go.popMsgArray =[[NSMutableArray alloc] init];
        }
    }
    
    [go.popMsgArray addObject:_message];
    
    
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(POPUP_GAP , POPUP_GAP, [UIScreen mainScreen].bounds.size.width - 2 * POPUP_GAP, POPUP_CELL_HEIGHT)];
    msgLabel.text = _message;
    msgLabel.backgroundColor = [UIColor clearColor];
    [msgLabel setFont:[UIFont systemFontOfSize:12]];
    [msgLabel setTextColor:[UIColor whiteColor]];
    msgLabel.textAlignment = NSTextAlignmentCenter;
    [go.popView addSubview: msgLabel];
    [go.popView setFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height - go.popMsgArray.count * POPUP_CELL_HEIGHT - 2 * POPUP_GAP,[UIScreen mainScreen].bounds.size.width , go.popMsgArray.count * POPUP_CELL_HEIGHT + 2 * POPUP_GAP)];
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.16f];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    [go.popView setFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height,[UIScreen mainScreen].bounds.size.width , go.popMsgArray.count * POPUP_CELL_HEIGHT + 2 * POPUP_GAP)];
    [UIView commitAnimations];
    
    go.popTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:go selector:@selector(hidePopup) userInfo:nil repeats:NO];
}

+(void)hidePopupMsg
{
    [GO(WS_GlobalObject) hidePopup];
}

-(void)hidePopup
{
    
    WS_GlobalObject *go = GO(WS_GlobalObject);
    
    if (go.popMsgArray.count == 1) {
        [go.popTimer invalidate];
        go.popTimer = nil;
        [UIView animateWithDuration:CMM_AnimatePerior animations:^{
            [go.popView setFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height - go.popMsgArray.count * POPUP_CELL_HEIGHT - 2 * POPUP_GAP,[UIScreen mainScreen].bounds.size.width , go.popMsgArray.count * POPUP_CELL_HEIGHT + 2 * POPUP_GAP)];
        }completion:^(BOOL finished){
            [go.popView removeFromSuperview];
            [go.popMsgArray removeObjectAtIndex:0];
            
            go.popMsgArray = nil;
            go.popView = nil;
        }];
        
    }
}

@end
