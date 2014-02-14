//
//  GKTableView.h
//  GK
//
//  Created by W.S. on 13-5-16.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+SVPullToRefresh.h"
#import "PullTableFooterView.h"

@protocol GKTableDelegate;

@interface GKTableView : UITableView<FooterViewClickDelegate>
{
  BOOL isLoadingMore;
}
@property (assign,nonatomic) BOOL canLoadMore;
//@property (assign,nonatomic) BOOL hideTopView;
@property(nonatomic,assign) id<GKTableDelegate> gkdelegate;

-(void)stopAnimate;
-(void)startAnimate;
- (void) setFooterViewVisibility:(BOOL)visible;
- (void) loadMoreCompleted;
//-(void)hideHeaderRefreshView;

@property(nonatomic,strong) PullTableFooterView *footerView;
@end

@protocol GKTableDelegate <NSObject>

@optional

-(void)refresh;
-(void)loadMore;

@end
