//
//  WSScrollContentView.m
//  GK
//
//  Created by W.S. on 13-8-16.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "WSScrollContentView.h"
#import "CommonFunction.h"

enum{
  STATUS_NORMAL,
  STATUS_REFRESH,
  STATUS_LOAD
};

@interface WSScrollContentView()
@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) EGORefreshTableHeaderView *headerView;
@property (nonatomic,strong) EGORefreshTableFooterView *footerView;


@property (nonatomic,strong) NSDate *lastUpdatedDate;

@property (nonatomic,assign) int status;
@end



@implementation WSScrollContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    
    return self;
}

-(void)setDelegate:(id<WSScrollContentViewDelegate>)delegate
{
    _delegate = delegate;
    
    if ([delegate respondsToSelector:@selector(contentView)]) {
        self.contentView = [delegate performSelector:@selector(contentView)];
    } else if ([delegate respondsToSelector:@selector(contentView:)]){
        self.contentView = [delegate performSelector:@selector(contentView:) withObject:self];
    }
    
    CGRect rect = self.contentView.frame;
    rect.origin = CGPointZero;
    self.contentView.frame = rect;
    
    if ([self.contentView isKindOfClass:[UIScrollView class]]) {
        self.scrollView = (UIScrollView*)self.contentView;
    } else {
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        [self.scrollView addSubview:self.contentView];
        self.scrollView.contentSize = self.contentView.frame.size;
    }
    
    __block id weakSelf = self;
    [self.scrollView addPullToRefreshWithActionHandler:^{
        [weakSelf startRefresh];
    }];
    
    
    [self addSubview:self.scrollView];

}

-(void)enableScrollFor:(id)obj
{
    if ([obj respondsToSelector:@selector(contentView)]) {
        self.contentView = [obj performSelector:@selector(contentView)];
        if ([self.contentView isKindOfClass:[UIScrollView class]]) {
            self.scrollView = (UIScrollView*)self.contentView;
        } else {
            CGRect rect = self.frame;
            rect.origin = CGPointZero;
            self.scrollView = [[UIScrollView alloc] initWithFrame:rect];
            
            rect.size = self.contentView.frame.size;
            self.contentView.frame = rect;
            [self.scrollView addSubview:self.contentView];
            self.scrollView.contentSize = CGSizeMake(self.contentView.frame.size.width, MAX(self.frame.size.height + 0.5, self.contentView.frame.size.height+.5) );
            self.scrollView.showsVerticalScrollIndicator = YES;
        }
        [self addSubview:self.scrollView];

    }
}


-(void)showFooterView:(BOOL)show{
#if 1
    if (show && !self.scrollView.pullToLoadMoreView) {
        __block id weakSelf = self;
        [self.scrollView addPullToRefreshWithActionHandler:^{
            [weakSelf startLoadMore];
        }position:SVPullToRefreshPositionBottom];
    } else  if(!show){
        [self.scrollView removePullToLoadMoreView];
    }

#else
    if (show) {
        CGFloat height = MAX(self.scrollView.contentSize.height, self.scrollView.frame.size.height);
        if (self.footerView && [self.footerView superview])
        {
            self.footerView.frame = CGRectMake(0.0f,
                                               height,
                                               self.scrollView.frame.size.width,
                                               self.bounds.size.height);
        }else {
            self.footerView = [[EGORefreshTableFooterView alloc] initWithFrame:
                               CGRectMake(0.0f, height,
                                          self.scrollView.frame.size.width, self.bounds.size.height)];
            self.footerView.delegate = self;
            [self.scrollView addSubview:self.footerView];
        }
        
        if (self.footerView)
        {
            [self.footerView refreshLastUpdatedDate];
        }
    } else {
        if (self.footerView && [self.footerView superview]) {
            [self.footerView removeFromSuperview];
        }
        self.footerView = nil;
    }
#endif
}

//-(void)createHeaderView{
//    if (self.headerView && [self.headerView superview]) {
//        [self.headerView removeFromSuperview];
//    }
//	self.headerView = [[EGORefreshTableHeaderView alloc] initWithFrame:
//                          CGRectMake(0.0f, 0.0f - self.bounds.size.height,
//                                     self.frame.size.width, self.bounds.size.height)];
//    self.headerView.delegate = self;
//    
//	[self.scrollView addSubview:self.headerView];
//}


#pragma mark -
#pragma mark the heaqder & footer control interface for user
-(void)trigRefresh
{
  //  [self.scrollView setContentOffset:CGPointMake(0, -60) animated:YES];

    //[self.headerView trigRefresh];
    [self.scrollView triggerPullToRefresh];
 //   [self setScrollViewContentInset:UIEdgeInsetsMake(-60, 0, 0, 0)];
}

-(void)startRefresh
{
    if ([self.delegate respondsToSelector:@selector(refresh)]) {
        self.status = STATUS_REFRESH;
        [self.delegate performSelector:@selector(refresh)];
    }
}

-(void)finishRefresh
{
    [self finishRefresh:[NSDate date]];
}

-(void)finishRefresh:(NSDate*)date
{
    [self hideHeaderView];
    self.lastUpdatedDate = date;
}

-(void)stopRefresh
{
    [self hideHeaderView];
}

-(void)hideHeaderView
{
 //   [self.headerView egoRefreshScrollViewDataSourceDidFinishedLoading:self.scrollView];
    [self.scrollView.pullToRefreshView stopAnimating];

    self.status = STATUS_NORMAL;

}

-(void)showFooterView
{
    [self showFooterView:TRUE];
}

-(void)hideFooterView
{
    [self showFooterView:FALSE];
    self.status = STATUS_NORMAL;
}

-(void)startLoadMore
{
    if ([self.delegate respondsToSelector:@selector(loadMore)]) {
        self.status = STATUS_LOAD;
        
        [self.delegate performSelector:@selector(loadMore)];
    }
}

-(void)stopLoadMore
{
   // [self.footerView egoRefreshScrollViewDataSourceDidFinishedLoading:self.scrollView];
    [self.scrollView.pullToLoadMoreView stopAnimating];
    self.status = STATUS_NORMAL;
}

-(void)finishLoadMore
{
    //[self hideFooterView];
    [self stopLoadMore];
    self.lastUpdatedDate = [NSDate date];
}

-(void)setLastUpdatedDate:(NSDate *)lastUpdatedDate
{
    _lastUpdatedDate = lastUpdatedDate;
    
    if (lastUpdatedDate != nil) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateStyle:NSDateFormatterLongStyle];
        [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
        NSString *string = [formatter stringFromDate:lastUpdatedDate];
        
        [self.scrollView.pullToRefreshView setSubtitle:string forState:SVPullToRefreshStateAll];
    }
}

-(void)scrollToYop
{
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
//- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset {
//    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
//        self.scrollView.contentInset = contentInset;
//    } completion:^(BOOL finished) {
////        if(self.state == SVPullToRefreshStateHidden && contentInset.top == self.originalScrollViewContentInset.top)
////            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
////                arrow.alpha = 0;
////            } completion:NULL];
//    }];
//}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods


//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    
//    if (scrollView.contentOffset.y < 0) {
//        if (self.headerView) {
//            [self.headerView egoRefreshScrollViewDidScroll:scrollView];
//        }
//    } else if(scrollView.contentOffset.y > scrollView.frame.size.height){
//        if (self.footerView)
//        {
//            [self.footerView egoRefreshScrollViewDidScroll:scrollView];
//        }
//    }
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//
//    if (self.headerView) {
//        [self.headerView egoRefreshScrollViewDidEndDragging:scrollView];
//    }
//    
//	if (self.footerView)
//	{
//        [self.footerView egoRefreshScrollViewDidEndDragging:scrollView];
//    }
//}
//
//- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
//{
//    if (aRefreshPos == EGORefreshHeader) {
//        [self startRefresh];
//    } else {
//        [self startLoadMore];
//    }
//	
//}
//
//- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view{
//
//	return self.status != STATUS_NORMAL;
//	
//}


@end
