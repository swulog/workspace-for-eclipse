//
//  GKStoreListCtrller.h
//  GK
//
//  Created by W.S. on 13-12-9.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GKBaseViewController.h"
#import "WSScrollContentView.h"
#import "WSMultiColList.h"

@interface GKStoreSortListCtrller : GKBaseViewController
@property (weak, nonatomic) IBOutlet WSScrollContentView *scrollContentV;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet WSMultiColList *groupV0;
@property (weak, nonatomic) IBOutlet WSMultiColList *groupV1;
@property (weak, nonatomic) IBOutlet WSMultiColList *groupV2;

@end
