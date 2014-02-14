//
//  GS_StartupViewCtrller.m
//  GS
//
//  Created by W.S. on 13-6-4.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GS_StartupViewCtrller.h"

@interface GS_StartupViewCtrller ()

@end

@implementation GS_StartupViewCtrller

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.imgV.contentMode = UIViewContentModeScaleAspectFill;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







- (void)viewDidUnload {
    [self setImgV:nil];
    [super viewDidUnload];
}
@end
