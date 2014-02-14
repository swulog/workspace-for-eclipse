//
//  GKTableView.m
//  GK
//
//  Created by W.S. on 13-5-16.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GKTableView.h"

@implementation GKTableView



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addPullToRefreshWithActionHandler:^(void){
        }];
    }
    return self;
}

-(void)awakeFromNib
{
    UIColor *bgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"screen_backgroud"]];
    self.backgroundColor =bgColor;
    
      
    self.footerView = [[PullTableFooterView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    self.canLoadMore = YES;
    self.footerView.delegate = self;
   // self.tableFooterView = self.footerView;
}

-(void)setGkdelegate:(id<GKTableDelegate>)delegate
{
    _gkdelegate = delegate;
    __unsafe_unretained GKTableView *blockSelf = self;
     //__block
    [blockSelf addPullToRefreshWithActionHandler:^(void){
        if (!blockSelf->isLoadingMore)
        {
            if ([blockSelf.gkdelegate respondsToSelector:@selector(refresh) ]) {
                [blockSelf.gkdelegate performSelector:@selector(refresh)];
            }
            
        }
    }
     ];
   

}

//-(void)setHideTopView:(BOOL)hideTopView
//{
//    self.pullToRefreshView.hideTopView = hideTopView;
//}
//
//-(void)hideHeaderRefreshView
//{
//    [self setPullToRefreshView:Nil];
//}

-(void)stopAnimate
{
    [self.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil];
}

-(void)startAnimate
{
 //   [self.pullToRefreshView triggerRefresh];
    [self triggerPullToRefresh];
}

- (void) setFooterViewVisibility:(BOOL)visible
{
    if (visible && (self.tableFooterView != self.footerView || self.tableFooterView == nil || self.footerView.hidden == YES))
    {
        self.tableFooterView = self.footerView;
        self.tableFooterView.hidden = NO;
    }
    else if (!visible)
    {
//        PullTableFooterView *fv = (PullTableFooterView *)self.footerView;
//        [fv reset];
        
        if (self.tableFooterView == self.footerView ) {
            self.tableFooterView = nil;
            self.footerView.hidden  = YES;
        }
      
        isLoadingMore = FALSE;
    }
}


- (void) willBeginLoadingMore
{
    PullTableFooterView *fv = (PullTableFooterView *)self.footerView;
    fv.infoLabel.text = @"正在加载";
    if ([self.delegate respondsToSelector:@selector(loadMorePullTable)]) {
        [self.delegate performSelector:@selector(loadMorePullTable)];
    }
  //  [fv.activityIndicator startAnimating];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) loadMoreCompleted
{
    isLoadingMore = NO;
    
    {
        
        PullTableFooterView *fv = (PullTableFooterView *)self.footerView;
     //   fv.infoLabel.text = @"加载更多";
        [fv reset];
      //  [fv.activityIndicator stopAnimating];
        
        if (!self.canLoadMore) {
            // Do something if there are no more items to load
            
            // We can hide the footerView by: [self setFooterViewVisibility:NO];
            
            // Just show a textual info that there are no more items to load
            fv.infoLabel.hidden = NO;
        }
    }
}

- (BOOL) loadMore
{
    
    if (isLoadingMore)
        return NO;
    isLoadingMore = YES;
    [self willBeginLoadingMore];
    
    return YES;
}
-(void)footerViewCliecked
{

    [self loadMore];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



@end
