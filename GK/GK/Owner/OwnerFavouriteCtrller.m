//
//  GS_CouponManageCtrller.m
//  GS
//
//  Created by W.S. on 13-6-22.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "OwnerFavouriteCtrller.h"
#import "GlobalObject.h"
#import "OwnerCouponTableCell.h"
#import "OwnerXWGTableCell.h"

#import "GKStoreSortListService.h"
#import "GKXWGService.h"
#import<CoreText/CoreText.h>
#import "GKStoreInfomationController.h"
#import "XWGGoodDetailCtrller.h"
#import "GKCouponInforController.h"
#import "WSWarningImageView.h"

typedef enum{
    Favourite_Coupon,
    Favourite_TbItem,
    
    FavouriteSort_Count
}FavouriteSort;

#define TableRowHeight 75

@interface OwnerFavouriteCtrller ()<WSScrollContentViewDelegate>

{
    BOOL hadClearMoreSperateLine[FavouriteSort_Count];
    BOOL isDeleting;

    BOOL isAutoRefresh;
}
@property (nonatomic,strong) NSArray *favourBtn;
@property (strong,nonatomic) NSMutableArray *listArray;
@property (strong,nonatomic) NSArray *tableViewArray;
@property (strong,nonatomic) NSArray *contentTableArray;
@property (nonatomic,assign) FavouriteSort curStatus;

@end

@implementation OwnerFavouriteCtrller

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil style:VIEW_WITH_NAVBAR];
    if (self) {
        // Custom initialization

    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"我的收藏"];
    [self addBackItem];
    [self initParams];
    [self initUI];
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goodLoveChanged:) name:NOTIFICATION_GOOD_LOVED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goodLoveChanged:) name:NOTIFICATION_GOOD_UNLOVED object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(couponLoveChanged:) name:NOTIFICATION_COUPON_LOVED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(couponLoveChanged:) name:NOTIFICATION_COUPON_UNLOVED object:nil];
    
    [self.favourBtn[Favourite_Coupon] sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self setCouponTableView:nil];
    [self setTbItemTable:nil];
    [self setCouponBtn:nil];
    [self setXwgGoodBtn:nil];
    [super viewDidUnload];
}

-(void)viewWillLayoutSubviews
{
    [self.tableViewArray makeObjectsPerformSelector:@selector(resetrAutoresizingMask)];
}

#pragma mark - 
#pragma mark initer -
-(void)initParams
{
    pageNum = LIST_PAGE_LimitLess_MUM;
    pageIndex[0] = StartPageNo;
    pageIndex[1] = StartPageNo;
    
    _curStatus =  NOT_DEFINED;

    hadClearMoreSperateLine[Favourite_Coupon] = FALSE ;
    hadClearMoreSperateLine[Favourite_TbItem] = FALSE ;
    
    self.listArray          = [NSMutableArray arrayWithObjects:[NSMutableArray array],[NSMutableArray array], nil];
    self.contentTableArray  = [NSArray arrayWithObjects:self.couponTableView,self.tbItemTable, nil];
    self.tableViewArray     = [NSArray arrayWithObjects:self.couponScrollV,self.xwgGoodScrollV, nil];
    self.favourBtn          = [NSArray arrayWithObjects:self.couponBtn,self.xwgGoodBtn, nil];
}

-(void)initUI
{
    self.couponBtn.backgroundColor = colorWithUtfStr(PersonalCenterC_CellMSGBtnBGColor);
    [self.couponBtn setHightedBGColor:colorWithUtfStr(OwnerFavouriteC_BtnHightedColor)];
    self.xwgGoodBtn.backgroundColor = colorWithUtfStr(PersonalCenterC_LogViewLogonBtnBg);
    [self.xwgGoodBtn setHightedBGColor:colorWithUtfStr(OwnerFavouriteC_BtnHightedColor)];
    
    for (WSScrollContentView *table in self.tableViewArray) {
        table.delegate = self;
        table.backgroundColor = self.view.backgroundColor;
    }
    
    for (UITableView *table in self.contentTableArray) {
        table.backgroundColor = self.view.backgroundColor;
        table.rowHeight = TableRowHeight;
    }
    
    for (int k = 0 ; k < FavouriteSort_Count ; k++) {
        UIButton *btn = self.favourBtn[k];
        [btn setTag:k];
        [btn addTarget:self action:@selector(sortChanged:) forControlEvents:UIControlEventTouchUpInside];
        btn.adjustsImageWhenHighlighted = NO;
    }
}

#pragma mark -
#pragma mark setter -

-(void)setCurStatus:(FavouriteSort)curStatus
{
    if (self.curStatus != curStatus || self.status == VIEW_PROCESS_FAIL) {
        _curStatus = curStatus;
        [self switchTableTo:curStatus];
    }
}
#pragma mark -
#pragma mark notification handler -
-(void)goodLoveChanged:(NSNotification*)notification
{
    
    if (self.viewIsAppear) {
        return;
    }
    
    GoodsInfo *pGood = notification.object;
    NSString *id = pGood.id;
    
    NSMutableArray *array = self.listArray[Favourite_TbItem];
    if ([notification.name isEqualToString:NOTIFICATION_GOOD_LOVED]) {
        if (!nextPageEnabled[Favourite_TbItem]) {
            [array insertObject:pGood atIndex:0];
            
            if (array.count == 1) {
                [self.contentTableArray[Favourite_TbItem] reloadData];
            } else   {
                NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
                
                [self.contentTableArray[Favourite_TbItem] beginUpdates];
                [self.contentTableArray[Favourite_TbItem] insertRowsAtIndexPaths:[NSArray arrayWithObject:indexpath] withRowAnimation:UITableViewRowAnimationNone];
                [self.contentTableArray[Favourite_TbItem] endUpdates];
            }
        }
    } else if (IsSafeArray(array)) {
        int row = 0;
        BOOL find = FALSE;
        for (GoodsInfo *good in array) {
            if ([good.id isEqualToString:id]) {
                [array removeObject:good];
                find = TRUE;
                break;
            }
            row++;
        }
        
        if (find) {
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:row inSection:0];
            [self.contentTableArray[Favourite_TbItem] beginUpdates];
            [self.contentTableArray[Favourite_TbItem] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexpath] withRowAnimation:UITableViewRowAnimationNone];
            [self.contentTableArray[Favourite_TbItem] endUpdates];
        }
    }
}

-(void)couponLoveChanged:(NSNotification*)notification
{
    if (self.viewIsAppear) {
        return;
    }
    
    Coupon *pGood = notification.object;
    NSString *id = pGood.id;
    
    NSMutableArray *array = self.listArray[Favourite_Coupon];
    if ([notification.name isEqualToString:NOTIFICATION_COUPON_LOVED]) {
        if (!nextPageEnabled[Favourite_Coupon]) {
            [array insertObject:pGood atIndex:0];
            
            if (array.count == 1) {
                [self.contentTableArray[Favourite_Coupon] reloadData];
            } else {
                NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
                
                [self.contentTableArray[Favourite_Coupon] beginUpdates];
                [self.contentTableArray[Favourite_Coupon] insertRowsAtIndexPaths:[NSArray arrayWithObject:indexpath] withRowAnimation:UITableViewRowAnimationNone];
                [self.contentTableArray[Favourite_Coupon] endUpdates];
            }
        }
    } else if (IsSafeArray(array)) {
        int row = 0;
        BOOL find = FALSE;
        for (Coupon *good in array) {
            if ([good.id isEqualToString:id]) {
                [array removeObject:good];
                find = TRUE;
                break;
            }
            row++;
        }
        
        if (find) {
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:row inSection:0];
            [self.contentTableArray[Favourite_Coupon] beginUpdates];
            [self.contentTableArray[Favourite_Coupon] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexpath] withRowAnimation:UITableViewRowAnimationNone];
            [self.contentTableArray[Favourite_Coupon] endUpdates];
        }
    }
}

#pragma mark -
#pragma mark event handler -


-(void)sortChanged:(id)sender
{
    self.curStatus = ((UIControl*)sender).tag;
}

-(void)switchTableTo:(FavouriteSort)status
{
    isDeleting = FALSE;
    for (int k = 0;  k < self.contentTableArray.count; k++) {
        [self.contentTableArray[k] setEditing:false];
        [self.tableViewArray[k] setHidden:(k!= status)];
    }
    
    if (initStatus[status] == FALSE)
        [self.tableViewArray[status] trigRefresh];
}

-(void)getLoveList:(FavouriteSort)couponStatus
{

//    int pagenum   = pageNum;
//    int pageindex = pageIndex[couponStatus] + StartPageNo;
//    
//    if (self.status == VIEW_PROCESS_LOADMORE) {
//        if (rowDeleted[couponStatus]) {
//            pagenum = pageindex * pagenum;
//            pageindex = 1;
//        }
//    } else {
//        pageindex = StartPageNo;
//    }
    
    
    NillBlock_OBJ_BOOL sucBlock = ^(NSObject *obj,BOOL next){
        initStatus[couponStatus] = TRUE;
    //    pageIndex[couponStatus] = pageindex;
        nextPageEnabled[couponStatus] = next;

        NSMutableArray *newArray = (NSMutableArray*)obj;

        if (!newArray) {
            if (self.status == VIEW_PROCESS_REFRESH || rowDeleted[couponStatus])
                [self.listArray[couponStatus] removeAllObjects];
        } else {
            if (self.status == VIEW_PROCESS_REFRESH || rowDeleted[couponStatus])
                self.listArray[couponStatus] = newArray;
            else
                [self.listArray[couponStatus] addObjectsFromArray:newArray];
        }
        rowDeleted[couponStatus] = FALSE;
               
        UITableView *table = self.contentTableArray[couponStatus];
        [table reloadData];

        BOOL isRefresh = (self.status == VIEW_PROCESS_REFRESH);
        self.status = VIEW_PROCESS_NORMAL;
        if (isRefresh) {
//            if (self.status == VIEW_PROCESS_REFRESH && !isAutoRefresh) {
//                [self.tableViewArray[couponStatus] finishRefresh:[GlobalObject dateForListRefresh:kListIdentifier[couponStatus]]];
//            } else {
//                [self.tableViewArray[couponStatus] finishRefresh];
//            }
            [self.tableViewArray[couponStatus] finishRefresh:[GlobalObject dateForListRefresh:kListIdentifier[couponStatus]]];
            [self.tableViewArray[couponStatus] scrollToYop];
        } else {
            [self.tableViewArray[couponStatus] finishLoadMore];
        }
        
        if (nextPageEnabled[couponStatus])
            [self.tableViewArray[couponStatus] showFooterView];
        else
            [self.tableViewArray[couponStatus] hideFooterView];
    };
    
    
    NillBlock_Error failBlock = ^(NSError *err){
        WSScrollContentView *table = self.tableViewArray[couponStatus];
        if (self.status == VIEW_PROCESS_LOADMORE)
            [table stopLoadMore];
        else
            [table stopRefresh];
        self.status = VIEW_PROCESS_FAIL;
        [self showTopPop:err.localizedDescription];
    };
    
    if (couponStatus == Favourite_Coupon) {
        [GlobalDataService GetMyCouponLoveList:!isAutoRefresh index:pageIndex[couponStatus] pagenum:pageNum succ:sucBlock fail:failBlock];
    //    [GlobalDataService couponLoveList:pageindex pagenum:pagenum succ:sucBlock fail:failBlock];
    } else if(couponStatus == Favourite_TbItem) {
        [GlobalDataService GetMyXWGLoveList:!isAutoRefresh index:pageIndex[couponStatus] pagenum:pageNum succ:sucBlock fail:failBlock];
    //    [GlobalDataService XWGLoveList:pageIndex[couponStatus] pagenum:pageNum succ:sucBlock fail:failBlock];
    }
}

-(void)unLoveCoupon:(NSIndexPath*)indexPath
{
    Coupon *coupon = [self.listArray[Favourite_Coupon] objectAtIndex:indexPath.row];
    
    NillBlock_Nill blockUpdate = ^{
        [self.listArray[Favourite_Coupon] removeObject:coupon];
        rowDeleted[Favourite_Coupon] = TRUE;
        
        self.status = VIEW_PROCESS_NORMAL;
        [self hideWaitting];
        
        [self.contentTableArray[_curStatus] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_COUPON_UNLOVED object:coupon];
        
    };
    
    self.status = VIEW_PROCESS_GETTING;
    [NSTimer scheduledTimerWithTimeInterval:CMM_AnimatePerior target:self selector:@selector(showWatting) userInfo:nil repeats:NO];
    
    [GKStoreSortListService loveCoupon:coupon.id isLoved:TRUE success:^{
        blockUpdate();
    } fail:^(NSError *err) {
        if (err.code == 422) {
            blockUpdate();
        }  else {
            self.status = VIEW_PROCESS_NORMAL;
            [self hideWaitting];
        }
        [self showTopPop:err.localizedDescription];
        
    }];
    
}
-(void)unLoveXWGGood:(NSIndexPath*)indexPath
{
    GoodsInfo *good = [self.listArray[Favourite_TbItem] objectAtIndex:indexPath.row];

    NillBlock_Nill blockUpdate = ^{
        [self.listArray[Favourite_TbItem] removeObject:good];
        rowDeleted[Favourite_TbItem] = TRUE;
        
        self.status = VIEW_PROCESS_NORMAL;
        [self hideWaitting];
        
        [self.contentTableArray[_curStatus] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GOOD_UNLOVED object:good];
    };
    
    self.status = VIEW_PROCESS_GETTING;
    [NSTimer scheduledTimerWithTimeInterval:CMM_AnimatePerior target:self selector:@selector(showWatting) userInfo:nil repeats:NO];
        
    [GKXWGService loveGood:good.id hadFocused:TRUE success:^{
        blockUpdate();
    } fail:^(NSError *err) {
        if (err.code == 422) {
            blockUpdate();
        }  else {
            self.status = VIEW_PROCESS_NORMAL;
            [self hideWaitting];
        }
        [self showTopPop:err.localizedDescription];

    }];
}

-(void)refresh
{
    isAutoRefresh = !initStatus[self.curStatus];
    
    self.status = VIEW_PROCESS_REFRESH;
    [self getLoveList:_curStatus];
}

-(void)loadMore
{
    self.status = VIEW_PROCESS_LOADMORE;
    [self getLoveList:_curStatus];
}

#pragma mark -
#pragma mark Custom Delegate -

-(UIView*)contentView:(WSScrollContentView*)scrollV
{
    return self.contentTableArray[scrollV.tag];
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
//    if (!self.listArray || self.listArray.count == 0) {
//        ret =  0;
//    }
    
    NSArray *array = [self.listArray objectAtIndex:tableView.tag];
    ret = array.count;
    
    if (ret > 0) {
        if (!hadClearMoreSperateLine[_curStatus] && !tableView.tableFooterView) {
            hadClearMoreSperateLine[_curStatus] = TRUE;
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            
            UIView *view =[ [UIView alloc]init];
            view.backgroundColor = [UIColor clearColor];
            [tableView setTableFooterView:view];
        }
        
    } else {
        hadClearMoreSperateLine[_curStatus] = FALSE;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return array.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier[] = {@"OwnerCouponTableCell",@"OwnerXWGTableCell"} ;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier[tableView.tag]];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellIdentifier[tableView.tag] owner:self options:nil] objectAtIndex:0];
      //  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        [(OwnerCouponTableCell*)cell configWithReuseIdentify:cellIdentifier[tableView.tag]];
    }
    
    NSObject *obj = (self.listArray[tableView.tag])[indexPath.row];
    if (tableView.tag == Favourite_Coupon) {
        OwnerCouponTableCell *couponCell = (OwnerCouponTableCell*)cell;
        Coupon *coupon = (Coupon*)obj;
        couponCell.storeNameLabel.text = coupon.title;
        if (IsSafeString(coupon.image_url)) {
            [couponCell.couponIcon showUrl:[NSURL URLWithString:coupon.image_url] activity:YES palce:[UIImage imageNamed:OwnerFavouriteC_NoCouponImgIcon]] ;
        } else {
            [couponCell.couponIcon showDefaultImg:[UIImage imageNamed:OwnerFavouriteC_NoCouponImgIcon]];
        }

        couponCell.couponNameLabel.text = coupon.store_name;
        
        NSDate *curDate = [NSDate date];
        NSString *curDateStr =   transDatetoChinaDateStr(curDate);
        curDate = dateFromChinaDateString(curDateStr);
        NSDate *endDate = dateFromString(coupon.end);
        NSString *endDateStr =   transDatetoChinaDateStr(endDate);
        endDate = dateFromChinaDateString(endDateStr);
        
        NSTimeInterval dayTimer = 24*60*60;
        
        if ([endDate compare:curDate] < NSOrderedSame) {
            couponCell.couponValidateLabel.text = @"已过期";
        } else {
            NSTimeInterval timer =  [endDate timeIntervalSinceDate:curDate];
            int days =  ceil(timer/dayTimer);
            couponCell.couponValidateLabel.text = [NSString stringWithFormat:@"剩余%d天",days+1];
        }
        
    } else{
        GoodsInfo *good = (GoodsInfo*)obj;
        OwnerXWGTableCell *couponCell = (OwnerXWGTableCell*)cell;
        couponCell.goodNameLabel.text = good.title;
        if (IsSafeString(good.smal_image_url)) {
            [couponCell.storeIcon showUrl:[NSURL URLWithString:good.smal_image_url] activity:YES palce:[WSWarningImage ImageForWarning:nil font:Nil color:nil]];
        } else {
            [couponCell.storeIcon showDefaultImg:[UIImage imageNamed:LIST_DEFAULT_IMG]];
        }
        
        couponCell.priceLabel.text = [NSString stringWithFormat:@"RMB %d",[good.price intValue]];

    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject *obj = (self.listArray[_curStatus])[indexPath.row];
    UIViewController *vc;
    if (_curStatus == Favourite_Coupon) {
        Coupon *coupon = (Coupon*)obj;
        vc = [[GKCouponInforController alloc] initWithCoupon:[NSArray arrayWithObject:coupon] focus:0];
    } else if(_curStatus == Favourite_TbItem) {
        GoodsInfo *good = (GoodsInfo*)obj;
        vc = [[XWGGoodDetailCtrller alloc] initWithGood:good];
    }
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:FALSE];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if (_curStatus == Favourite_Coupon) {
            [self unLoveCoupon:indexPath];
        } else if(_curStatus == Favourite_TbItem){
            [self unLoveXWGGood:indexPath];
        }
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (curStatus == CouponStatus_Normal) {
//        return  UITableViewCellEditingStyleNone;
//    } 
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (tableView.tag == CouponStatus_Pengding) {
//        return  @"撤销";
//    } else if(tableView.tag == CouponStatus_Expired){
//        return @"删除";
//    }
//    return nil;
    return @"删除";
}

//-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}

@end
