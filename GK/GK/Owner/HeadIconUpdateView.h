//
//  HeadIconUpdateView.h
//  GK
//
//  Created by W.S. on 13-11-6.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Appheader.h"

@interface HeadIconUpdateView : XIBView
@property (weak, nonatomic) IBOutlet WSImageView *headIconBtb;
@property (weak, nonatomic) IBOutlet WSLargeButton *photoBtn;
@property (weak, nonatomic) IBOutlet WSLargeButton *cameraBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
