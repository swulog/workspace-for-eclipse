//
//  GS_StoreInfoCtrller.m
//  GS
//
//  Created by W.S. on 13-6-6.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GS_StoreInfoCtrller.h"
#import "GS_GlobalObject.h"
#import "CustomCellBackgroundView.h"

@interface GS_StoreInfoCtrller ()

@end

@implementation GS_StoreInfoCtrller

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.noteBtn.hidden = YES;
        self.noteLabel.hidden = YES;
        
        self.sortArray = [[GS_GlobalObject GS_GObject] getSorts:nil];
        if (!self.sortArray) {
            [[GS_GlobalObject GS_GObject] addObserver:self forKeyPath:@"sortArray" options:NSKeyValueObservingOptionNew context:nil];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStoreInfo:) name:NOTIFICATION_STORE_REFRESH object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStoreInfo:) name:NOTIFICATION_STORE_UPDATE object:nil];

    }
    return self;
}

-(id)initWithStore:(StoreInfo*)store
{
    self = [self initNibWithStyle:WS_ViewStyleWithNavBar];
    
    if (self) {
        self.iStore = store;
        
        [GSStoreService getStoreStatus:store.id succ:^(BOOL unPenging){
            if (unPenging) {
                self.noteBtn.hidden = YES;
                self.noteLabel.hidden = YES;
            } else {
                self.noteBtn.hidden = NO;
                self.noteLabel.hidden = NO;
            }
        }fail:^(NSError* err){
            [GS_GlobalObject showPopup:err.localizedDescription];
        }];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_STORE_UPDATE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_STORE_REFRESH object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavTitle:@"商户资料"];
    [self addNavRightItem:@"编辑" action:@selector(editClick)];
    
    
    self.tableView.backgroundView =nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    if (IOS_VERSION >= 7.0) {
        [self.tableView move:20 direct:Direct_Up];
        [self.tableView strechTo:CGSizeMake(320, self.tableView.frame.size.height+20)];
    }
    
    [self refreshSelf];

}


-(void)viewWillAppear:(BOOL)animated
{
    if (hadUpdateStoreStatus) {
        hadUpdateStoreStatus = FALSE;
        return;
    }
    
    if (!self.noteBtn.hidden && self.iStore && self.iStore.id &&!isGetStoreStatus) {
        isGetStoreStatus = TRUE;
        [GSStoreService getStoreStatus:self.iStore.id succ:^(BOOL unPenging){
            isGetStoreStatus = FALSE;
             if (unPenging) {
                self.noteBtn.hidden = YES;
                self.noteLabel.hidden = YES;
            } else {
                self.noteBtn.hidden = NO;
                self.noteLabel.hidden = NO;
            }
        }fail:^(NSError *err){
            isGetStoreStatus = FALSE;
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    

}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setUserLabel:nil];
    [self setTradeLabel:nil];
    [self setSortLabel:nil];
    [self setStoreNameLabel:nil];
    [self setNoteBtn:nil];
    [self setNoteLabel:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark inside function -
-(void)updateStoreInfo:(NSNotification*)notification
{
    StoreInfo *store = notification.object;
    
    if (![notification.name isEqualToString: NOTIFICATION_STORE_REFRESH]) {
        
        [GSStoreService getStoreStatus:store.id succ:^(BOOL unPenging){
            hadUpdateStoreStatus = TRUE;
            if (unPenging) {
                self.noteBtn.hidden = YES;
                self.noteLabel.hidden = YES;
            } else {
                self.noteBtn.hidden = NO;
                self.noteLabel.hidden = NO;
            }
        }fail:nil];
    }

    
    if (store != self.iStore) {
        if ([self.iStore.id isEqualToString:store.id] || !self.iStore) {
            self.iStore = store;
            [self refreshSelf];
        } 
    } else {
        [self refreshSelf];
    }
    
    [GS_GlobalObject GS_GObject].iStore = self.iStore;

}

-(void)refreshSelf
{
    if (self.iStore) {
        self.userLabel.text = [NSString stringWithFormat:@"%d人",self.iStore.user_count];
        self.tradeLabel.text = [NSString stringWithFormat:@"%d笔",self.iStore.deal_count];
        self.sortLabel.text = [[GS_GlobalObject GS_GObject] getSortName:self.iStore.taxo_id];
        self.storeNameLabel.text = self.iStore.name;
        
        [self.tableView reloadData];
    }
}

#pragma mark -
#pragma mark event handler -
-(void)editClick
{
    GS_StoreDetailCtrller *vc = [[GS_StoreDetailCtrller alloc] initWithStoreInfo:self.iStore];
    vc.delegate = self;
    self.storeEditCtrller = vc;
    [self pushViewControler:vc withNavBar:YES animated:YES];
    
    
 //   [self.navigationController pushViewController:vc animated:YES];
//    showModalViewCtroller(self, vc, YES);
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"sortArray"]) {
        [[GS_GlobalObject GS_GObject] removeObserver:self forKeyPath:@"sortArray"];
        self.sortArray = [GS_GlobalObject GS_GObject].sortArray;
        self.sortLabel.text = [[GS_GlobalObject GS_GObject] getSortName:self.iStore.taxo_id];
    }
    
}

-(void)saveOK
{
    hadUpdateStoreStatus = TRUE;
    
    if (!([self.storeEditCtrller.storeInfo.name isEqualToString:self.iStore.name] && [self.storeEditCtrller.storeInfo.address isEqualToString:self.iStore.address] && [self.storeEditCtrller.storeInfo.discount isEqualToString:self.iStore.discount])) {
        self.noteBtn.hidden = NO;
        self.noteLabel.hidden = NO;
    }
    
    
    self.iStore = self.storeEditCtrller.storeInfo;
    
//    self.noteBtn.hidden = NO;
//    self.noteLabel.hidden = NO;
    [self refreshSelf];
    
    [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimeInterval time){
        [self dismissModalViewControllerAnimated:YES];

    }repeats:NO];
}

#pragma mark -
#pragma mark table datasource & delegate  -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 3;
        default:
            return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"storeDetailCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
         }
    
    switch (indexPath.section) {
        case 0:
        {
            static char *iconStr[] = {"icon_map","icon_ph","icon_clo"};
            NSString *title;;
            switch (indexPath.row) {
                case 0:
                {
                    title = [NSString stringWithFormat:@"门店地址  %@",self.iStore.address && self.iStore.address.length > 0 ? self.iStore.address:@""];

                }
                    break;
                case 1:
                {
                    title = [NSString stringWithFormat:@"联系电话  %@",NSStringSafeFormat(self.iStore.phone)];
                                 }
                    break;
                case 2:
                    title = [NSString stringWithFormat:@"营业时间  %@",NSStringSafeFormat(self.iStore.hours)];
                    break;
            }
            cell.textLabel.text = title;
            cell.textLabel.font = FONT_NORMAL_14;
            cell.imageView.image = [UIImage imageNamed:[NSString stringWithUTF8String:iconStr[indexPath.row]]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];


        }
            break;
        case 1:
        {
            NSString *discount ;
            if ([self.iStore.discount floatValue] == 0.0f) {
                discount = @"免费";
            } else if([self.iStore.discount floatValue] == 10.0f){
                discount = @"暂无折扣";
            } else {
                discount = [NSString stringWithFormat:@"基础折扣  %@折",NSStringSafeFormat(self.iStore.discount)];
            }
            
            cell.textLabel.text = discount;
            cell.imageView.image = [UIImage imageNamed:@"icon_zk"];

            cell.textLabel.font = FONT_NORMAL_14;
            cell.textLabel.textColor = [UIColor redColor];
            [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
            break;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
            return cell.frame.size.height;
        }
            
        default:
            return 44;
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 40;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}



@end
