//
//  WSScrollContentView.h
//  GK
//
//  Created by W.S. on 13-8-16.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"
#import "UIScrollView+SVPullToRefresh.h"

@class WSScrollContentView;
@protocol WSScrollContentViewDelegate <NSObject>
@optional
-(UIView*)contentView:(WSScrollContentView*)wsScrollV;
-(UIView*)contentView;
-(void)refresh;
@optional
-(void)loadMore;
@end

@interface WSScrollContentView : UIView<UIScrollViewDelegate>


@property (nonatomic,assign) id<WSScrollContentViewDelegate> delegate;
@property (nonatomic,strong) UIScrollView *scrollView;

-(void)enableScrollFor:(id)obj;

-(void)showFooterView;
-(void)hideFooterView;
-(void)finishLoadMore;
-(void)stopLoadMore;    //加载失败时调用以停止动画,会保留foortview

-(void)stopRefresh;     //刷新失败时调用以停止动画
-(void)finishRefresh;
-(void)finishRefresh:(NSDate*)date;
-(void)trigRefresh;
-(void)setLastUpdatedDate:(NSDate *)lastUpdatedDate;
-(void)scrollToYop;
@end


