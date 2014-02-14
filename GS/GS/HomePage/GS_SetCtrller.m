//
//  GS_SetCtrller.m
//  GS
//
//  Created by W.S. on 13-6-6.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GS_SetCtrller.h"
#import "GS_UpdatePWDCtrller.h"
#import "GS_LogonCtrller.h"
#import "GS_GlobalObject.h"
typedef enum {
    StoreUserSetField_Group0_Start,
    StoreUserSetPhone  = StoreUserSetField_Group0_Start,
    StoreUserSetPWD,
    StoreUserSet_Field_Group0_Num,
    

}StoreDetailField;

#define FieldViewStartTag 1050

static char* fieldTitleStr[] = {"手机号","修改密码"};


@interface GS_SetCtrller ()

@end

@implementation GS_SetCtrller

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavTitle:@"设置"];
    [self addBackItem:@"返回" action:nil];
    [self addNavRightItem:@"注销" action:@selector(logOff)];
    
    self.tableView.backgroundView =nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    if (IOS_VERSION>=7.0) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    
    NSString *curVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.verLabel.text = [NSString stringWithFormat:@"贵客-商户版 V%@",curVersion];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setVerLabel:nil];
    [super viewDidUnload];
}
#pragma mark -
#pragma mark event handler -

-(void)logOff
{
    [self goback];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFCATION_LOGOFF object:nil];
//    GS_LogonCtrller *vc =[[GS_LogonCtrller alloc] initNibWithStyle:WS_ViewStyleWithNavBar];
//    showModalViewCtroller(self, vc, YES);
}
#pragma mark -
#pragma mark inside function -
-(void)gotoUpdatePwd
{
    GS_UpdatePWDCtrller *vc =[[GS_UpdatePWDCtrller alloc] initNibWithStyle:WS_ViewStyleWithNavBar];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark table datasource & delegate  -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"我的账号";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SettingCell" ;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        NSInteger index = indexPath.row;
        
        switch (indexPath.row) {
            case StoreUserSetPhone:
            {
                WS_GeneralTableFieldView *cellSubView =  [[WS_GeneralTableFieldView alloc] initWithType:WS_FieldStyle_Label withRightBtn:FALSE delegate:nil];
                [cellSubView setTag:(index + FieldViewStartTag)];
                [cellSubView setFieldName:[NSString stringWithUTF8String:fieldTitleStr[index]] autoSize:FALSE];
                [cellSubView setFieldValue:[GS_GlobalObject GS_GObject].ownIdInfo.gsId];
                cell.accessoryView = cellSubView;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
            }
            case StoreUserSetPWD:
            {
                cell.textLabel.text = [NSString stringWithUTF8String:fieldTitleStr[index]];
                cell.textLabel.font = FONT_NORMAL_14;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            }
                
            default:
                break;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //关闭键盘，如果有的话
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryView) {
        WS_GeneralTableFieldView *cellSubView = (WS_GeneralTableFieldView*)cell.accessoryView;
        [cellSubView unFocusTextField];
    }
    
    switch(indexPath.row){
        case 1:
            [self gotoUpdatePwd];
            break;
        default:
            break;
    }
    
}



@end
