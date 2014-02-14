//
//  WSPopupView.h
//  GK
//
//  Created by W.S. on 13-10-17.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum{
    WS_PopS_Down,
    WS_PopS_Center,
    WS_PopS_Up
}WS_PopStyle;


@protocol WSPopupDelete;




@interface WSPopupView : UIView



@property (nonatomic,assign) id<WSPopupDelete> delegate;
+(WSPopupView*)showPopupView:(UIView*)popupView mask:(CGRect)rect type:(WS_PopStyle)type;
-(void)show;
-(void)hide;
@end


@protocol WSPopupDelete <NSObject>

@optional
-(BOOL)popViewClicked;
-(void)popViewWillDisappear;
@end