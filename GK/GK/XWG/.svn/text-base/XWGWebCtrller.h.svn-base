//
//  XWGWebCtrller.h
//  GK
//
//  Created by W.S. on 13-8-29.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GKBaseViewController.h"

@interface XWGWebCtrller : GKBaseViewController<UIGestureRecognizerDelegate>
{
   UIActivityIndicatorView *activityIndicatorView;
}
@property (weak, nonatomic) IBOutlet UIWebView *webV;
@property (weak, nonatomic) IBOutlet UIView *toolBar;
@property (weak, nonatomic) IBOutlet UIButton *toolBarBackBtn;
@property (weak, nonatomic) IBOutlet UIButton *toolBarForwardBtn;

- (IBAction)backClick:(id)sender;
- (IBAction)forwardClick:(id)sender;
- (IBAction)refreshClick:(id)sender;
- (IBAction)closeClick:(id)sender;


-(id)initWithUrl:(NSString*)url title:(NSString*)titleStr;
@end
