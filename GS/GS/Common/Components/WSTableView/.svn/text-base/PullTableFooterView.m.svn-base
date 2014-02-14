//
// DemoTableFooterView.m
//
// @author Shiki
//

#import "PullTableFooterView.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation PullTableFooterView

@synthesize activityIndicator;
@synthesize infoLabel;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
     //   self.backgroundColor = [UIColor colorWithRed:215.0/255.0 green:192.0/255.0 blue:158.0/255.0 alpha:1.0f];
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        // [self.activityIndicator  setFrame:CGRectMake(15, 15, 20, 20)];
        self.activityIndicator.center = self.center;
        [self addSubview:self.activityIndicator ];
        

        self.infoLabel = [[DownLineLabel alloc] initWithFrame:CGRectMake(0, 0, 100, 21)];
        
        
        self.infoLabel.center = CGPointMake(160, 25);
        self.infoLabel.text = @"加载更多";
        self.infoLabel.font = [UIFont systemFontOfSize:12.0f];
        self.infoLabel.textColor = [UIColor darkGrayColor];
        

        
        self.infoLabel.textAlignment = NSTextAlignmentCenter;
        self.infoLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.infoLabel];
        
        
        CGRect rect = self.infoLabel.frame;
        rect.origin.y -=5;
        rect.size.height +=10;
        UIControl *control = [[UIControl alloc]  initWithFrame:rect];
        [control setBackgroundColor:[UIColor clearColor]];
        [control addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:control];
        
        

    }
    return self;
}


- (void) dealloc
{

    self.activityIndicator = nil;
    self.infoLabel = nil;
}

-(void)click
{
    self.infoLabel.hidden = YES;
    [self.activityIndicator startAnimating];
    
    if ([self.delegate respondsToSelector:@selector(footerViewCliecked)]) {
        [self.delegate performSelector:@selector(footerViewCliecked)];
    }
}

-(void)reset
{
    self.infoLabel.hidden = FALSE;
    self.infoLabel.text = @"加载更多";

    [self.activityIndicator stopAnimating];
}
@end
