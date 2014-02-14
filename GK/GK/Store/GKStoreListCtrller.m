//
//  GKCanYinController.m
//  GK
//
//  Created by apple on 13-4-11.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GKStoreListCtrller.h"
#import "GKStoreTableCell.h"
#import "GKStoreInfomationController.h"
#import "GlobalObject.h"
#import "GKSearchResultCtroller.h"
#import "NIDropDown.h"
#import "NSObject+GKExpand.h"

#define SUB_STATUS_NONE 0x00
#define SUB_STATUS_GET_REGION 0x01
#define STATUS_GET_SORTS 0x02

#define LBS_STATUS_BAR_HEIGHT 30
#define LBS_STATUS_BTN_WIDTH 26
#define WSMultiColListMaxHeight 240

#define GPS_UNABLED_MSG @"请开启地理信息服务获取更准确的信息"
#define GPS_LOAD_MSG @"正在获取位置信息"
#define GPS_NOT_STARTUP @"请先开启地理信息服务"
#define GPS_GET_FAIL @"获取地理信息失败"

#define TotalAreaStr @"全部商圈"
#define TitleForNeighbour @"附近商家"
#define TitleForOwnerFocus @"我的关注"
#define DefaultStoreTitleForNeighbour @"所有商家"
#define DefaultStoreTitleForStoreList @"所有类型"

#define DistanceDefaultIndex 1




@interface GKStoreListCtrller ()<WSScrollContentViewDelegate>
{
    int areaTag,aliginTag,sortTag,distanceTag;
    BOOL STOPScrolling ;
    
    NSString *titleString;
    
    
    BOOL upsideViewValidated;
    BOOL LBSBarValidated;
    
    NSString *storeListRequetUrl;
}

@property (strong,nonatomic) NSString *searchKey;

@property (nonatomic,assign) BOOL isOwnerFocused;
@property (nonatomic,assign) BOOL hadDeletedFocuse;

@property (nonatomic,assign) BOOL upsideHidenabledViewHided;
@property (nonatomic,assign) BOOL upsideHidenabledViewShowing;

@property (nonatomic,strong) WSPopupView *storeTopSortPicker;
@property (nonatomic,strong) WSPopupView *areaPicker,*alignPicker,*sortPicker,*distancePicker;
@property (nonatomic,strong) UIButton *downDragView;

@property (strong,nonatomic) UIBarButtonItem *refreshBarItem;
@property (strong,nonatomic) UIActivityIndicatorView *refreshAniView;
@property (strong,nonatomic) UIButton *refreshBtn;

@property (strong,nonatomic) UILabel *gpsStatusLabel;
@property (nonatomic,strong) UIView *lbsToolBarView;
@property (nonatomic,strong) UIButton *focusBtn;

//附近
@property (nonatomic,assign) int distanceScope;
@property (nonatomic,strong) NSMutableArray *distanceStrs;

@property (nonatomic,strong) NSArray *alignStrs;
@property (nonatomic,strong) NSString *alignStr;

@property (nonatomic,strong) NSArray *storeSortArray;
@property (nonatomic,strong) NSArray *sorts;
@property (nonatomic,assign) BOOL needInitSortName;


@property (strong,nonatomic) NSArray *regionArray;
@property (strong,nonatomic) NSString *regionId;

@property (strong,nonatomic) NSString    *cityId;
@property (strong,nonatomic) BMKAddrInfo *curAddress;

@property (strong,nonatomic) NSMutableArray *storeArray;
@property (strong,nonatomic) NSArray *moreArray;
@property (assign,nonatomic) NSInteger sortId;
@property (assign,nonatomic) NSInteger topSortId;
@property(assign,nonatomic) BOOL isGetDistance;

@property(assign,nonatomic) NSInteger subStatus;

@end

@implementation GKStoreListCtrller
@synthesize sorts = _sorts;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil style:VIEW_WITH_NAVBAR];
    if (self) {
    }
    return self;
}

-(id)initForNeighbour
{
    self = [self initWithNibName:@"GKStoreListCtrller" bundle:Nil];
    if (self) {
        self.isGetDistance = TRUE;
    }
    return self;
}

-(id)initWithSearchKey:(NSString*)key
{
    self = [self initWithNibName:@"GKStoreListCtrller" bundle:Nil];
    
    if (self) {
        self.searchKey = key;
    }
    
    return self;
}

-(id)initForOwnerFocus
{
    self = [self initWithNibName:@"GKStoreListCtrller" bundle:Nil];
    
    if (self) {
        self.isOwnerFocused = true;
    }
    
    return self;
}

-(id)initForSort:(StoreSort*)sort
{
    self  = [self initWithNibName:@"GKStoreListCtrller" bundle:Nil];
    if (self) {
        self.sortId = [sort.id intValue];
        self.topSortId = [(sort.parent_cid ? sort.parent_cid : sort.id)  intValue];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self initOwnParams];
    [self initAppearance];
    [self initUpsideHidenabledView];
    [self initTopTabBtn];
    [self initOwnContentTable];
    
    if (upsideViewValidated) [self getSorts];
    
    if (LBSBarValidated){
        [self showGPSStatusBar];
        [self refreshLocation];
    } else if(self.isOwnerFocused){
        [self.scrollContentV trigRefresh];
    } else {
        [self getCityId];
    }
    
    AddNotification(Notification_StoreFocus,@selector(focused:));
    AddNotification(Notification_StoreUnFocus,@selector(focused:));
}

-(void)viewWillLayoutSubviews
{
    self.scrollContentV.autoresizingMask = UIViewAutoresizingNone;
//    if (IOS_VERSION < 7.0 && isInitView) {
//        CGSize size = self.contentTable.frame.size;
//        size.height += APP_STATUSBAR_HEIGHT;
//        [self.contentTable strechTo:size];
//        isInitView = FALSE;
//    }
}

#pragma mark -
#pragma mark event handler - 
-(void)refreshClick
{
    if (!([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus]!= kCLAuthorizationStatusDenied) ))
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil
                                                        message:@"您需要先开启定位服务"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
        [alert show];
    } else {
        [self refreshLocation];
    }
}

- (IBAction)topTabBtnClicked:(id)sender {
    
    UIButtonWithStoreList *btn = (UIButtonWithStoreList*)sender;
    btn.tabSsSelected = !btn.tabSsSelected;

    self.focusBtn = btn;

    if (btn.tabSsSelected) {
        if (btn.tag == areaTag) {
            [self showAreaPicker];
        } else if(btn.tag == aliginTag){
            [self showAliginPicker];
        } else if(btn.tag == distanceTag) {
            [self showDistancePicker];
        } else if (btn.tag == sortTag) {
            if (IsSafeArray(self.storeSortArray)) {
                [self showStoreSortPicker];
            }
        }
    }
}




#pragma mark -
#pragma mark inside normal function -
-(void)showGPSStatusBar
{
    CGPoint p = CGPointMake(0, APP_SCREEN_HEIGHT - LBS_STATUS_BAR_HEIGHT -  APP_TABBAR_HEIGHT);
    if (IOS_VERSION < 7.0) {
        p.y -= APP_STATUSBAR_HEIGHT;
    }
    p = [self.view convertPoint:p fromView:nil];
    
    CGRect rect ;
    rect.origin = p;
    rect.size = CGSizeMake(APP_SCREEN_WIDTH, LBS_STATUS_BAR_HEIGHT);
    
    UIView *toolBarView = [[UIView alloc] initWithFrame:rect];
    toolBarView.alpha = 0.8f;
    toolBarView.backgroundColor =colorWithUtfStr(ResetPWDC_BtnBGColor);
    
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,toolBarView.frame.size.width , LBS_STATUS_BAR_HEIGHT)];
    myLabel.font=[UIFont systemFontOfSize:12];
    myLabel.backgroundColor = [UIColor clearColor];
    myLabel.textAlignment= NSTextAlignmentCenter;
    myLabel.textColor = [UIColor whiteColor];
    [toolBarView addSubview:myLabel];
    self.gpsStatusLabel = myLabel;

    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshBtn setTintColor:[UIColor whiteColor]];
    [refreshBtn setImage:[UIImage imageNamed:@"refreshIcon"] forState:UIControlStateNormal];
    [refreshBtn setAdjustsImageWhenHighlighted:YES];
    refreshBtn.showsTouchWhenHighlighted = YES;
    [refreshBtn addTarget:self action:@selector(refreshClick) forControlEvents:UIControlEventTouchUpInside];
    [refreshBtn setFrame:CGRectMake(toolBarView.frame.size.width - LBS_STATUS_BAR_HEIGHT , 0, LBS_STATUS_BAR_HEIGHT, LBS_STATUS_BAR_HEIGHT)];
    [toolBarView addSubview:refreshBtn];
     [self.view addSubview:toolBarView];
    self.refreshBtn = refreshBtn;
    self.lbsToolBarView = toolBarView;
}

-(void)showGPSAni
{
    if (!self.refreshAniView) {
        self.refreshAniView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }

    [self.refreshAniView startAnimating];
    [self.refreshBarItem setCustomView:self.refreshAniView];
}

-(void)showGPSRefreshBtn
{
    if ([self.refreshBarItem.customView isKindOfClass:[UIActivityIndicatorView class]]) {
        [self.refreshAniView stopAnimating];
        [self.refreshBarItem setCustomView:self.refreshBtn];
    }
}

-(void)updateStoreListWithDistance
{
    NSArray *destArray = self.storeArray;
    int orgLength  = 0;
    
    if (self.status == VIEW_PROCESS_LOADMORE) {
        orgLength  = [self.storeArray indexOfObject:[self.moreArray objectAtIndex:0]];
        destArray = self.moreArray;
    }
//    for (StoreInfo *store in destArray) {
//        double longitude = self.curAddress.geoPt.longitude;
//        double latitude = self.curAddress.geoPt.latitude;
//        
//        store.distance = distanceBetween(store.latitude, store.longitude, latitude, longitude) ;
//    }
    
    NSComparator cmptr = ^(StoreInfo *obj1, StoreInfo *obj2){
        if ([obj1 distance] > [obj2 distance]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 distance] < [obj2 distance]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };

    NSMutableArray *newArray = [NSMutableArray arrayWithArray:[destArray  sortedArrayUsingComparator:cmptr] ];
    
    if (destArray != self.storeArray) {
        [self.storeArray replaceObjectsInRange:NSMakeRange(orgLength,self.storeArray.count - orgLength) withObjectsFromArray:newArray];
    } else {
        self.storeArray = newArray;
    }
}









-(void)showStoreTopSortPicker
{
    if (!self.storeTopSortPicker) {
        WSMultiColList *tablee = [[WSMultiColList alloc] initWithFrame:CGRectMake(0, 64, 320, 200)];
        tablee.numOfColPerRow = 3;
        tablee.type = WSMultiCol_ImageStr;
        tablee.footColor = colorWithUtfStr(SortListC_NavPopViewFootColor);
        tablee.multiColListDelegate = self;
        tablee.ownContentInset = UIEdgeInsetsMake(18, 0, 18, 0);
        tablee.cellGap = 0 ;
        tablee.cellTitltColor = colorWithUtfStr(SortListC_NavPopViewTitleColor);
        tablee.selectedColor = nil;
        NSMutableArray *array = [NSMutableArray array];
        for (int k = 0 ; k < StoreTopSortNum; k++) {
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, HomePageC_MenuItemWidth, HomePageC_MenuItemHeight)];
            [imageV setImage:[UIImage imageNamed:[NSString stringWithUTF8String:StoreSortIcon[k]]]];
            WSMultiColCell *cell = [WSMultiColCell initWithTitle:[NSString stringWithUTF8String:STORE_SORT[k]] imageView:imageV];
            [array addObject:cell];
        }
        tablee.itemSource =array;
        
        self.storeTopSortPicker = [WSPopupView showPopupView:tablee  mask:CGRectMake(0, APP_NAVBAR_HEIGHT + APP_STATUSBAR_HEIGHT, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - APP_NAVBAR_HEIGHT) type:WS_PopS_Down];
    } else {
        [self.storeTopSortPicker show];
    }

}

-(void)showAreaPicker
{
    if (self.areaPicker) {
        [self.areaPicker show];
        return;
    }
    
    NillBlock_Nill showPickerBlock = ^{
        if (!IsSafeArray(self.regionArray)) {
            return ;
        }

        UIButton *areaBtn = (UIButton*)[self.upsideHidenabledView viewWithTag:areaTag];
        CGPoint p = CGPointMake(areaBtn.frame.origin.x , areaBtn.frame.origin.y + areaBtn.frame.size.height);
        p = [areaBtn.superview convertPoint:p toView:Nil]; //APP_DELEGATE.window];
        CGRect rect = CGRectZero;
        rect.origin = p;
        rect.origin.y += 1;
        rect.size.width = areaBtn.frame.size.width;
        
        WSMultiLevelList *areaList = [self multiLevelList:nil rect:rect];
        rect.size.width =self.view.frame.size.width;
        rect.size.height = APP_SCREEN_HEIGHT - p.y;
        
        self.areaPicker = [WSPopupView showPopupView:areaList mask:rect type:WS_PopS_Down];
        self.areaPicker.delegate = self;
        [areaList selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    };
    
    if(!self.isGetDistance)
    {
        if (!self.regionArray) {
            [self getCityArea:^(void){
                showPickerBlock();
            }];
        } else {
            showPickerBlock();
        }
    }
}

-(void)showAliginPicker
{
    if (self.alignPicker) {
        [self.alignPicker show];
        return;
    }
    
    UIButton *alignBtn = (UIButton*)[self.upsideHidenabledView viewWithTag:aliginTag];
    CGPoint p = CGPointMake(alignBtn.frame.origin.x , alignBtn.frame.origin.y + alignBtn.frame.size.height);
    p = [alignBtn.superview convertPoint:p toView:APP_DELEGATE.window];
    CGRect rect = CGRectZero;
    rect.origin = p;
    rect.size.width = alignBtn.frame.size.width;
    rect.origin.y += 1;

    
    WSMultiLevelList *areaList = [self multiLevelList:nil rect:rect];
    rect.origin.x = 0;
    rect.size.width =self.view.frame.size.width;
    rect.size.height = APP_SCREEN_HEIGHT - p.y;

    self.alignPicker = [WSPopupView showPopupView:areaList mask:rect type:WS_PopS_Down];
    self.alignPicker.delegate = self;
    [areaList selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

-(void)showDistancePicker
{
    if (self.distancePicker) {
        [self.distancePicker show];
        return;
    }
    
    UIButton *alignBtn = (UIButton*)[self.upsideHidenabledView viewWithTag:distanceTag];
    CGPoint p = CGPointMake(alignBtn.frame.origin.x , alignBtn.frame.origin.y + alignBtn.frame.size.height);
    p = [alignBtn.superview convertPoint:p toView:APP_DELEGATE.window];
    CGRect rect = CGRectZero;
    rect.origin = p;
    rect.size.width = alignBtn.frame.size.width;
    rect.origin.y += 1;
    
    WSMultiLevelList *areaList = [self multiLevelList:nil rect:rect];
    rect.origin.x = 0;
    rect.size.width =self.view.frame.size.width;
    rect.size.height = APP_SCREEN_HEIGHT - p.y;
    
    self.distancePicker = [WSPopupView showPopupView:areaList mask:rect type:WS_PopS_Down];
    self.distancePicker.delegate = self;
    [areaList selectRowAtIndexPath:[NSIndexPath indexPathForRow:DistanceDefaultIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

-(void)showStoreSortPicker
{
    if (self.sortPicker) {
        [self.sortPicker show];
        return;
    }
    
    if (!IsSafeArray(self.sorts)) {
        return;
    }
    
    UIButton *alignBtn = (UIButton*)[self.upsideHidenabledView viewWithTag:sortTag];
    CGPoint p = CGPointMake(alignBtn.frame.origin.x , alignBtn.frame.origin.y + alignBtn.frame.size.height);
    p = [alignBtn.superview convertPoint:p toView:APP_DELEGATE.window];
    CGRect crect  = CGRectZero;
    crect.origin = p;
    crect.origin.y +=1;
    crect.size.height = (APP_SCREEN_HEIGHT - p.y  - APP_TABBAR_HEIGHT ) > WSMultiColListMaxHeight ? WSMultiColListMaxHeight : (APP_SCREEN_HEIGHT - p.y  - APP_TABBAR_HEIGHT );
    crect.size.width = APP_SCREEN_WIDTH - p.x;
    UIView *v = [[UIView alloc] initWithFrame:crect];
    
    
    crect.origin = CGPointMake(0, 0);
    crect.size.width = alignBtn.frame.size.width;
    WSMultiLevelList *areaList = [self multiLevelList:nil rect:crect];
    areaList.tag = sortTag;
    v.clipsToBounds = YES;
    [v addSubview:areaList];

    NSInteger index = 0;
    if (self.sortId != self.topSortId) {
        NSArray *array = [self getChildSorts:self.topSortId];
        for (StoreSort *sort in array) {
            index++;
            if ([sort.id intValue] == self.sortId) {
                break;
            }
        }
    }
 
    crect.origin.x = 0;
    crect.origin.y = p.y+1;
    crect.size.width = self.view.frame.size.width;
    crect.size.height = APP_SCREEN_HEIGHT - p.y ;
    
    self.sortPicker = [WSPopupView showPopupView:v mask:crect type:WS_PopS_Down];
    self.sortPicker.delegate = self;
    [areaList selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    [areaList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

-(WSMultiLevelList*)multiLevelList:(NSArray*)items rect:(CGRect)rect
{
    WSMultiLevelList *tableView = [[WSMultiLevelList alloc] initWithFrame:rect];

    tableView.multiLevelDataSource = items;
    tableView.selectedColor = colorWithUtfStr(SortListC_TopTabPopViewCellSelectedBg);
    tableView.cellColor = colorWithUtfStr(SortListC_TopTabPopViewCellBg);
    tableView.titleColor = colorWithUtfStr(SortListC_TopTabPopViewTitleColor);
    tableView.tag = self.focusBtn.tag;
    tableView.multiTableDelegate = self;
    tableView.maxHeight =  WSMultiColListMaxHeight;//appScreenHeight - APP_TABBAR_HEIGHT - rect.origin.y;
    return tableView;
}

-(void)refreshTableForTopTabChanged
{
    self.storeArray = nil;
    self.moreArray = nil;
    [self.scrollContentV hideFooterView];
    [self.contentView reloadData];
    if (storeListRequetUrl) {
        [GKStoreSortListService cancelRequest:storeListRequetUrl];
        storeListRequetUrl = nil;
    }
    [self.scrollContentV trigRefresh];
}


-(void)showUpsideHidenabledView
{
    self.upsideHidenabledViewHided = FALSE;
    self.upsideHidenabledViewShowing = TRUE;
    self.upsideHidenabledView.hidden = FALSE;
    self.downDragView.hidden = YES;
    STOPScrolling = TRUE;

    CGRect rect = self.scrollContentV.frame;
    float height = APP_NAVBAR_HEIGHT + self.topBtn0.frame.size.height - self.downDragView.frame.size.height;
    rect.origin.y += height;
    rect.size.height -= height;
    
    CGRect rect1 = self.upsideHidenabledView.frame;
    rect1.size.height = APP_NAVBAR_HEIGHT + self.topBtn0.frame.size.height;
    
    [UIView animateWithDuration:CMM_AnimatePerior animations:^{
        self.upsideHidenabledView.frame = rect1;
        self.scrollContentV.frame = rect;
    } completion:^(BOOL finished) {
        self.upsideHidenabledViewShowing = FALSE;
    }];
}

-(void)hideUpsideHidenabledView:(float)offset
{
    float height = self.upsideHidenabledView.frame.size.height;
    
    if (self.contentView.contentSize.height > (self.contentView.frame.size.height + height)) {
        self.upsideHidenabledViewHided = YES;
        
        if (!self.downDragView) {
            float y = 0;
            if (IOS_VERSION >= 7.0) {
                y = APP_STATUSBAR_HEIGHT;
            }
            
            self.downDragView = [[UIButton alloc] initWithFrame:CGRectMake(0, y, APP_SCREEN_WIDTH, DragDownArrowBtnHeight)];
            [self.downDragView setImage:[UIImage imageNamed:DragDownArrowBtnBg] forState:UIControlStateNormal];
            [self.downDragView setBackgroundColor:colorWithUtfStr(DragDownAViewBgColor)];
            [self.downDragView addTarget:self action:@selector(showUpsideHidenabledView) forControlEvents:UIControlEventTouchDown];
            self.downDragView.clipsToBounds = YES;
            [self.view addSubview:self.downDragView];
        } else {
            self.downDragView.hidden  = FALSE;
        }
        
        height -=DragDownArrowBtnHeight;

        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;

        CGRect rect = self.scrollContentV.frame;
        rect.origin.y -= height;
        rect.size.height += height;
        self.scrollContentV.frame = rect;
        //self.contentTable.contentOffset = CGPointMake(0, offset - height + 18);
        
        rect = self.upsideHidenabledView.frame;
        rect.size.height = 0;
        
        CGRect rect1 = self.downDragView.frame;
        rect1.size.height = 0;
        self.downDragView.frame = rect1;
        rect1.size.height =  DragDownArrowBtnHeight;
        [UIView animateWithDuration:CMM_AnimatePerior animations:^{
            self.upsideHidenabledView.frame = rect;
            self.downDragView.frame = rect1;
        } completion:^(BOOL finished) {
                self.upsideHidenabledView.hidden = YES;
        }];

    }
}
-(StoreSort*)getParentSort:(WSMultiLevelList*)table
{
    WSMultiLevelList *top =  [table topList];
    NSArray *array = self.sorts;
    while (top != table.parentList && top.nextList) {
        array = ((StoreSort*)array[top.selectRow-1]).children;
        top =  top.nextList;
    }
    return table == top ? nil : (StoreSort*)array[top.selectRow-1];;
}
-(StoreSort*)getSelectedSort:(WSMultiLevelList*)table
{
    WSMultiLevelList *top =  [table topList];
    NSArray *array = self.sorts;
    StoreSort *sort = Nil;
    while (top != table && top.nextList) {
        array = ((StoreSort*)array[top.selectRow-1]).children;
        sort = (StoreSort*)array[top.selectRow-1];
        top =  top.nextList;
    }
    return sort;
}

-(NSArray*)getCurChildSort:(WSMultiLevelList*)table
{
    WSMultiLevelList *top =  [table topList];
    NSArray *array = self.sorts;
    
    while (top != table && top.nextList) {
        array = ((StoreSort*)array[top.selectRow-1]).children;
        top =  top.nextList;
    }
    return array;
}

-(NSArray*)getChildSorts:(NSInteger)pSortId
{
    for (StoreSort *sort in self.sorts) {
        if ([sort.id intValue]  == pSortId) {
            return sort.children;
        }
    }
    return nil;
}

-(NSString*)getSortName:(NSString*)sortId
{
    NSArray *array = [self getChildSorts:self.topSortId];
    for (StoreSort *sort  in array) {
        if ([sortId isEqualToString: sort.id]) {
            return sort.name;
        }
    }
    return nil;
}

#pragma mark -
#pragma mark network adapter -
-(void)getStoreList:(NillBlock_Array)succBlock fail:(NillBlock_Error)failBlock
{
    int tpageIndex = self.status != VIEW_PROCESS_LOADMORE ? 1:(pageIndex + 1);
    int tapgeNum = pageNum;
    
    if (self.isOwnerFocused && self.status == VIEW_PROCESS_LOADMORE) {
        if (self.hadDeletedFocuse) {
            tapgeNum = tpageIndex * pageNum;
            tpageIndex = 1;
        }
    }
    
    NillBlock_OBJ_BOOL inSideSuccBack = ^(NSObject *obj,BOOL next){
        NSArray *array = (NSArray*)obj;
        if (self.status == VIEW_PROCESS_LOADMORE) {
            [self.storeArray addObjectsFromArray:array];
            self.moreArray = array;
            pageIndex = tpageIndex;
        } else {
            self.storeArray = [NSMutableArray arrayWithArray:array];
            pageIndex = 1;
        }
        storeListRequetUrl = nil;
        maybeNextPage = next;
        self.hadDeletedFocuse = FALSE;
        
        SAFE_BLOCK_CALL(succBlock, array);
        

        
        if (self.status == VIEW_PROCESS_REFRESH) {
            [self.scrollContentV finishRefresh];
            [self.scrollContentV scrollToYop];
        } else {
            [self.scrollContentV finishLoadMore];
        }
        
        if (maybeNextPage) {
            [self.scrollContentV showFooterView];
            //            [self.contentTable loadMoreCompleted];
        } else {
            [self.scrollContentV hideFooterView];
        }
        
        self.status = VIEW_PROCESS_NORMAL;
        [self hideWaitting];
    };
    
    NillBlock_Error insideFailBack = ^(NSError *err){
        if (self.viewIsAppear){//(!self.isInitDataWithGetDistance) {
            [self showTopPop:err.localizedDescription];
        }
        storeListRequetUrl = nil;
        SAFE_BLOCK_CALL(failBlock, err);
        if (self.status == VIEW_PROCESS_LOADMORE)
            [self.scrollContentV stopLoadMore];
        else
            [self.scrollContentV stopRefresh];
//        if (self.status == VIEW_PROCESS_LOADMORE) {
//            if (maybeNextPage) {
//                [self.scrollContentV setFooterViewVisibility:TRUE];
//                [self.contentTable loadMoreCompleted];
//            } else {
//                [self.contentTable setFooterViewVisibility:FALSE];
//            }
//        } else  if(self.status == VIEW_PROCESS_REFRESH){
//            [self.contentTable stopAnimate];
//        }
        
        self.status = VIEW_PROCESS_FAIL;
        [self hideWaitting];
    };
    
    if (self.searchKey) {
        [GKStoreSortListService searchStore:self.searchKey city:self.cityId index:tpageIndex num:tapgeNum success:inSideSuccBack fail:insideFailBack];
    } else if (self.isOwnerFocused) {
        [GKOwnerService getFocusStoreList:tpageIndex num:tapgeNum success:inSideSuccBack fail:insideFailBack];
    } else {
        CLLocationCoordinate2D geopt = self.curAddress?self.curAddress.geoPt:kCLLocationCoordinate2DInvalid;
        NSString *cityId = self.isGetDistance ?@"0" :self.cityId;
        
        WSNetServicesReault *result = [GKStoreSortListService getStoreList:self.sortId city:cityId region:self.regionId loc:geopt sortWith:self.alignStr distance:self.distanceScope index:tpageIndex num:tapgeNum success:inSideSuccBack fail:insideFailBack];
        
        storeListRequetUrl = result.url;
    }
}


-(void)getFuJinList
{
    [self getStoreList:^(NSArray *array){
        if (self.curAddress && CLLocationCoordinate2DIsValid(self.curAddress.geoPt)){
            for (StoreInfo *store in array) {
                double longitude = self.curAddress.geoPt.longitude;
                double latitude = self.curAddress.geoPt.latitude;
                
                store.distance = distanceBetween(store.latitude, store.longitude, latitude, longitude) ;
            }
        }
        
        if ([self.alignStr isEqualToString:[NSString stringWithUTF8String:NearStoreList_Option[0]]]  && array.count > 0) {
            if (self.curAddress && CLLocationCoordinate2DIsValid(self.curAddress.geoPt)) {
                [self updateStoreListWithDistance];
            }
        }
        
        [self resetTable];
//        if (self.status == VIEW_PROCESS_REFRESH || self.isInitDataWithGetDistance ||  self.status == VIEW_PROCESS_GETTING) {
//            [self.scrollContentV stopAnimate];
//            [self.contentTable setContentOffset:CGPointMake(0,0) animated:YES];
//        }
        
   //     self.isInitDataWithGetDistance = FALSE;
    //    self.scrollContentV.scrollEnabled  =TRUE;
        
    }fail:^(NSError *err){
      //  self.isInitDataWithGetDistance = FALSE;
    //    self.contentTable.scrollEnabled  =TRUE;
        //[self.scrollContentV stopAnimate];
        
    }];
}

-(void)refreshList
{
    [self getStoreList:^(NSArray *array) {
        
        // [self getStoreList:self.sortId seqencing:self.alignStr region:self.regionId loc:self.curAddress?self.curAddress.geoPt:kCLLocationCoordinate2DInvalid suc:^(NSArray *array){
    //    self.contentTable.scrollEnabled  =TRUE;
        
        [self resetTable];
//        if (self.status == VIEW_PROCESS_REFRESH || self.status == VIEW_PROCESS_GETTING) {
//            [self.contentTable stopAnimate];
//            [self.contentTable setContentOffset:CGPointMake(0,0) animated:YES];
//        }
        
        if (!self.isOwnerFocused && !self.isGetDistance &&!self.searchKey) {
            if (!self.regionArray) {
                [self getCityArea:nil];
            }
        }

        
        
    }fail:^(NSError *err){
      //  self.contentTable.scrollEnabled  =TRUE;
   //     [self.contentTable stopAnimate];
    }];
}

-(void)getCityArea:(NillBlock_Nill)sucBlock
{
    if ((self.subStatus & SUB_STATUS_GET_REGION) != SUB_STATUS_GET_REGION) {
        self.subStatus |= SUB_STATUS_GET_REGION;
        
        NillBlock_Array succBack = ^(NSArray* array){
            self.regionArray = array;
            self.subStatus &= ~SUB_STATUS_GET_REGION;
            [self hideWaitting];

            SAFE_BLOCK_CALL_VOID(sucBlock);
        };
        
        self.regionArray =  [GKStoreSortListService getRegionList:self.cityId success:^(NSArray *array){
            SAFE_BLOCK_CALL(succBack, array);
        }fail:^(NSError *err){
            self.subStatus &= ~SUB_STATUS_GET_REGION;
            [self hideWaitting];
        }];
        
        if (self.regionArray) {
            SAFE_BLOCK_CALL(succBack, self.regionArray);
        }
    } else {
        [self showWatting];
    }
}

-(void)refreshLocation
{
    if (!([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus]!= kCLAuthorizationStatusDenied) ))
    {
        self.curAddress = [GlobalObject getCurLocForExtraUser:FALSE succ:nil fail:nil];
        
        if (self.curAddress && self.curAddress.strAddr && self.curAddress.strAddr.length > 0) {
            self.gpsStatusLabel.text = [NSString stringWithFormat:@"上次登录:%@",self.curAddress.strAddr];
            
        } else {
            self.gpsStatusLabel.text = GPS_UNABLED_MSG;
        }
        
        self.status = VIEW_PROCESS_NORMAL;
        [self hideWaitting];
        
        if (storeListRequetUrl) {
            [GKStoreSortListService cancelRequest:storeListRequetUrl];
            storeListRequetUrl = nil;
        }
        [self.scrollContentV trigRefresh];
        
        return;
    }
    
    NillBlock_OBJ sucBlock = ^(NSObject *obj){
        self.curAddress = (BMKAddrInfo*)obj;
        [self showGPSRefreshBtn];
        if (self.curAddress && self.curAddress.strAddr && self.curAddress.strAddr.length >0) {
            self.gpsStatusLabel.text = [NSString stringWithFormat:@"我在%@",self.curAddress.strAddr];
        } else {
            self.gpsStatusLabel.text = GPS_GET_FAIL;
        }
        
        self.status = VIEW_PROCESS_NORMAL;
        [self hideWaitting];
        if (storeListRequetUrl) {
            [GKStoreSortListService cancelRequest:storeListRequetUrl];
            storeListRequetUrl = nil;
        }
        [self.scrollContentV trigRefresh];
    };
    
    self.curAddress = [GlobalObject getCurLocForExtraUser:TRUE succ:^(NSObject *obj){
        SAFE_BLOCK_CALL(sucBlock, obj);
    }fail:^(NSError *err){
        self.status = VIEW_PROCESS_FAIL;
        [self hideWaitting];
        
     //   self.isInitDataWithGetDistance  = FALSE;
        
        self.gpsStatusLabel.text = err.localizedDescription;
        [self showGPSRefreshBtn];
      //  self.contentTable.scrollEnabled  =TRUE;
        self.view.userInteractionEnabled = TRUE;
    }];
    
    if (self.curAddress) {
        SAFE_BLOCK_CALL(sucBlock, self.curAddress);
    } else {
        [self showGPSAni];
        self.gpsStatusLabel.text = GPS_LOAD_MSG;
    }
}


-(void)deleteFocusForStore:(NSString*)sToredId
{
    self.status = VIEW_PROCESS_GETTING;
    [NSTimer scheduledTimerWithTimeInterval:CMM_AnimatePerior target:self selector:@selector(showWatting) userInfo:nil repeats:NO];
    
    [GKStoreSortListService focusStore:sToredId isFocus:TRUE success:^(void){
        self.status = VIEW_PROCESS_NORMAL;
        [self hideWaitting];
        self.hadDeletedFocuse = TRUE;
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_StoreUnFocus object:sToredId];
    }fail:^(NSError *err){
        self.status = VIEW_PROCESS_NORMAL;
        [self hideWaitting];
        [GlobalObject showPopup:err.localizedDescription];
    }];
}

-(void)getSorts
{
    if (!IsInStatus(self.subStatus, STATUS_GET_SORTS)) {
        UpdateStatus(self.subStatus, STATUS_GET_SORTS);
        [GlobalDataService GetStoreSort:FALSE succ:^(NSArray *array) {
            RestoreStatus(self.subStatus,STATUS_GET_SORTS);
            self.sorts = array;
        } fail:^(NSError *err) {
            RestoreStatus(self.subStatus,STATUS_GET_SORTS);
        }];
    }
}

-(void)getCityId
{
    NSString *cityId = [GlobalObject getCityIdForExtraUser:^(NSObject *obj){
        self.cityId = (NSString*)obj;
    }fail:^(NSError *err){
        self.status = VIEW_PROCESS_NORMAL;
        [self hideWaitting];
        [self showTopPop:err.localizedDescription];
    }];
    
    if (cityId) {
        self.cityId = cityId;
    } else {
        self.status = VIEW_PROCESS_GETTING;
        [self showWatting:YES];
    }
}

#pragma mark -
#pragma mark table datasource & delegate  -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int ret = self.storeArray.count;
    
    if (ret > 0) {
        if (!hadClearMoreSperateLine && !tableView.tableFooterView) {
            hadClearMoreSperateLine = TRUE;
            
            UIView *view =[ [UIView alloc]init];
            view.backgroundColor = [UIColor clearColor];
            [tableView setTableFooterView:view];
        }
       // tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    } else {
        hadClearMoreSperateLine = FALSE;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return ret;
        
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *storeCellIdentifier = @"GKStoreTableCell";
    static NSString *fujinCellIdentifier = @"GKFuJinTableCell";
    
    NSString *cellIdentifier =  self.isGetDistance ? fujinCellIdentifier : storeCellIdentifier;

    GKStoreTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:storeCellIdentifier owner:self options:nil] objectAtIndex:0];
        [cell configWithReuseIdentify:cellIdentifier];
    }
    
    StoreInfo *store = (StoreInfo*)[self.storeArray objectAtIndex:indexPath.row];
    cell.storeNameLabel.text = store.name;
    cell.storeAddressLabel.text = store.address;
    
    NSMutableString *str = nil;
    if (store.discount == 0.0f) {
        str = [NSMutableString stringWithFormat:@"免费"];
    } else if(store.discount != 10.0f) {
        str = [NSMutableString stringWithFormat:@"%1.1f折",store.discount];
    }
    
    if (store.coupon_title && store.coupon_title.length > 0) {
        if (str) {
            [str appendString:[NSString stringWithFormat:@"  |  %@",store.coupon_title]];
        } else {
            str = [NSMutableString stringWithString:store.coupon_title];
        }
    }
    
    if (!str && IsSafeString(store.phone)) {
        str = [NSMutableString stringWithString:store.phone];
    }
    
    cell.rebateLabel.text = str;

    NSString *urlStr = store.image_url;
    if (urlStr && urlStr.length>0 && cell.storeIcon.hidden == FALSE) {
        [cell.storeIcon showUrl:[NSURL URLWithString:store.image_url] activity:YES palce:[UIImage imageNamed:LIST_DEFAULT_IMG]];
        [cell.storeIcon setImageContentMode:UIViewContentModeScaleToFill];

        cell.storeIcon.tag = indexPath.row;
    } else {
        [cell.storeIcon showDefaultImg:[UIImage imageNamed:LIST_DEFAULT_IMG]];
    }

    cell.loveLabel.text = [NSString stringWithFormat:@"%d",store.follow_count];
    cell.discussLabel.text = [NSString stringWithFormat:@"%d",store.comment_count];
    if (self.isGetDistance) {
        NSString *distanceTxt ;
        float distance = store.distance / 1000 ;
        if (distance >= 1.0f) {
            distanceTxt = [NSString stringWithFormat:@"%-5.1f公里",distance];
        }else{
            distanceTxt = [NSString stringWithFormat:@"%-3.0f米",store.distance];
        }
        ((GKStoreTableCell*)cell).distanceLabel.text = distanceTxt;
        
        
//        if (self.scrollContentV.scrollView.pullToLoadMoreView && indexPath.row > (self.storeArray.count - 2)) {
//            if (!self.lbsToolBarView.hidden) {
//                [self.lbsToolBarView setHidden:YES animation:YES];
//            }
//        } else if(indexPath.row <= (self.storeArray.count - 5)){
//            if (self.lbsToolBarView.hidden) {
//                [self.lbsToolBarView setHidden:FALSE animation:YES];
//            }
//        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 116;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    StoreInfo *store = [self.storeArray objectAtIndex:indexPath.row];
    GKStoreInfomationController *vc = [[GKStoreInfomationController alloc] initWithNibName:@"GKStoreInfomationController" bundle:nil withStore:store orID:nil from:nil];
//    tableView.autoresizingMask = UIViewAutoresizingNone;
    [self.navigationController pushViewController:vc animated:YES];
    
    
    [NSTimer scheduledTimerWithTimeInterval:CMM_AnimatePerior block:^(NSTimeInterval time) {
        [tableView deselectRowAtIndexPath:indexPath animated:FALSE];

    } repeats:NO];

}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.isOwnerFocused ? UITableViewCellEditingStyleDelete :UITableViewCellEditingStyleNone;;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoreInfo *storeInfo = (StoreInfo*)[self.storeArray objectAtIndex:indexPath.row];
    [self deleteFocusForStore:storeInfo.id];
    
    [self.storeArray removeObjectAtIndex:indexPath.row];
    NSArray *array = [NSArray arrayWithObject:indexPath];
    [tableView beginUpdates];
    [tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
    [tableView endUpdates];
}


-(void)resetTable
{
    hadClearMoreSperateLine = FALSE;
    
    [self.contentView reloadData];
}


-(void)refresh
{
    //if (!self.isInitDataWithGetDistance)
    {
        self.status = VIEW_PROCESS_REFRESH;
    }
    
    if (self.isGetDistance) {
        [self getFuJinList];
    } else {
        [self refreshList];
    }
}

-(void)loadMore
{
    self.status = VIEW_PROCESS_LOADMORE;
    
    if (self.isGetDistance) {
        [self getFuJinList];
    } else {
        [self refreshList];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    //Simple velocity calculation
    static double prevCallTime = 0;
    static double prevCallOffset = 0;
    
    
    if (self.searchKey || self.isOwnerFocused) {
        return;
    }
    double curCallTime = CACurrentMediaTime();
    
    double timeDelta = curCallTime - prevCallTime;
    
    double curCallOffset = scrollView.contentOffset.y;
    
    double offsetDelta = curCallOffset - prevCallOffset;
    
    double velocity = (offsetDelta / timeDelta);
    
    prevCallTime = curCallTime;
    
    prevCallOffset = curCallOffset;
    
    float offset = scrollView.contentOffset.y;

    if (velocity > 1000 ) {
        if(!self.upsideHidenabledViewShowing){
            
            if (offset > self.upsideHidenabledView.frame.size.height && !self.upsideHidenabledViewHided)
            {
                [self hideUpsideHidenabledView:offset];
            }
        }
    }
    
    if (STOPScrolling) {
        STOPScrolling = FALSE;
        [scrollView setContentOffset:scrollView.contentOffset animated:FALSE];
    }
    
//    if (self.isGetDistance && !self.contentTable.footerView.hidden && offset > (scrollView.contentSize.height - self.contentTable.footerView.frame.size.height)) {
//        self.lbsToolBarView.hidden = YES;
//    } else if(self.isGetDistance) {
//        self.lbsToolBarView.hidden = FALSE;
//    }

}
#pragma mark -
#pragma mark custom uiview datasource & delegate -
-(void)cellSelected:(NSInteger)index
{
    if (self.topSortId != StoreSortIndex[index]) {
        self.sortId = StoreSortIndex[index];
        self.topSortId = self.sortId;
        [self setTitle:[NSString stringWithUTF8String:STORE_SORT[index]]];
        self.storeArray = nil;
        self.moreArray = nil;
        UIButton *btn = (UIButton*)[self.upsideHidenabledView viewWithTag:sortTag];
         [btn setTitle:self.topSortId == self.sortId ? @"所有类型" : [self getSortName:[NSString stringWithFormat:@"%d",self.topSortId]] forState:UIControlStateNormal];
        self.sortPicker = nil;
        [self.scrollContentV hideFooterView];
        [self.contentView reloadData];
        if (storeListRequetUrl) {
            [GKStoreSortListService cancelRequest:storeListRequetUrl];
            storeListRequetUrl = nil;
        }
        [self.scrollContentV trigRefresh];
    }
    [self.storeTopSortPicker hide];

}



-(void)popViewWillDisappear
{
//    self.focusBtn.backgroundColor = colorWithUtfStr(SortListC_ButtonBgColor);
    ((UIButtonWithStoreList*)self.focusBtn).tabSsSelected = false;

}


-(void)multiLevelList:(WSMultiLevelList*)table cellSelected:(NSIndexPath*)indexPath
{
    NSInteger index = indexPath.row;
    BOOL changed = TRUE;
//    self.focusBtn.backgroundColor = colorWithUtfStr(SortListC_ButtonBgColor);
    ((UIButtonWithStoreList*)self.focusBtn).tabSsSelected = false;
    
    if (table.tag == areaTag) {
        NSString *regionId = (index == 0 ? nil:((Region*)self.regionArray[index - 1]).id);
        
        if ((regionId && self.regionId && [regionId isEqualToString:self.regionId])
            ||(!regionId && !self.regionId )) {
            changed = FALSE;
        }
        
        if (changed) {
            self.regionId = regionId;
            [self.focusBtn setTitle:self.regionId?((Region*)self.regionArray[index-1]).name:TotalAreaStr forState:UIControlStateNormal];
            [self refreshTableForTopTabChanged];
        }
        
        [self.areaPicker hide];
        
    } else if(table.tag == aliginTag) {
        
        NSString *alignStr = self.alignStrs[index];
        if ([alignStr isEqualToString:self.alignStr]) {
            changed = FALSE;
        }
        
        if (changed) {
            self.alignStr = alignStr;
            
            [self.focusBtn setTitle:self.alignStr forState:UIControlStateNormal];
            [self refreshTableForTopTabChanged];
        }
        
        [self.alignPicker hide];
        
    } else if(table.tag == distanceTag) {
        int distance = NearStoreList_DistanceScope[index];
        if (self.distanceScope == distance) {
            changed = FALSE;
        }
        
        if (changed) {
            self.distanceScope = distance;
            [self.focusBtn setTitle:self.distanceStrs[index] forState:UIControlStateNormal];
            [self refreshTableForTopTabChanged];
        }
        
        [self.distancePicker hide];
    } else if(table.tag == sortTag) {
        if (self.isGetDistance) {
            NSArray *array =  [self getCurChildSort:table];
            int sortId = index > 0 ? [((StoreSort*)array[index - 1]).id intValue] :  [((StoreSort*)array[index]).parent_cid intValue];
            if (self.sortId == sortId) {
                changed = FALSE;
            }
        
            if (changed) {
                self.sortId = sortId;
                StoreSort *sort = nil;
                if (index == 0) {
                    sort = [self getParentSort:table];
                } else {
                    sort =  ((StoreSort*)array[index - 1]);//[self getSelectedSort:table];
                }
                
                [self.focusBtn setTitle:sort?sort.name:@"所有商家" forState:UIControlStateNormal];
            }
            
        } else {
            NSString *title = @"所有类型";
            if (index == 0) {
                if (self.sortId == self.topSortId) {
                    changed = FALSE;
                } else {
                    self.sortId = self.topSortId;
                }
            } else {
                NSArray *array = [self getChildSorts:self.topSortId];
                int sortid = [((StoreSort*)array[index - 1]).id intValue];
                if (sortid != self.sortId) {
                    title = ((StoreSort*)array[index - 1]).name;
                    self.sortId = sortid;
                } else {
                    changed = FALSE;
                }
            }
            if (changed) {
                [self.focusBtn setTitle:title forState:UIControlStateNormal];
            }
        }
        if (changed) {
            [self refreshTableForTopTabChanged];
        }
        [self.sortPicker hide];

    }
}

-(NSInteger)numberOfRow:(WSMultiLevelList*)table
{
    if (table.tag == areaTag) {
        return self.regionArray.count + 1;
    } else if(table.tag == aliginTag) {
        return self.alignStrs.count;
    } else if(table.tag == distanceTag) {
        return self.distanceStrs.count;
    } else if(table.tag == sortTag) {
        if (self.isGetDistance) {
            return [self getCurChildSort:table].count + 1;
        } else {
            return [self getChildSorts:self.topSortId].count + 1;
        }
    }
    return 0;
}

-(NSString*)multiLevelList:(WSMultiLevelList*)table titleOfRow:(NSInteger)row
{
    if (table.tag == areaTag) {
        if (row == 0) {
            return TotalAreaStr;
        } else {
            return ((Region*)self.regionArray[row-1]).name;
        }
    } else if(table.tag == aliginTag) {
        return self.alignStrs[row];
    } else if(table.tag == distanceTag) {
        return self.distanceStrs[row];
    } else if(table.tag == sortTag) {
        if (self.isGetDistance) {
            NSArray *array = [self getCurChildSort:table];
            if (row == 0) {
                if (array == self.sorts) {
                    return @"所有商家";
                } else {
                    return @"所有类型";
                }
            }
            
            StoreSort *sort = array[row-1];
            return sort.name;
        } else {
            NSArray *array = [self getChildSorts:self.topSortId];
            return  row == 0? @"所有类型" : ((StoreSort*)array[row - 1]).name;
        }

    }
    
    return nil;
}

-(BOOL)multiLevelList:(WSMultiLevelList*)table nextLevelEnabled:(NSInteger)row
{
    if (table.tag == areaTag) {
        return FALSE;
    } else if(table.tag == aliginTag) {
        return FALSE;
    } else if(table.tag == distanceTag) {
        return FALSE;
    } else if(table.tag == sortTag) {
        if (self.isGetDistance) {
            if (row == 0) {
                return false;
            }
            NSArray *array = [self getCurChildSort:table];
            StoreSort *sort = array[row-1];
            
            if (IsSafeArray(sort.children)) {
           // if (IsSafeArray(array)) {
                return TRUE;
            } else {
                return FALSE;
            }
        } else {
            return FALSE;
        }
    }
    return FALSE;
}

#pragma mark -
#pragma mark owner init function -
-(void)initOwnParams
{
    pageNum = LIST_PAGE_MAX_MUM;
    pageIndex = 1;
    
    if (self.isGetDistance) {
        areaTag = NOT_DEFINED;
        sortTag = self.topBtn0.tag;
        aliginTag = self.topBtn1.tag;
        distanceTag = self.topBtn2.tag;
    } else if (self.topSortId) {
        areaTag = self.topBtn0.tag;
        sortTag = self.topBtn1.tag;
        aliginTag = self.topBtn2.tag;
        distanceTag = NOT_DEFINED;
    }
}

-(void)initAppearance
{
    if (upsideViewValidated) {
        
        [[UIButtonWithStoreList appearance] setBackgroundColor:colorWithUtfStr(SortListC_ButtonBgColor)];
        [[UIButtonWithStoreList appearance] setTitleColor:colorWithUtfStr(SortListC_ButtonTextColor) forState:UIControlStateNormal];
        [[UIButtonWithStoreList appearance] setTitleColor:colorWithUtfStr(SortListC_ButtonHightedColor)  forState:UIControlStateHighlighted];
    }
}

-(void)initUpsideHidenabledView
{
    if (upsideViewValidated) {
        [self.upsideHidenabledView strech:APP_NAVBAR_HEIGHT direct:Direct_Up animation:NO];
        [self.upsideHidenabledView.subviews makeObjectsPerformSelector:@selector(moveDown:) withObject:[NSNumber numberWithFloat:(APP_NAVBAR_HEIGHT)]];
        [self.upsideHidenabledView addSubview:self.navBar];
        self.upsideHidenabledView.clipsToBounds = YES;
        
        if (IOS_VERSION >= 7.0) {
            [self.navBar performSelector:@selector(moveUp:) withObject:[NSNumber numberWithFloat:APP_STATUSBAR_HEIGHT]];
        }
    } else {
        [self.upsideHidenabledView removeFromSuperview];
        self.upsideHidenabledView = nil;
    }
}

-(void)initOwnContentTable
{
    self.contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.contentView.scrollEnabled  =FALSE;
    self.contentView.showsVerticalScrollIndicator = FALSE;
    self.contentView.backgroundColor = self.view.backgroundColor;
    self.contentView.sectionHeaderHeight = 0;
    
    self.scrollContentV.delegate = self;
    self.scrollContentV.backgroundColor = self.view.backgroundColor;
    
    if (!upsideViewValidated)
        [self.scrollContentV strech:self.topBtn0.frame.size.height  direct:Direct_Up animation:NO];
}

-(void)initTopTabBtn
{
    if (upsideViewValidated) {
        UIButton *btn = (UIButton*)[self.upsideHidenabledView viewWithTag:aliginTag];
        [btn setTitle:self.alignStr forState:UIControlStateNormal];
        
        if (!self.searchKey && !self.isGetDistance && !self.isOwnerFocused) {
            UIButton *btn = (UIButton*)[self.upsideHidenabledView viewWithTag:areaTag];
            [btn setTitle:TotalAreaStr forState:UIControlStateNormal];
        }
        
        if (self.distanceStrs) {
            btn = (UIButton*)[self.upsideHidenabledView viewWithTag:distanceTag];
            [btn setTitle:self.distanceStrs[DistanceDefaultIndex] forState:UIControlStateNormal];
        }
        
        btn = (UIButton*)[self.upsideHidenabledView viewWithTag:sortTag];
        if (self.isGetDistance) {
            [btn setTitle:self.storeSortArray[self.sortId] forState:UIControlStateNormal];
        } else {
            if (self.topSortId == self.sortId) {
                [btn setTitle:@"所有类型"  forState:UIControlStateNormal];
            } else if(self.sorts) {
                [btn setTitle:[self getSortName:[NSString stringWithFormat:@"%d",self.sortId]] forState:UIControlStateNormal];
            } else {
                self.needInitSortName = TRUE;
            }
        }
    }
}


#pragma  mark -
#pragma mark notification handler -

-(void)focused:(NSNotification*)notification
{
    if (self.viewIsAppear) {
        return;
    }
    
    NSString *storeId =  notification.object;
    
    if ([notification.name isEqualToString:Notification_StoreFocus]) {
        if (maybeNextPage && self.isOwnerFocused) {
            return;
        } else {
            BOOL find = FALSE;
            NSInteger index = 0;
            if (IsSafeArray(self.storeArray)) {
                for (StoreInfo *store in self.storeArray) {
                    if([storeId isEqualToString:store.id]) {
                        find = TRUE;
                        store.follow_count++;
                        break;
                    }
                    index++;
                }
            }
            if (find) {
                [self.contentView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                return;
            } else if(!self.isOwnerFocused) {
                return;
            }
            
            NillBlock_OBJ sucBack = ^(NSObject *obj){
                if (!IsSafeArray(self.storeArray))   self.storeArray = [NSMutableArray array];
                [self.storeArray insertObject:obj atIndex:0];
                
                if (self.storeArray.count > 1  ) {
                    [self.contentView beginUpdates];
                    [self.contentView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                    [self.contentView endUpdates];
                } else {
                    [self.contentView reloadData];
                }
            };
            
            StoreInfo *store =  [GKStoreSortListService getStoreDetail:storeId from:nil success:^(StoreInfo *storeInfo) {
                SAFE_BLOCK_CALL(sucBack, storeInfo);
            } fail:nil];
            
            if (store) {
                SAFE_BLOCK_CALL(sucBack, store);
            }
        }
    } else {
        BOOL find = FALSE;
        NSInteger row = 0;
        if (IsSafeArray(self.storeArray)) {
            for (StoreInfo *store in self.storeArray) {
                if([storeId isEqualToString:store.id]) {
                    find = TRUE;
                    if (!self.isOwnerFocused) {
                        store.follow_count--;
                    }
                    break;
                }
                row++;
            }
        }
        if (find) {
            if (!self.isOwnerFocused) {
                [self.contentView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            } else {
                [self.storeArray removeObjectAtIndex:row];
                [self.contentView beginUpdates];
                [self.contentView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                [self.contentView endUpdates];
            }
        }
    }
}

//-(void)cityUpdated
//{
//    self.cityId = GO(GlobalObject).cityId;
//    
//    if (self.searchKey) {
//        [self.contentTable startAnimate];
//    } else {
//        NillBlock_Array block = ^(NSArray *array){
//            self.sorts = array;
//            self.subStatus &= ~STATUS_GET_SORTS;
//
//            if (IsSafeArray(array)) {
//                BOOL find = FALSE;
//                for (StoreSort *sort in array) {
//                    if ([sort.id intValue] == self.sortId) {
//                        find = TRUE;
//                        break;
//                    } else if(IsSafeArray(sort.children)){
//                        for (StoreSort *sort1 in sort.children) {
//                            if ([sort1.id intValue] == self.sortId) {
//                                find = TRUE;
//                                break;
//                            }
//                        }
//                        if (find) {
//                            break;
//                        }
//                    }
//                }
//                if (find) {
//                    if (!self.isGetDistance) {
//                        [self.contentTable startAnimate];
//                    }
//                } else {
//                    self.sortPicker = nil;
//                    
//                    UIButton *btn =  (UIButton*)[self.upsideHidenabledView viewWithTag:sortTag];
//                    if (self.isGetDistance) {
//                        self.sortId = [TOPSort_PID intValue];
//                        [btn setTitle:@"所有商家" forState:UIControlStateNormal];
//                    } else {
//                        self.sortId = self.topSortId;
//                        [btn setTitle:@"所有类型" forState:UIControlStateNormal];
//                    }
//                    
//                    [self.contentTable startAnimate];
//                }
//            }
//        };
//
//        if (!(self.subStatus & STATUS_GET_SORTS)) {
//            self.subStatus |= STATUS_GET_SORTS;
//            NSArray *sorts  =  [GKStoreSortListService getStoreSorts:self.cityId success:^(NSArray *array) {
//                block(array);
//            } fail:^(NSError *err) {
//                self.sortPicker = nil;
//                self.subStatus &= ~STATUS_GET_SORTS;
//
//                UIButton *btn =  (UIButton*)[self.upsideHidenabledView viewWithTag:sortTag];
//                if (self.isGetDistance) {
//                    self.sortId = [TOPSort_PID intValue];
//                    [btn setTitle:@"所有商家" forState:UIControlStateNormal];
//                } else {
//                    self.sortId = self.topSortId;
//                    [btn setTitle:@"所有类型" forState:UIControlStateNormal];
//                }
//                
//                [self.contentTable startAnimate];
//                
//            }];
//            if (IsSafeArray(sorts)) {
//                block(sorts);
//            }
//        }
//    }
//    
//}
#pragma mark -
#pragma mark geter -
-(NSArray*)sorts
{
    if (!_sorts) {
        [self getSorts];
    }
    return _sorts;
}

#pragma mark -
#pragma mark setter -
-(void)setIsGetDistance:(BOOL)isGetDistance
{
    _isGetDistance = isGetDistance;
    
    if (_isGetDistance) {
        [self setTitle:TitleForNeighbour];
        self.tabImageName = [NSString stringWithUTF8String:tabImgNames[GKTAB_Near]];
        
        upsideViewValidated = TRUE;
        LBSBarValidated = TRUE;
        

        
        self.alignStrs = [NSArray arrayWithCArray:NearStoreList_Option len:sizeof(NearStoreList_Option)/sizeof(NearStoreList_Option[0])];
        self.alignStr = self.alignStrs[0];

        NSMutableArray *array = [NSMutableArray arrayWithObject:@"所有商家"];
        [array addObjectsFromArray:[NSArray arrayWithCArray:STORE_SORT len:StoreTopSortNum]];
        self.storeSortArray = array;
        
        int distanceStrNum = sizeof(NearStoreList_DistanceScope)/sizeof(NearStoreList_DistanceScope[0]);
        self.distanceStrs = [NSMutableArray arrayWithCapacity:distanceStrNum];
        for (int k = 0; k < distanceStrNum; k++) {
            NSString *distanceStr;
            if (NearStoreList_DistanceScope[k] == 0) {
                distanceStr = @"全部";
            } else if(NearStoreList_DistanceScope[k] < 1000) {
                distanceStr = [NSString stringWithFormat:@"范围%d米",NearStoreList_DistanceScope[k]];
            } else if (NearStoreList_DistanceScope[k] >= 10000){
                distanceStr = [NSString stringWithFormat:@"范围%d公里",NearStoreList_DistanceScope[k] /1000];
            } else if(NearStoreList_DistanceScope[k] >= 1000){
                if (NearStoreList_DistanceScope[k] % 1000 == 0) {
                    distanceStr = [NSString stringWithFormat:@"范围%d公里",NearStoreList_DistanceScope[k]/1000];
                } else {
                    distanceStr = [NSString stringWithFormat:@"范围%2.1d千米",NearStoreList_DistanceScope[k]/1000];
                }
            }
            [self.distanceStrs addObject:distanceStr];
            self.distanceScope = NearStoreList_DistanceScope[DistanceDefaultIndex];
         }
    }
}

-(void)setSearchKey:(NSString *)searchKey
{
    _searchKey = searchKey;
    
    [self addBackItem];
    [self setTitle:self.searchKey];
}

-(void)setIsOwnerFocused:(BOOL)isOwnerFocused
{
    _isOwnerFocused = isOwnerFocused;
    
    [self addBackItem];
    [self setTitle:TitleForOwnerFocus];
}

-(void)setTopSortId:(NSInteger)topSortId
{
    if (_topSortId != topSortId) {
        if (!_topSortId) {

            upsideViewValidated = TRUE;

            self.alignStrs = [NSArray arrayWithCArray:StoreList_Option len:sizeof(StoreList_Option)/sizeof(StoreList_Option[0])];
            self.alignStr = self.alignStrs[0];
            self.storeSortArray = [NSArray arrayWithObject:@"所有类型"];
            
            [self addBackItem];
        }
        
        _topSortId = topSortId;
        NSInteger sortIndex = getSortIndex(self.topSortId);
        [self setTile:[NSString stringWithUTF8String:STORE_SORT[sortIndex]] withDropBtn:self.isGetDistance?FALSE:TRUE action:@selector(showStoreTopSortPicker)];
    }
}

-(void)setCityId:(NSString *)cityId
{
    if (cityId != _cityId) {
        _cityId = cityId;
        
        if (cityId) {
            [self.scrollContentV trigRefresh];
            if (self.topSortId) [self getCityArea:nil]; //分类列表
        }
    }
}

@end


@implementation UIButtonWithStoreList
@end
