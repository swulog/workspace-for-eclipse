//
//  GKStoreInfomationController.h
//  GK
//
//  Created by apple on 13-4-14.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GKBaseViewController.h"
#import "GKStoreListCtrller.h"
#import "GKLogonCtroller.h"
#import "GKStoreSortListService.h"

typedef enum{
    Store_Action_None,
    Store_Action_Focus,
    Store_Action_QR,
    Store_Action_Comment,
    Store_Action_Share,
    Store_Action_Love
}Store_Action;

//@interface StoreDetailInfo : NSObject
//@property(strong,nonatomic) NSString *storeId;
//@property(strong,nonatomic) NSString *storeName;
//@property(assign,nonatomic) NSInteger totalTrade;
//@property(assign,nonatomic) NSInteger totalFocusd;
//@property(assign,nonatomic) float baseRebate;
//@property(strong,nonatomic) NSString *rebateTitle;
//@property(strong,nonatomic) NSString *rebateDetail;
//@property(strong,nonatomic) NSString *storeAddress;
//@property(strong,nonatomic) NSString *storeContactCall;
//@property(strong,nonatomic) NSString *storeWorkTime;
//@end

@protocol StoreInfoCtrllerDelegate;
@interface GKStoreInfomationController : GKBaseViewController<UMSocialUIDelegate,GKLogonDelegate>
{
    UIWebView *phoneCallWebView;
    BOOL focusChanged;
    BOOL hadFocused;
    BOOL isGetCellHeight;
    NSString *storeId;
}
@property (assign,nonatomic) id<StoreInfoCtrllerDelegate> unloadDelegate;
//@property(nonatomic,strong) StoreInfo *storeBaseInfo;
@property(nonatomic,strong) StoreInfo *storeDetailInfo;
@property (nonatomic,strong) NSArray *couponArray;

@property (assign,nonatomic) Store_Action cAction;
@property (nonatomic,strong) NSString *destCouponId;

//@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTradeLabel;
//@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UILabel *totalFocusLabel;
@property (weak, nonatomic) IBOutlet UILabel *baseRebateLabel;
@property (weak, nonatomic) IBOutlet UITableView *contentTable;
//@property (weak, nonatomic) IBOutlet GeometryImg *totalTradeLine;
//@property (weak, nonatomic) IBOutlet GeometryImg *totalFocusLine;
@property (weak, nonatomic) IBOutlet GeometryImg *baseRebateLine;
@property(nonatomic,strong) UIViewController *weiBoLogonCtroller;

//@property (weak, nonatomic) IBOutlet UIBarButtonItem *focusTabItem;

@property (nonatomic,strong) NSMutableArray *openStatusArray;
@property (weak, nonatomic) IBOutlet UIView *toolBarView;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *loveBtn;
@property (weak, nonatomic) IBOutlet UIButton *discussBtn;
@property (weak, nonatomic) IBOutlet UIButton *qrBtn;




@property (nonatomic,strong) NSString *advId;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil  withStore:(StoreInfo*)si orID:(NSString*)sToreId from:(NSString*)adv;
- (IBAction)QRClick:(id)sender;
- (IBAction)shareClick:(id)sender;
- (IBAction)focusClick:(id)sender;




@end

@protocol StoreInfoCtrllerDelegate <NSObject>

@optional
-(void)storeInfoCtrllerWillUnload:(NSNumber*)focusd;
@end

@interface UiViewWithStoreInfoC : UIView
@end
@interface UILabelWithStoreInfoC : UILabel
@end
@interface UILabelWithStoreInfoC_TopStatus_Title : UILabel
@end

