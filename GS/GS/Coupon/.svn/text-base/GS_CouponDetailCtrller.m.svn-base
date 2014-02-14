//
//  GS_CouponDetailCtrller.m
//  GS
//
//  Created by W.S. on 13-6-24.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GS_CouponDetailCtrller.h"
#import "RebateInfoView.h"
#import "GS_GlobalObject.h"

@interface GS_CouponDetailCtrller ()

@end

@implementation GS_CouponDetailCtrller

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithCoupon:(Coupon*)coupon
{
    self = [self initNibWithStyle:WS_ViewStyleWithNavBar];
    if (self) {
        self.coupon  = coupon;
        self.store = [GS_GlobalObject GS_GObject].iStore;
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavTitle:self.coupon.status == CouponStatus_Normal ? @"生效促销" : @"审核中促销"];
    [self addBackItem:@"返回" action:nil];
    
    if (self.coupon.status == CouponStatus_Pengding) {
        //self.validateImg.hidden = YES;
        self.validateImg.image = [UIImage imageNamed:@"pengdingIcon"];
    }
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    if (IOS_VERSION >= 7.0) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self.tableView move:20 direct:Direct_Up];
    }

  //  self.tableView.autoresizingMask =
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setValidateImg:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark table datasource & delegate  -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UITableViewCell *cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    if (indexPath.section == 0) {
        RebateInfoView *rebateInfoView = [[[NSBundle mainBundle] loadNibNamed:@"RebateInfoView" owner:self options:nil] objectAtIndex:0];
        rebateInfoView.rebateTitleLabel.text = self.store.name;
        rebateInfoView.couponTitleLabel.text = self.coupon.title;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [rebateInfoView setStartDate:transDatetoChinaDateStr([formatter dateFromString:self.coupon.start]) endData:transDatetoChinaDateStr([formatter dateFromString:self.coupon.end])];
    
        [rebateInfoView setContent:self.coupon.body];
        [rebateInfoView setNote:self.coupon.note];
        
        if (IsSafeString(self.coupon.image_url)) {
            [rebateInfoView setAdvImage:[NSURL URLWithString:self.coupon.image_url]];
        }
        
        [cell addSubview:rebateInfoView];
        CGRect rect = cell.frame;
        rect.size.height = rebateInfoView.frame.size.height+6;
        
        [cell setFrame:rect];
    } else if(indexPath.section == 1){
        cell.imageView.image = [UIImage imageNamed:@"distanceIcon"];
        cell.textLabel.text = [NSString stringWithFormat:@"地址 %@",self.store.address];
        cell.textLabel.font= FONT_NORMAL_18;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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

@end
