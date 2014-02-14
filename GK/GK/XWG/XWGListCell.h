//
//  XWGListCell.h
//  GK
//
//  Created by W.S. on 13-8-27.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSImageView.h"
#import "TMQuiltViewCell.h"
#import "Appheader.h"


@interface XWGListCell : TMQuiltViewCell
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet WSImageView *goodImageV;
@property (weak, nonatomic) IBOutlet UILabel *loveLabel;
@property (weak, nonatomic) IBOutlet UIImageView *loveV;
@property (weak, nonatomic) IBOutlet UIView *downCView;

@property (nonatomic,strong) NSMutableDictionary *handlers;

-(void)addObserver:(NSObject*)obj forKeyPath:(NSString *)keyPath handler:(NillBlock_OBJ)handler;
-(void)removeCellObserverForKeyPath:(NSString *)keyPath;
@end



