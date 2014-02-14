//
//  GS_CouponManageCtrller.m
//  GS
//
//  Created by W.S. on 13-6-22.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GS_CouponManageCtrller.h"
#import "GS_GlobalObject.h"
#import "GS_CouponDetailCtrller.h"
@interface GS_CouponManageCtrller ()

@end

@implementation GS_CouponManageCtrller

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithID:(NSString*)sToreId
{
    self = [self initNibWithStyle:WS_ViewStyleWithNavBar];
    
    if (self) {
        self.storeId = sToreId;
        pageNum = LIST_PAGE_MAX_MUM;
        curStatus = CouponTableSort_Normal;
        self.listArray = [NSMutableArray arrayWithCapacity:CouponTableSort_Count];
        for (int k = 0 ; k < CouponTableSort_Count; k++) {
            [self.listArray addObject:[NSMutableArray array]];   
        }

    }
    
    return self;
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavTitle:@"管理促销"];
    [self addBackItem:@"返回" action:nil];
    
    
    self.tableViewArray = [NSArray arrayWithObjects:self.pengdingTable,self.tableView,self.expiredTable, nil];
    for (GKTableView *table in self.tableViewArray) {
        table.gkdelegate = self;
        table.backgroundColor = [UIColor clearColor];
        table.backgroundView = nil;
        
        if (IOS_VERSION >= 7.0) {
            table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            [table move:20 direct:Direct_Up];
        }
    }
    [self switchTableTo:curStatus];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setSwitchView:nil];
    [self setPengdingTable:nil];
    [self setExpiredTable:nil];
    [super viewDidUnload];
}

- (IBAction)switchValueChanged:(id)sender {
 //   CouponStatus status;
    
    curStatus = self.switchView.selectedSegmentIndex;

//    switch(self.switchView.selectedSegmentIndex)
//    {
//        case 0:
//            status = CouponStatus_Normal;
//            break;
//            
//        case 1:
//            status = CouponStatus_Pengding;
//            break;
//
//        case 2:
//            status = CouponStatus_Expired;
//            break;
//    }
    
    [self switchTableTo:curStatus];
    
}

-(void)switchTableTo:(CouponTableSort)status
{
    for (GKTableView *table in self.tableViewArray) {
        table.hidden = YES;
    }
    ((GKTableView*)[self.tableViewArray objectAtIndex:status]).hidden = FALSE;
        
    if (initStatus[curStatus] == FALSE){
        iStatus = WS_ViewStatus_Getting;
        [self getCouponList:status];
    } else {
        GKTableView *table = [self.tableViewArray objectAtIndex:status];
        [table reloadData];
    }
}

-(void)getCouponList:(CouponTableSort)couponStatus
{
    [NSTimer scheduledTimerWithTimeInterval:0.26f target:self selector:@selector(showWatting) userInfo:nil repeats:NO];

    int pagenum = pageNum;
    int pageindex = pageIndex[couponStatus] + 1; //服务器页码从 1 开始
    
    if (iStatus == WS_ViewStatus_LoadMore) {
        if (rowDeleted[couponStatus]) {
            pagenum = pageindex * pagenum;
            pageindex = 1;
        }
    } else {
        pageindex = 1;
    }

    NillBlock_OBJ sucBlock = ^(NSObject *obj){
        initStatus[couponStatus] = TRUE;
        rowDeleted[couponStatus] = FALSE;
        pageIndex[couponStatus] = pageindex;
        
        NSMutableArray *newCouponArray = (NSMutableArray*)obj;
        if (newCouponArray.count ==  pagenum)   {
            nextPageEnabled[couponStatus] = TRUE;
        } else {
            nextPageEnabled[couponStatus] = FALSE;
        }

        NSMutableArray *array = [self.listArray objectAtIndex:couponStatus];
        if (!array || array.count == 0) {
            array = newCouponArray;
            [self.listArray replaceObjectAtIndex:couponStatus withObject:array];
        } else {
            if (iStatus == WS_ViewStatus_LoadMore) {
                if (pagenum > pageNum) {
                    array = newCouponArray;
                    [self.listArray replaceObjectAtIndex:couponStatus withObject:array];
                } else {
                    [array addObjectsFromArray:newCouponArray];
                 }
            } else {
                array = newCouponArray;
                [self.listArray replaceObjectAtIndex:couponStatus withObject:array];
            }
        }
               
        iStatus = WS_ViewStatus_Normal;
        [self hideWaitting];
        
        GKTableView *table = [self.tableViewArray objectAtIndex:couponStatus];
        if (nextPageEnabled[couponStatus]) {
            [table setFooterViewVisibility:TRUE];
            [table loadMoreCompleted];
        } else {
            [table setFooterViewVisibility:FALSE];
        }
        
        [table stopAnimate];
        [table reloadData];

    };
    
    
    NillBlock_Error failBlock = ^(NSError *err){
        GKTableView *table = [self.tableViewArray objectAtIndex:couponStatus];
        [table stopAnimate];
        
        iStatus = WS_ViewStatus_GetFail;
        [self hideWaitting];
        [GS_GlobalObject showPopup:err.localizedDescription];
    };
    
    [GSCouponService getCouponList:couponStatus store:self.storeId page:pageindex pageNum:pagenum succ:sucBlock fail:failBlock];
}

-(void)deleteCoupon:(NSString*)couponId
{
  //  initStatus[CouponStatus_Expired] = FALSE;

    rowDeleted[curStatus] = TRUE;

    [GSCouponService deleteCoupon:couponId status:curStatus];
}

-(void)revokeCoupon:(NSString*)couponId
{
    initStatus[CouponTableSort_Experied] = FALSE;
    rowDeleted[curStatus] = TRUE;

    [GSCouponService deleteCoupon:couponId status:curStatus];
}

-(void)reReleaseOK:(Coupon*)coupon
{
    
    NSMutableArray *dataArray = [self.listArray objectAtIndex:curStatus];
    GKTableView *table = [self.tableViewArray objectAtIndex:curStatus];
    
    //Coupon *tcoupon = [dataArray objectAtIndex:table.indexPathForSelectedRow.row];
    
    [dataArray removeObjectAtIndex:table.indexPathForSelectedRow.row];
    
    [table deleteRowsAtIndexPaths:[NSArray arrayWithObject:table.indexPathForSelectedRow] withRowAnimation:UITableViewRowAnimationFade];
    
 //   initStatus[CouponStatus_Normal] = FALSE;
    initStatus[CouponTableSort_Pengding] = FALSE;
}

-(void)refresh
{
    iStatus = WS_ViewStatus_Refreshing;
    [self getCouponList:curStatus];

}

-(void)loadMorePullTable
{
    iStatus = WS_ViewStatus_LoadMore;
    [self getCouponList:curStatus];
    //rowDeleted[curStatus] = FALSE;

}

#pragma mark -
#pragma mark table datasource & delegate  -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (!self.listArray || self.listArray.count == 0) {
        return 0;
    }
    
    NSArray *array = [self.listArray objectAtIndex:tableView.tag];
    
    return array.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CouponTableCell" ;
    
    NSArray *dataArray = [self.listArray objectAtIndex:tableView.tag];
    Coupon *coupon = [dataArray objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        
        cell.textLabel.textColor = [UIColor redColor];
        cell.detailTextLabel.font = FONT_NORMAL_12;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = coupon.title;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *dateStr = [NSString stringWithFormat:@"有效期:%@~%@",transDatetoChinaDateStr([formatter dateFromString:coupon.start]),transDatetoChinaDateStr([formatter dateFromString:coupon.end])];
    cell.detailTextLabel.text = dateStr;


    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (curStatus != CouponTableSort_Experied) {
        
        GS_CouponDetailCtrller *vc = [[GS_CouponDetailCtrller alloc] initWithCoupon:[[self.listArray objectAtIndex:curStatus] objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:vc animated:YES];
    } else {

        GS_CouponReleaseCtrller *vc= [[GS_CouponReleaseCtrller alloc] initWithCoupon:[[self.listArray objectAtIndex:curStatus] objectAtIndex:indexPath.row]];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];        
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if (curStatus == CouponTableSort_Pengding) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"撤销这条促销信息？"
                                                            message:@"撤销的促销信息保存在“未发布”中，可重新发布"];
            
            [alert addButtonWithTitle:@"取消"];
            [alert addButtonWithTitle:@"确定" handler:^{
                
                
                NSMutableArray *dataArray = [self.listArray objectAtIndex:curStatus];
                Coupon *coupon = [dataArray objectAtIndex:indexPath.row];
                [dataArray removeObjectAtIndex:indexPath.row];                
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                
                [self revokeCoupon:coupon.id];
            }];
            

            [alert show];
        } else if(curStatus == CouponTableSort_Experied){
            
            NSMutableArray *dataArray = [self.listArray objectAtIndex:curStatus];
            Coupon *coupon = [dataArray objectAtIndex:indexPath.row];
            
            [dataArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            [self deleteCoupon:coupon.id];
        }
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (curStatus == CouponStatus_Normal) {
//        return  UITableViewCellEditingStyleNone;
//    } 
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == CouponTableSort_Pengding) {
        return  @"撤销";
    } else if(tableView.tag == CouponTableSort_Experied){
        return @"删除";
    }
    
    return nil;
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == CouponTableSort_Normal ) {
        return NO;
    }
    return YES;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
    
}
@end
