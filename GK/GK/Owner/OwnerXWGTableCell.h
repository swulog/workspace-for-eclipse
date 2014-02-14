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

@interface OwnerXWGTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet WSImageView *storeIcon;

@property (weak, nonatomic) IBOutlet UILabel *goodNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIView *descView;
@property (weak, nonatomic) IBOutlet UIView *contentView;



-(void)configWithReuseIdentify:(NSString*)identify;

@end
