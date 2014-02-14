//
//  WS_GlobalObject.h
//  GS
//
//  Created by W.S. on 13-6-7.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppConstans.h"

@interface WS_GlobalObject : NSObject

+(WS_GlobalObject*)WS_GObject;

#pragma mark -
#pragma mark waitting screen
@property(nonatomic,strong) UIView *waittingView;
+(void)showWaitting:(UIView*)_view;
+(void)showTopWaitting;
+(void)hideWaitting;



#pragma mark -
#pragma mark pop info
@property(nonatomic,strong) UIImage* popBg; //popup cell backgroud
@property(nonatomic,strong) UIView  *popView;
@property(nonatomic,strong) NSMutableArray *popMsgArray;
@property(nonatomic,strong) NSTimer *popTimer;
+(void)showPopup:(NSString*)_message;
+(void)hidePopupMsg;



@end
