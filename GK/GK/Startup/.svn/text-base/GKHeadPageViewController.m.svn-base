
//
//  GKHeadPageViewController.m
//  GK
//
//  Created by apple on 13-4-11.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GKHeadPageViewController.h"
//#import "GKBaseViewController.h"
#import "GKStoreListCtrller.h"
//#import "CInputAssistView.h"
#import "StyledPageControl.h"
#import "GKStoreInfomationController.h"
#import "GKLogonService.h"
#import "GlobalObject.h"
//#import "WSImageView.h"
#import "WSWarningImageView.h"
#import "GKStoreSortListCtrller.h"


#define ST_None 0x00
#define ST_GetCities 0x01


@interface GKHeadPageViewController ()<SprinBoardDelete>
{
    BOOL advFialuare,isADVGetting;
    BOOL timerJustStartUp;
    NSUInteger subStatus;
}
@property (nonatomic,strong) UIButton *cityBtn;
@property (nonatomic,strong) UIImageView *cityArrowImg;
@property (nonatomic,strong) NSArray *cities;

@property (nonatomic,strong) WSPopupView *cityPickerView;
@property (nonatomic,strong) NSTimer *advScrollTimer;

@property (nonatomic,assign) BOOL isAddCustomMenu;

@end

@implementation GKHeadPageViewController


//#define ADV_HEIGHT 147
#define HJIMG_START_TAG 1000
#define ADV_MAX 100
#define ADV_DEFAULT_ICON @"banner_default"

#define ADVSCrollTimeval 3.0f

//@synthesize  nav;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil style:VIEW_WITH_NAVBAR];
    if (self) {
        // Custom initialization
        self.tabImageName = [NSString stringWithUTF8String:tabImgNames[GKTAB_Home]];
       // self.tabTitle = [NSString stringWithUTF8String:tabTitles[GKTAB_XWG]];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addNavRightItem:nil img:[UIImage imageNamed:@"search"] action:@selector(showSearch)];
    [self addGKLogInsideNavBar];
    
  //  self.view.clipsToBounds = YES;
    
    [self initAdvScrollView];
    [self initPageControl];
    [self initScrollContentView];
    
    
    [self initCityInfo];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (advFialuare && !isADVGetting) {
        [self getAdvInfo:self.cityId];
    } else if(IsSafeArray(self.advArray)) {
        [self startAutoScroll];
    }
    
    self.isAddCustomMenu = FALSE;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.advScrollTimer) {
        [self.advScrollTimer setFireDate:[NSDate distantFuture]];
    }
    
    [self.springBoradView cancelDeleteAction];
}


- (void)viewWillLayoutSubviews
{
    self.fullScrollView.autoresizingMask =  UIViewAutoresizingNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    
    [self setAdvScrollView:nil];
    [self setCustPageControl:nil];
    [super viewDidUnload];
}
#pragma mark -
#pragma mark network adapter -
-(void)getCities
{
    NillBlock_OBJ cityListBlock = ^(NSObject *obj){
        if (!obj)  return ;
        self.cities = (NSArray*)obj;
        subStatus &= ~ST_GetCities;
        NSString *cityId = self.cityId;
        NSString *cityName = self.cityName;
        [self checkCityName];
        if (self.cityId && ![self.cityId isEqualToString:cityId])      [self getAdvInfo:self.cityId];
        if (self.cityName && ![self.cityName isEqualToString:cityName]) [self refreshCityBtn];
    };
    
    if (subStatus & ST_GetCities) {
        return;
    } else {
        subStatus |= ST_GetCities;
        cityListBlock([GKLogonService getCityLIist:cityListBlock fail:^(NSError *err) {
            subStatus &= ~ST_GetCities;
        }]);
    }
}

-(void)initCityInfo
{
    
    [self getCities];
    

    NillBlock_OBJ cityIdBlock = ^(NSObject *obj){
        if (!obj)  return ;
        
        self.cityId = (NSString*)obj;
        self.cityName = GO(GlobalObject).cityName;
        
        [self checkCityName];
        [self getAdvInfo:self.cityId];
        [self refreshCityBtn];
//        if (!self.cityName) {
//            [self getCityName:self.cityId];
//        }
    };
    cityIdBlock([GlobalObject getCityIdForExtraUser:cityIdBlock fail:nil]);
}

-(void)getAdvInfo:(NSString*)cityId
{
    NillBlock_OBJ sucBack = ^(NSObject *obj){
        if (obj) {
            isADVGetting = FALSE;
            advFialuare = FALSE;
            self.advArray = (NSArray*)obj;
            
            [self.advScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            for (int k = 0; k < self.advArray.count; k++) {
                WSImageView *imgV = [[WSImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * k, 0, self.view.frame.size.width,self.advScrollView.frame.size.height)];
                [self.advScrollView addSubview:imgV];
                [imgV setTag:HJIMG_START_TAG+k];
                [imgV addTarget:self action:@selector(advClick:) forControlEvents:UIControlEventTouchUpInside];
                GKAdvInfo *adv = [self.advArray objectAtIndex:k];
                [imgV showUrl:[NSURL URLWithString:adv.image_url] activity:YES palce:[WSWarningImage ImageForWarning:@"网络获取失败" font:Nil color:nil]];
            }
    
            self.advScrollView.contentSize = CGSizeMake( self.advArray.count  * self.view.frame.size.width,self.advScrollView.frame.size.height);
            self.advScrollView.contentOffset =  CGPointZero;
            self.advScrollView.userInteractionEnabled = TRUE;
            
            self.custPageControl.hidden = FALSE;
            self.custPageControl.currentPage = 0;
            self.custPageControl.numberOfPages = self.advArray.count;
            
            [self.custPageControl setCoreNormalColor:colorWithUtfStr(Color_PageCtrllerNormalColor)];
            [self.custPageControl setCoreSelectedColor:self.advArray.count == 1 ? colorWithUtfStr(Color_PageCtrllerNormalColor) : colorWithUtfStr(Color_PageCtrllerSelectedColor)];
            
            [self startAutoScroll];
        } else if(cityId != nil) {
            [self getAdvInfo:nil];
        } else {
            WSImageView *imgV = self.advScrollView.subviews[0];
            [imgV showDefaultImg:[WSWarningImage ImageForWarning:@"暂无图片" font:Nil color:nil]];
        }
    };
    
    isADVGetting = TRUE;
    NSArray *array =  [GKLogonService getAdvInfo:cityId succ:^(NSObject *obj){
        SAFE_BLOCK_CALL(sucBack, obj);
    }fail:^(NSError *err){
        isADVGetting = FALSE;
        advFialuare = TRUE;
        if (self.advScrollView.subviews.count == 1) {
            self.advScrollView.backgroundColor = [UIColor whiteColor];
            WSImageView *imgV = self.advScrollView.subviews[0];
            [imgV showDefaultImg:[WSWarningImage ImageForWarning:@"网络获取失败" font:Nil color:nil]];
        }
    }];
    
    if (IsSafeArray(array)) {
        SAFE_BLOCK_CALL(sucBack, array);
    }
    
}

#pragma mark -
#pragma mark inside normal function -

-(void)advViewAutoScroll
{
    if (!self.viewIsAppear) {
        return;
    }
    if (timerJustStartUp) {
        timerJustStartUp = FALSE;
        return;
    }
    
    CGPoint offset = self.advScrollView.contentOffset;
    CGFloat pageWidth = self.advScrollView.frame.size.width;
    
    int page = floor((offset.x - pageWidth / 2) / pageWidth) + 1;
    int nextPage = (page + 1) % self.custPageControl.numberOfPages;

    WSImageView *imgV = (WSImageView*)[self.advScrollView viewWithTag:(HJIMG_START_TAG + page)];
    WSImageView *nextImgV = (WSImageView*)[self.advScrollView viewWithTag:(HJIMG_START_TAG + nextPage)];

    if (imgV.isWaitting || nextImgV.isWaitting) {
        [self.advScrollTimer setFireDate:[NSDate distantFuture]];
        
        imgV = imgV.isWaitting ? imgV : nextImgV;
        __block WSImageView *imgVAlias = imgV;
        __block NSString *obserToken = [imgV addObserverForKeyPath:@"isWaitting" task:^(id obj, NSDictionary *change) {
            if (!imgVAlias.isWaitting) {
                [imgVAlias removeObserverWithBlockToken:obserToken];
                [self startAutoScroll];
            }
        }];
    } else {
        offset.x = nextPage * pageWidth;
        [self.advScrollView setContentOffset:offset];
        [self scrollViewDidScroll:self.advScrollView];
    }
}


-(void)startAutoScroll
{
    if (self.viewIsAppear) {
        if (!self.advScrollTimer) {
            self.advScrollTimer = [NSTimer scheduledTimerWithTimeInterval:ADVSCrollTimeval target:self selector:@selector(advViewAutoScroll) userInfo:Nil repeats:YES];
        }
        timerJustStartUp = TRUE;
        [self.advScrollTimer setFireDate:[NSDate distantPast]];
    }
}

-(void)showSearch
{
    GKSearchResultCtroller *vc = [[GKSearchResultCtroller alloc] initWithNibName:@"GKSearchResultCtroller" bundle:nil keyword:nil];
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)addGKLogInsideNavBar
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:GK_NavLog] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, GK_NavLogWidth, GK_NavLogHeight)];
    btn.userInteractionEnabled  = FALSE;
    UIBarButtonItem *logoBarItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = FONT_NORMAL_13;
    float width = 10;
    
    NSString *cityTitle = self.cityName;
    if (IsSafeString(self.cityName)) {
        CGSize labsize = [self.cityName sizeWithFont:btn.titleLabel.font constrainedToSize:CGSizeMake(9999,20) lineBreakMode:NSLineBreakByWordWrapping];
        width = labsize.width;
    } else {
        cityTitle = @"";
    }
    
    [btn setTitle:cityTitle forState:UIControlStateNormal];
    [btn setTitleColor:colorWithUtfStr(HomePageC_NavbarCityColor) forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [btn setFrame:CGRectMake(0,0 , width + NavBarDownArrowWidth, 30)];
    self.cityBtn = btn;
    
    UIImageView *imgV =[[UIImageView alloc] initWithImage:[UIImage imageNamed:NavBarDownArrow]];
    [imgV setFrame:CGRectMake(width +  7 , 12 , NavBarDownArrowWidth, NavBarDownArrowheight)];
    [btn addSubview:imgV];
    self.cityArrowImg = imgV;
    
    [btn addTarget:self action:@selector(showCityPicker) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *cityBarItem =[[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navBar.topItem.leftBarButtonItems = [NSArray arrayWithObjects:logoBarItem,cityBarItem, nil];
    
}

-(void)showCityPicker
{
    if (!self.cityPickerView && IsSafeArray(self.cities)) {
        WSMultiColList *tablee = [[WSMultiColList alloc] initWithFrame:CGRectMake(0, 64, 320, 200)];
        tablee.numOfColPerRow = 3;
        tablee.cellTitltColor = colorWithUtfStr(HomePageC_NavbarCityColor);
        tablee.footColor = colorWithUtfStr(HomePageC_NavPopViewFootColor);
        tablee.selectedColor = colorWithUtfStr(HomePageC_NavbarCitySelectedColor);
        
        NSMutableArray *array = [NSMutableArray array];
        for (int k = 0 ; k < self.cities.count; k++) {
            WSMultiColCell *cell = [WSMultiColCell initWithTitle:((City*)self.cities[k]).name imageView:nil];
            if ([((City*)self.cities[k]).name isEqualToString:self.cityName] ) {
                tablee.selectedItem = [NSMutableArray arrayWithObject:[NSNumber numberWithInt:k]];
            }
            [array addObject:cell];
        }
        
        tablee.itemSource =array;
        tablee.multiColListDelegate = self;
        self.cityPickerView = [WSPopupView showPopupView:tablee  mask:CGRectMake(0, APP_NAVBAR_HEIGHT+APP_STATUSBAR_HEIGHT, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT-(APP_NAVBAR_HEIGHT+APP_STATUSBAR_HEIGHT)) type:WS_PopS_Down];
        
    } else if(self.cityPickerView){
        [self.cityPickerView show];
    } else{
        [self getCities];
    }
}

-(void)cellSelected:(NSInteger)index
{
    City *city = self.cities[index];
    self.cityId = city.id;
    [GO(GlobalObject) setCityId:self.cityId name:city.name];
    self.cityName = city.name;
    [self refreshCityBtn];
    [self getAdvInfo:self.cityId];
    [self.cityPickerView hide];

}

//-(NSString*)getCityName:(NSString*)cityId
//{
//    if (IsSafeArray(self.cities)) {
//        for (City *city in self.cities) {
//            if ([cityId isEqualToString:city.id]) {
//                self.cityName = city.name;
//                [self refreshCityBtn];
//                return city.name;
//            }
//        }
//    }
//    return nil;
//}

-(void)refreshCityBtn
{
    if (!self.cityBtn) {
        return;
    }
    
    NSString *cityTitle = self.cityName;
    float width = 30;
    if (IsSafeString(self.cityName)) {
        CGSize labsize = [self.cityName sizeWithFont:self.cityBtn.titleLabel.font constrainedToSize:CGSizeMake(9999,20) lineBreakMode:NSLineBreakByWordWrapping];
        width = labsize.width;
    } else {
        cityTitle = @"";
    }
    
    [self.cityBtn setTitle:cityTitle forState:UIControlStateNormal];
    CGRect rect = self.cityBtn.frame;
    float offset = width + NavBarDownArrowWidth - rect.size.width;
    [self.cityBtn strechTo:CGSizeMake(width + NavBarDownArrowWidth, 30)];
    [self.cityArrowImg move:offset direct:Direct_Right];
 //   [self.cityBtn setFrame:CGRectMake(0,0 , width + NavBarDownArrowWidth, 30)];
}

-(void)checkCityName
{
    if (!self.cityId || !self.cities) {
        return;
    }
    
    __block BOOL findID = FALSE;
    __block NSString *cityName;
    
    [self.cities enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        City *city = obj;
        if ([city.id isEqualToString:self.cityId]) {
            cityName = city.name;
            findID = TRUE;
            *stop = TRUE;
        }
    }];
    
    if (findID && ![cityName isEqualToString:self.cityName]) {
        self.cityName = cityName;
        [GO(GlobalObject) setCityId:self.cityId name:self.cityName];
        City *city = [[City alloc] init];
        city.id = self.cityId;
        city.name = cityName;
        [city save:@"id"];
    } else if(!findID) {
        [GO(GlobalObject) setCityId:GK_Default_CityId name:GK_Default_CityName];
        self.cityId = GK_Default_CityId;
        self.cityName = GK_Default_CityName;
    }
}

-(StoreSort*)TopSort:(StoreTopSort)sortId
{
    StoreSort *sort = [[StoreSort alloc] init];
    sort.id = [NSString stringWithFormat:@"%d",sortId];
    return sort;
}

#pragma mark -
#pragma mark notication handler -
-(void)handlerForSortChangedNotification
{
    if (![self viewIsAppear]) {
        [self updateSpringBorad];
    }
}

-(void)updateSpringBorad
{
    NSMutableArray *total = [GlobalObject totalCustStoreSorts];
    NSMutableArray *locate = [GlobalObject locateStoreSorts];

    [self.springBoradView removeAllItem];
    
    [locate enumerateObjectsUsingBlock:^(NSString *sortId, NSUInteger idx, BOOL *stop) {
        __block BOOL find = FALSE;
        for (int k = 0 ; k < total.count && !find; k++) {
            [total[k] enumerateObjectsUsingBlock:^(CustomStoreSort *sort, NSUInteger idx, BOOL *stop) {
                if ([sort.ID isEqualToString:sortId]) {
                    SpringBoardItem *btnItem = [self.springBoradView addItem:[UIImage imageNamed:sort.Icon] title:sort.Name handler:@selector(CustomMenuClick:) with:self];
                    btnItem.tag = [sort.ID intValue];
                    find = *stop = TRUE;
                }
            }];
        }
    }];
    SpringBoardItem *addItem = [self.springBoradView addItem:[UIImage imageNamed:@"HP_AddMenuIcon"] title:@"增加分类" handler:@selector(addCustomMenu) with:self];
    addItem.deleteEnabled = FALSE;
    addItem.tag = NOT_DEFINED;
    
    [self.springBoradView layoutIfNeeded];
    float height = self.springBoradView.frame.origin.y + self.springBoradView.frame.size.height - self.advScrollView.frame.origin.y + 10;
    [self.fullScrollView setContentSize:CGSizeMake(0, height)];
    
    if (self.isAddCustomMenu) {
        [self.fullScrollView  setContentOffset:CGPointMake(0, self.fullScrollView.contentSize.height - self.fullScrollView.frame.size.height) animated:YES];
    }
}

#pragma mark -
#pragma mark event handler -

-(void)advClick:(id)sender
{
    WSImageView *imgV = (WSImageView*)sender;
    GKAdvInfo *adv =[self.advArray objectAtIndex:(imgV.tag - HJIMG_START_TAG)];
    
    if (adv.store_id && adv.store_id.length>0) {
        GKStoreInfomationController *vc = [[GKStoreInfomationController alloc] initWithNibName:@"GKStoreInfomationController" bundle:nil withStore:nil orID:adv.store_id from:adv.id];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)pageControlClick:(id)sender
{
    StyledPageControl *pageCtrl = (StyledPageControl*)sender;
    [self.advScrollView setContentOffset:(CGPointMake(self.advScrollView.frame.size.width * pageCtrl.currentPage, self.advScrollView.frame.origin.x)) animated:YES];
}

- (IBAction)canyinClick:(id)sender {
    [self gotoStoreList:[self TopSort:StoreSort_CANYIN]];
}

- (IBAction)yuleClick:(id)sender {
    [self gotoStoreList:[self TopSort:StoreSort_YULE]];
}

- (IBAction)yundongClick:(id)sender {
    [self gotoStoreList:[self TopSort:StoreSort_YUNDONG]];
}

- (IBAction)gouwuClick:(id)sender {
    [self gotoStoreList:[self TopSort:StoreSort_GOUWU]];
}

- (IBAction)shenghuoClick:(id)sender {
    [self gotoStoreList:[self TopSort:StoreSort_SHENGHUO]];
}

- (IBAction)beautyClick:(id)sender {

    StoreSort *sort = [[StoreSort alloc] init];
    sort.id = [NSString stringWithFormat:@"%d",StoreSortIdForBeauty];
    sort.parent_cid = [NSString stringWithFormat:@"%d",StoreSortPIdForBeauty];

    [self gotoStoreList:sort];
}

-(void)gotoStoreList:(StoreSort*)sort
{
    GKStoreListCtrller *vc = [[GKStoreListCtrller alloc] initForSort:sort];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)addCustomMenu
{
    self.isAddCustomMenu = TRUE;

    GKStoreSortListCtrller *vc = [[GKStoreSortListCtrller alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)CustomMenuClick:(id)sender
{
    StoreSort *sort = [[StoreSort alloc] init];
    sort.id = [NSString stringWithFormat:@"%d",((UIButton*)sender).tag];
    
    NSMutableArray *total = [GlobalObject totalCustStoreSorts];
    __block NSString *pid = nil;
    for (int k = 0; k < total.count && !pid; k++) {
        [total[k] enumerateObjectsUsingBlock:^(CustomStoreSort *obj, NSUInteger idx, BOOL *stop) {
            if ([obj.ID isEqualToString:sort.id]) {
                pid = obj.PID;
                *stop = TRUE;
            }
        }];
    }
    sort.parent_cid = pid;
    
    [self gotoStoreList:sort];
}

#pragma mark -
#pragma mark initer -
-(void)initPageControl
{
    self.custPageControl.hidden = YES;
    [self.custPageControl setPageControlStyle:PageControlStyleFillRect];
    [self.custPageControl setCoreNormalColor:colorWithUtfStr(Color_PageCtrllerNormalColor)];
    [self.custPageControl setCoreSelectedColor:colorWithUtfStr(Color_PageCtrllerSelectedColor)];
    [self.custPageControl addTarget:self action:@selector(pageControlClick:) forControlEvents:UIControlEventValueChanged];
    
}
-(void)initAdvScrollView
{
    self.advScrollView.contentSize = CGSizeMake( 1* self.view.frame.size.width,self.view.frame.size.height);
    self.advScrollView.userInteractionEnabled = FALSE;
    WSImageView *imgV = [[WSImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.advScrollView.frame.size.height)];
    [imgV showUrl:nil activity:YES];
    [imgV setTag:HJIMG_START_TAG];
    [self.advScrollView addSubview:imgV];
}

-(void)initScrollContentView
{
    self.springBoradView.backgroundColor = self.view.backgroundColor;
    [self.springBoradView setItemOffset:UIOffsetMake(29, 0)];
    [self.springBoradView setItemSize:CGSizeMake(68, 88)];
    [self.springBoradView setHorAutoAlignment:YES];
    [self.springBoradView setItemGap:UIOffsetMake(0, 8)];
    [self.springBoradView setAutoHeight:YES];
    self.springBoradView.delegate = self;
    [self updateSpringBorad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerForSortChangedNotification) name:NOTIFICATION_LocationDefinedStoreSortsChanged object:nil];
    
    UITapGestureRecognizer *clickRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(cancelDeleteAction:)];
    [clickRecognizer setNumberOfTapsRequired:1];
  //  [clickRecognizer delaysTouchesBegan];
    [self.view addGestureRecognizer:clickRecognizer];
}

-(void)cancelDeleteAction:(id)sender
{
    UIGestureRecognizer *gesture = sender;
    gesture.cancelsTouchesInView = FALSE;
    
    
    BOOL isDel  = [self.springBoradView isInsideDelView:[gesture locationInView:self.springBoradView]];
    
    if (!isDel) {
        [self.springBoradView cancelDeleteAction];
    }
}

#pragma mark -
#pragma mark scroll view delegate -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView == self.advScrollView) {
        CGFloat pageWidth = self.advScrollView.frame.size.width;
        
        int page = floor((scrollView.contentOffset.x - pageWidth / 2) /pageWidth)+1;
        
        self.custPageControl.currentPage = page;
    }

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.advScrollTimer setFireDate:[NSDate distantFuture]];
    timerJustStartUp = TRUE;
    [self.advScrollTimer setFireDate:[NSDate distantPast]];
    
}

-(void)SpringItemDelete:(id)sender
{
    SpringBoardItem *btn = ((SpringBoardItem*)sender);
    NSString *sortId = [NSString stringWithFormat:@"%d",btn.tag];
    NSMutableArray *locate = [GlobalObject locateStoreSorts];
    [locate enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        if ([sortId isEqualToString:obj]) {
            [locate removeObject:obj];
            *stop = TRUE;
        }
    }];

    [GlobalObject setLocStoreSorts:locate];
    
    [self.springBoradView deleteItem:btn animation:YES];
    
}

-(void)SpringBoardDeleteOver
{
    float height = self.springBoradView.frame.origin.y + self.springBoradView.frame.size.height - self.advScrollView.frame.origin.y + 10;
    [UIView animateWithDuration:CMM_AnimatePerior animations:^{
        self.fullScrollView.contentOffset = CGPointMake(0, height - self.fullScrollView.frame.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            [self.fullScrollView setContentSize:CGSizeMake(0, height)];
            self.fullScrollView.contentOffset = CGPointMake(0, height - self.fullScrollView.frame.size.height);
        }
    }];
}

-(void)SpringBoardReAlign
{
    NSMutableArray *destSorts = [NSMutableArray array];
    NSArray *array = self.springBoradView.items;
    [array enumerateObjectsUsingBlock:^(SpringBoardItem *obj, NSUInteger idx, BOOL *stop) {
        if (obj.tag != NOT_DEFINED) {
            [destSorts addObject:[NSString stringWithFormat:@"%d",obj.tag]];
        }
    }];
    [GlobalObject setLocStoreSorts:destSorts];
}

@end
