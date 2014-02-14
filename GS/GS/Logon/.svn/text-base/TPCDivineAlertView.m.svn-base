//
//  TPCDivineAlertView.m
//  ThePhoneCode
//
//  Created by Airfly Pan on 10-1-27.
//  Copyright 2010 Guiwang Network Inc.. All rights reserved.
//

#import "TPCDivineAlertView.h"
#import <QuartzCore/QuartzCore.h>

@implementation TPCDivineAlertView

@synthesize MessageView,isLandscape;

- (void) setMessage:(NSString *)value {
	MessageView.text = value;
}

- (void) setLandscapeOrientation:(BOOL)value {
	isLandscape = value;
}

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		MessageView = [[UITextView alloc] initWithFrame:CGRectZero];
		MessageView.font = [UIFont systemFontOfSize:14];
		MessageView.editable = NO;
		MessageView.textAlignment = UITextAlignmentLeft;
		MessageView.text = self.message;
		MessageView.layer.borderColor = [UIColor grayColor].CGColor;
        MessageView.layer.borderWidth =1.0;
        MessageView.layer.cornerRadius =5.0;
		self.message = @"";
				
		[self addSubview:MessageView];
	}
	return self;
}

- (void)setFrame:(CGRect)rect {
	[super setFrame:CGRectMake(0, 0, rect.size.width, 300)];
	if(isLandscape) {
		self.center = CGPointMake(480/2, 320/2);
	} else {
		self.center = CGPointMake(320/2, 480/2);
	}
    
    [self setNeedsDisplay];
}

- (void)layoutSubviews {
	CGFloat buttonTop;
	for (UIView *view in self.subviews) {
		if ([[[view class] description] isEqualToString:@"UIAlertButton"]) {
			view.frame = CGRectMake(view.frame.origin.x, self.bounds.size.height - view.frame.size.height - 15, view.frame.size.width, view.frame.size.height);
			buttonTop = view.frame.origin.y;
		}
	}
	buttonTop -= 7; buttonTop -= 190;
    buttonTop = 40;
	MessageView.frame = CGRectMake(12, buttonTop, self.frame.size.width - 54, 190);
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	/*
	UIGraphicsBeginImageContext(MessageView.frame.size);
	CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 2.0);
	CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.9, 0.9, 1.0, 1.0);
	CGContextSetShadow(UIGraphicsGetCurrentContext(), CGSizeMake(0, -3), 3.0);
	CGContextStrokeRect(UIGraphicsGetCurrentContext(), CGContextGetClipBoundingBox(UIGraphicsGetCurrentContext()));
	[MessageView addSubview:[[[UIImageView alloc] initWithImage:UIGraphicsGetImageFromCurrentImageContext()] autorelease]];
	UIGraphicsEndImageContext();
	 */
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

/*
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}
*/
- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	MessageView = nil;
}





@end
