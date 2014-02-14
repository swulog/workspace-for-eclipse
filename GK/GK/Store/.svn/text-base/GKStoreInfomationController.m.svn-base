//
//  GKStoreInfomationController.m
//  GK
//
//  Created by apple on 13-4-14.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GKStoreInfomationController.h"
#import "GlobalObject.h"
#import "GKQRViewController.h"
#import "GKLogonService.h"
#import "GK_PhotoPreviewCtrller.h"
#import "GKCouponInforController.h"
#import "PopoverView.h"
#import "SNSShareView.h"
#import "GKCommentService.h"
#import "CommentCell.h"
#import "GKCommentListCtrller.h"
#import "WSWarningImageView.h"
#import "GKCommentReleaseCtrller.h"

enum {
    FIELD_STORE_PHOTO,
    FIELD_COUPON,
    FIELD_STORE_CONTACT,
    FIELD_STORE_DISCUSS
   // FIELD_NOTE
};

#define StorePhotoGap 8
#define StorePhotoWidth 110
#define StorePhotoHeight StorePhotoWidth

#define TableCellCMMHeight 40
#define CommentCellCMMHeight 75

#define TableCellPhotoScrollViewTag 2000
#define TableCellCustomTitleLabelTag 2001
#define TableCellAddressLabelTag 2002
#define TableCellDiscussBtnTag 2003
#define TableCellTitleViewForIOS6 2004
#define TableCellCommentTag 2005
#define TitleLabelInsetWithIOS6 10

#define CommentShowNum 2

#define SHARE_TIP @"我在 @贵客 发现了一家不错的店，你也来看看吧！%@%@ " GK_WebSite
#define ShareTitleWithWX @"分享个好东东给你"

//#define WXTimeLine_Share_Tip

@interface GKStoreInfomationController ()<UMSocialUIDelegate,PhotoPreviewDelegate>
{
    UIView *testV;
}
@property (nonatomic,strong) NSMutableArray *storePhotoes;
@property (nonatomic,strong) NSArray *commentList;
@property (nonatomic,assign) BOOL nextComments;
//@property (nonatomic,strong) NSMutableArray *couponLoveList;
//@property (nonatomic,strong) NSMutableArray *storeCouponLoveList;
@property (nonatomic,assign) BOOL hadInitTable;
@property (nonatomic,assign) BOOL hadInitCouponSection;

@property (nonatomic,strong) GKLogonCtroller *logonController;
@end

@implementation GKStoreInfomationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil  withStore:(StoreInfo*)si orID:(NSString*)sToreId from:(NSString*)adv
{ 
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil style:VIEW_WITH_NAVBAR];
    if (self) {
        self.advId = adv;
        storeId = sToreId ?sToreId: si.id;
        self.storeDetailInfo = si;
        
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Custom initialization
    
    [[UiViewWithStoreInfoC appearance] setBackgroundColor:colorWithUtfStr(StoreInfoC_TopStatusBgColor)];
    [[UILabelWithStoreInfoC appearance] setTextColor:colorWithUtfStr(StoreInfoC_TopStatusValueColor)];
    [[UILabelWithStoreInfoC_TopStatus_Title appearance] setTextColor:colorWithUtfStr(StoreInfoC_TopStatusTitleColor)];
    
    
    [self setTitle:@"商家详情"];
    [self addBackItem];
//    [self addBackItem:@"返回" action:@selector(goback)];

    [self initToolBar];
    self.contentTable.backgroundView = nil;
    self.contentTable.backgroundColor = [UIColor clearColor];
    
    self.contentTable.showsVerticalScrollIndicator = FALSE;
    self.contentTable.separatorColor = colorWithUtfStr(CommonViewBGColor);
    self.contentTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    if (IOS_VERSION >= 7.0) {
        [self.contentTable setContentInset:UIEdgeInsetsMake(-30, 0, 0, 0)];
    }
    
    if (self.storeDetailInfo) {
        [self resetOwnerForm];
        [self reloadITable];
    } else if(storeId) {
        self.discussBtn.enabled = FALSE;
        [self getStoreDetail:storeId];
    } else {
        assert("Param Error,Pls Check");
    }
    
    [self getCoupouns];
    
    if (![GlobalObject getHiddenStoreIconConfig]) {
        [self getStorePhotoes:self.storeDetailInfo?self.storeDetailInfo.id:storeId];
    }
    
    if(![GlobalDataService isLogoned]){
        self.loveBtn.enabled = TRUE;
    } else {
        self.loveBtn.enabled  = FALSE;
        [self getFocusStatus:storeId];
    }

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logonSuccess) name:NOTIFICATION_LOGON_OK object:Nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateComment:) name:Notification_CommentRelease object:Nil];
    
    
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFocusStatus:) name:Notification_StoreFocus object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFocusStatus:) name:Notification_StoreUnFocus object:nil];

}

//-(void)dealloc
//{
////    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_StoreFocus object:nil];
////    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_StoreUnFocus object:nil];
//    
//    [self setTotalTradeLabel:nil];
//    [self setTotalFocusLabel:nil];
//    [self setBaseRebateLabel:nil];
//    [self setContentTable:nil];
//
//    [self setBaseRebateLine:nil];
//    [self setWeiBoLogonCtroller:nil];
//}

- (void)viewDidUnload {
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_StoreFocus object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_StoreUnFocus object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_LOGON_OK object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_CommentRelease object:nil];
    
    [self setTotalTradeLabel:nil];
    [self setTotalFocusLabel:nil];
    [self setBaseRebateLabel:nil];
    [self setContentTable:nil];

    [self setBaseRebateLine:nil];
    [self setWeiBoLogonCtroller:nil];
    [super viewDidUnload];
}



#pragma mark -
#pragma mark inside method -
-(NSInteger)transFieldIndex:(NSInteger)section
{
    NSInteger index = section;
    
    if (!IsSafeArray(self.storePhotoes))
        index++;
    
    if (index != 0)
        if (!IsSafeArray(self.couponArray))
            index++;
    
    return index;
}


//-(void)updateFocusStatus:(NSNotification*)notification
//{
//    NSString *tstoreId = (NSString*)notification.object;
//    
//    if ([tstoreId isEqualToString:self.storeDetailInfo.id]) {
//        if ([notification.name isEqualToString:Notification_StoreUnFocus]) {
//            hadFocused = FALSE;
//        } else if([notification.name isEqualToString:Notification_StoreFocus]){
//            hadFocused = TRUE;
//        }
//        
//        self.loveBtn.enabled = TRUE;
//        [self.loveBtn setImage:[UIImage imageNamed:hadFocused?StoreInfoC_LoveIcon:StoreInfoC_UnLoveIcon] forState:UIControlStateNormal];
//        self.totalFocusLabel.text = [NSString stringWithFormat:@"%d",hadFocused ?[self.totalFocusLabel.text intValue] : [self.totalFocusLabel.text intValue] - 1 ];
//    }
//}

-(void)resetOwnerForm
{
    self.totalTradeLabel.text = [NSString stringWithFormat:@"%d",self.storeDetailInfo.deal_count];
    self.totalFocusLabel.text = [NSString stringWithFormat:@"%d",self.storeDetailInfo.follow_count];
    
    NSMutableString *str ;
    if (self.storeDetailInfo.discount == 0.0f) {
        str = [NSMutableString stringWithFormat:@"免费"];
    } else if(self.storeDetailInfo.discount == 10.0f){
        str = [NSMutableString stringWithFormat:@"暂无折扣"];
    } else {
        str = [NSMutableString stringWithFormat:@"%1.1f折",self.storeDetailInfo.discount];
    }
    self.baseRebateLabel.text = str;
    
    [self setTitle:self.storeDetailInfo.name];
    
    if (!self.commentList)  [self getComments];
    if (self.storeDetailInfo) {
        self.discussBtn.enabled = TRUE;
    }
}

-(void)getStoreDetail:(NSString*)iD
{
    if (!(self.storeDetailInfo = [GKStoreSortListService getStoreDetail:iD from:self.advId success:^(StoreInfo *_storeInfo){

        self.storeDetailInfo = _storeInfo;

        self.status = VIEW_PROCESS_NORMAL;
        [self hideWaitting];
        [self resetOwnerForm];
       // [self.contentTable reloadData];
        [self reloadITable];
        
    }fail:^(NSError *err){
        self.status = VIEW_PROCESS_FAIL;
        [self hideWaitting];
        [GlobalObject showPopup:err.localizedDescription];
    }])) {
        self.status = VIEW_PROCESS_GETTING;
        [NSTimer scheduledTimerWithTimeInterval:CMM_AnimatePerior target:self selector:@selector(showWatting) userInfo:nil repeats:NO];
    } else {
        [self resetOwnerForm];
        //[self.contentTable reloadData];
            [self reloadITable];
    }
}

-(void)getCoupouns
{
    NillBlock_Nill sucBack = ^{
        self.openStatusArray = [NSMutableArray arrayWithCapacity:self.couponArray.count];
        
        
        int row = 0;
        BOOL find = FALSE;
        if (IsSafeString(self.destCouponId)) {
            for (Coupon *storeCoupon in self.couponArray) {
                if ([storeCoupon.id isEqualToString:self.destCouponId]) {
                    find = TRUE;
                    break;
                }
                row++;
            }
        }
        
        if (!find) {
            row = 0;
        }

  
        //  [self.openStatusArray addObject:[NSNumber numberWithBool:TRUE]];
        for (int k = 0; k < self.couponArray.count; k++) {
            [self.openStatusArray addObject:[NSNumber numberWithBool:row==k]];
        }
        
//        if ([GlobalObject isLogonGK] && IsSafeArray(self.couponArray)) {
//            [self getOwnerLoveCouponList];
//        }

        if (self.hadInitTable) {
            BOOL top =IsSafeArray(self.storePhotoes)?FALSE:true;
            [self.contentTable insertSections:[NSIndexSet indexSetWithIndex:top?0:1] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [self reloadITable];
        }
        
        if (row != 0) {
            [self.contentTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:IsSafeArray(self.storePhotoes)?1:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        self.hadInitCouponSection = TRUE;



    };
    
    self.couponArray = [GKStoreSortListService getCounponList:storeId success:^(NSArray* array){
        self.couponArray = array;
        if(self.couponArray && self.couponArray.count > 0)
        {
            SAFE_BLOCK_CALL_VOID(sucBack);
        }
        
    }fail:nil];
    
    if(self.couponArray && self.couponArray.count > 0)
    {
        SAFE_BLOCK_CALL_VOID(sucBack);
        
    }

}

-(void)getFocusStatus:(NSString*)sToreID
{
    [GKStoreSortListService getFocusStatus:sToreID user:[GlobalDataService userGKId] success:^(BOOL isFocused){
        
        [self.loveBtn setImage:[UIImage imageNamed:isFocused?StoreInfoC_LoveIcon:StoreInfoC_UnLoveIcon] forState:UIControlStateNormal];
        hadFocused = isFocused;
        if (self.cAction == Store_Action_Focus) {
            self.cAction = Store_Action_None;
            [self focusToStore];
        } else {
            self.loveBtn.enabled = TRUE;
        }
    }fail:^(NSError *err){
        [GlobalObject showPopup:err.localizedDescription];
        self.cAction = Store_Action_None;
    }];
}

-(void)getStorePhotoes:(NSString*)sId
{
    NillBlock_Array sucBack = ^(NSArray *array){
        self.storePhotoes = [NSMutableArray arrayWithArray:array];
        NSMutableArray *storePhotoes  = [NSMutableArray arrayWithArray:self.storePhotoes];
        int delCount = 0;
        for (int k = 0;k<storePhotoes.count;k++) {
            StorePhotos *photo = storePhotoes[k];
            if (!IsSafeString(photo.thumbnail_image)) {
                [self.storePhotoes removeObjectAtIndex:k-delCount];
                delCount++;
            }
        }
        storePhotoes = nil;
        
        [self.storePhotoes sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            StorePhotos *photo1 = (StorePhotos*)obj1;
            StorePhotos *photo2 = (StorePhotos*)obj2;
            
            return [photo1.name compare:photo2.name];
        }];
        
        if (self.storePhotoes.count > 0) {
            if (self.hadInitTable) {
                [self.contentTable beginUpdates];
                [self.contentTable insertSections:[NSIndexSet indexSetWithIndex:FIELD_STORE_PHOTO] withRowAnimation:UITableViewRowAnimationFade];
                [self.contentTable endUpdates];
            } else {
                [self reloadITable];
            }

        }
    };
    
    NSArray *photoes = [GKStoreSortListService getStorePhotoes:sId refreshed:FALSE succ:^(NSArray *array) {
        sucBack(array);
    } fail:^(NSError *err) {
        
    }];
    
    if (photoes && photoes.count > 0) {
        sucBack(photoes);
    }
}

-(void)focusToStore
{
    self.loveBtn.enabled = FALSE;
    [GKStoreSortListService focusStore:self.storeDetailInfo.id isFocus:hadFocused success:^(void){
        self.loveBtn.enabled = TRUE;
        focusChanged = TRUE;
        hadFocused = !hadFocused;
        
        [self showTopPop:hadFocused?@"关注成功":@"已经取消关注"];
        [self.loveBtn setImage:[UIImage imageNamed:hadFocused?StoreInfoC_LoveIcon:StoreInfoC_UnLoveIcon] forState:UIControlStateNormal];
        self.totalFocusLabel.text = [NSString stringWithFormat:@"%d",hadFocused ?[self.totalFocusLabel.text intValue] + 1 : [self.totalFocusLabel.text intValue] - 1 ];
        [[NSNotificationCenter defaultCenter] postNotificationName:hadFocused?Notification_StoreFocus:Notification_StoreUnFocus object:self.storeDetailInfo.id];
        
    }fail:^(NSError *err){
        self.loveBtn.enabled = TRUE;
        if ([err.domain isEqualToString:GK_ERROR_DOMAIN] && err.code == GK_ERROR_FOCUS_STATUS_EXCEPTION) {
            hadFocused = TRUE;
            [self.loveBtn setImage:[UIImage imageNamed:hadFocused?StoreInfoC_LoveIcon:StoreInfoC_UnLoveIcon] forState:UIControlStateNormal];
            return ;
        }
        [GlobalObject showPopup:err.localizedDescription];
    }];
}

-(void)CallPhone:(NSString*)phoneNum{
    
    
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
    
    if ( !phoneCallWebView ) {
        
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];// 这个webView只是一个后台的容易 不需要add到页面上来  效果跟方法二一样 但是这个方法是合法的
    }
    
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    
}

-(void)reloadITable
{
    [self.contentTable reloadData];
    self.hadInitTable = TRUE;
}




#pragma mark -
#pragma mark event handler -
//-(void)expandCell:(UIButton *)sender
//{
//    NSInteger tag = sender.tag;
//    
//    NSInteger row = (tag - 1000) /2;
//    
//    NSNumber *nStatus  = [self.openStatusArray objectAtIndex:row];
//    BOOL blStatus;
//    if (!nStatus || ![nStatus boolValue]) {
//        blStatus = TRUE;
//    } else {
//        blStatus = FALSE;
//    }
//    
//    NSInteger rowIndex = row;
//    for (int k = 0; k < row; k++) {
//        NSNumber *nStatus = [self.openStatusArray objectAtIndex:k];
//        if (nStatus && [nStatus boolValue]) {
//            rowIndex++;
//        }
//    }
//    
//    NSInteger index = 0;
//    if (self.storePhotoes && self.storePhotoes.count > 0) {
//        index++;
//    }
//    [self.openStatusArray replaceObjectAtIndex:row withObject:[NSNumber numberWithBool:blStatus]];
//    
//    [self.contentTable beginUpdates];
//    [self.contentTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:rowIndex inSection:index]] withRowAnimation:UITableViewRowAnimationNone];
//    
//    if (blStatus) {
//        [self.contentTable  insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:(rowIndex+1) inSection:index]] withRowAnimation:UITableViewRowAnimationFade];
//    } else {
//        [self.contentTable  deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:(rowIndex+1) inSection:index]] withRowAnimation:UITableViewRowAnimationFade];
//    }
//
//    [self.contentTable  endUpdates];
//}

-(void)goback
{
    if (self.unloadDelegate && [self.unloadDelegate respondsToSelector:@selector(storeInfoCtrllerWillUnload:)]) {
        [self.unloadDelegate performSelector:@selector(storeInfoCtrllerWillUnload:) withObject:[NSNumber numberWithBool:focusChanged?hadFocused:1]];
    }
      [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)QRClick:(id)sender {
    if ([self isLogoned]){
        GKQRViewController *vc = [[GKQRViewController alloc] initWithNibName:@"GKQRViewController" bundle:nil needTab:NO closeStyle:QRCloseStyle_DismissDown];
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentFullViewController:nvc animated:YES completion:nil];
        
    }else{
        self.cAction = Store_Action_QR;
    }
}

- (IBAction)shareClick:(id)sender {
    [SNSShareView show:CGPointMake(0, APP_SCREEN_HEIGHT-APP_TABBAR_HEIGHT-160) fullScreen:FALSE handler:^(NSString *plateName) {
        NSString *shareCouponstr = IsSafeString(self.storeDetailInfo.coupon_title)?[NSString stringWithFormat:@":%@",self.storeDetailInfo.coupon_title]:@"";
        NSString *shareContent = [NSString stringWithFormat:SHARE_TIP,self.storeDetailInfo.name,shareCouponstr];
        UIImage *shareImage =  [UIImage imageNamed:@"IOS114.png"] ;

        if ([plateName isEqualToString:UMShareToWechatTimeline]) {
            [UMSocialData defaultData].extConfig.title = shareContent;
        } else if([plateName isEqualToString:UMShareToWechatSession]) {
            [UMSocialData defaultData].extConfig.title = ShareTitleWithWX;
        }
        
        [[UMSocialControllerService defaultControllerService] setShareText:shareContent shareImage:shareImage socialUIDelegate:self];
        [UMSocialSnsPlatformManager getSocialPlatformWithName:plateName].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    }];
    
    self.cAction = Store_Action_Share;
}

- (IBAction)focusClick:(id)sender {
    if ([self isLogoned])
        [self focusToStore];
    else
        self.cAction = Store_Action_Focus;
}

- (IBAction)commentClick:(id)sender {
    if ([self isLogoned]) {
        GKCommentReleaseCtrller *vc =[[GKCommentReleaseCtrller alloc] initWithStore:self.storeDetailInfo];
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentFullViewController:nvc animated:YES completion:nil];
    } else {
        self.cAction = Store_Action_Comment;
    }
}

-(BOOL)isLogoned
{
    BOOL isLogoned= [GlobalDataService isLogoned];
    
    if (!isLogoned) {
        GKLogonCtroller *logonVc = [[GKLogonCtroller alloc] init];
        self.logonController = logonVc;
        
        UINavigationController *vc  = [[UINavigationController alloc] initWithRootViewController:logonVc];
        [vc setNavigationBarHidden:YES];
        [self presentFullScreenViewController:vc animated:YES completion:nil];
    }
    
    return isLogoned;
}

-(BOOL)logonCancel
{
    self.cAction = Store_Action_None;
    return TRUE;
}

-(void)logonSuccess
{
    if (self.logonController) {
        [self dismissFullScreenViewControllerAnimated:WSDismissStyle_AlphaAnimation completion:^{
            self.logonController = nil;
            if (self.cAction == Store_Action_QR) {
                GKQRViewController *vc = [[GKQRViewController alloc] initWithNibName:@"GKQRViewController" bundle:nil needTab:NO closeStyle:QRCloseStyle_DismissDown];
                UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
                [self presentFullViewController:nvc animated:YES completion:nil];
            } else if(self.cAction == Store_Action_Focus) {
                [self focusToStore];
            } else if(self.cAction == Store_Action_Comment) {
                GKCommentReleaseCtrller *vc =[[GKCommentReleaseCtrller alloc] initWithStore:self.storeDetailInfo];
                UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
                [self presentFullViewController:nvc animated:YES completion:nil];
            }
        }];
    }
    
    if (self.cAction != Store_Action_Focus || !self.logonController) {
        [self getFocusStatus:self.storeDetailInfo.id];
    }
}

-(void)gotoPhotoPreviw:(id)sender
{
    WSImageView *imgV = sender;
    
    int focus =  imgV.tag;
    
    GK_PhotoPreviewCtrller *vc  = [[GK_PhotoPreviewCtrller alloc] initWtihPhotoList:self.storePhotoes offset:focus];
    CGRect rect = imgV.frame;
    rect = [self.view convertRect:rect fromView:imgV.superview];
    vc.startRect = rect;
    vc.delegate = self;
    
    [self presentTransparentViewController:vc];
    
}

-(CGRect)rectForFocus:(NSInteger)index
{
    UITableViewCell *cell =  [self.contentTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UIScrollView *scrollV = (UIScrollView*)[cell viewWithTag:TableCellPhotoScrollViewTag];
//    CGRect rect = CGRectMake(0, 0, StorePhotoWidth, StorePhotoHeight) ;
//    rect.origin.x = (StorePhotoWidth + StorePhotoGap) * index;
    CGRect rect =  ((WSImageView*)scrollV.subviews[index]).frame;
    [scrollV scrollRectToVisible:rect animated:FALSE];
    rect = ((WSImageView*)scrollV.subviews[index]).frame;
    
    rect = [self.view convertRect:rect fromView:scrollV];
    return rect;
}


-(void)gotoDiscussView:(id)sender
{
    GKCommentListCtrller *vc =[[GKCommentListCtrller alloc] initWithStore:self.storeDetailInfo];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentFullViewController:nvc animated:YES completion:nil];
}


#pragma mark -
#pragma mark Network Service -
-(void)getComments
{
    [GKCommentService GetCommentList:storeId index:1 num:CommentShowNum rank:NOT_DEFINED refresh:FALSE
                                succ:^(NSObject *obj, BOOL nextEnabled, BOOL isOffLine, BOOL isCache) {
                                    BOOL replace = FALSE;
                                    if (IsSafeArray(self.commentList)) {
                                        replace = TRUE;
                                    }
                                    
                                    self.commentList = (NSArray*)obj;
                                    self.nextComments = nextEnabled;
                                    if (IsSafeArray(self.commentList)) {
                                        if (self.hadInitTable) {
                                            NSInteger section =  [self numberOfSectionsInTableView:self.contentTable] - 1;

                                            if (!replace) {
                                                [self.contentTable insertSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationBottom];
                                            } else {
                                                [self.contentTable reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
                                            }

                                        } else {
                                            [self reloadITable];
                                        }
                                    }
                                } fail:^(NSError *err) {
                                    
                                }];
}

#pragma mark -
#pragma mark table datasource & delegate  -


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int retValue  = 1;
    
    if (self.couponArray && self.couponArray.count > 0){
        retValue++;
    }
    if (self.storePhotoes && self.storePhotoes.count > 0) {
        retValue++;
    }
    
    if (IsSafeArray(self.commentList)) {
        retValue++;
    }
    
    return retValue;
}




//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    static NSString *sectionTitle[] = {nil,@"当前促销",@"商家信息",nil};
//    
//    NSInteger index = [self transFieldIndex:section];
//    return sectionTitle[index]; //[NSString stringWithUTF8String:sectionTitle[index]];
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger index = [self transFieldIndex:section];

    switch (index) {
        case FIELD_COUPON:
        {
            NSInteger rowNum = self.couponArray.count;
//            for (NSNumber *openStatus in self.openStatusArray) {
//                if ([openStatus boolValue]) {
//                    rowNum++;
//                }
//            }
            return rowNum;
        }
        case FIELD_STORE_CONTACT:
            return 3;
        case FIELD_STORE_DISCUSS:
//            if (!IsSafeArray(self.commentList))
//                return 1;
//            else
            return self.commentList.count + (self.nextComments ? 1 : 0);
        default:
            return 1;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static char *cellIdentifier[] = {"StorePhotoCell","CouponTitleCell","storeDetailCell","DiscussCell"};
    
    UITableViewCell *cell;
    
    __block BOOL isNewCell = FALSE;
    
    Block_CreateCell createCellBlock = ^(NSString *identify){
        UITableViewCell *cell =  isGetCellHeight?nil: [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            isNewCell = TRUE;
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            UIView *selectV = [[UIView alloc] initWithFrame:cell.frame];
            selectV.backgroundColor = colorWithUtfStr(Color_TableSelector);
            cell.selectedBackgroundView = selectV;
            
            if (IOS_VERSION >= 7.0) cell.separatorInset = UIEdgeInsetsZero;
            else cell.backgroundView = [[UIView alloc] init];
        }
        return cell;
    };
    
    NSInteger index = [self transFieldIndex:indexPath.section];
    switch (index) {
        case FIELD_STORE_PHOTO:
        {
            cell = createCellBlock([NSString stringWithUTF8String:cellIdentifier[index]]);
            UIScrollView *scrollV = (UIScrollView*)[cell viewWithTag:TableCellPhotoScrollViewTag];
            
            if (!scrollV) {
                float x,width;
                
                if (IOS_VERSION >= 7.0) {
                    x = 0 ;
                    width = tableView.frame.size.width;
                } else {
                    width = TableCMMRowWidth;
                    x = (tableView.frame.size.width - width ) /2;
                }
                
                scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(x, 0, width, StorePhotoWidth)];
                [scrollV setTag:TableCellPhotoScrollViewTag];
                [cell addSubview:scrollV];

                scrollV.showsHorizontalScrollIndicator = FALSE;
                cell.backgroundColor = [UIColor clearColor];
                
                CGRect rect = CGRectMake(0, 0, StorePhotoWidth , StorePhotoWidth);
                
                int index = 0;
                
             //   [scrollV.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                for (StorePhotos *photo in self.storePhotoes) {
                    
                    if (IsSafeString(photo.thumbnail_image)) {
                        UIView *v = [[UIView alloc] initWithFrame:rect];
                        [v move:index * (StorePhotoWidth + StorePhotoGap) direct:Direct_Right];

                        WSImageView *imgV = [[WSImageView alloc] initWithFrame:rect];
                        [imgV showUrl:[NSURL URLWithString:photo.thumbnail_image] activity:YES palce:[WSWarningImage ImageForWarning:@"网络获取失败" font:Nil color:nil]];
                        [imgV setTag:index];
                        [imgV addTarget:self action:@selector(gotoPhotoPreviw:) forControlEvents:UIControlEventTouchUpInside];
                        
                        [v addSubview:imgV];
                        
                        [scrollV addSubview:v];
                        
                        index++;
                    }
                }
                [scrollV setContentSize:CGSizeMake(index * StorePhotoWidth + (index - 1)*StorePhotoGap, StorePhotoHeight)];
                cell.selectionStyle =  UITableViewCellSelectionStyleNone;

            }
            break;
        }
        case FIELD_COUPON:
        {
            cell = createCellBlock([NSString stringWithUTF8String:cellIdentifier[index]]);

            UILabel *label;
            if (isNewCell) {
                if (IOS_VERSION >= 7.0) {
                    label = cell.textLabel;
                    cell.backgroundColor = [UIColor whiteColor];
                } else {
                    UIView *cellView = [[UILabel alloc] initWithFrame:CGRectMake((tableView.frame.size.width - TableCMMRowWidth)/2, indexPath.row == 0? 0: 0, TableCMMRowWidth, indexPath.row == 0 ? TableCellCMMHeight :(TableCellCMMHeight - 1))];
                    cellView.tag = TableCellTitleViewForIOS6;
                    cellView.backgroundColor = [UIColor whiteColor];
                    label = [[UILabel alloc] initWithFrame:CGRectMake(TitleLabelInsetWithIOS6, 0, cellView.frame.size.width - TitleLabelInsetWithIOS6 -40, cellView.frame.size.height)];
                    label.tag = TableCellCustomTitleLabelTag;
                    [cellView addSubview:label];
                    [cell addSubview:cellView];
                }
                
                label.font = FONT_NORMAL_13;
                label.textColor = colorWithUtfStr(StoreInfoC_TableCellTitleColor);
                
                float width = (IOS_VERSION >= 7.0) ? 40 : 60;
                UIView *accessView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 35)];
                UIButton *accessBtn = [[UIButton alloc] initWithFrame:accessView.frame];
                accessView.backgroundColor = cell.backgroundColor;
                [accessView addSubview:accessBtn];
                accessView.userInteractionEnabled = FALSE;
                [accessBtn setImage:[UIImage imageNamed: StoreInfoC_TableCouponCellRightArrow] forState:UIControlStateNormal];
                accessBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 35, 0, 0);
                accessBtn.titleEdgeInsets = UIEdgeInsetsMake(2, 0, 0, 0);
                accessBtn.titleLabel.font = FONT_NORMAL_11;
                [accessBtn setTitleColor:colorWithUtfStr(StoreInfoC_TopStatusValueColor) forState:UIControlStateNormal];
                [accessBtn setTitle:@"详情" forState:UIControlStateNormal];
                cell.accessoryView = accessView;
            } else {
                if (IOS_VERSION >= 7.0) {
                    label = cell.textLabel;
                } else {
                    UIView *cellView = [cell viewWithTag:TableCellTitleViewForIOS6];
                    label = (UILabel*)[cellView viewWithTag:TableCellCustomTitleLabelTag];
                }
            }
            
            Coupon *coupon = [self.couponArray objectAtIndex:indexPath.row];
            label.text = coupon.title;

            break;
        }
            
        case FIELD_STORE_CONTACT:
        {
            cell = createCellBlock([NSString stringWithUTF8String:cellIdentifier[index]]);
            
            UILabel *label,*addressLabel;
            UIView *cellView;
            
            if (isNewCell) {
                if (IOS_VERSION >= 7.0) {
                    label = cell.textLabel;
                    cell.backgroundColor = colorWithUtfStr(StoreInfoC_TopStatusBgColor);
                } else  {
                    cellView = [[UILabel alloc] initWithFrame:CGRectMake((tableView.frame.size.width - TableCMMRowWidth)/2, indexPath.row == 0? 0: 0, TableCMMRowWidth, indexPath.row == 0 ? TableCellCMMHeight :(TableCellCMMHeight - 1))];
                    cellView.tag = TableCellTitleViewForIOS6;
                    cellView.backgroundColor = colorWithUtfStr(StoreInfoC_TopStatusBgColor);
                    label = [[UILabel alloc] initWithFrame:CGRectMake(TitleLabelInsetWithIOS6, 0, cellView.frame.size.width - TitleLabelInsetWithIOS6 -40, cellView.frame.size.height)];
                    label.tag = TableCellCustomTitleLabelTag;
                    label.backgroundColor = cellView.backgroundColor;
                    [cellView addSubview:label];
                    [cell addSubview:cellView];
                }
                
                label.font = FONT_NORMAL_13;
                label.textColor = colorWithUtfStr(StoreInfoC_TopStatusTitleColor);

            } else {
                if (IOS_VERSION >= 7.0) {
                    label = cell.textLabel;
                    addressLabel = (UILabel*)[cell viewWithTag:TableCellAddressLabelTag];
                } else {
                    cellView = [cell viewWithTag:TableCellTitleViewForIOS6];
                    label = (UILabel*)[cellView viewWithTag:TableCellCustomTitleLabelTag];
                    addressLabel = (UILabel*)[cellView viewWithTag:TableCellAddressLabelTag];
                }
            }
            
            NSString *title;;
            switch (indexPath.row) {
                case 0:
                {
                    title = [NSString stringWithFormat:@"地址："];
                    if (!addressLabel) {
                        addressLabel = [[UILabel alloc ]  initWithFrame:CGRectMake(55, -2 , cell.frame.size.width - 110, cell.frame.size.height)];
                        addressLabel.tag = TableCellAddressLabelTag;
                        
                        addressLabel.backgroundColor = label.backgroundColor;
                        addressLabel.numberOfLines = 0;
                        addressLabel.font = label.font;
                        addressLabel.textColor = label.textColor;
                        addressLabel.textAlignment = NSTextAlignmentLeft;
                        if (IOS_VERSION < 7.0) {
                            [cellView addSubview:addressLabel];
                        } else {
                            [cell addSubview:addressLabel];
                        }
                    }
                    
                    addressLabel.text = SafeString(self.storeDetailInfo.address);
                    break;
                }
                case 1:
                {
                    title = [NSString stringWithFormat:@"电话： %@",self.storeDetailInfo.phone];
                    break;
                }
                case 2:
                {
                    title = [NSString stringWithFormat:@"营业时间： %@",self.storeDetailInfo.hours];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    break;
                }
            }
            
            label.text = title;

            static NSString* icons[] = {StoreInfoC_DistanceIcon,StoreInfoC_CallIcon,Nil};
            if (IsSafeString(icons[indexPath.row])) {
                UIImageView *v = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icons[indexPath.row]]];
                [v setFrame:CGRectMake(0, 0, StoreInfoC_DistanceIconWidth, StoreInfoC_DistanceIconHeight)];
                cell.accessoryView = v;
            }
            
            break;
        }
            
        case FIELD_STORE_DISCUSS:
        {
      //      NSInteger row = [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1;
            NSString *defaultIdenitifier = [NSString stringWithUTF8String:cellIdentifier[index]];
            NSString *identifier = (CommentShowNum == indexPath.row?[NSString stringWithFormat:@"%@More",defaultIdenitifier] :defaultIdenitifier) ;
            cell = createCellBlock(identifier);
            if (isNewCell) {
                if (indexPath.row == CommentShowNum && self.nextComments) {
                    UIView *cellView;
                    UILabel *label;
                        if (IOS_VERSION >= 7.0) {
                            label = cell.textLabel;
                            cell.backgroundColor = colorWithUtfStr(StoreInfoC_TopStatusBgColor);
                        } else  {
                            cellView = [[UILabel alloc] initWithFrame:CGRectMake((tableView.frame.size.width - TableCMMRowWidth)/2, indexPath.row == 0? 0: 0, TableCMMRowWidth, indexPath.row == 0 ? TableCellCMMHeight :(TableCellCMMHeight - 1))];
                            cellView.tag = TableCellTitleViewForIOS6;
                            cellView.backgroundColor = colorWithUtfStr(StoreInfoC_TopStatusBgColor);
                            label = [[UILabel alloc] initWithFrame:CGRectMake(TitleLabelInsetWithIOS6, 0, cellView.frame.size.width - TitleLabelInsetWithIOS6 -40, cellView.frame.size.height)];
                            label.tag = TableCellCustomTitleLabelTag;
                            label.backgroundColor = cellView.backgroundColor;
                            [cellView addSubview:label];
                            [cell addSubview:cellView];
                        }
                    label.text = @"查看全部评论";
                    label.textAlignment = NSTextAlignmentCenter;
                    label.font = FONT_NORMAL_13;
                    label.textColor = colorWithUtfStr(Color_PageCtrllerNormalColor);
                } else {
                    CommentCell *v = [CommentCell XIBView];
                    if (IOS_VERSION < 7.0) {
                        float x,width;
                        
                        width = TableCMMRowWidth;
                        x = (tableView.frame.size.width - width ) /2;
                        CGRect rect = v.frame;
                        rect.origin.x = x;
                        rect.size.width = width;
                        v.frame = rect;
                    } else {
                        float width = tableView.frame.size.width;
                        CGRect rect = v.frame;
                        rect.size.width =width;
                        cell.frame = rect;
                    }
                    v.tag = TableCellCommentTag;
                    [cell addSubview:v];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.userInteractionEnabled = FALSE;
                    testV = v;
                }
            }
            if(CommentShowNum != indexPath.row || !self.nextComments) {
                Comment *comment = self.commentList[indexPath.row];
                CommentCell *v = (CommentCell*)[cell viewWithTag:TableCellCommentTag];
                v.rankTag = [comment.rank intValue];
                v.name = SafeString(comment.owner_name);
                v.dateLabel.text = SafeString(comment.created);
                v.comment = SafeString(comment.subject);
            }
            break;
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [self transFieldIndex:indexPath.section];

    switch (index) {
        case FIELD_STORE_PHOTO:
            return StorePhotoWidth;
        case FIELD_STORE_DISCUSS:
        {
            if (([self tableView:tableView numberOfRowsInSection:indexPath.section] - 1 == indexPath.row)&&self.nextComments) {
                return TableCellCMMHeight;
            } else {
                return CommentCellCMMHeight;
            }
        }
        default:
            return TableCellCMMHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    int org = section;
    section = [self transFieldIndex:section];
    float height  = 0;
    
    if (section == FIELD_COUPON || section == FIELD_STORE_DISCUSS) {
        height =  25;
    }
    
    if (height == 0 && org != 0) {
        height += 1;
    }
    
    return height;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    section = [self transFieldIndex:section];
    
    if (section == FIELD_COUPON || section == FIELD_STORE_DISCUSS) {
        static NSString *sectionTitle[] = {nil,@"当前促销",nil,@"用户评论"};

        float width,x ;
        if (IOS_VERSION >= 7.0) {
            width = tableView.frame.size.width;
            x = 0;
        } else {
            width = TableCMMRowWidth;
            x = (tableView.frame.size.width - TableCMMRowWidth ) /2;
        }
        
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 25)];
        UILabel *labale = [[UILabel alloc] initWithFrame:CGRectMake(x, 0,width , 25)];
        labale.text = sectionTitle[section];
        labale.backgroundColor = colorWithUtfStr(StoreInfoC_TableSectionTitleBgColor);
        labale.textColor = [UIColor whiteColor];
        labale.font = FONT_NORMAL_13;
        labale.textAlignment = NSTextAlignmentCenter;
        labale.autoresizingMask = UIViewAutoresizingNone;
        [v addSubview:labale];
        return v;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [self transFieldIndex:indexPath.section];

    if(index == FIELD_STORE_CONTACT && indexPath.row == 0)
    {
        if (self.storeDetailInfo.latitude  > 0 || self.storeDetailInfo.longitude > 0) {
            CLLocation *storLocation = [[CLLocation alloc] initWithLatitude:self.storeDetailInfo.latitude longitude:self.storeDetailInfo.longitude];
           [GlobalObject pushOwnPositionInsideMap:storLocation in:(UIViewController*)self title:self.storeDetailInfo.name];

        }
        
    } else if(index == FIELD_STORE_CONTACT && indexPath.row == 1){
        if (checkPhoneNo(self.storeDetailInfo.phone) || checkMobileNo(self.storeDetailInfo.phone) || checkLocPhoneNo(self.storeDetailInfo.phone) || check400PhoneNo(self.storeDetailInfo.phone))  {
            [self CallPhone:self.storeDetailInfo.phone];

        }
        
        //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.storeDetailInfo.phone]]];
    } else if(index == FIELD_COUPON){
        GKCouponInforController *vc =[[GKCouponInforController alloc] initWithCoupon:self.couponArray focus:indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (index == FIELD_STORE_DISCUSS){
        [self gotoDiscussView:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}


//- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
//{
//    NSInteger index = indexPath.section;
//    if (!self.couponArray || self.couponArray.count == 0){
//        index++;
//    }
//    
//    if (index == 0) {
//        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        NSInteger row = (cell.tag - 1000) /2;
//        
//        NSNumber *nStatus  = [self.openStatusArray objectAtIndex:row];
//        BOOL blStatus;
//        if (!nStatus || ![nStatus boolValue]) {
//            blStatus = TRUE;
//        } else {
//            blStatus = FALSE;
//        }
//        [self.openStatusArray replaceObjectAtIndex:row withObject:[NSNumber numberWithBool:blStatus]];
//        
//        [tableView beginUpdates];
//        if (blStatus) {
//            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
//        } else {
//            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
//        }
//        
//        [tableView endUpdates];
// 
//    }
//}

#pragma mark -
#pragma mark owner init function -
-(void)initToolBar
{
    self.shareBtn.backgroundColor = colorWithUtfStr(StoreInfoC_TableSectionTitleBgColor);
    self.loveBtn.backgroundColor = colorWithUtfStr(StoreInfoC_TableSectionTitleBgColor);
    self.discussBtn.backgroundColor = colorWithUtfStr(StoreInfoC_TableSectionTitleBgColor);
    self.qrBtn.backgroundColor = colorWithUtfStr(StoreInfoC_TableCellTitleColor);
    
    UIView *border = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.toolBarView.frame.size.width, 2)];
    border.backgroundColor =  [UIColor colorWithRed:.9f green:.9f blue:.9f alpha:.8f];
    [self.toolBarView addSubview:border];

}
#pragma mark -
#pragma mark UMService Delegate -

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        [self showTopPop:@"分享成功"];
    } else if (response.responseCode == UMSResponseCodeCancel){
        
    } else {
        [self showTopPop:@"分享失败"];
    }
}

#pragma mark -
#pragma mark notification handler -
-(void)updateComment:(NSNotification*)notification
{
    Comment *store = notification.object;
    if ([store.sid isEqualToString:storeId])
        [self getComments];
}

@end

@implementation UiViewWithStoreInfoC
@end
@implementation UILabelWithStoreInfoC
@end
@implementation UILabelWithStoreInfoC_TopStatus_Title
@end




