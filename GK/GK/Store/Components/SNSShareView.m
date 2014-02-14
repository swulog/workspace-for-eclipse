//
//  SNSShareView.m
//  GK
//
//  Created by W.S. on 13-11-13.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "SNSShareView.h"
#import "Config.h"
#import "GKAppDelegate.h"
#import "Constants.h"

@interface SNSShareView()
@property (nonatomic,strong) WSPopupView *popView;
@property (nonatomic,copy) void(^SNSShareHandler)(NSString *plateName) ;
@end

@implementation SNSShareView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    self.backgroundColor = colorWithUtfStr(ResetPWDC_BtnBGColor);
}


+(void)show:(CGPoint)abspoint fullScreen:(BOOL)maskScreen handler:(void(^)(NSString *plateName))SNSShareHandler;
{
    SNSShareView *tSelf = [self XIBView];
    tSelf.SNSShareHandler = SNSShareHandler;
    CGRect rect = tSelf.frame;
    rect.origin = abspoint;
    tSelf.frame = rect;
    
    if (maskScreen) {
        rect =APP_FRAME;
    } else {
        rect = CGRectMake(0, APP_STATUSBAR_HEIGHT+APP_NAVBAR_HEIGHT, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT-(APP_STATUSBAR_HEIGHT+APP_NAVBAR_HEIGHT));
    }
    
    tSelf.popView = [WSPopupView showPopupView:tSelf  mask:rect type:WS_PopS_Up];
}


- (IBAction)snsClick:(id)sender {
    UIButton *btn = (UIButton*)sender;
    NSInteger tag = btn.tag;
    
    NSString *plats[] = {UMShareToSina,UMShareToRenren,UMShareToTencent,UMShareToQzone,UMShareToWechatTimeline,UMShareToWechatSession};
    NSString *plat = plats[tag];
    [self.popView hide];
    
    double delayInSeconds = 0.2f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        SAFE_BLOCK_CALL(self.SNSShareHandler, plat);

    });
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(id)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self)
    {
        return nil;
    }
    else
    {
        return hitView;
    }
}

@end
