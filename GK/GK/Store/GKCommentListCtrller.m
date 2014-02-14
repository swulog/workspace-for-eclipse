//
//  GKCommentListCtrller.m
//  GK
//
//  Created by W.S. on 13-12-12.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GKCommentListCtrller.h"
#import "GKCommentService.h"
#import "CommentCell.h"
#import "GKCommentReleaseCtrller.h"
#import "GlobalDataService.h"
#import "GKLogonCtroller.h"

#define GoodCommentTag 1
#define BadCommentTag 0
#define CommentSortNum 2

#define NumOfPage 10

#define TableCellCommentTag 2000

#define CommentCellCMMHeight 75


@interface GKCommentListCtrller ()<GKTableDelegate,WSScrollContentViewDelegate>
{
    BOOL tableInitStatus[CommentSortNum];
    BOOL tableNextEnabled[CommentSortNum];
    BOOL hadClearMoreSperateLine[CommentSortNum];
    int  tablePageIndex[CommentSortNum];
    UIView *test;
    
}
@property (nonatomic,strong) NSArray *tableViewArray;
@property (nonatomic,strong) NSArray *buttonArray;
@property (nonatomic,strong) NSMutableArray *commentListArray;
@property (nonatomic,strong) NSArray *expandCells;

@property (nonatomic,assign) NSInteger currentFocusd;
@property (nonatomic,assign) BOOL hideToolBar;
@property (nonatomic,assign) BOOL isFromOwnerCenter;

@end

@implementation GKCommentListCtrller



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil style:VIEW_WITH_NAVBAR];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithStore:(StoreInfo*)store
{
    self = [self initWithNibName:@"GKCommentListCtrller" bundle:Nil];
    if (self) {
        self.store = store;
    }
    return self;
}

-(id)initForOwnerCenter
{
    self = [self init];
    if (self) {
        self.hideToolBar = TRUE;
        self.isFromOwnerCenter = TRUE;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"全部评论"];
    [self addBackItem];
    
    [self initParams];
    [self initUi];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logonSuccess) name:NOTIFICATION_LOGON_OK object:Nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateComment:) name:Notification_CommentRelease object:Nil];
    
    [self.buttonArray[GoodCommentTag] sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark initer -
-(void)initUi
{
    self.goodBtn.backgroundColor = colorWithUtfStr(LogonC_TextFieldTextColor);
    self.badBtn.backgroundColor = colorWithUtfStr(Color_PageCtrllerSelectedColor);
    [self.goodBtn setHightedBGColor:colorWithUtfStr(OwnerFavouriteC_BtnHightedColor)];
    [self.badBtn setHightedBGColor:colorWithUtfStr(OwnerFavouriteC_BtnHightedColor)];
    [self.badBtn setTitleColor:colorWithUtfStr(Color_PageCtrllerNormalColor) forState:UIControlStateNormal];

    self.goodTable.backgroundColor = self.view.backgroundColor;
    self.badTable.backgroundColor = self.view.backgroundColor;
    
    for (WSScrollContentView *table in self.tableViewArray) {
    //    table.gkdelegate = self;
        table.delegate = self;
        table.backgroundColor = self.view.backgroundColor;
    }
    
    for (int k = 0 ; k < self.buttonArray.count ; k++) {
        UIButton *btn = self.buttonArray[k];
        [btn setTag:k];
        [btn addTarget:self action:@selector(sortChanged:) forControlEvents:UIControlEventTouchUpInside];
        btn.adjustsImageWhenHighlighted = NO;
    }
    
    if (!self.hideToolBar) {
        self.toolBar.backgroundColor = colorWithUtfStr(Color_PageCtrllerSelectedColor);
        [self.commentBtn setTitleColor:colorWithUtfStr(Color_PageCtrllerNormalColor) forState:UIControlStateNormal];
        [self.commentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        UIView *border = [[UIView alloc] initWithFrame:CGRectMake(0, 1, self.toolBar.frame.size.width, 1)];
        border.backgroundColor =  [UIColor colorWithRed:.9f green:.9f blue:.9f alpha:.8f];
        [self.toolBar addSubview:border];
    } else {
        self.toolBar.hidden = YES;
        for (WSScrollContentView *table in self.tableViewArray) {
            [table strechTo:CGSizeMake(table.frame.size.width, table.frame.size.height+self.toolBar.frame.size.height)];
           // [[self contentView:table] strechTo:CGSizeMake(table.frame.size.width, table.frame.size.height+self.toolBar.frame.size.height)];
        }
    }

}

-(void)initParams
{
    _currentFocusd = NOT_DEFINED;
    self.commentListArray = [NSMutableArray arrayWithObjects:[NSMutableArray array],[NSMutableArray array], nil];
    self.tableViewArray = [NSArray arrayWithObjects:self.badScrollV, self.goodScrollV,nil];
    self.buttonArray = [NSArray arrayWithObjects:self.badBtn, self.goodBtn,nil];
    self.expandCells = [NSArray arrayWithObjects:[NSMutableArray array],[NSMutableArray array], nil];
}

#pragma mark -
#pragma mark setter -

-(void)setCurrentFocusd:(NSInteger)currentFocusd
{
    if (self.currentFocusd != currentFocusd) {
        _currentFocusd = currentFocusd;
        [self switchTableTo:currentFocusd];
    } else if(self.status == VIEW_PROCESS_FAIL){
        [self switchTableTo:currentFocusd];
    }
}

#pragma mark -
#pragma mark event handler -

-(void)sortChanged:(id)sender
{
    self.currentFocusd = ((UIControl*)sender).tag;
}

- (IBAction)release:(id)sender {
    
    BOOL isLogoned= [GlobalDataService isLogoned];
    
    if (!isLogoned) {
        GKLogonCtroller *logonVc = [[GKLogonCtroller alloc] init];
        UINavigationController *vc  = [[UINavigationController alloc] initWithRootViewController:logonVc];
        [vc setNavigationBarHidden:YES];
        [self presentFullScreenViewController:vc animated:YES completion:nil];
    } else {
        [self gotoCommentReleaseView];
    }
}

-(void)gotoCommentReleaseView
{
    GKCommentReleaseCtrller *vc =[[GKCommentReleaseCtrller alloc] initWithStore:self.store];
    [self presentFullViewController:vc animated:YES completion:nil];
}

#pragma mark -
#pragma mark inside function -

-(void)switchTableTo:(NSInteger)tag
{
    if (tableInitStatus[tag] == FALSE)
        [self.tableViewArray[tag] trigRefresh];
    
    for (WSScrollContentView *table in self.tableViewArray)
        table.hidden = table.tag != tag ;
}
#pragma mark -
#pragma mark Custom Delegate -

-(void)logonSuccess
{
    [self dismissFullScreenViewControllerAnimated:WSDismissStyle_AlphaAnimation completion:^{
        [self gotoCommentReleaseView];
    }];
}

-(UIView*)contentView:(WSScrollContentView*)scrollV
{
    UITableView *tables[] = {self.badTable,self.goodTable};
    return tables[scrollV.tag];
}
#pragma mark -
#pragma mark notification handler -
-(void)updateComment:(NSNotification*)notification
{
    Comment *comment = notification.object;
    [self.tableViewArray[[comment.rank intValue]] trigRefresh];
}
#pragma mark -
#pragma mark network adapter -

-(void)refresh
{
    self.status = VIEW_PROCESS_REFRESH;
    [self getCommentList];
}

-(void)loadMore
{
    self.status = VIEW_PROCESS_LOADMORE;
    [self getCommentList];
}

-(void)getCommentList
{
    int pagenum   = NumOfPage;
    int pageindex = self.status == VIEW_PROCESS_REFRESH ? StartPageNo : tablePageIndex[self.currentFocusd] + 1 ;
    
    NillBlock_OBBB sucBlock = ^(NSObject *obj, BOOL nextEnabled, BOOL isOffLine, BOOL isCache){
        tableInitStatus[self.currentFocusd] = TRUE;
        tablePageIndex[self.currentFocusd] = pageindex;
        
        NSMutableArray *newArray = (NSMutableArray*)obj;
        tableNextEnabled[self.currentFocusd] = nextEnabled;
        
        BOOL isRefresh = (self.status == VIEW_PROCESS_REFRESH);
        self.status = VIEW_PROCESS_NORMAL;

        if (isRefresh) {
            if (!newArray) 
                [self.commentListArray[self.currentFocusd] removeAllObjects];
            else
                self.commentListArray[self.currentFocusd] = newArray;
        } else {
            [self.commentListArray[self.currentFocusd] addObjectsFromArray:newArray];
        }
        
        WSScrollContentView *table = self.tableViewArray[self.currentFocusd];
        [((UITableView*)[self contentView:table]) reloadData];
        
        if (isRefresh) {
            [table finishRefresh];
            [table scrollToYop];
        } else {
            [table finishLoadMore];
        }
        
        if (tableNextEnabled[self.currentFocusd]) {
            [table showFooterView];
        } else {
            [table hideFooterView];
        }
    };
    
    NillBlock_Error failBlock = ^(NSError *err){
        WSScrollContentView *table = self.tableViewArray[self.currentFocusd];
        if (self.status == VIEW_PROCESS_LOADMORE)
            [table stopLoadMore];
        else
            [table stopRefresh];
        self.status = VIEW_PROCESS_FAIL;
        [self showTopPop:err.localizedDescription];
    };

    if (self.isFromOwnerCenter) {
        [GKCommentService GetOwnerCommentList:self.currentFocusd index:pageindex num:pagenum refresh:self.status == VIEW_PROCESS_REFRESH succ:sucBlock fail:failBlock];
    } else {
        [GKCommentService GetCommentList:self.store.id index:pageindex num:pagenum rank:self.currentFocusd refresh:self.status == VIEW_PROCESS_REFRESH succ:sucBlock fail:failBlock];
    }
}

#pragma mark -
#pragma mark table datasource & delegate  -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger ret ;
    
    NSArray *array = self.commentListArray[tableView.tag];
    ret = array.count;
    
    if (ret > 0) {
        if (!hadClearMoreSperateLine[tableView.tag] && !tableView.tableFooterView) {
            hadClearMoreSperateLine[tableView.tag] = TRUE;
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            
            UIView *view =[ [UIView alloc]init];
            view.backgroundColor = [UIColor clearColor];
            [tableView setTableFooterView:view];
        }
    } else {
        hadClearMoreSperateLine[tableView.tag] = FALSE;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return ret;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __block BOOL find = FALSE;
    NSArray *array = self.expandCells[tableView.tag];
    if (IsSafeArray(array)) {
        [array enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL *stop) {
            if ([obj intValue] == indexPath.row) {
                find = TRUE;
                *stop = TRUE;
            }
        }];
    }
    
    if (find) {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        CommentCell *v = (CommentCell*)[cell viewWithTag:TableCellCommentTag];
        v.dropEnabeld = TRUE;
        [v layoutIfNeeded];
        return v.frame.size.height;
    }
    
    return CommentCellCMMHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CommentCell";
    
    BOOL isNewCell = FALSE;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        isNewCell = TRUE;
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = self.view.backgroundColor;
        if (IOS_VERSION >= 7.0) cell.separatorInset = UIEdgeInsetsZero;
    }
    
    CommentCell *v = nil;
    if (isNewCell) {
         v = [CommentCell XIBView];
        if (IOS_VERSION < 7.0) {
            float width = TableCMMRowWidth;
            float x = (tableView.frame.size.width - width ) /2;
            CGRect rect = v.frame;
            rect.origin.x = x;
            rect.size.width = width;
            v.frame = rect;
        } else {
            float width = tableView.frame.size.width;
            float x = (tableView.frame.size.width - width ) /2;
            CGRect rect = v.frame;
            rect.origin.x = x;
            rect.size.width = width;
            v.frame = rect;
        }
        
        v.tag = TableCellCommentTag;
        v.backgroundColor = self.view.backgroundColor;
        [cell addSubview:v];
    } else {
        v = (CommentCell*)[cell viewWithTag:TableCellCommentTag];
    }
    
    Comment *comment = self.commentListArray[tableView.tag][indexPath.row];
    if (self.isFromOwnerCenter) {
        NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"评论%@",comment.store_name]];
        [attriString addAttribute:(NSString *)NSForegroundColorAttributeName
                            value:(colorWithUtfStr(SortListC_ButtonTextColor))
                            range:NSMakeRange(0, [NSString stringWithFormat:@"评论"].length)];
        [attriString addAttribute:(NSString *)NSForegroundColorAttributeName
                            value:(id)((tableView.tag == GoodCommentTag ? colorWithUtfStr(LogonC_TextFieldTextColor): colorWithUtfStr(SortListC_ButtonHightedColor)))
                               range:NSMakeRange([NSString stringWithFormat:@"评论"].length, comment.store_name.length)];
        [v  setAttributedName:attriString];
    } else {
        [v setName:SafeString(comment.owner_name)];
    }
    
    [v setComment:SafeString(comment.subject)];
    v.dateLabel.text = SafeString(comment.created);
    v.rankTag = [comment.rank intValue];
    v.dropEnabeld = FALSE;
    NSMutableArray *array = self.expandCells[tableView.tag];
    [array enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL *stop) {
        if ([obj intValue] == indexPath.row) {
            v.dropEnabeld =TRUE;
            cell.userInteractionEnabled = TRUE;
            *stop = TRUE;
        }
    }];
    if (!v.dropEnabeld) {
        [v layoutIfNeeded];
        if (v.expandValidate) {
            cell.userInteractionEnabled = TRUE;
        } else {
            cell.userInteractionEnabled = FALSE;
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    CommentCell *v = (CommentCell*)[cell viewWithTag:TableCellCommentTag];
    v.dropEnabeld = !v.dropEnabeld;
    NSMutableArray *array = self.expandCells[tableView.tag];
    if (v.dropEnabeld) {
        [array addObject:[NSNumber numberWithInt:indexPath.row]];
    } else {
        [array enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL *stop) {
            if ([obj intValue] == indexPath.row) {
                [array removeObject:obj];
                *stop = TRUE;
            }
        }];
    }
    
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}
@end
