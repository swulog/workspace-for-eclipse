//
//  GSPhotoUploadCtrller.m
//  GS
//
//  Created by W.S. on 13-9-6.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GSPhotoUploadCtrller.h"
#import "GSStoreService.h"

@interface GSPhotoUploadCtrller ()
@property (nonatomic,assign) CGRect contentRect;
@property (nonatomic,strong) UIImage *img;
@end

@implementation GSPhotoUploadCtrller

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}


-(id)initWithImg:(UIImage*)image
{
    self = [self initWithNibName:@"GSPhotoUploadCtrller" bundle:nil];
    if (self) {
        self.img = image;

        
        
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor clearColor];
    
    UIImageView *tImgV = [[UIImageView alloc] initWithImage:self.img];
    [tImgV compressToRect:self.imgView.frame];
    [self.contentView addSubview:tImgV];
    
    self.contentRect = self.contentView.frame;
    CGPoint center = self.contentView.center;
    self.contentView.frame = CGRectMake(0, 0, 320, 10);
    self.contentView.center = center;
    [self.contentView.layer setBorderWidth:2.0f];
    [self.contentView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [UIView animateWithDuration:0.26f animations:^{
        self.contentView.frame = self.contentRect;
        self.bgView.alpha = 0.7f;
    }];
    [self.progressView setProgress:0.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setContentView:nil];
    [self setImgView:nil];
    [self setProgressView:nil];
    [self setBgView:nil];
    [super viewDidUnload];
}


@end
