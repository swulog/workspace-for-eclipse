//
//  GKImgCroperViewController.h
//  GK
//
//  Created by W.S. on 13-5-13.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "Appheader.h"

typedef enum{
    STRECH_LU,
    STRECH_LD,
    STRECH_RU,
    STRECH_RD
}STRECH_DIRECT;

@interface GKImgCroperViewController : UIViewController
{
    CGPoint lastPoint;
    BOOL isMoveCropRect;
    STRECH_DIRECT strechDirection;
}
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBarItem;
@property (strong,nonatomic) UIImageView *imgV;
@property (strong,nonatomic) UIImage *srcImg;
@property (weak, nonatomic) IBOutlet UIView *imgRegion;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

- (IBAction)saveClick:(id)sender;

- (IBAction)backClick:(id)sender;
-(id)initWithImg:(UIImage*)iMg;

@end
