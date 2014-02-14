//
//  GKImgCroperViewController.h
//  GK
//
//  Created by W.S. on 13-5-13.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    STRECH_LU,
    STRECH_LD,
    STRECH_RU,
    STRECH_RD
}STRECH_DIRECT;

typedef enum{
    CroperStyle_Square,
    CroperStyle_480X220

}CroperStyle;

@protocol GKImgCroperDelegate <NSObject>

-(void)saveImage:(UIImage*)img;

@end

@interface GKImgCroperViewController : UIViewController
{
    CGPoint lastPoint;
    BOOL isMoveCropRect;
    STRECH_DIRECT strechDirection;
    CroperStyle style;
    float initWidth,initHeight;
}
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBarItem;
@property (strong,nonatomic) UIImageView *imgV;
@property (strong,nonatomic) UIImage *srcImg;
@property (weak, nonatomic) IBOutlet UIView *imgRegion;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (assign,nonatomic) id<GKImgCroperDelegate> delegate;
- (IBAction)saveClick:(id)sender;

- (IBAction)backClick:(id)sender;
-(id)initWithImg:(UIImage*)iMg;
-(id)initWithImg:(UIImage*)iMg style:(CroperStyle)sTyle;
@end