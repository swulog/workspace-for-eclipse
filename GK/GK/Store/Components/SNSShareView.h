//
//  SNSShareView.h
//  GK
//
//  Created by W.S. on 13-11-13.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "NSObject+GKExpand.h"
#import "WSPopupView.h"

@interface SNSShareView : XIBView

@property (weak, nonatomic) IBOutlet UIButton *sinaBtn;

- (IBAction)snsClick:(id)sender;

+(void)show:(CGPoint)abspoint fullScreen:(BOOL)maskScreen handler:(void(^)(NSString *plateName))SNSShareHandler;

@end


