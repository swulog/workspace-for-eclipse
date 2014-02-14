//
//  GKTBListCtrller.h
//  GK
//
//  Created by W.S. on 13-8-14.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GKBaseViewController.h"
#import "TMQuiltView.h"
#import "WSScrollContentView.h"
#import "XWGListCell.h"
#import "GKStoreListCtrller.h"

@interface XWGListCtrller : GKBaseViewController<TMQuiltViewDataSource,TMQuiltViewDelegate,WSScrollContentViewDelegate,WSMultiColCellDelegate,UIScrollViewDelegate>
{
    NSMutableArray *itemArray;
    int     pageNo,pageNum;
    BOOL    hadNextPage;
}
@property (nonatomic,strong) TMQuiltView *tableView;
@property (nonatomic,strong) EGORefreshTableHeaderView *tableHeaderView;
@property (nonatomic,strong) EGORefreshTableFooterView *tableFooterView;
@property (nonatomic,strong) WSScrollContentView *wsScrollContentV;
@property (nonatomic,strong) UIButton *topBtn;
@property (weak, nonatomic) IBOutlet UIView *topToolBar;
@property (weak, nonatomic) IBOutlet UIButtonWithStoreList *recommandBtn;
@property (weak, nonatomic) IBOutlet UIButtonWithStoreList *hotBtn;
@property (weak, nonatomic) IBOutlet UIButtonWithStoreList *newerBtn;


- (IBAction)recommandClick:(id)sender;
- (IBAction)hotClick:(id)sender;
- (IBAction)newClick:(id)sender;

@end

