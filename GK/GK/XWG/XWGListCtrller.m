//
//  GKTBListCtrller.m
//  GK
//
//  Created by W.S. on 13-8-14.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "XWGListCtrller.h"
#import "GlobalObject.h"
#import "TMPhotoQuiltViewCell.h"
#import "GKXWGService.h"
#import "XWGGoodDetailCtrller.h"

#define LIST_TAG_START  1000

#define ST_NoNe 0x00
#define ST_GetSorts 0x01
//typedef enum{
//    AlignSort_NotDefine = -1,
//    AlignSort_Recomand,
//    AlignSort_Hot,
//    AlignSort_New
//}AlignSort;

@interface XWGListCtrller ()
{
    NSUInteger subStatus;
    NSString *xwgRequetUrl;
    
    BOOL STOP;
}
@property (nonatomic,strong) WSPopupView *sortPicker;
@property (nonatomic,strong) WSMultiColList *sortListView;
@property (nonatomic,strong) NSMutableArray *sorts;
//@property (nonatomic,assign) AlignSort alignIndex;
@property (nonatomic,strong) UIButtonWithStoreList *focusBtn;

@property (nonatomic,strong) NSString *orderStr;
@property (nonatomic,assign) NSInteger sortId;

@property (nonatomic,assign) BOOL topToolBarHieded,topToolBarShowing;
@property (nonatomic,strong) UIButton *downDragView;

@end

@implementation XWGListCtrller

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil style:VIEW_WITH_NAVBAR];
    if (self) {
        // Custom initialization
        self.tabImageName = [NSString stringWithUTF8String:tabImgNames[GKTAB_XWG]];
    //    self.tabTitle = [NSString stringWithUTF8String:tabTitles[GKTAB_XWG]];
        
        pageNum = XWG_LIST_PAGE_MAX_MUM;
        pageNo = 1;
        
        self.sortId = GoodIDForEditor;
        self.orderStr = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[UIButtonWithStoreList appearance] setBackgroundColor:colorWithUtfStr(SortListC_ButtonBgColor)];
    [[UIButtonWithStoreList appearance] setTitleColor:colorWithUtfStr(SortListC_ButtonTextColor) forState:UIControlStateNormal];
    [[UIButtonWithStoreList appearance] setTitleColor:colorWithUtfStr(SortListC_ButtonHightedColor)  forState:UIControlStateHighlighted];
    
    [self setTitle:@"享网购"];
    [self addBackItem:nil img:[UIImage imageNamed:XWGC_SortBtnIcon] action:@selector(showSortPicker)];
    
    [self.topToolBar.subviews makeObjectsPerformSelector:@selector(moveDown:) withObject:[NSNumber numberWithFloat:APP_NAVBAR_HEIGHT]];
    [self.topToolBar addSubview:self.navBar];
    self.topToolBar.clipsToBounds = YES;
    [self.topToolBar setFrame:CGRectMake(self.navBar.frame.origin.x, self.navBar.frame.origin.y, self.navBar.frame.size.width, self.navBar.frame.size.height + self.recommandBtn.frame.size.height)];
    
    if (IOS_VERSION >= 7.0) {
        [self.navBar moveUp:[NSNumber numberWithInt:APP_STATUSBAR_HEIGHT]];
    }

    
    float y = self.topToolBar.frame.origin.y + self.topToolBar.frame.size.height + 5;
    self.wsScrollContentV = [[WSScrollContentView alloc] initWithFrame:CGRectMake(0, y, APP_SCREEN_WIDTH, self.view.frame.size.height - y)];
    self.wsScrollContentV.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.wsScrollContentV];
    self.wsScrollContentV.delegate = self;
    self.wsScrollContentV.scrollView.delegate = self;
    
    self.topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.topBtn setImage:[UIImage imageNamed:XWGC_TopBtnIcon] forState:UIControlStateNormal];
    [self.topBtn setFrame:CGRectMake(270, self.view.frame.origin.y + self.view.frame.size.height - 150, XWGC_TopBtnIconWidth, XWGC_TopBtnIconHeight)];
    
    
    
    __block XWGListCtrller *weakself  = self;
    [self.view addSubview:self.topBtn];
    [self.topBtn addEventHandler:^(id sender) {
        [weakself.wsScrollContentV scrollToYop];
    } forControlEvents:UIControlEventTouchUpInside];
    self.topBtn.hidden = YES;
    
    self.sorts = [NSMutableArray array];
    XWGGoodSort *sort = [[XWGGoodSort alloc] init];
    sort.id = GoodIDForTopSort;
    sort.name = @"全部宝贝";
    [self.sorts addObject:sort];
    [self getXWGSorts];
//    [self.sorts addObjectsFromArray:[GKXWGService getXWGGoodSorts:^(NSArray *array) {
//        [self.sorts addObjectsFromArray:array];
//    } fail:nil]];
    
    [self.recommandBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillUnload
{
    itemArray = nil;
}


#pragma mark - 
#pragma mark event handler-
- (IBAction)recommandClick:(id)sender {
    UIButtonWithStoreList *btn = (UIButtonWithStoreList*)sender;
    
    if (self.focusBtn == sender) {
        return;
    }
    
    [self btnSelected:btn];
    
    
    self.sortId = GoodIDForEditor;
    self.orderStr = nil;
    
    for (XWGListCell *cell in self.tableView.visibleCells) {
        [cell removeCellObserverForKeyPath:@"user_favorites"];
    }
    itemArray = nil;
    [self.tableView reloadData];
    
    [self.wsScrollContentV trigRefresh];
}

- (IBAction)hotClick:(id)sender {
    UIButtonWithStoreList *btn = (UIButtonWithStoreList*)sender;
    if (self.focusBtn == sender) {
        return;
    }
    
    [self btnSelected:btn];
    
    self.orderStr = btn.titleLabel.text;
    if (self.sortId == GoodIDForEditor) {
        self.sortId = GoodIDForTopSort;
    }
    for (XWGListCell *cell in self.tableView.visibleCells) {
        [cell removeCellObserverForKeyPath:@"user_favorites"];
    }
    itemArray = nil;
    [self.tableView reloadData];
    
    [self.wsScrollContentV trigRefresh];
    
}

- (IBAction)newClick:(id)sender {
    UIButtonWithStoreList *btn = (UIButtonWithStoreList*)sender;
    if (self.focusBtn == sender) {
        return;
    }
    
    [self btnSelected:btn];
    
    self.orderStr = btn.titleLabel.text;
    if (self.sortId == GoodIDForEditor) {
        self.sortId = GoodIDForTopSort;
    }
    for (XWGListCell *cell in self.tableView.visibleCells) {
        [cell removeCellObserverForKeyPath:@"user_favorites"];
    }
    itemArray = nil;
    [self.tableView reloadData];
    [self.wsScrollContentV trigRefresh];
}

-(void)cellSelected:(NSInteger)index
{
    XWGGoodSort *sort = self.sorts[index];
    if ([sort.id intValue] == self.sortId) {
        [self.sortPicker  hide];
        return;
    }
    
    if (self.sortId == GoodIDForEditor) {
         self.focusBtn.backgroundColor = colorWithUtfStr(SortListC_ButtonBgColor);
        self.focusBtn = Nil;
    }
    
    if (xwgRequetUrl) {
        [GKXWGService cancelRequest:xwgRequetUrl];
        xwgRequetUrl = nil;
    }

    self.sortId = [sort.id intValue];
    [self.wsScrollContentV trigRefresh];
    
    [self.sortPicker  hide];
}

#pragma mark -
#pragma mark inside normal function -

-(GoodsInfo*)getItemWithId:(NSString*)id
{
    for(int k = 0 ; k < itemArray.count; k++){
        if([((GoodsInfo*)[itemArray objectAtIndex:k]).id isEqualToString:id])
            
            return [itemArray objectAtIndex:k];
    }
    return nil;
}

-(void)btnSelected:(UIButtonWithStoreList*)btn
{
    if (self.focusBtn) {
        self.focusBtn.backgroundColor = colorWithUtfStr(SortListC_ButtonBgColor);
    }
    
    btn.backgroundColor = colorWithUtfStr(SortListC_TopTabPopViewCellSelectedBg);

    self.focusBtn = btn;
    
    if (xwgRequetUrl) {
        [GKXWGService cancelRequest:xwgRequetUrl];
        xwgRequetUrl = nil;
    }

}

-(void)showSortPicker
{
    if (self.sorts.count == 1) { /*全部宝贝*/
        if (!(subStatus & ST_GetSorts)) {
            [self getXWGSorts];
        }
        return;
    }
    
    if (!self.sortPicker) {
        WSMultiColList *tablee = [[WSMultiColList alloc] initWithFrame:CGRectMake(0, 64, 320, 200)];
        tablee.numOfColPerRow = 3;
        tablee.cellTitltColor = colorWithUtfStr(HomePageC_NavbarCityColor);
        tablee.footColor = colorWithUtfStr(HomePageC_NavPopViewFootColor);
        tablee.selectedColor = colorWithUtfStr(XWGC_MenuSelectColor);
        self.sortListView = tablee;
        
        NSMutableArray *array = [NSMutableArray array];
        NSInteger selectIndex = 0;
        for (int k = 0 ; k < self.sorts.count; k++) {
            WSMultiColCell *cell = [WSMultiColCell initWithTitle:((XWGGoodSort*)self.sorts[k]).name imageView:nil];
            if ([((XWGGoodSort*)self.sorts[k]).id intValue] == self.sortId) {
                selectIndex = k;
            }
            [array addObject:cell];
        }
        
        tablee.itemSource =array;
        if (self.sortId != GoodIDForEditor) {
            tablee.selectedItem = [NSMutableArray arrayWithObject:[NSNumber numberWithInt:selectIndex]];
        }
        
        tablee.multiColListDelegate = self;
        self.sortPicker = [WSPopupView showPopupView:tablee  mask:CGRectMake(0, 64, 320, 568-64) type:WS_PopS_Down];
    } else {
        if (self.sortId == GoodIDForEditor) {
            [self.sortListView delSelected];
        } else {
            NSInteger selectIndex = NOT_DEFINED;
            for (int k = 0 ; k < self.sorts.count; k++) {
                if ([((XWGGoodSort*)self.sorts[k]).id intValue] == self.sortId) {
                    selectIndex = k;
                    break;
                }
            }
            if (selectIndex!= NOT_DEFINED) {
                self.sortListView.selectedItem = [NSMutableArray arrayWithObject:[NSNumber numberWithInt:selectIndex]];
            }
            [self.sortListView reloadData];
        }
        [self.sortPicker show];
    }
}

-(void)hideTopBtnToolbar:(float)offset
{
    float height = self.topToolBar.frame.size.height;
    
    if (self.tableView.contentSize.height > (self.tableView.frame.size.height + height)) {
        self.topToolBarHieded = YES;
        
        if (!self.downDragView) {
            float y = 0;
            if (IOS_VERSION >= 7.0) {
                y = APP_STATUSBAR_HEIGHT;
            }
            self.downDragView = [[UIButton alloc] initWithFrame:CGRectMake(0, y, APP_SCREEN_WIDTH, DragDownArrowBtnHeight)];
            [self.downDragView setImage:[UIImage imageNamed:DragDownArrowBtnBg] forState:UIControlStateNormal];
            [self.downDragView setBackgroundColor:colorWithUtfStr(DragDownAViewBgColor)];
            [self.downDragView addTarget:self action:@selector(showTopBtnToolbar) forControlEvents:UIControlEventTouchDown];
            
            [self.view addSubview:self.downDragView];
        } else {
            self.downDragView.hidden  = FALSE;
        }
        
        height -=DragDownArrowBtnHeight;
        CGRect rect = self.wsScrollContentV.frame;
        rect.origin.y -= height;
        rect.size.height += height;
        self.wsScrollContentV.frame = rect;
        
        rect = self.topToolBar.frame;
        rect.size.height = 0;
        
        CGRect rect1 = self.downDragView.frame;
        rect1.size.height = 0;
        self.downDragView.frame = rect1;
        rect1.size.height =  DragDownArrowBtnHeight;
#if 1
        [UIView animateWithDuration:CMM_AnimatePerior animations:^{
            self.topToolBar.frame = rect;
            self.downDragView.frame = rect1;
        } completion:^(BOOL finished) {
                self.topToolBar.hidden = YES;
        }];
#else
        CGAffineTransform transform1 = CGAffineTransformMakeScale(1, 0.00);
        CGAffineTransform transform2 = CGAffineTransformMakeTranslation(0, -self.downDragView.frame.size.height/2);
        CGAffineTransform transform = CGAffineTransformConcat(transform1, transform2);
        self.downDragView.transform = transform;
        
        [UIView animateWithDuration:0.26f animations:^{
            self.topToolBar.frame = rect;
            self.downDragView.transform =  CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            //   self.topTabView.hidden = YES;
        }];
#endif
    }
}
-(void)showTopBtnToolbar
{
    self.topToolBarHieded = FALSE;
    self.topToolBarShowing = TRUE;
    self.topToolBar.hidden = FALSE;
    self.downDragView.hidden = YES;
    
    STOP = TRUE;
    
    CGRect rect = self.wsScrollContentV.frame;
    float height = APP_NAVBAR_HEIGHT + self.recommandBtn.frame.size.height - self.downDragView.frame.size.height;
    rect.origin.y += height;
    rect.size.height -= height;
    //   self.contentTable.contentOffset = CGPointMake(0, offset + 40);
    
    CGRect rect1 = self.topToolBar.frame;
    rect1.size.height = APP_NAVBAR_HEIGHT + self.recommandBtn.frame.size.height;
    
    CGRect rect2 = self.downDragView.frame;
    rect2.size = CGSizeMake(rect2.size.width, 1);
    
#if 1
    [UIView animateWithDuration:CMM_AnimatePerior animations:^{
        self.topToolBar.frame = rect1;
        self.wsScrollContentV.frame = rect;
      //  self.downDragView.frame = rect2;
    } completion:^(BOOL finished) {
         //   self.downDragView.hidden = YES;
            self.topToolBarShowing = FALSE;
    }];
#else
    CGAffineTransform transform1 = CGAffineTransformMakeScale(1, 0.00);
    CGAffineTransform transform2 = CGAffineTransformMakeTranslation(0, -self.downDragView.frame.size.height/2);
    CGAffineTransform transform = CGAffineTransformConcat(transform1, transform2);
    
    
    [UIView animateWithDuration:0.26f animations:^{
        self.topToolBar.frame = rect1;
        self.downDragView.transform = transform;
        self.wsScrollContentV.frame = rect;
        // [self.contentTable setContentOffset:p];
        
    } completion:^(BOOL finished) {
        if (finished) {
            self.downDragView.hidden = YES;
            self.topToolBarShowing = FALSE;
        }
        //   self.topTabView.hidden = YES;
    }];
#endif
}

#pragma mark -
#pragma mark network adapter -


-(void)getXWGList:(int)pageIndex num:(int)_pageNum succ:(NillBlock_Array)succBack fail:(NillBlock_Error)failBack
{
    
    WSNetServicesReault *result =  [GKXWGService getXWGList:self.sortId order:self.orderStr page:pageIndex num:_pageNum succ:^(NSObject *obj, BOOL result) {
        self.status = VIEW_PROCESS_NORMAL;
        hadNextPage = result;
        xwgRequetUrl = Nil;
        NSArray *array = (NSArray*)obj;
        SAFE_BLOCK_CALL(succBack, array);
    } fail:^(NSError *err) {
        self.status = VIEW_PROCESS_FAIL;
        xwgRequetUrl = Nil;
        SAFE_BLOCK_CALL(failBack, err);
    }];
    
    xwgRequetUrl = result.url;
}

-(void)getXWGSorts
{
    if (!(subStatus & ST_GetSorts)) {
        subStatus |= ST_GetSorts;
        
        NillBlock_Array block = ^(NSArray *array) {
            subStatus &= ~ST_GetSorts;
            [self.sorts addObjectsFromArray:array];
        };
        
        NSArray *array =  [GKXWGService getXWGGoodSorts:block fail:^(NSError *err) {
            subStatus &= ~ST_GetSorts;
        }];
        
        if (IsSafeArray(array)) {
            block(array);
        }
    }

}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

-(void)refresh
{
    [self getXWGList:1 num:pageNum succ:^(NSArray *array) {
        pageNo = 1;
        
        for (XWGListCell *cell in self.tableView.visibleCells) {
            [cell removeCellObserverForKeyPath:@"user_favorites"];
        }
        
        itemArray = [NSMutableArray arrayWithArray:array];
        [self.tableView reloadData];
        [self.wsScrollContentV finishRefresh];
        if (hadNextPage) {
            [self.wsScrollContentV showFooterView];
        } else {
            [self.wsScrollContentV hideFooterView];
        }
        [self.wsScrollContentV scrollToYop];
    } fail:^(NSError *err) {
        [self.wsScrollContentV stopRefresh];
    }];
}

-(void)loadMore
{
    [self getXWGList:pageNo+1 num:pageNum succ:^(NSArray *array) {
        pageNo++;
        [itemArray addObjectsFromArray:array];
        [self.tableView reloadData];
        [self.wsScrollContentV finishLoadMore];
        if (!hadNextPage) {
            [self.wsScrollContentV hideFooterView];
            NSLog(@"hideFooterView");
        }
    } fail:^(NSError *err) {
        [self.wsScrollContentV stopLoadMore];
    }];
}

-(UIView*)contentView
{
    self.tableView = [[TMQuiltView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, self.wsScrollContentV.frame.size.height)];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.tableView.tmDelegate = self;
    self.tableView.dataSource = self;
    return self.tableView;
}

#pragma mark -
#pragma mark table delegate & datasource -
- (NSInteger)quiltViewNumberOfCells:(TMQuiltView *)TMQuiltView
{
    if (itemArray) {
        return  itemArray.count;
    }
    
    return 0;
}

- (TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString *cellIdentifierPrefix = @"XWGListCell";
    NSString *cellIdentifier = [NSString stringWithFormat:@"%@%03d%03d",cellIdentifierPrefix,indexPath.section,indexPath.row];
    
    
    XWGListCell *cell = (XWGListCell *)[quiltView dequeueReusableCellWithReuseIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XWGListCell" owner:self options:nil] objectAtIndex:0];
        [cell configReuseIdentifier:cellIdentifier];
    }
    
    GoodsInfo *good = [itemArray objectAtIndex:indexPath.row];
    if (good) {
        cell.priceLabel.text =    IsSafeString(good.price)?[NSString stringWithFormat:@"RMB %d",(int)[good.price  floatValue]]:@"";
        cell.loveLabel.text = [NSString stringWithFormat:@"%d",good.user_favorites];
        
        [cell removeCellObserverForKeyPath:@"user_favorites"];
        
        __block XWGListCell *weakCell = cell;
        [cell addObserver:good forKeyPath:@"user_favorites" handler:^(id obj){
            weakCell.loveLabel.text = [NSString stringWithFormat:@"%d",((GoodsInfo*)obj).user_favorites];
        }];

        if (IsSafeString(good.smal_image_url)) {
            [cell.goodImageV showUrl:[NSURL URLWithString:good.smal_image_url] activity:YES];
        } else {
            [cell.goodImageV setDefaultImg:[UIImage imageNamed: LIST_DEFAULT_IMG]];
        }
    }
    
    
    if (quiltView.contentOffset.y > quiltView.frame.size.height * 1.5 ) {
        self.topBtn.hidden = FALSE;
    } else {
        self.topBtn.hidden = YES;
    }
    return cell;
    
}

- (void)quiltView:(TMQuiltView *)quiltView didSelectCellAtIndexPath:(NSIndexPath *)indexPath
{
    int index = indexPath.row;
    GoodsInfo *goods = [itemArray objectAtIndex:index];
    if (goods) {
        XWGGoodDetailCtrller *vc = [[XWGGoodDetailCtrller alloc] initWithGood:goods];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (NSInteger)quiltViewNumberOfColumns:(TMQuiltView *)quiltView
{
    return 3;
}

- (CGFloat)quiltViewMargin:(TMQuiltView *)quilView marginType:(TMQuiltViewMarginType)marginType
{

    return 5;
}

- (CGFloat)quiltView:(TMQuiltView *)quiltView heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    
    float ret = 108;
    
    GoodsInfo *good = [itemArray objectAtIndex:indexPath.row];
    
    if (good) {
        NSString *imgUrl = good.smal_image_url;
        
        if (IsSafeString(imgUrl)) {
            NSRange range =  [imgUrl rangeOfString:@"/public" options:NSBackwardsSearch];
            if (range.location != NSNotFound) {
                int l0 = range.location - range.length;
                
                range.length = l0;
                range.location = 0;
                
                range = [imgUrl rangeOfString:@"styles/" options:NSBackwardsSearch range:range];
                if (range.location != NSNotFound) {
                    int l1 = range.location;
                    
                    range.location = l1 + range.length;
                    range.length = l0 - l1;
                    
                    NSString *sizeStr = [imgUrl substringWithRange:range];
                    
                    NSArray *sizeA =     [sizeStr.uppercaseString componentsSeparatedByString:@"X"];
                    
                    if ([sizeA count] > 0) {
                        int width = [(NSString*)[sizeA objectAtIndex:0] intValue];
                        int height = [(NSString*)[sizeA objectAtIndex:1] intValue];
                        
                        float rate = width / 100.0f;
                        float dHeight = height / rate;
                        
                        if (dHeight <= 100) {
                            ret = 108;
                        } else if(dHeight >= 150){
                            ret = 158;
                        } else {
                            ret = 143;
                        }
                    }
                }
            }
        }
    }
    
    return ret + 30;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    //Simple velocity calculation
    static double prevCallTime = 0;
    static double prevCallOffset = 0;
    

    double curCallTime = CACurrentMediaTime();
    
    double timeDelta = curCallTime - prevCallTime;
    
    double curCallOffset = scrollView.contentOffset.y;
    
    double offsetDelta = curCallOffset - prevCallOffset;
    
    double velocity = (offsetDelta / timeDelta);
    
    prevCallTime = curCallTime;
    
    prevCallOffset = curCallOffset;
    
    if (velocity > 1000 ) {
        if(!self.topToolBarShowing){
            float offset = scrollView.contentOffset.y;
            
            if (offset > self.topToolBar.frame.size.height && !self.topToolBarHieded)
            {
                [self hideTopBtnToolbar:offset];
            }
        }
    }
    if (STOP) {
        [scrollView setContentOffset:scrollView.contentOffset animated:NO];
        STOP = FALSE;
    }
}


@end


