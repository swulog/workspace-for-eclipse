//
//  GKGuideFlowController.m
//  GK
//
//  Created by apple on 13-4-7.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GKGuideFlowController.h"
//#import "Constants.h"

@interface GKGuideFlowController ()

@end



@implementation GKGuideFlowController

@synthesize type;


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
    self.guideScrollCtroller.contentSize = CGSizeMake( self.guideScrollCtroller.subviews.count * self.view.frame.size.width,self.view.frame.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -
#pragma mark event handler -

- (IBAction)startBtnClick:(id)sender {
    [self gotoStartupView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{

    UIView *v = [scrollView.subviews objectAtIndex:(scrollView.subviews.count - 1)];
        
    if(scrollView.contentOffset.x > v.frame.origin.x + v.frame.size.width / 4){
            [self gotoStartupView];
    
    }
}

#pragma mark -
#pragma mark general function -
-(void)gotoStartupView
{
    if ([self.GKBaseDelegate respondsToSelector:@selector(BaseControllerWouldUnload)]) {
        [self.GKBaseDelegate BaseControllerWouldUnload];
    }    
}
@end