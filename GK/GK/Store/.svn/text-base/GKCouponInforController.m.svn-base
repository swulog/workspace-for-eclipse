//
//  GKCouponInforController.m
//  GK
//
//  Created by W.S. on 13-10-29.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GKCouponInforController.h"
#import "CouponView.h"
#import "GlobalObject.h"

@interface GKCouponInforController ()
{
    BOOL      actionLovedStatus;
    NSInteger actionIndex;
}

@property (nonatomic,strong) NSArray *coupons;
@property (nonatomic,assign) NSInteger selctedIndex;
@property (nonatomic,strong) NSMutableArray *couponLoveList;

@property (nonatomic,strong) NSMutableArray *couponViews;


@property (nonatomic,strong) GKLogonCtroller *logonVC;

@end

@implementation GKCouponInforController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil style:VIEW_WITH_NAVBAR];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithCoupon:(NSArray*)coupons focus:(NSInteger)index
{
    self = [self initWithNibName:@"GKCouponInforController" bundle:Nil];
    
    if (self) {
        self.coupons = coupons;
        self.selctedIndex = index;
        actionIndex = NOT_DEFINED;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"促销详情"];
    [self addBackItem];
    [self setBackgroundWithUIColor:[UIColor whiteColor]];
    
    [self.pageControl setPageControlStyle:PageControlStyleThumb];
    self.pageControl.thumbImage = [UIImage imageNamed:CouponInforC_PageControlNormalIcon];
    self.pageControl.selectedThumbImage = [UIImage imageNamed:CouponInforC_PageControlSeletedIcon];
    self.pageControl.hidesForSinglePage = YES;
    self.pageControl.numberOfPages = self.coupons.count;
    if (self.pageControl.numberOfPages == 1) {
        self.pageControlBGV.hidden = YES;
    }
    
    self.scrollV.pagingEnabled = TRUE;
    self.scrollV.showsHorizontalScrollIndicator = FALSE;
    self.scrollV.showsVerticalScrollIndicator = FALSE;
    self.scrollV.bounces = FALSE;

    self.couponViews = [NSMutableArray arrayWithCapacity:self.coupons.count];
    for (int k = 0; k < self.coupons.count; k++) {
        CouponView *v = [CouponView couponViewWithCoupon:self.coupons[k]];
        v.tag = k;

        [v setLoveHandler:^(BOOL loved, NSInteger index) {
            [self love:loved for:index];
        }];
        
        if ([GlobalDataService isLogoned]) {
            [v setLoveEnabled:FALSE];
        }
        
        [v move:k * self.scrollV.frame.size.width direct:Direct_Right];
        [self.scrollV addSubview:v];
        [self.couponViews addObject:v];
    }
    [self.scrollV setContentSize:CGSizeMake(self.scrollV.frame.size.width * self.coupons.count, 0)];
    
    [self.scrollV setContentOffset:CGPointMake(self.scrollV.frame.size.width * self.selctedIndex, 0)];
    [self scrollViewDidScroll:self.scrollV];
    
    if ([GlobalDataService isLogoned])    [self getOwnerLoveCouponList];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loveCoupon:) name:NOTIFICATION_COUPON_LOVED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loveCoupon:) name:NOTIFICATION_COUPON_UNLOVED object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)love:(BOOL)loved for:(NSInteger)index
{
    if (![GlobalDataService isLogoned]) {

        GKLogonCtroller *logonVc = [[GKLogonCtroller alloc] init];
        logonVc.logonDelegate = self;
        logonVc.hidesBottomBarWhenPushed = YES;
        self.logonVC =logonVc;
        
        UINavigationController *vc  = [[UINavigationController alloc] initWithRootViewController:logonVc];
        [vc setNavigationBarHidden:YES];
        [self presentFullScreenViewController:vc animated:YES completion:nil];
        
        actionIndex = index;
        actionLovedStatus = loved;
        
    } else {
        Coupon *coupon = self.coupons[index];
        [GKStoreSortListService loveCoupon:coupon.id isLoved:loved success:^{
            
         //   [GlobalObject updateCouponLoveList:coupon hasLove:loved];
//            if (!self.couponLoveList) {
//                self.couponLoveList = GO(GlobalDataService).gCouponLoveList;
//            }
    
            [((CouponView*)self.couponViews[index]) setLoved:!loved];
            [self showTopPop:!loved?@"成功添加此促销至\"我的收藏\"！":@"取消收藏成功"];

            [[NSNotificationCenter defaultCenter] postNotificationName:!loved?NOTIFICATION_COUPON_LOVED:NOTIFICATION_COUPON_UNLOVED object:coupon];
            
        } fail:^(NSError *err) {
            if (!(!loved && err.code == 422)) {
                [self showTopPop:err.localizedDescription];
            }
        }];
    }
}

-(void)getOwnerLoveCouponList
{
    NillBlock_OBJ sucBack = ^(NSObject *obj){
        self.couponLoveList = (NSMutableArray*)obj;
        if (IsSafeArray(self.couponLoveList)) {
            for (int k = 0 ; k<self.coupons.count; k++) {
                Coupon *coupon = self.coupons[k];
                for (Coupon *loveCoupon in self.couponLoveList) {
                    if ([loveCoupon.id isEqualToString:coupon.id]) {
                        [((CouponView*)self.couponViews[k]) setLoved:TRUE];
                        break;
                    }
                }
            }
        }
        
        for (CouponView *cv in self.couponViews) {
            [cv setLoveEnabled:TRUE];
        }
        if (actionIndex != NOT_DEFINED) {
            [self love:actionLovedStatus for:actionIndex];
        }
    };
    
    [GlobalDataService GetMyCouponLoveList:FALSE index:StartPageNo pagenum:LIST_PAGE_LimitLess_MUM succ:^(NSObject *obj, BOOL result) {
        SAFE_BLOCK_CALL(sucBack, obj);
    } fail:nil];
//  // [GlobalDataService couponLoveList:^(NSObject *obj) {
//        SAFE_BLOCK_CALL(sucBack, obj);
//    } fail:^(NSError *err) {
//        
//    }];
    
}

-(void)logonSuccess
{
//    [self.navigationController popViewControllerWithAnimation:NavigationAnimation_AlphaAnimation finished:^{
//        [self.logonVC.view removeFromSuperview];
//        self.logonVC = nil;
//    }];
    if (self.logonVC) {
        [self dismissFullScreenViewControllerAnimated:WSDismissStyle_AlphaAnimation completion:^{
            self.logonVC = nil;
        }];
    }

    
    [self getOwnerLoveCouponList];
    //[self love:actionLovedStatus for:actionIndex];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.view.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;

    self.pageControl.currentPage = page;
}

-(void)loveCoupon:(NSNotification*)notification
{
    if (self.viewIsAppear)  return;
    
    Coupon *coupon = notification.object;
    
    BOOL find = FALSE;
    int k = 0;
    for (; k < self.coupons.count; k++) {
        Coupon *sCoupon = self.coupons[k];
        if ([sCoupon.id isEqualToString:coupon.id]) {
            find = TRUE;
            break;
        }
    }
    
    if (!find)   return;
    
    BOOL loved = FALSE;
    if ([notification.name isEqualToString:NOTIFICATION_COUPON_LOVED])   loved = TRUE;

    [self.couponViews[k] setLoved:loved];
}

@end


