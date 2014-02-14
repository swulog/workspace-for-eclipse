//
//  ThemeADVCCtrller.m
//  GK
//
//  Created by W.S. on 13-11-12.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "ThemeADVCCtrller.h"
#import "GKLogonService.h"
#import "GlobalObject.h"
#import "GKStoreInfomationController.h"
#import "ThemeADVCell.h"

@interface ThemeADVCCtrller ()
{
    BOOL hadClearMoreSperateLine;
    BOOL isInitView;
}
@property (nonatomic,strong) NSArray *themeAdvArray;
@end

@implementation ThemeADVCCtrller

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil style:VIEW_WITH_NAVBAR];
    if (self) {
        // Custom initialization
        self.tabImageName = [NSString stringWithUTF8String:tabImgNames[GKTAB_Theme]];


    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"精选推荐"];
    
    isInitView = TRUE;
    self.WSScrollView.delegate = self;
    [self.WSScrollView trigRefresh];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshThemeAdv) name:NOTIFICATION_CityUpdate object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark setter -
-(void)setThemeAdvArray:(NSArray *)themeAdvArray
{
    _themeAdvArray = themeAdvArray;
    [self resetTable];
}

#pragma mark -
#pragma mark network adapter -
-(void)refreshThemeAdv:(NSString*)cityId
{
    NillBlock_OBJ block = ^(NSObject *obj){
        self.themeAdvArray = (NSArray*)obj;
        
        if (IsSafeString(cityId) && !IsSafeArray(self.themeAdvArray)) {
            //[self refreshThemeAdv:Nil];
            if (self.viewIsAppear) {
                [self showTopPop:@"暂无推荐内容"];
            }
            [self.WSScrollView finishRefresh];
        } else {
            [self.WSScrollView finishRefresh];
            if (isInitView) {
                isInitView = FALSE;
                if (IsSafeArray(self.themeAdvArray)) {
                    GKThemeAdvInfo *adv  = self.themeAdvArray[0];
                    [self.WSScrollView setLastUpdatedDate:dateFromString(adv.createDate)];
                }
            }
            [self.WSScrollView scrollToYop];
        }
    };
    
    NSArray *array = [GKLogonService getThemeAdvInfo:cityId refresh:!isInitView succ:^(NSObject *obj) {
        block(obj);
    } fail:^(NSError *err) {
        [self showTopPop:err.localizedDescription];
        [self.WSScrollView stopRefresh];
    }];
    
    if (array) {
        block(array);
    }

}

-(void)refreshThemeAdv
{
    [self refreshThemeAdv:GO(GlobalObject).cityId];
}

#pragma mark -
#pragma mark inside normal function -
-(void)resetTable
{
    hadClearMoreSperateLine = FALSE;
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark table datasource & delegate  -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int ret = self.themeAdvArray.count;
    
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

#define ThemeADVCellTag 2000

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ThemeADVCell";
    NSString *indexCellIdeentifier = [NSString stringWithFormat:@"%@%d",cellIdentifier,indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indexCellIdeentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indexCellIdeentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = tableView.backgroundColor;
    }
    
    GKThemeAdvInfo *adv  = self.themeAdvArray[indexPath.row];
    ThemeADVCell *custV = (ThemeADVCell*)[cell viewWithTag:ThemeADVCellTag];
    if (!custV) {
        custV = [ThemeADVCell XIBView];
        custV.tag = ThemeADVCellTag;
        custV.userInteractionEnabled = FALSE;
        [cell addSubview:custV];
    }
    if (IsSafeString(adv.image_url)) {
        [custV.advImgV showUrl:[NSURL URLWithString:adv.image_url] activity:YES palce:[UIImage imageNamed:LIST_DEFAULT_IMG]];
    } else {
        [custV.advImgV showDefaultImg:[UIImage imageNamed:LIST_DEFAULT_IMG]];
    }
    
    custV.titleLabel.text = [NSString stringWithFormat:@"    %@",adv.title];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 216;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GKThemeAdvInfo *store = self.themeAdvArray[indexPath.row];
    GKStoreInfomationController *vc = [[GKStoreInfomationController alloc] initWithNibName:@"GKStoreInfomationController" bundle:nil withStore:nil orID:store.store_id from:nil];
    tableView.autoresizingMask = UIViewAutoresizingNone;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)refresh
{
    [self refreshThemeAdv];
}

-(UIView*)contentView
{
    CGRect rect = self.WSScrollView.frame;
    rect.origin.y = 0;
    self.tableView = [[UITableView alloc] initWithFrame:rect];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = self.view.backgroundColor;
    return self.tableView;
}


@end
