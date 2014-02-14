//
//  RebateInfoView.h
//  GK
//
//  Created by apple on 13-4-14.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeometryImg.h"
#import "WSImageView.h"

@interface RebateInfoView : UIView
@property (weak, nonatomic) IBOutlet GeometryImg *rebateLine;
@property (weak, nonatomic) IBOutlet UILabel *rebateTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rebateContent;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet WSImageView *advImgV;
@property (weak, nonatomic) IBOutlet UIImageView *advImgBk;

@property (weak, nonatomic) IBOutlet UILabel *couponTitleLabel;
@property (assign,nonatomic) BOOL isAutoSize;
-(void)setContent:(NSString*)content;
-(void)setNote:(NSString*)note;
-(void)setStartDate:(NSString*)_startDate endData:(NSString*)_endDate;
-(void)setAdvImage:(NSURL*)imgUrl;
@end
