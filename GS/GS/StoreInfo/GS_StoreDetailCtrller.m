//
//  GS_StoreDetailCtrller.m
//  GS
//
//  Created by W.S. on 13-6-5.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GS_StoreDetailCtrller.h"
#import "GS_HomePageFrameCtrller.h"
#import "GSStoreService.h"
#import "GS_GlobalObject.h"

typedef enum {
    Group0_Start,
    StoreDetailField_Name=Group0_Start,
    StoreDetailField_Type,
    StoreDetailField_Address,
    StoreDetailField_Call,
    Group0_Over,
    Group0_Num = Group0_Over - Group0_Start,

    Group1_Start = Group0_Over,
    StoreDetailField_WorkStartTime = Group1_Start,
    StoreDetailField_WorkEndTime,
    Group1_Over,
    Group1_Num = Group1_Over - Group1_Start,
    
    Group2_Start = Group1_Over,
    StoreDetailField_BaseReate = Group2_Start,
    Group2_Over,
    Group2_Num = Group2_Over - Group2_Start,



    StoreDetailField_TotalNum = Group0_Num + Group1_Num +Group2_Num
}StoreDetailField;

#define GroupNum 3

#define FieldViewStartTag 1050

static char* fieldTitleStr[] = {"商户名称","经营类别","门店地址","联系电话","上班时间","下班时间","基础折扣"};
static char* groupTitleStr[GroupNum] = {"","营业时间",""};

#define NameFieldPlaceStr  @"如：大老虎火锅 ，不带地名"
#define PhoneFieldPlaceStr @"便于客户预订服务"
#define AddressFieldPlaceStr @"可以开启GPS自动定位"

#define BaseDicountNotificationTip @"*在没有发布任何促销时默认为贵客会员提供此折扣率"
#define BaseDiscountNotificationTipForEdit @"*资料修改须经过审核才能生效"

#define NAME_FORMAT_ERROR_TAG @"请输入正确的商店名字，可输入2-16个字符"
#define PHONE_FORMAT_ERROR_TAG @"请输入正确的电话号码,不支持分机号码"
#define Address_Empty_ErrorTag @"请输入正确的地址或者点击定位选择商店地址"
#define Address_Unmatched_Error_Tag @"您输入的地址未能找到对应坐标，确定使用该地址么？"
#define Address_Format_ErrorTag @"请输入正确的地址,必须有XX市"

@interface GS_StoreDetailCtrller ()
@property (nonatomic,strong) NSString *districtName;
@end

@implementation GS_StoreDetailCtrller

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initNibWithStyle:(WS_ViewStyle)style
{
    self = [super initNibWithStyle:style];
    
    if (self) {
     //   isAdd = TRUE;
        
        self.sortArray = [[GS_GlobalObject GS_GObject] getSorts:nil];
        if (!self.sortArray) {
            [[GS_GlobalObject GS_GObject] addObserver:self forKeyPath:@"sortArray" options:NSKeyValueObservingOptionNew context:nil];
        }

        
        
//        self.sortArray = [[GS_GlobalObject GS_GObject] getSorts:^(NSArray* array){
//            self.sortArray = array;
//            WS_GeneralTableFieldView *fieldView = (WS_GeneralTableFieldView*)((UITableViewCell*)[self.tableView.visibleCells objectAtIndex:StoreDetailField_Type]).accessoryView;
//            
//            
//            
//            NSString *fieldValue;
//            if (self.storeInfo) {
//                //  fieldValue = ((StoreSort*)[self.sortArray objectAtIndex:self.storeInfo.])
//            } else  if(!fieldView.fieldStr){
//                fieldValue = ((StoreSort*)[self.sortArray objectAtIndex:0]).name;
//                [fieldView setFieldValue:fieldValue];
//            }
//
//        }];
    }
    return self;
}

-(id)initWithStoreID:(NSString*)_storeID
{
    self = [self initNibWithStyle:WS_ViewStyleWithNavBar];
    if (self) {
        self.addStoreID = _storeID;
        isAdd = TRUE;
    }
    
    return self;
}

-(id)initWithStoreInfo:(StoreInfo*)info
{
    self = [self initNibWithStyle:WS_ViewStyleWithNavBar];
    if (self) {
        self.storeInfo = info;
        if (info) {
            isAdd = FALSE;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavTitle:@"基本资料"];
    [self addNavRightItem:@"保存" action:@selector(saveClick)];
//    self.backgroundView= nil;
//    [self.backgroundView removeFromSuperview];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.scrollEnabled = FALSE;
    
    if (self.storeInfo) {
        [self addBackItem:@"返回" action:@selector(goback)];
    } else  if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus]!= kCLAuthorizationStatusDenied)
    {
        [GS_GlobalObject getBaiduLocation:^(NSObject *obj){
            self.iLocation = (BMKAddrInfo*)obj;
            self.districtName = self.iLocation.addressComponent.district;
            if (self.addressField && (!self.addressField.fieldStr || self.addressField.fieldStr.length == 0)) {
                [self.addressField setFieldValue:self.iLocation.strAddr];
            }
        }fail:nil];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLocation:) name:WSNotification_SaveLocFromBMMap object:nil];

    [self refreshSelf];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_LOC_UPDATE object:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}



#pragma mark -
#pragma mark inside function -
-(void)saveMyStore
{

    
    NillBlock_Nill saveBlock = ^{
        [GSStoreService saveStoreInfo:self.storeInfo succ:^(NSObject* obj){
            if (isAdd) {
                [[NSUserDefaults standardUserDefaults] setValue:[GS_GlobalObject GS_GObject].ownIdInfo.gsId forKeyPath:@"LastUser"];
            }
            
            iStatus = WS_ViewStatus_Normal;
            [self hideWaitting];
            
            if (isAdd) {
                [GS_GlobalObject showPopup:@"保存成功，正在跳转首页"];
            } else {
                [GS_GlobalObject showPopup:@"保存成功"];
            }
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(saveOK)]) {
                [self.delegate performSelector:@selector(saveOK)];
                self.view.userInteractionEnabled = FALSE;
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_STORE_SAVEOK object:self.storeInfo];
            
        }fail:^(NSError *err){
            iStatus = WS_ViewStatus_GetFail;
            [self hideWaitting];
            [GS_GlobalObject showPopup:err.localizedDescription];
        }];
        
    };
    
    NillBlock_OBJ BLOCK_GetDistrictId = ^(NSObject *obj){
        NSString *cityId = (NSString*)obj;
        
        if (IsSafeString(self.districtName)) {
            District *district = nil;

            district = [GSStoreService getDistrictId:cityId disctrictName:self.districtName success:^(NSObject *obj) {
                
                self.storeInfo.districtId = ((District*)obj).id;
                SAFE_BLOCK_CALL_VOID(saveBlock);
            } fail:^(NSError *err) {
                iStatus = WS_ViewStatus_GetFail;
                [self hideWaitting];
                [GS_GlobalObject showPopup:err.localizedDescription];
            }];
            
            if (district) {
                self.storeInfo.districtId = district.id;
                SAFE_BLOCK_CALL_VOID(saveBlock);
            }
        } else {
            SAFE_BLOCK_CALL_VOID(saveBlock);
        }
        
    };
    
    if (self.hadEditedAddress || self.hadLocated || isAdd) {
        NSRange range  =  [self.storeInfo.address rangeOfString:@"市"];
        if (range.location != NSNotFound) {
            NSRange range1 = [self.storeInfo.address rangeOfString:@"省"];
            if (range1.location != NSNotFound) {
                range.length = range.location - range1.location - range1.length + range.length;
                range.location = range1.location + range1.length;
            } else {
                range.length = range.location + range.length;
                range.location = 0;
            }
            NSString  *cityName = [self.storeInfo.address substringWithRange:range];
            iStatus = WS_ViewStatus_Getting;
            [NSTimer scheduledTimerWithTimeInterval:0.26f target:self selector:@selector(showWatting) userInfo:nil repeats:NO];
            City *city =  [GSStoreService getCityId:cityName success:^(NSObject *obj){
                self.storeInfo.city_id = ((City*)obj).id;
                SAFE_BLOCK_CALL(BLOCK_GetDistrictId,self.storeInfo.city_id);
            }fail:^(NSError *err){
                iStatus = WS_ViewStatus_GetFail;
                [self hideWaitting];
                [GS_GlobalObject showPopup:err.localizedDescription];
            }];
            
            if (city) {
                self.storeInfo.city_id = city.id;
                SAFE_BLOCK_CALL(BLOCK_GetDistrictId,self.storeInfo.city_id);
               // SAFE_BLOCK_CALL_VOID(saveBlock);
            }
        }
    } else {
        iStatus = WS_ViewStatus_Getting;
        [NSTimer scheduledTimerWithTimeInterval:0.26f target:self selector:@selector(showWatting) userInfo:nil repeats:NO];
        SAFE_BLOCK_CALL_VOID(saveBlock);
    }
}

-(void)updateLocation:(NSNotification*)_notification
{
    BMKAddrInfo *loc =(BMKAddrInfo*)_notification.object;
    self.iLocation = loc;
    [self.addressField setFieldValue:self.iLocation.strAddr];
    self.districtName = loc.addressComponent.district;
    self.hadLocated = TRUE;
    self.hadEditedAddress = FALSE;
}

-(void)refreshSelf
{
    if (self.storeInfo) {
        [self.tableView reloadData];
    }
}

-(void)transFocus:(UIView*)fieldView;
{
    if (focusField == fieldView) {
        return;
    }
    
    if ([focusField isKindOfClass:[UITextField class]]) {
        if (((UITextField*)focusField).keyboardType == UIKeyboardTypeNumberPad) {
            [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
        }

        if ([fieldView isKindOfClass:[UITextField class]]) {
                    //    [fieldView becomeFirstResponder];
        } else {
            [focusField resignFirstResponder];
        }
    } else if(focusField){
        WS_GeneralTableFieldView *field = (WS_GeneralTableFieldView*)focusField;
        [field resignFocus];
    }
    
    focusField = fieldView;
}

#pragma mark - 
#pragma mark event handler -
- (void)saveClick {
    if (isAdd && !self.storeInfo) {
        self.storeInfo = [[StoreInfo alloc] init];
        self.storeInfo.id = self.addStoreID;
    }
    
    
    for (int k = Group0_Start;k<StoreDetailField_TotalNum;k++) {
        WS_GeneralTableFieldView *field = (WS_GeneralTableFieldView*)[self.fieldArray objectAtIndex:k];
        
        switch (k) {
            case StoreDetailField_Name:
                if (!checkID(((UITextField*)field.fieldValueView).text)) {
                    [GS_GlobalObject showPopup:NAME_FORMAT_ERROR_TAG];
                    return ;
                } else {
                    self.storeInfo.name = ((UITextField*)field.fieldValueView).text;
                }
                break;
            case StoreDetailField_Call:
                if (checkMobileNo(((UITextField*)field.fieldValueView).text) ||
                    checkPhoneNo(((UITextField*)field.fieldValueView).text) ||
                    check400PhoneNo(((UITextField*)field.fieldValueView).text)||
                    check800PhoneNo(((UITextField*)field.fieldValueView).text)) {
                    self.storeInfo.phone = ((UITextField*)field.fieldValueView).text;
                } else {
                    [GS_GlobalObject showPopup:PHONE_FORMAT_ERROR_TAG];
                    return ;
                }
                break;
            case StoreDetailField_Address:
            {
                NSString *strAddr =  ((UITextField*)self.addressField.fieldValueView).text;
                
                if (!strAddr || strAddr.length == 0) {
                    [GS_GlobalObject showPopup:Address_Empty_ErrorTag];
                    return;
                }
                
                if (self.hadLocated || isAdd) { //已经定位过，已定位经纬度为准
                    self.storeInfo.latitude = self.iLocation.geoPt.latitude;
                    self.storeInfo.longitude = self.iLocation.geoPt.longitude;
                }
                
                break;
            }
                
            case StoreDetailField_WorkStartTime:
                self.storeInfo.hours = field.fieldStr;
                break;
            case StoreDetailField_WorkEndTime:
                self.storeInfo.hours = [NSString stringWithFormat:@"%@-%@",self.storeInfo.hours,field.fieldStr];
                break;
            case StoreDetailField_BaseReate:
            {
                NSString *baseRebrate = field.fieldStr;
                if (IsSafeString(baseRebrate)) {
                    if ([baseRebrate isEqualToString:@"免费"]) {
                        baseRebrate = @"0.0";
                    } else  if([baseRebrate isEqualToString:@"暂无折扣"]){
                        baseRebrate = @"10.0";
                    } else {
                        NSRange range = [field.fieldStr rangeOfString:@"折"];
                        baseRebrate = [ field.fieldStr substringToIndex:range.location];
                    }
                    
                    self.storeInfo.discount = baseRebrate;
                }
                
                
                break;
            }
            case StoreDetailField_Type:
                self.storeInfo.taxo_id = [[GS_GlobalObject GS_GObject] getSortID:field.fieldStr];
                break;
            default:
                break;
        }
    }
    
    NSString *strAddr =  ((UITextField*)self.addressField.fieldValueView).text;
    if (self.hadEditedAddress) {
        if (!self.hadLocated) {
            //获取经纬度
            NSRange range  =  [strAddr rangeOfString:@"市"];
            if (range.length == 0) {
                [GS_GlobalObject showPopup:Address_Format_ErrorTag];
                return;
            }
            
            
            iStatus = WS_ViewStatus_Getting;
            [NSTimer scheduledTimerWithTimeInterval:0.26f target:self selector:@selector(showWatting) userInfo:nil repeats:NO];
            
            [GS_GlobalObject getGPSLocWithAddress:strAddr succ:^(NSObject *obj){
                BMKAddrInfo *bmkAddr = (BMKAddrInfo*)obj;
                self.storeInfo.latitude = bmkAddr.geoPt.latitude;
                self.storeInfo.longitude = bmkAddr.geoPt.longitude;
                self.storeInfo.address = strAddr;
                
                CLLocation *loc = [[CLLocation alloc] initWithLatitude:bmkAddr.geoPt.latitude longitude:bmkAddr.geoPt.longitude];
                [[GS_GlobalObject GS_GObject] getLocationStrWithBaidu:loc succ:^(NSObject *obj) {
                    BMKAddrInfo *bmkAddr = (BMKAddrInfo*)obj;
                    self.districtName = bmkAddr.addressComponent.district;
                    [self saveMyStore];
                } fail:^(NSError *err) {
                    [self saveMyStore];
                }];
                
            }fail:^(NSError *err){
                iStatus = WS_ViewStatus_GetFail;
                [self hideWaitting];
                
                if (err.code == (WS_ErrorDomainStart + WS_LocationError)) {
                    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:Address_Unmatched_Error_Tag];
                    [sheet addButtonWithTitle:@"确定" handler:^{
                        self.storeInfo.address = strAddr;
                        [self saveMyStore];
                    }];
                    [sheet addButtonWithTitle:@"取消" handler:^{
                        return ;
                    }];
                    [sheet showInView:self.view];
                } else {
                    [GS_GlobalObject showPopup:err.localizedDescription];
                    return ;
                }
            }];
        } else {
            self.storeInfo.address = strAddr;
            [self saveMyStore];

        }
    } else {
        self.storeInfo.address = strAddr;
        [self saveMyStore];
    }
}

-(void)goback
{
    if(focusField && [focusField isKindOfClass:[WS_GeneralTableFieldView class]]){
        WS_GeneralTableFieldView *field = (WS_GeneralTableFieldView*)focusField;
        [field resignFocus];
    }
    [self dismissModalViewControllerAnimated:YES];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"sortArray"]) {
        [[GS_GlobalObject GS_GObject] removeObserver:self forKeyPath:@"sortArray"];
        self.sortArray = [GS_GlobalObject GS_GObject].sortArray;
//        self.sortLabel.text = [[GS_GlobalObject GS_GObject] getSortName:self.iStore.taxo_id];
        WS_GeneralTableFieldView *fieldView = (WS_GeneralTableFieldView*)((UITableViewCell*)[self.tableView.visibleCells objectAtIndex:StoreDetailField_Type]).accessoryView;
        
        
        
        NSString *fieldValue;
        if (self.storeInfo) {
            //  fieldValue = ((StoreSort*)[self.sortArray objectAtIndex:self.storeInfo.])
        } else  if(!fieldView.fieldStr){
            fieldValue = ((StoreSort*)[self.sortArray objectAtIndex:0]).name;
            [fieldView setFieldValue:fieldValue];
        }

    }
    
}
#pragma mark -
#pragma mark table delegate & datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return GroupNum;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithUTF8String:groupTitleStr[section]];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
        v.backgroundColor = [UIColor clearColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, tableView.frame.size.width, 30)];
        label.backgroundColor = [UIColor clearColor];
        label.text = self.storeInfo?BaseDiscountNotificationTipForEdit:BaseDicountNotificationTip;
        label.textColor =[UIColor redColor];
        label.font = FONT_NORMAL_12;
        [v addSubview:label];
        
        return v;
    } else {
        return nil;
    }
}
//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
//{
//    return section != 2?@"" : (self.storeInfo?BaseDiscountNotificationTipForEdit:BaseDicountNotificationTip);
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section== 1? 35:5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section == 2 ?20: 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return Group0_Num;
    } else if(section == 1){
        return Group1_Num;
    } else {
        return Group2_Num;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

    
    NSInteger index = (indexPath.section == 0 ? indexPath.row : (indexPath.section == 1 ? (Group1_Start + indexPath.row) : (Group2_Start + indexPath.row)));
                       
    NSString *titleStr= [NSString stringWithUTF8String:fieldTitleStr[index]] ;
    WS_GeneralTableFieldView *cellSubView =nil;

    switch (index) {
        case StoreDetailField_Name:
            cellSubView =  [[WS_GeneralTableFieldView alloc] initWithType:WS_FieldStyle_Text withRightBtn:FALSE delegate:self];
            [cellSubView setFieldPlaceHolder:NameFieldPlaceStr];
            if (self.storeInfo) {
                [cellSubView setFieldValue:NSStringSafeFormat(self.storeInfo.name)];
            }
            break;
        case StoreDetailField_Type:
            cellSubView =  [[WS_GeneralTableFieldView alloc] initWithType:WS_FieldStyle_Picker withRightBtn:FALSE delegate:self];
            if (self.sortArray) {
                NSString *fieldValue;
                if (self.storeInfo) {
                    fieldValue = [[GS_GlobalObject GS_GObject] getSortName:self.storeInfo.taxo_id];
                } else {
                    fieldValue = ((StoreSort*)[self.sortArray objectAtIndex:0]).name;
                }
                [cellSubView setFieldValue:fieldValue];
            }
            break;
        case StoreDetailField_Address:
            cellSubView =  [[WS_GeneralTableFieldView alloc] initWithType:WS_FieldStyle_Text withRightBtn:YES delegate:self];
            [cellSubView.accessBtn setTitle:@"定位" forState:UIControlStateNormal];
            self.addressField = cellSubView;

            if (![CLLocationManager locationServicesEnabled]) {
                [cellSubView setFieldPlaceHolder:AddressFieldPlaceStr];
            }
            if (self.storeInfo) {
                [cellSubView setFieldValue:NSStringSafeFormat(self.storeInfo.address)];
            } else if(self.iLocation){
                [cellSubView setFieldValue:self.iLocation.strAddr];
            }
            break;
        case StoreDetailField_Call:
            cellSubView =  [[WS_GeneralTableFieldView alloc] initWithType:WS_FieldStyle_Text withRightBtn:FALSE delegate:self];
            [cellSubView setFieldPlaceHolder:PhoneFieldPlaceStr];
            if (self.storeInfo) {
                [cellSubView setFieldValue:NSStringSafeFormat(self.storeInfo.phone)];
            }
            ((UITextField*)cellSubView.fieldValueView).keyboardType = UIKeyboardTypeNumberPad;
            break;

        case StoreDetailField_WorkStartTime:
        {
            cellSubView =  [[WS_GeneralTableFieldView alloc] initWithType:WS_FieldStyle_Picker withRightBtn:FALSE delegate:self];
            
            NSMutableString *startHourStr = [NSMutableString stringWithString:@"08:00"];
            if (self.storeInfo && self.storeInfo.hours && self.storeInfo.hours.length > 0) {
                NSRange range = [self.storeInfo.hours rangeOfString:@"-"];
                NSString *startStr = [self.storeInfo.hours substringToIndex:range.location];
                
                if (startStr) {
                    startHourStr = [NSMutableString stringWithString:startStr];
                    [startHourStr replaceOccurrencesOfString:@":" withString:@"." options:NSLiteralSearch range:NSMakeRange(0, [startHourStr length])];
                    startHourStr =  [NSMutableString stringWithFormat:@"%05.2f",[startHourStr floatValue]];
                    [startHourStr replaceCharactersInRange:[startHourStr rangeOfString:@"."] withString:@":"];
                }                 
            }
            
            [cellSubView setFieldValue:startHourStr];
        }
            break;
        case StoreDetailField_WorkEndTime:
        {
            cellSubView =  [[WS_GeneralTableFieldView alloc] initWithType:WS_FieldStyle_Picker withRightBtn:FALSE delegate:self];
            
            NSMutableString *endHourStr = [NSMutableString stringWithString:@"18:00"];
            if (self.storeInfo && self.storeInfo.hours && self.storeInfo.hours.length > 0) {
                NSRange range = [self.storeInfo.hours rangeOfString:@"-"];
                NSString *endStr;
                
                @try {
                    endStr = [self.storeInfo.hours substringFromIndex:(range.location+range.length)];
                    if (endStr) {
                        endHourStr = [NSMutableString stringWithString:endStr];
                        [endHourStr replaceOccurrencesOfString:@":" withString:@"." options:NSLiteralSearch range:NSMakeRange(0, [endHourStr length])];
                        endHourStr =  [NSMutableString stringWithFormat:@"%05.2f",[endHourStr floatValue]];
                        [endHourStr replaceCharactersInRange:[endHourStr rangeOfString:@"."] withString:@":"];
                    }
                    
                }
                @catch (NSException *exception) {
                }
            }
            [cellSubView setFieldValue:endHourStr];
        }
            break;
        case StoreDetailField_BaseReate:
            cellSubView =  [[WS_GeneralTableFieldView alloc] initWithType:WS_FieldStyle_Picker  withRightBtn:FALSE delegate:self];
            if (self.storeInfo) {
                if ([self.storeInfo.discount floatValue] == 0.0f) {
                   [cellSubView setFieldValue:@"免费"];
                }  else if([self.storeInfo.discount floatValue] == 10.0f){
                    [cellSubView setFieldValue:@"暂无折扣"];
                }  else {
                    [cellSubView setFieldValue:[NSString stringWithFormat:@"%3.1f折",[NSStringSafeFormat(self.storeInfo.discount) floatValue]]];
                }
            } else {
                [cellSubView setFieldValue:[NSString stringWithFormat:@"9.0折"]];
            }
            break;
        default:
            break;
    }
    
    [cellSubView setTag:(index+FieldViewStartTag)];
    [cellSubView setFieldName:titleStr autoSize:FALSE];
    cell.accessoryView = cellSubView;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!self.fieldArray) {
        self.fieldArray = [NSMutableArray arrayWithCapacity:StoreDetailField_TotalNum];
    }
    [self.fieldArray addObject:cellSubView];
    
    return cell;
}



//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}

#pragma mark -
#pragma mark table field delegate & datsource -



-(NSInteger)pickerViewSeletedRow:(WS_GeneralTableFieldView*)fieldView component:(NSInteger)component
{
    switch (fieldView.tag - FieldViewStartTag) {
        case StoreDetailField_Type:
            [fieldView.pickView setPickWidth:200];
            
            return [[GS_GlobalObject GS_GObject] getSortIndexWithName:fieldView.fieldStr];
            
            
            
//            if(self.storeInfo){
//                return [[GS_GlobalObject GS_GObject] getSortIndex:self.storeInfo.taxo_id];
//            } else {
//                return 0;
//            }
        case StoreDetailField_BaseReate:
        {
            [fieldView.pickView setPickWidth:100];
            
            NSString *value = fieldView.fieldStr;
            if ([value isEqualToString:@"免费"]) {
                value = @"0.0";
            } else if([value isEqualToString:@"暂无折扣"]){
                value = @"10.0";
            }
            
            NSString *digitValue = [value substringToIndex:1];
            
            NSRange range = {2,1};
            NSString *unitValue = [value substringWithRange:range];
            
            if (component == 0) {
                return digitValue.intValue;
            } else {
                return unitValue.intValue;
            }
        }
            
            
        case StoreDetailField_WorkStartTime:
        case StoreDetailField_WorkEndTime:
        {
            [fieldView.pickView setPickWidth:100];
        
            NSString *hours = fieldView.fieldStr;
            
            NSRange range = [hours rangeOfString:@"-"];
            
//            NSString *startStr = [hours substringToIndex:range.location];
//            NSString *endStr = [hours substringFromIndex:(range.location  + range.length)];
//            NSString *opStr = ((fieldView.tag - FieldViewStartTag) == StoreDetailField_WorkStartTime)?startStr:endStr;
            
            range = [hours rangeOfString:@":"];
            
            NSString *hourStr = [hours substringToIndex:range.location];
            NSString *minStr = [hours substringFromIndex:(range.location+range.length)];
            
            if (component == 0) {
                return hourStr.intValue;
            } else {
                return minStr.intValue;
            }
        }
            

            
        default:
            return 0;
    }
}

-(NSString*)fieldView:(WS_GeneralTableFieldView*)fieldView  pickerViewSelected:(TSLocateView*)pickView
{
    NSString *retStr = nil;
    
    switch (fieldView.tag - FieldViewStartTag) {
        case StoreDetailField_Type:
        {
            retStr = ((StoreSort*)[self.sortArray objectAtIndex:[pickView.locatePicker selectedRowInComponent:0 ]]).name;
            break;
        }
        case StoreDetailField_BaseReate:
        {
            NSInteger unitDigit =  [pickView.locatePicker selectedRowInComponent:1];
            NSInteger tenDigit = [pickView.locatePicker selectedRowInComponent:0];
            retStr = [NSString stringWithFormat:@"%d.%d折",tenDigit,unitDigit];
            if ([retStr floatValue] == 0.0f) {
                retStr = @"免费";
            } else if([retStr floatValue] == 10.0f){
                retStr = @"暂无折扣";
            }
            break;
        }
            
        case StoreDetailField_WorkStartTime:
        case StoreDetailField_WorkEndTime:
        {
            retStr = [NSString stringWithFormat:@"%02d:%02d",[pickView.locatePicker selectedRowInComponent:0],[pickView.locatePicker selectedRowInComponent:1]];
            break;
        }
        default:
//            if ([pickView.locatePicker selectedRowInComponent:0] == 0) {
//                retStr =  @"第一行";
//            } else {
//                retStr =  @"第二行";
//            }
            break;
    }
    
    return retStr;
    }

-(void)pickerViewWillDidload:(WS_GeneralTableFieldView*)fieldView
{
    [self transFocus:fieldView];
//    if ([focusField isKindOfClass:[UITextField class]]) {
//        [focusField resignFirstResponder];
//    } else {
//        WS_GeneralTableFieldView *field = (WS_GeneralTableFieldView*)focusField;
//        [field resignFocus];
//    }
//    
//    focusField = fieldView;
    
}

- (NSInteger)fieldView:(WS_GeneralTableFieldView*)fieldView numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    switch (fieldView.tag - FieldViewStartTag) {
        case StoreDetailField_BaseReate:
            return 2;
        case StoreDetailField_WorkStartTime:
        case StoreDetailField_WorkEndTime:
            return 2;
        default:
            return 1;
    }
    
}


- (NSInteger)fieldView:(WS_GeneralTableFieldView*)fieldView pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (fieldView.tag - FieldViewStartTag) {
        case StoreDetailField_Type:
            return self.sortArray.count;
        case StoreDetailField_BaseReate:
            if (component == 0) {
                return 10;
            } else {
                return 10;
            }
        case StoreDetailField_WorkStartTime:
        case StoreDetailField_WorkEndTime:
        {
            if (component == 0) {
                return 24;
            } else {
                return 60;
            }
        }
        default:
            return 3;
    }
    
    
}

- (NSString *)fieldView:(WS_GeneralTableFieldView*)fieldView pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *retStr = nil;
    
    switch (fieldView.tag - FieldViewStartTag) {
        case StoreDetailField_Type:
        {
            retStr = ((StoreSort*)[self.sortArray objectAtIndex:row]).name;
            break;
        }
        case StoreDetailField_BaseReate:
        {
            if (component == 0) {
                retStr = [NSString stringWithFormat:@"%d.",row];
            } else {
                retStr = [NSString stringWithFormat:@"%d",row];
            }
            break;
        }
        case StoreDetailField_WorkStartTime:
        case StoreDetailField_WorkEndTime:
        {
            if (component == 0) {
                retStr = [NSString stringWithFormat:@"%d",row];
            } else {
                retStr = [NSString stringWithFormat:@"%02d",row];
            }
            break;
        }
        default:
            break;
    }
    
    
    return retStr;
}

-(void)accessPerformed
{
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus]!= kCLAuthorizationStatusDenied) {
        [GS_GlobalObject showCurentLocInsideMap:self title:@"定位商店地址" enabledSave:true];
        self.addressField.accessBtn.enabled = FALSE;
        [NSTimer scheduledTimerWithTimeInterval:2.26f block:^(NSTimeInterval time){
            self.addressField.accessBtn.enabled = TRUE;
        }repeats:NO];
        
    } else {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil
                                                        message:@"您需要先开启定位服务"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
//    CLLocation *storLocation = [[CLLocation alloc] initWithLatitude:self.storeDetailInfo.latitude longitude:self.storeDetailInfo.longitude];
//    [[GS_GlobalObject GS_GObject] pushOwnPositionInsideMap:storLocation in:self];
}

#pragma mark -
#pragma mark text field delegate -
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{

    if (textField.keyboardType == UIKeyboardTypeNumberPad ) {
        if(!textField.inputAccessoryView) {
            CInputAssistViewStyle style = CInputAssistViewDone;
            textField.inputAccessoryView = [CInputAssistView createWithDelegate:self target:textField style:style];
        }
        
        [self.tableView setContentOffset:CGPointMake(0, 44) animated:YES];
        
    }
    
    [self transFocus:textField];
    if (textField == self.addressField.fieldValueView) {
        self.hadEditedAddress = TRUE;
    }
    return TRUE;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)inputAssistViewCancelTapped:(UITextField*)aTextFiled
{
    [aTextFiled resignFirstResponder];
    focusField = nil;
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];

}
-(void)inputAssistViewDoneTapped:(UITextField*)aTextFiled
{
    [aTextFiled resignFirstResponder];
    focusField = nil;
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

//-(void)closeKeyPad:(id)sender
//{
//    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
//    tap.cancelsTouchesInView = FALSE;
//    
//    if ([focusField isKindOfClass:[UITextField class]]) {
//        [focusField resignFirstResponder];
//        focusField = nil;
//    }
//}
//
//-(void)keyboardWillChangeFrame:(NSNotification *)notification
//{
//    
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_2
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
//#endif
//#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_3_2
//        NSValue *keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
//#else
//        NSValue *keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardBoundsUserInfoKey];
//#endif
//        
//        CGRect keyboardBounds;
//        [keyboardBoundsValue getValue:&keyboardBounds];
//        
//        CGPoint point =  CGPointMake(focusField.frame.origin.x, focusField.frame.origin.y);
//        CGPoint absPoint = [focusField.superview convertPoint:point toView:nil];
//        
//        float diff = absPoint.y + focusField.frame.size.height - keyboardBounds.origin.y;
//        CGRect rect = self.contentView.frame;
//        
//        rect.origin.y -= diff +7;
//        
//        if (sourceModule <=  LogonSourceModule_QR ) {
//            if (rect.origin.y > 44) {
//                rect.origin.y = 44;
//            }
//        } else {
//            if (rect.origin.y > 44 - Logon_Offset_WithTab) {
//                rect.origin.y = 44 - Logon_Offset_WithTab;
//            }
//        }
//        
//        
//        [UIView animateWithDuration:0.26f animations:^{
//            [self.contentView setFrame:rect];
//        }completion:^(BOOL isfinished){
//            
//        }];
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_2
//    }
//#endif
//}







@end
