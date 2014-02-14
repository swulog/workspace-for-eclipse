//
//  GKStoreTableCell.h
//  GK
//
//  Created by apple on 13-4-13.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSImageView.h"
#import "NSObject+GKExpand.h"

@interface GKStoreTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet WSImageView *storeIcon;

@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rebateLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeAddressLabel;

@property (weak, nonatomic) IBOutlet UIButton *distanceIcon;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

//@property (weak, nonatomic) IBOutlet UILabel *tradeLabel;

@property (weak, nonatomic) IBOutlet UIView *descView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIView *discussView;
@property (weak, nonatomic) IBOutlet UIView *loveView;

@property (weak, nonatomic) IBOutlet UILabel *discussLabel;
@property (weak, nonatomic) IBOutlet UILabel *loveLabel;

-(void)configWithReuseIdentify:(NSString*)identify;
@end


