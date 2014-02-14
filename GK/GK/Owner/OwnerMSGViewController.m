//
//  OwnerMSGViewController.m
//  GK
//
//  Created by W.S. on 13-5-8.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "OwnerMSGViewController.h"

@interface OwnerMSGViewController ()

@end

@implementation OwnerMSGViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil style:VIEW_WITH_NAVBAR];
    if (self) {
        // Custom initialization
        [self setTitle:@"我的消息"];
#ifdef TABBAR_WITH_CUSTOM
        [self addBackItemInside:@"返回"];
#else
        [self addBackItem:@"返回"];
#endif
        [self.slideTab initWithTabCount_Ex:2 delegate:self];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setSlideTab:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}


#pragma mark - 
#pragma mark slide tab control delegate -
- (UILabel*) labelFor:(SlidingTabsControl*)slidingTabsControl atIndex:(NSUInteger)tabIndex
{
    static char* titleStrArray[] = {"订阅","官方"};
    
    UILabel* label = [[UILabel alloc] init];
    label.text =     [NSString stringWithUTF8String:titleStrArray[tabIndex]];
    
    return label;
}
@end
