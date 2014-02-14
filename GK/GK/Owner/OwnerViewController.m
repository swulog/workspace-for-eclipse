//
//  OwnerViewController.m
//  GK
//
//  Created by W.S. on 13-5-7.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "OwnerViewController.h"
#import "GKStoreListCtrller.h"
#import "OwnerParentViewController.h"
#import "GKImgCroperViewController.h"
#import "OwnerSetController.h"
#import "GKOwnerService.h"
#import "GlobalObject.h"
#import "OwnerFavouriteCtrller.h"
#import "WSLargeButton.h"
#import "PopoverView.h"
#import "GKQRViewController.h"
#import "TKContactsMultiPickerController.h"
#import "GKCommentService.h"
#import "GKCommentListCtrller.h"
#import "GK_PhotoPreviewCtrller.h"
typedef enum{
    Group0_Start,
    Owner_Msg = Group0_Start,
    Group0_Over,
    Group0_Num = Group0_Over - Group0_Start,

    Group1_Start = Group0_Over,
    Owner_Set = Group1_Start,
    Owner_Invite,
    Owner_Store,
    Group1_Over,
    Group1_Num = Group1_Over - Group1_Start,

    Group2_Start = Group1_Over,
    Owner_Exit = Group2_Start,
    Group2_Over,
    Group2_Num = Group2_Over - Group2_Start,

    Owner_Field_Over = Group2_Over
}Owner_Field;


enum {
    FIELD_Msg,
    FIELD_Complex,
    FIELD_Exit,
    
    GroupNum
};


static const char *ComplexFieldName[] = {"设置","邀请好友","成为商家"};


#define SheetTag_Exit 2000
#define SheetTag_Store 2001

#define TableRowHeight 40

#define TableWidthWithIOS6 310

#define InviteText @"我用#贵客#享受到了本地很多商家超低的折扣！你也试试！  http://m.vipguike.com"

@interface OwnerViewController ()<TKContactsMultiPickerControllerDelegate,PhotoPreviewDelegate>
@property (strong,nonatomic) GKLogonCtroller *logonController;
@property (weak, nonatomic) IBOutlet UILabel *favouriteNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *favouriteTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *focusTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *focusNumLabel;
@end

@implementation OwnerViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil style:VIEW_WITH_NAVBAR];
    if (self) {
        // Custom initialization
        self.tabImageName = [NSString stringWithUTF8String:tabImgNames[GKTAB_Owner]];
       // self.tabTitle = [NSString stringWithUTF8String:tabTitles[GKTAB_Owner]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self initUi];
    
    if ([GlobalDataService isLogoned]) {
        [self updateUIWithData];
    }  else {
        [self showGKLogView:false];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loved:) name:NOTIFICATION_GOOD_LOVED object:Nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loved:) name:NOTIFICATION_GOOD_UNLOVED object:Nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loved:) name:NOTIFICATION_COUPON_LOVED object:Nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loved:) name:NOTIFICATION_COUPON_UNLOVED object:Nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(focused:) name:Notification_StoreFocus object:Nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(focused:) name:Notification_StoreUnFocus object:Nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUIWithData) name:NOTIFICATION_UserInfoUpdated object:Nil];
  //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUIWithData) name:NOTIFICATION_LOGON_OK object:Nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self setTableView:nil];
    [self setIconImg:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark initer -
-(void)initUi
{
    self.favouriteBtn.backgroundColor = colorWithUtfStr(PersonalCenterC_BtnBGColor);
    [self.favouriteBtn setHightedBGColor:colorWithUtfStr(Color_TableSelector)];

    self.focusBtn.backgroundColor = colorWithUtfStr(PersonalCenterC_BtnBGColor);
    [self.focusBtn setHightedBGColor:colorWithUtfStr(Color_TableSelector)];

    self.favouriteTitleLabel.textColor = colorWithUtfStr(PersonalCenterC_BtnTitleColor);
    self.focusTitleLabel.textColor = colorWithUtfStr(PersonalCenterC_BtnTitleColor);
    
    self.favouriteNumLabel.textColor = colorWithUtfStr(PersonalCenterC_BtnValueColor);
    self.focusNumLabel.textColor = colorWithUtfStr(PersonalCenterC_BtnValueColor);
    
    self.tableView.rowHeight = TableRowHeight;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = FALSE;
    self.tableView.sectionHeaderHeight = 0;
    if (IOS_VERSION >= 7.0) {
        [self.tableView setContentInset:UIEdgeInsetsMake(-36, 0, 0, 0)];
    }
   // self.tableView.bounces = FALSE;
    self.tableView.separatorColor = [UIColor whiteColor];
}

#pragma mark -
#pragma mark inside function -

-(void)showGKLogView:(BOOL)animated
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self.gkLogContrainView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:PersonalCenterC_LogViewBg]]];
        [self.gkLogContrainView addSubview:self.gkLogView];
        CGPoint p = self.gkLogContrainView.center;
        p = [self.gkLogContrainView convertPoint:p fromView:self.view] ;
        p.y -= 50;
        self.gkLogView.center = p;
        
        self.gkLog_LogonBtn.backgroundColor = colorWithUtfStr(PersonalCenterC_LogViewLogonBtnBg);
        [self.gkLog_LogonBtn setHightedBGColor:[UIColor lightGrayColor]];
        self.gkLog_LogonBtnDBK.backgroundColor = colorWithUtfStr(PersonalCenterC_LogViewLogonBtnBgBK);
    });
    
    [self.gkLogContrainView setHidden:FALSE animation:animated];
    [self setTitle:@"个人中心"];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HandlerForLogonOK) name:NOTIFICATION_LOGON_OK object:nil];
}

-(void)gotoLogon
{
    GKLogonCtroller *logonVc = [[GKLogonCtroller alloc] init];
   // logonVc.logonDelegate = self;
    logonVc.hidesBottomBarWhenPushed = YES;
    self.logonController =logonVc;
    
    UINavigationController *vc  = [[UINavigationController alloc] initWithRootViewController:logonVc];
    [vc setNavigationBarHidden:YES];
    [self presentFullScreenViewController:vc animated:YES completion:nil];
}

-(void)updateUIWithData
{
    self.gkLogContrainView.hidden = TRUE;

    GKIDInfo *idinfo = GO(GlobalDataService).gUserInfo;
    
    [self setTitle:idinfo.name];
    [self addNavRightItem:nil img:[UIImage imageNamed:PersonalCenterC_QRIcon] action:@selector(showQR)];

    self.favouriteNumLabel.text =  [NSString stringWithFormat:@"%d",(idinfo.share_bookmark_count + idinfo.coupon_bookmark_count)];
    self.focusNumLabel.text = [NSString stringWithFormat:@"%d",idinfo.store_follow_count];
    
    UIImage *defaultImg = [UIImage imageNamed:PersonalCenterC_DefaultIcon];
    if (IsSafeString(idinfo.avatar_url)) {
        [self.iconImg showUrl:[NSURL URLWithString:idinfo.avatar_url] activity:YES palce:defaultImg];
        if (self.iconImg.isWaitting) {
            __block WSImageView *imgVAlias = self.iconImg;
            __block NSString *obserToken = [self.iconImg addObserverForKeyPath:@"isWaitting" task:^(id obj, NSDictionary *change) {
                if (!imgVAlias.isWaitting) {
                    [imgVAlias removeObserverWithBlockToken:obserToken];
                    [imgVAlias addTarget:self action:@selector(gotoPhotoPreviw:) forControlEvents:UIControlEventTouchUpInside];
                }
            }];
        } else {
            [self.iconImg addTarget:self action:@selector(gotoPhotoPreviw:) forControlEvents:UIControlEventTouchUpInside];
        }

    } else{
        [self.iconImg showDefaultImg:defaultImg];
    }
}

-(void)logonSuccess
{
    [self updateUIWithData];
    [self.tableView reloadData];
    if (self.logonController) {
        [self dismissFullScreenViewControllerAnimated:WSDismissStyle_AlphaAnimation completion:^{
            self.logonController = nil;
        }];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_LOGON_OK object:nil];
}



#pragma mark -
#pragma mark event handler -
- (IBAction)logonClick:(id)sender {
    [self gotoLogon];
}

- (IBAction)exitClick:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"您确定退出么？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定", nil];
    [sheet setTag:SheetTag_Exit];
    
    [sheet showInView:APP_DELEGATE.window];
    [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:FIELD_Exit] animated:YES];
}

- (IBAction)favouriteClick:(id)sender {
//    UIButton *btn = sender;
//    btn.backgroundColor = colorWithUtfStr(PersonalCenterC_BtnBGColor);


    OwnerFavouriteCtrller *vc = [[OwnerFavouriteCtrller alloc] initWithNibName:@"OwnerFavouriteCtrller" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    

    
    
}

- (IBAction)focusClick:(id)sender {
//
//    UIButton *btn = sender;
//    btn.backgroundColor = colorWithUtfStr(PersonalCenterC_BtnBGColor);
    
 //   OwnerFocusController *vc = [[OwnerFocusController alloc] initWithNibName:@"OwnerFocusController" bundle:nil];
   GKStoreListCtrller *vc = [[GKStoreListCtrller alloc] initForOwnerFocus];
    [self.navigationController pushViewController:vc animated:YES];
}

//- (IBAction)btnTouchDown:(id)sender {
//    UIButton *btn = sender;
//    btn.backgroundColor = colorWithUtfStr(PersonalCenterC_BtnSelectedColor);
//}
//
//- (IBAction)btnTouchUpOustSide:(id)sender {
//    UIButton *btn = sender;
//    btn.backgroundColor = colorWithUtfStr(PersonalCenterC_BtnBGColor);
//
//}

-(void)gotoMSG:(id)sender
{
    [self showTopPop:@"暂无消息"];
}


-(void)gotoDiscuss:(id)sender
{
    GKCommentListCtrller *vc =[[GKCommentListCtrller alloc] initForOwnerCenter];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)showQR
{
    GKQRViewController *vc = [[GKQRViewController alloc] initWithNibName:@"GKQRViewController" bundle:nil needTab:NO closeStyle:QRCloseStyle_PopRight];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)gotoPhotoPreviw:(id)sender
{
    WSImageView *imgV = sender;
    
    PhotoTransporingObject *photo = [[PhotoTransporingObject alloc] init];
    photo.orgUrlString = GO(GlobalDataService).gUserInfo.avatar_url;
    photo.transporingUrlString = photo.orgUrlString;
    GK_PhotoPreviewCtrller *vc  = [[GK_PhotoPreviewCtrller alloc] initWithTransPhotoList:[NSArray arrayWithObject:photo] offset:0];
    CGRect rect = imgV.frame;
    rect = [self.view convertRect:rect fromView:imgV.superview];
    vc.startRect = rect;
    vc.delegate = self;
    
    [self presentTransparentViewController:vc];
    
}

-(CGRect)rectForFocus:(NSInteger)index
{
    return self.iconImg.frame;
}
#pragma  mark -
#pragma mark notification handler -

-(void)HandlerForLogonOK
{
    
    [self logonSuccess];
}

-(void)loved:(NSNotification*)notification
{
    self.favouriteNumLabel.text =  [NSString stringWithFormat:@"%d",(GO(GlobalDataService).gUserInfo.share_bookmark_count + GO(GlobalDataService).gUserInfo.coupon_bookmark_count)];
}

-(void)focused:(NSNotification*)notification
{
    self.focusNumLabel.text =  [NSString stringWithFormat:@"%d",GO(GlobalDataService).gUserInfo.store_follow_count];
}


#pragma mark -
#pragma mark actionsheet delegate -
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (actionSheet.tag == SheetTag_Store) {
        if (buttonIndex == 0) { //确定
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:GK_STORE_APPSTORE_URL]];
        }

    } else if(actionSheet.tag == SheetTag_Exit){
        if (buttonIndex == 0) {
            [GlobalDataService resetDataService];
            [GKCommentService restCommentService];
            
            [self showGKLogView:YES];

            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LastUser"];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ExitLogon object:nil];
            
        } else {

        }
    }
}

#pragma mark -
#pragma mark table datasource & delegate  -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return GroupNum;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int nums[] = {Group0_Num,Group1_Num,Group2_Num};
    return nums[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TableRowHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"OwnerTableCellIdentifier" ;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        UIView *selectV = [[UIView alloc] initWithFrame:cell.frame];
        selectV.backgroundColor = colorWithUtfStr(Color_TableSelector);
        cell.selectedBackgroundView = selectV;
        
        if (IOS_VERSION >= 7.0) cell.separatorInset = UIEdgeInsetsZero;
        else cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero] ;

    }

    switch (indexPath.section) {
        case FIELD_Msg:
        {
            float x,width;
            
            if (IOS_VERSION >= 7.0) {
                x = 0 ;
                width = tableView.frame.size.width;
            } else {
                width = TableCMMRowWidth;
                x = (tableView.frame.size.width - width ) /2;
            }
            
            UIView *v = [[UIView alloc] initWithFrame:CGRectMake(x, 0, width, TableRowHeight)];
            
            WSLargeButton *msgBtn = [[WSLargeButton alloc] initWithFrame:CGRectMake(0, 0,v.frame.size.width / 2, TableRowHeight)];
            [msgBtn setBackgroundColor:colorWithUtfStr(PersonalCenterC_CellMSGBtnBGColor)];
            [msgBtn setHightedBGColor:colorWithUtfStr(PersonalCenterC_CellMSGBtnSelectedBGColor)];
            [msgBtn setBadgeFillColor:colorWithUtfStr(PersonalCenterC_LogViewLogonBtnBg)];
            [msgBtn setTitle:@"消息中心" forState:UIControlStateNormal];
            [msgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            msgBtn.titleLabel.font = FONT_NORMAL_13;
            [msgBtn addTarget:self action:@selector(gotoMSG:) forControlEvents:UIControlEventTouchUpInside];
            [v addSubview:msgBtn];
            
            WSLargeButton *discussBtn = [[WSLargeButton alloc] initWithFrame:CGRectMake(msgBtn.frame.size.width,0,v.frame.size.width / 2, TableRowHeight)];
            [discussBtn setBackgroundColor:colorWithUtfStr(PersonalCenterC_LogViewLogonBtnBg)];
            [discussBtn setHightedBGColor:colorWithUtfStr(PersonalCenterC_CellMSGBtnSelectedBGColor)];
            [discussBtn setBadgeFillColor:colorWithUtfStr(PersonalCenterC_CellMSGBtnBGColor)];

            [discussBtn setTitle:@"我发表的评论" forState:UIControlStateNormal];
            [discussBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            discussBtn.titleLabel.font = FONT_NORMAL_13;
            [discussBtn addTarget:self action:@selector(gotoDiscuss:) forControlEvents:UIControlEventTouchUpInside];
            [v addSubview:discussBtn];
            [cell addSubview:v];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        }
        case FIELD_Complex:
        {
            UILabel *label;
            if (IOS_VERSION >= 7.0) {
                label = cell.textLabel;
                cell.backgroundColor = colorWithUtfStr(StoreInfoC_TopStatusBgColor);
            } else {
                label = [[UILabel alloc] initWithFrame:CGRectMake((tableView.frame.size.width - TableCMMRowWidth)/2, indexPath.row == 0? 0: 0, TableCMMRowWidth, indexPath.row == 0 ? TableRowHeight :(TableRowHeight-1))];
                label.backgroundColor = colorWithUtfStr(StoreInfoC_TopStatusBgColor);
                [cell addSubview:label];
            }

            label.text = [NSString stringWithUTF8String:ComplexFieldName[indexPath.row]];
            label.font = FONT_NORMAL_13;
            label.textColor = colorWithUtfStr(PersonalCenterC_CellTitleColor);
            label.textAlignment = NSTextAlignmentCenter;
            break;
        }
        case FIELD_Exit:
        {
            UILabel *label;
            if (IOS_VERSION >= 7.0) {
                label = cell.textLabel;
                cell.backgroundColor =  colorWithUtfStr(PersonalCenterC_LogViewLogonBtnBg);
            } else {
                label = [[UILabel alloc] initWithFrame:CGRectMake((tableView.frame.size.width - TableCMMRowWidth)/2, indexPath.row == 0? 0: 0, TableCMMRowWidth, indexPath.row == 0 ? TableRowHeight :(TableRowHeight -1))];
                label.backgroundColor = colorWithUtfStr(PersonalCenterC_LogViewLogonBtnBg);
                [cell addSubview:label];
            }
            
            label.text = @"退出登录";
            label.font = FONT_NORMAL_13;
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;

            break;
        }
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int nums[] = {Group0_Start,Group1_Start,Group2_Start};
    NSInteger index = nums[indexPath.section] + indexPath.row;
    
    switch (index) {
        case Owner_Exit:
            [self exitClick:Nil];
            break;
            
        case Owner_Set:
        {
            OwnerSetController *vc = [[OwnerSetController alloc] initWithNibName:@"OwnerSetController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            break;
        }
            
        case Owner_Store:
        {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"安装贵客商户版后可注册成为商家" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"下载贵客商户版", nil];
            [sheet setTag:SheetTag_Store];
            [sheet showInView:APP_DELEGATE.window];
            [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
            break;
        }
        
        case Owner_Invite:
        {
            [tableView deselectRowAtIndexPath:indexPath animated:NO];

            if (IOS_VERSION >= 6.0) {
                __block BOOL accessGranted = YES;
                if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined){
                    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
                    ABAddressBookRequestAccessWithCompletion(nil, ^(bool granted, CFErrorRef error) {
                        accessGranted = granted;
                        dispatch_semaphore_signal(sema);
                    });
                    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
                } else if(ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized) {
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil
                                                                    message:@"您须要先在设置里授权贵客可以访问手机通讯录"
                                                                   delegate:self
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                    [alert show];
                    return;
                }
                if (!accessGranted) {
                    return;
                }
            }
            
            TKContactsMultiPickerController *vc = [[TKContactsMultiPickerController alloc] init];
            vc.tkdelegate = self;
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
          //  [self presentFullScreenViewController:navController animated:YES completion:nil];
            [self presentFullViewController:navController animated:YES completion:nil];
            break;
        }
        default:
            break;
    }
}

#pragma mark - TKContactsMultiPickerControllerDelegate
- (void)contactsMultiPickerController:(TKContactsMultiPickerController*)picker didFinishPickingDataWithInfo:(NSArray*)data
{
    NSMutableArray *array = [NSMutableArray array];
    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        TKAddressBook *ab = (TKAddressBook*)obj;
        if (IsSafeString(ab.tel)) {
            [array addObject:ab.tel];
        }
           }];
    
   // [self dismissFullScreenViewControllerAnimated:WSDismissStyle_T2DAnimation completion:nil];
    [self dismissFullViewControllerAnimated:YES completion:nil];
    [self showMessageView:array title:@"邀请好友" body:InviteText];
}

- (void)contactsMultiPickerControllerDidCancel:(TKContactsMultiPickerController*)picker
{
//    [self dismissFullScreenViewControllerAnimated:WSDismissStyle_T2DAnimation completion:nil];
    [self dismissFullViewControllerAnimated:YES completion:nil];
}

-(void)showMessageView : (NSArray *)phones title : (NSString *)title body : (NSString *)body
{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.body = body;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
  //  [self dismissModalViewControllerAnimated:YES];
    
    switch (result) {
        case MessageComposeResultCancelled:
        {
            //click cancel button
        }
            break;
        case MessageComposeResultFailed:// send failed
            
            break;
            
        case MessageComposeResultSent:
        {
            //do something
            [self showTopPop:@"发送成功"];
        }
            break;
        default:
            break;
    } 
    [self dismissViewControllerAnimated:YES completion:nil];

}
@end
