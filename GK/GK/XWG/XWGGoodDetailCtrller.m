//
//  XWGGoodDetailCtrller.m
//  GK
//
//  Created by W.S. on 13-8-28.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "XWGGoodDetailCtrller.h"
#import "XWGWebCtrller.h"
#import "GlobalObject.h"
#import "SNSShareView.h"



#define  DescriptionTxtColor "#666666"
#define  NameTxtCorlor "#FF6699"

//【商品标题】+【￥价格】+商品淘宝客URL或商品URL；微信朋友圈的分享模板则为：商品小图+【商品标题】+【￥价格】
#define SHARE_TIP @"【%@】【￥%d】 %@ "
#define ShareTitleWithWX @"分享个宝贝给你"
@interface XWGGoodDetailCtrller ()<UIScrollViewDelegate>
@property (nonatomic,strong) NSString *clickUrl;
@property (nonatomic,strong) NSMutableArray *clickUrlHandlers;
@property (nonatomic,assign) BOOL isGettingClickUrl;

@property (nonatomic,strong) GKLogonCtroller *logonController;
//@property (nonatomic,strong) NSMutableArray *ownXWGLoveList;
@end



@implementation XWGGoodDetailCtrller

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil style:VIEW_NOBAR];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}



-(id)initWithGood:(GoodsInfo*)good
{
    self = [self init];
    if(self){
        iGood = good;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initViewUI];
    [self updateUIWithData];
    [self refreshLoveStatus];
    
#if 1 //淘宝客暂时关闭
    self.clickUrl = iGood.url;
#else
    [self getClickUrl:nil fail:nil];
#endif
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loveGood:) name:NOTIFICATION_GOOD_LOVED object:Nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loveGood:) name:NOTIFICATION_GOOD_UNLOVED object:Nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    iGood = nil;
    [self setImgV:nil];
    [self setLoveLabel:nil];
    [self setDescriptionLabel:nil];
    [self setBuyBtn:nil];
    [self setBottomCView:nil];
    [self setLoveBtn:nil];
    [self setTitleLabel:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark Initer -
-(void)initViewUI
{
    [[UILabelWithGoodDeatil appearance] setTextColor:colorWithUtfStr(XWGGGC_NormalTextColor)];
    
    [self.imgV setImageContentMode:UIViewContentModeScaleAspectFill];
    self.imgV.imgV.clipsToBounds = YES;
    
    self.imgBottomBK.backgroundColor =  colorWithUtfStr(XWGGGC_ImgBKColor);
    
    self.titleLabel.numberOfLines = 0;
    self.descriptionLabel.numberOfLines = 0;
    
    self.loveLabel.textColor = colorWithUtfStr(XWGGGC_ImportTextColor);
    self.sharerLabel.textColor = colorWithUtfStr(XWGGGC_ImportTextColor);
    
    self.scrollContentV.backgroundColor = self.view.backgroundColor;
    self.contentView.backgroundColor = self.view.backgroundColor;
    
    [self initToolBar];
}

-(void)initToolBar
{
    self.shareBtn.backgroundColor = colorWithUtfStr(StoreInfoC_TableSectionTitleBgColor);
    self.loveBtn.backgroundColor = colorWithUtfStr(StoreInfoC_TableSectionTitleBgColor);
    self.buyBtn.backgroundColor = colorWithUtfStr(StoreInfoC_TableCellTitleColor);
    
//    if (IOS_VERSION < 7.0) {
//        [self.toolBar move:APP_STATUSBAR_HEIGHT direct:Direct_Up];
//    }
}

-(void)updateUIWithData
{

    
    if (IsSafeString(iGood.title)) {
        self.titleLabel.text = iGood.title;
    } else{
        self.titleLabel.hidden = YES;
    }
    
    if (IsSafeString(iGood.description)) {
        self.descriptionLabel.text = iGood.description;
    } else {
        self.descriptionLabel.hidden = YES;
    }
    
    if (IsSafeString(iGood.owner_id)) {
        [self getUserName];
    } else {
        self.sharerLabel.text = @"贵客";
    }
    
    self.loveLabel.text = [NSString stringWithFormat:@"%d人喜欢",iGood.user_favorites];

    [self.buyBtn setTitle:[NSString stringWithFormat:@"RMB %d 去购买",[iGood.price intValue]] forState:UIControlStateNormal];
    [self layout];
    if (IsSafeString(iGood.large_image_url)) {
        [self.imgV showUrl:[NSURL URLWithString:iGood.large_image_url] activity:YES palce:Nil ];
    }
    
}

#define ScrollViewInsertY 40

-(void)layout
{
    
    float orgY = self.loveLabel.frame.origin.y;
    
    [self.descriptionLabel reAliginWith:self.titleLabel idirect:Direct_Down gap:2];
    [self.shareTitleLabel reAliginWith:self.descriptionLabel idirect:Direct_Down gap:5];
    [self.sharerLabel reAliginWith:self.descriptionLabel idirect:Direct_Down gap:5];
    [self.loveLabel reAliginWith:self.sharerLabel idirect:Direct_Down gap:0];
    
    float bHeight = self.bottomCView.frame.size.height + self.loveLabel.frame.origin.y - orgY;
    
    float y = self.toolBar.frame.origin.y;
    if (IOS_VERSION < 7.0)  y -= APP_STATUSBAR_HEIGHT;
    
    CGRect rect = self.bottomCView.frame;
    rect.origin.y = y - bHeight - self.scrollContentV.frame.origin.y + ScrollViewInsertY;
    self.bottomCView.frame = CGRectIntegral(rect);

    CGSize size = CGSizeMake(self.imgV.frame.size.width, self.bottomCView.frame.origin.y - self.imgV.frame.origin.y);//+ (IOS_VERSION>=7.0?2:4) );
    [self.imgV strechTo:size];
    
    [self.contentView moveUp:[NSNumber numberWithInt:ScrollViewInsertY]];
    [self.contentView strech:ScrollViewInsertY direct:Direct_Down animation:NO];
    [self.scrollContentV enableScrollFor:self];
    [self.scrollContentV.scrollView setContentInset:UIEdgeInsetsMake(-ScrollViewInsertY, 0, 0, 0)];
    self.scrollContentV.scrollView.delegate = self;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset  = scrollView.contentOffset.y;
    if (yOffset < 0) {
        yOffset = floorf(yOffset);
        float offset = yOffset  - self.contentView.frame.origin.y;
        CGRect f = self.contentView.frame;
        f.origin.y = yOffset;
        f.size.height -= offset ;
        self.contentView.frame = f;
        
        f = self.imgV.frame;
        f.size.height -= offset;
        self.imgV.frame = f;
        [self.bottomCView moveUp:[NSNumber numberWithFloat:offset]];
        
    }
}
#pragma mark -
#pragma mark Event Handler -
- (IBAction)buyClick:(id)sender {
    
    NillBlock_Nill gotoWeb = ^{
        if (IsSafeString(self.clickUrl)) {
            XWGWebCtrller *vc = [[XWGWebCtrller alloc] initWithUrl:self.clickUrl title:iGood.title];
            //[self.navigationController pushViewController:vc animated:YES];
            [self presentViewController:vc animated:YES completion:Nil];
//            [self.navigationController pushViewControllerAnimatedWithTransition:vc];
        }
    };
    
    if (!self.clickUrl) {
        self.status = VIEW_PROCESS_GETTING;
        [NSTimer scheduledTimerWithTimeInterval:CMM_AnimatePerior target:self selector:@selector(showWatting) userInfo:nil repeats:NO];

        [self getClickUrl:^{
            self.status = VIEW_PROCESS_NORMAL;
            [self hideWaitting];
            
            gotoWeb();
        } fail:^(NSError *err) {
            self.status = VIEW_PROCESS_FAIL;
            [self hideWaitting];
            
            [GlobalObject showPopup:err.localizedDescription];
        }];
    } else {
        gotoWeb();
    }
    
    
}

- (IBAction)shareClick:(id)sender {
    NillBlock_Nill gotoWeiBo = ^{
        if (IsSafeString(self.clickUrl)) {
            
            [SNSShareView show:CGPointMake(0, APP_SCREEN_HEIGHT-APP_TABBAR_HEIGHT-160) fullScreen:YES handler:^(NSString *plateName) {
                
                NSString *shareContent = [NSString stringWithFormat:SHARE_TIP,iGood.title,(int)[iGood.price floatValue],self.clickUrl];
                UIImage *shareImage = (self.imgV.imgV && self.imgV.imgV.image )? self.imgV.imgV.image :[UIImage imageNamed:@"IOS114.png"] ;
                
                if ([plateName isEqualToString:UMShareToWechatTimeline]) {
                    [UMSocialData defaultData].extConfig.title = shareContent;
                } else if([plateName isEqualToString:UMShareToWechatSession]) {
                    [UMSocialData defaultData].extConfig.title = ShareTitleWithWX;
                }
                
                [[UMSocialControllerService defaultControllerService] setShareText:shareContent shareImage:shareImage socialUIDelegate:self];
                [UMSocialSnsPlatformManager getSocialPlatformWithName:plateName].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            }];

        }
    };
    
    if (!self.clickUrl) {
        self.status = VIEW_PROCESS_GETTING;
        [NSTimer scheduledTimerWithTimeInterval:CMM_AnimatePerior target:self selector:@selector(showWatting) userInfo:nil repeats:NO];
        
        [self getClickUrl:^{
            self.status = VIEW_PROCESS_NORMAL;
            [self hideWaitting];
            
            gotoWeiBo();
        } fail:^(NSError *err) {
            self.status = VIEW_PROCESS_FAIL;
            [self hideWaitting];
            
            [GlobalObject showPopup:err.localizedDescription];
        }];
    } else {
        gotoWeiBo();
    }

}

- (IBAction)loveClick:(id)sender {
    if (![GlobalDataService isLogoned]) {
        GKLogonCtroller *vc = [[GKLogonCtroller alloc] init];
        vc.logonDelegate = self;
        self.logonController = vc;
       // [self.navigationController pushViewControllerAnimatedWithTransition:vc];

        UINavigationController *Nvc  = [[UINavigationController alloc] initWithRootViewController:vc];
        [Nvc setNavigationBarHidden:YES];
        [self presentFullScreenViewController:Nvc animated:YES completion:nil];
        
    } else {
        [self loveGood];
    }
}

- (IBAction)goback:(id)sender {
    [super goback];
}


#pragma mark -
#pragma mark inside normal function -
-(void)getClickUrl:(NillBlock_Nill)succBack fail:(NillBlock_Error)failBack
{
    if (self.isGettingClickUrl) {
        if (succBack) {
            NSArray *backArray = [NSArray arrayWithObjects:[succBack copy],[failBack copy], nil];
            [self.clickUrlHandlers removeAllObjects];
            [self.clickUrlHandlers addObject:backArray];
        }
        return;
    }
    
    self.clickUrl =  [GKXWGService convertUrl2TBKUrl:iGood.item_id succ:^(NSObject *obj) {
        self.isGettingClickUrl = FALSE;
        self.clickUrl = obj?(NSString*)obj:iGood.url;
        
        for (NSArray* array in self.clickUrlHandlers) {
            NillBlock_Nill block =  [array objectAtIndex:0];
            SAFE_BLOCK_CALL_VOID(block);
        }
        [self.clickUrlHandlers removeAllObjects];
    } fail:^(NSError *err) {
        self.isGettingClickUrl = FALSE;
        self.clickUrl = nil;
        for (NSArray* array in self.clickUrlHandlers) {
            NillBlock_Error block =  [array objectAtIndex:1];
            SAFE_BLOCK_CALL(block,err);
        }
        [self.clickUrlHandlers removeAllObjects];
    }];
    
    if (self.clickUrl) {
        SAFE_BLOCK_CALL_VOID(succBack);
    } else {
        self.isGettingClickUrl = TRUE;
        if (succBack) {
            NSArray *backArray = [NSArray arrayWithObjects:[succBack copy],[failBack copy], nil];
            [self.clickUrlHandlers removeAllObjects];
            [self.clickUrlHandlers addObject:backArray];
        }
    }
}

-(void)getUserName
{
    NillBlock_OBJ   sucCallBack = ^(NSObject* obj){
        if (obj) {
            UserInfo    *user = (UserInfo*)obj;
            NSString    *name = user.name;
            self.sharerLabel.text = name;
        }
    };
    
    UserInfo *user =   [GKXWGService getUserInfo:iGood.owner_id success:^(NSObject *obj) {
        sucCallBack(obj);
    } fail:^(NSError *err) {
    }];
    
    sucCallBack(user);
}

-(void)refreshLoveStatus
{
    if ([GlobalDataService isLogoned]) {
        self.loveBtn.enabled = FALSE;
        
        NillBlock_BOOL succBack = ^(BOOL love){
            loveStatus = love;
            [self.loveBtn setImage:[UIImage imageNamed:loveStatus?StoreInfoC_LoveIcon:StoreInfoC_UnLoveIcon] forState:UIControlStateNormal ];
            self.loveBtn.enabled = TRUE;
        };
        
        [GlobalDataService getXWGLoveStatus:iGood.id succ:^(BOOL love) {
            succBack(love);
        } fail:^(NSError *err) {
            [self.loveBtn setImage:[UIImage imageNamed:loveStatus?StoreInfoC_LoveIcon:StoreInfoC_UnLoveIcon]forState:UIControlStateNormal];
        }];
    } else{
        self.loveBtn.enabled = TRUE;
        [self.loveBtn setImage:[UIImage imageNamed:StoreInfoC_UnLoveIcon] forState:UIControlStateNormal];
    }
}

-(void)loveGood
{

    self.loveBtn.enabled = FALSE;
    
    NillBlock_BOOL succBlock = ^(BOOL status){
        loveStatus = status;
        [self.loveBtn setImage:[UIImage imageNamed:loveStatus?StoreInfoC_LoveIcon:StoreInfoC_UnLoveIcon] forState:UIControlStateNormal];
        self.loveLabel.text = [NSString stringWithFormat:@"%d人喜欢",loveStatus?++iGood.user_favorites:--iGood.user_favorites];
        [self showTopPop:loveStatus?@"成功添加此宝贝至\"我的收藏\"！":@"取消收藏成功"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:loveStatus?NOTIFICATION_GOOD_LOVED:NOTIFICATION_GOOD_UNLOVED object:iGood];
    };
    
    [GKXWGService loveGood:iGood.id hadFocused:loveStatus success:^{
        self.loveBtn.enabled = TRUE;
        succBlock(!loveStatus);
    } fail:^(NSError *err) {
        self.loveBtn.enabled = TRUE;
        [self showTopPop:err.localizedDescription];
        
        if (err.code == 422) {
            succBlock(TRUE);
        }
    }];
}




#pragma mark -
#pragma mark notifiction handler -
-(void)loveGood:(NSNotification*)notification
{
    if (self.viewIsAppear) return;
    
    GoodsInfo *good = notification.object;
    
    if ([good.id isEqualToString:iGood.id]) {
        
        loveStatus = [notification.name isEqualToString:NOTIFICATION_GOOD_LOVED];
        
        [self.loveBtn setImage:[UIImage imageNamed:loveStatus?StoreInfoC_LoveIcon:StoreInfoC_UnLoveIcon] forState:UIControlStateNormal];
        self.loveLabel.text = [NSString stringWithFormat:@"%d人喜欢",loveStatus?++iGood.user_favorites:--iGood.user_favorites];
    }
}
#pragma mark -
#pragma mark logon delegate -
-(void)logonSuccess
{

    [self refreshLoveStatus];
#if 1
    [self dismissFullScreenViewControllerAnimated:WSDismissStyle_AlphaAnimation completion:^{
        self.logonController = nil;
        //[self loveGood];
    }];
#else
    [self.navigationController popViewControllerWithAnimation:NavigationAnimation_AlphaAnimation finished:^{
        [self.logonController.view removeFromSuperview];
        self.logonController = nil;
    }];
#endif
}
@end

@implementation UILabelWithGoodDeatil



@end
