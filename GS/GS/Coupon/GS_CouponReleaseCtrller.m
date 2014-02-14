//
//  GS_CouponReleaseCtrller.m
//  GS
//
//  Created by W.S. on 13-6-21.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GS_CouponReleaseCtrller.h"
#import "GS_GlobalObject.h"
#import "CouonPicCell.h"

#define FieldViewStartTag 1050
#define ACTION_TakePicture 0
#define ACTION_SelPicture 1
#define ACTION_Cancel 2

typedef enum {
    Group0_Start,
    CounponEdit_Title  = Group0_Start,
    CounponEdit_Detail,
    CounponEdit_Limited,
    Group0_Over,
    Group0_Num = Group0_Over - Group0_Start,

    Group1_Start = Group0_Over,
    CounponEdit_AdvPic = Group1_Start,
    Group1_Over,
    Group1_Num = Group1_Over - Group1_Start,
    
    Group2_Start = Group1_Over,
    CounponEdit_StartTime = Group2_Start,
    CounponEdit_EndTime,
    Group2_Over,
    Group2_Num = Group2_Over - Group2_Start,

    Group3_Start = Group2_Over,
    CounponEdit_CommitBtn = Group3_Start,
    Group3_Over,
    Group3_Num = Group3_Over - Group3_Start,
    
    CouponEditField_TotalNum = Group0_Num + Group1_Num + Group2_Num + Group3_Num

}CounponEditField;
#define GroupNum 4


static char* fieldTitleStr[] = {"促销标题","促销详情","使用限制","","开始日期","结束日期"};
static char* groupTitleStr[GroupNum] = {"","添加促销海报（可选）","有效期",""};
#define TitleFieldPlaceStr  @"30个字符以内"
#define DetailFieldPlaseStr @"280个字符以内"
#define LimitedFieldPlaceStr @"选填,50个字符以内"
#define DefaultNoteStr @"本促销不与其他优惠同享"

#define TitleEmeptyTip @"请输入促销的标题"
#define BodyEmeptyTip @"请输入促销的详细信息"
#define OldDateTip @"请输入正确的促销日期"
#define CouponReleaseTip @"*在此发布的促销的优惠力度不得低于基础折扣，否则不予通过审核"

@interface GS_CouponReleaseCtrller ()
@property (nonatomic,strong) UIImage *couponImg;
@property (nonatomic,assign) BOOL couponImgdeleted ;

//@property (nonatomic,assign) BOOL hadChangedAdvImg;

@end
@implementation GS_CouponReleaseCtrller

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
    if(self){
        self.coupon  = coupon;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavTitle:@"发布促销"];
    [self addBackItem:@"返回" action:@selector(goback)];
    
    self.tableView.backgroundView =nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    if (IOS_VERSION >= 7.0) {
        [self.tableView move:20 direct:Direct_Up];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    self.commitBtn.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setCommitBtn:nil];
    [super viewDidUnload];
}
- (IBAction)commitClick:(id)sender {
    Coupon *coupon = [[Coupon alloc] init];
    coupon.store_id = IsSafeString(self.storeId)?self.storeId:self.coupon.store_id;
    
    BOOL isAdd = TRUE;
//    if (self.coupon && self.coupon.status == CouponStatus_Cancel) {
//        isAdd = FALSE;
//    }
    if (self.coupon) {
        isAdd = FALSE;
    }
    
    if (!isAdd) {
        coupon.id = self.coupon.id;
    }
    
    WS_GeneralTableFieldView *field;
    for (int k = 0; k < CouponEditField_TotalNum; k++) {
        UIView *v  = [self.fieldArray objectAtIndex:k];
        switch (k) {
            case CounponEdit_Title:
                field = (WS_GeneralTableFieldView*)v;
                coupon.title = field.fieldStr;
                break;
            case CounponEdit_Detail:
                field = (WS_GeneralTableFieldView*)v;
                coupon.body = field.fieldStr;
                break;
                
            case CounponEdit_Limited:
                field = (WS_GeneralTableFieldView*)v;
                coupon.note = field.fieldStr;
                break;
                
            case CounponEdit_StartTime:
                field = (WS_GeneralTableFieldView*)v;
                coupon.start = transfromChinaDateStr(field.fieldStr, @"/");
                break;
                
            case CounponEdit_EndTime:
                field = (WS_GeneralTableFieldView*)v;
                coupon.end = transfromChinaDateStr(field.fieldStr, @"/");
                break;
            case CounponEdit_AdvPic:
                if (self.couponImg) {
                    NSData *imgData = UIImageJPEGRepresentation(self.couponImg, 0.5);
                    coupon.coupon_picture = [imgData base64EncodedString];
                } else if(self.couponImgdeleted) {
                    coupon.coupon_picture =@"0";
                }
//                else  if(self.coupon && IsSafeString(self.coupon.image_url)){
//                    coupon.image_url = self.coupon.image_url;
//                }
                break;
            default:
                break;
        }
    }
    
    if (!coupon.title || coupon.title.length == 0) {
        [GS_GlobalObject showPopup:TitleEmeptyTip];
        return;
    }
    
    if (!coupon.body ||coupon.body.length == 0) {
        [GS_GlobalObject showPopup:BodyEmeptyTip];
        return;
    }
    
    NSString *startStr = transtoChinaDateStr(coupon.start,@"/");
    NSDate *startDate =  dateFromChinaDateString(startStr);
    NSString *curStr = transDatetoChinaDateStr([NSDate date]);
    NSDate *curDate = dateFromChinaDateString(curStr);
    
    if ([startDate compare:curDate] < NSOrderedSame) {
        [GS_GlobalObject showPopup:OldDateTip];
        return;
    }
    
    self.commitBtn.enabled = FALSE;
    
    iStatus = WS_ViewStatus_Getting;
    [NSTimer scheduledTimerWithTimeInterval:0.26f target:self selector:@selector(showWatting) userInfo:nil repeats:NO];
    

    [GSCouponService saveCoupon:coupon isAdd:isAdd succ:^(NSObject *obj){
//        if (self.coupon && isAdd) {
//            [GSCouponService deleteCoupon:self.coupon.id status:<#(int)#>]
//        }
        
        iStatus = WS_ViewStatus_Normal;
        [self hideWaitting];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(reReleaseOK:)]) {
            [self.delegate performSelector:@selector(reReleaseOK:) withObject:coupon];
        }
        
        [GS_GlobalObject showPopup:@"发布成功"];
        [self goback];
    }fail:^(NSError *err){
        iStatus = WS_ViewStatus_GetFail;
        [self hideWaitting];
        
        [GS_GlobalObject showPopup:err.localizedDescription];
        self.commitBtn.enabled = TRUE;
        
    }];
}

-(void)goback
{
    if(focusField && [focusField isKindOfClass:[WS_GeneralTableFieldView class]]){
        WS_GeneralTableFieldView *field = (WS_GeneralTableFieldView*)focusField;
        [field resignFocus];
    }
    [super goback];
}

-(void)saveText:(NSString *)text
{
    NSIndexPath *indexPath =  [self.tableView indexPathForSelectedRow];
    NSInteger index = (indexPath.section == 0 ? indexPath.row : (Group1_Start + indexPath.row));

    WS_GeneralTableFieldView *field = [self.fieldArray objectAtIndex:index];
    [field setFieldValue:text];
    
}
-(void)modifyAdvPic
{
    UIActionSheet *sheet;
    
    if ((self.coupon && IsSafeString(self.coupon.image_url) && !self.couponImgdeleted) || self.couponImg) {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除图片" otherButtonTitles:@"拍照",@"相册", nil];
    } else {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    }
    
    [sheet showInView:APP_DELEGATE.window];
}

#pragma mark -
#pragma mark table datasource & delegate  -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return GroupNum;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    static int rows[] = {Group0_Num,Group1_Num,Group2_Num,Group3_Num};
    return rows[section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return section==0?[GS_GlobalObject GS_GObject].iStore.name:[NSString stringWithUTF8String:groupTitleStr[section]];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
        v.backgroundColor = [UIColor clearColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width - 20, 30)];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 2;
        label.text = CouponReleaseTip;
        label.textColor =[UIColor redColor];
        label.font = FONT_NORMAL_12;
        [v addSubview:label];
        
        return v;
    } else {
        return nil;
    }
}

-(int)caluateIndex:(NSIndexPath *)indexPath
{
    static int rows[] = {Group0_Num,Group1_Num,Group2_Num,Group3_Num};
    
    int index = 0;
    for (int k = 0; k < indexPath.section; k++) {
        index += rows[k];
    }
    index+= indexPath.row;
    
    return index;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableString *cellIdentifier = [[NSMutableString alloc] initWithString:@"CouponCell"];
    NSInteger index = [self caluateIndex:indexPath];
    [cellIdentifier appendFormat:@"%d",index];
    
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        WS_GeneralTableFieldView *cellSubView = nil;
        UIView *cellView;
        switch (index) {
            case CounponEdit_Title:
            case CounponEdit_Detail:
            case CounponEdit_Limited:
            {
                 cellSubView =  [[WS_GeneralTableFieldView alloc] initWithType:WS_FieldStyle_Text withRightBtn:FALSE delegate:nil];
                [cellSubView setTag:(index + FieldViewStartTag)];
                [cellSubView setFieldName:[NSString stringWithUTF8String:fieldTitleStr[index]] autoSize:FALSE];
                [cellSubView setFieldPlaceHolder:index==CounponEdit_Title?TitleFieldPlaceStr:(index==CounponEdit_Detail?DetailFieldPlaseStr:LimitedFieldPlaceStr)];
                ((UITextField*)cellSubView.fieldValueView).borderStyle = UITextBorderStyleNone;
                ((UITextField*)cellSubView.fieldValueView).userInteractionEnabled = FALSE;
              //  cell.accessoryView = cellSubView;
                [cellSubView move:20 direct:Direct_Right];
                [cell addSubview:cellSubView];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
         //       cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if (self.coupon) {
                    if (index == CounponEdit_Title ) {
                        [cellSubView setFieldValue:self.coupon.title];
                    } else if(index == CounponEdit_Detail) {
                        [cellSubView setFieldValue:self.coupon.body];
                    } else {
                        [cellSubView setFieldValue:self.coupon.note];
                    }
                } else {
                    if(index == CounponEdit_Limited){
                        [cellSubView setFieldValue:DefaultNoteStr];
                        [cellSubView setFieldValueColor:[UIColor darkGrayColor]];
                    }
                }
                
                break;
            }
            case CounponEdit_StartTime:
            case CounponEdit_EndTime:
            {
                cellSubView =  [[WS_GeneralTableFieldView alloc] initWithType:WS_FieldStyle_DatePicker withRightBtn:FALSE delegate:self];
                [cellSubView setTag:(index + FieldViewStartTag)];

                [cellSubView setFieldName:[NSString stringWithUTF8String:fieldTitleStr[index]] autoSize:FALSE];
                [cellSubView setFieldValue:transDatetoChinaDateStr([NSDate date])];
                cell.accessoryView = cellSubView;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                if (index == CounponEdit_StartTime) {
                    self.startDateField = cellSubView;
                } else {
                    self.endDateField = cellSubView;
                }
                
                if (self.coupon) {
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
                    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    if (index == CounponEdit_StartTime) {
                        [cellSubView setFieldValue:transDatetoChinaDateStr([formatter dateFromString:self.coupon.start])];
                    } else {
                        [cellSubView setFieldValue:transDatetoChinaDateStr([formatter dateFromString:self.coupon.end])];
                    }
                }
                break;
            }
            case CounponEdit_AdvPic:
            {
                CouonPicCell *picCell  = [[[NSBundle mainBundle] loadNibNamed:@"CouonPicCell" owner:self options:nil] objectAtIndex:0 ];
                if ((self.coupon && IsSafeString(self.coupon.image_url) && !self.couponImgdeleted) || self.couponImg) {
                    [picCell.advImgV setFrame:CGRectMake(0, 0, 290, 290.0f/480.0f*220.0f)];
                    picCell.tipLabel.hidden = YES;
                    [picCell setFrame:CGRectMake(15, 0, 290, 290.0f/480.0f*220.0f)];

                    if (self.couponImg) {
                        [picCell.advImgV showDefaultImg:self.couponImg];
                    } else {
                        [picCell.advImgV  showUrl:[NSURL URLWithString:self.coupon.image_url]];
                    }
                    picCell.advImgV.layer.cornerRadius = 7;
                    [picCell.advImgV.layer setMasksToBounds:YES]; 
                    picCell.advImgV.layer.borderColor =[[UIColor lightGrayColor] CGColor];
                    picCell.advImgV.layer.borderWidth = 1;
                } else {
                    [picCell setFrame:CGRectMake(15, 0, 290, 65)];

                    [picCell.advImgV showDefaultImg:[UIImage imageNamed:@"storePicAdd"]];
                    [picCell.advImgV setFrame:CGRectMake(0, 0, 65, 65)];

                }
                [picCell.advImgV addTarget:self action:@selector(modifyAdvPic) forControlEvents:UIControlEventTouchUpInside];
                cellView = picCell;
                //cell.accessoryView = cellView;
                [cell addSubview:cellView];
                UIView *tempView = [[UIView alloc] init];
                [cell setBackgroundView:tempView];
                if (IOS_VERSION >= 7.0) {
                    cell.backgroundColor = [UIColor clearColor];
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

                break;
            }
            case CounponEdit_CommitBtn:
            {
                UIView *tempView = [[UIView alloc] init];
                [cell setBackgroundView:tempView];
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setFrame:CGRectMake(30, 5, 250, 38)];
                [btn setTitle:@"提交" forState:UIControlStateNormal];
                 btn.titleLabel.font = FONT_BOLD_18;
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(commitClick:) forControlEvents:UIControlEventTouchUpInside];
                                [btn setBackgroundImage:[UIImage imageNamed:@"logon_logon"] forState:UIControlStateNormal];
                [cell addSubview:btn];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

                cellView = btn;
                if (IOS_VERSION >= 7.0) {
                    cell.backgroundColor = [UIColor clearColor];
                }
                break;
            }
            default:
                break;
        }
        if (!self.fieldArray) {
            self.fieldArray = [NSMutableArray arrayWithCapacity:CouponEditField_TotalNum];
        }
        if (cellSubView) {
            cellView = cellSubView;
        }
        
        self.fieldArray[index] = cellView;
//        [self.fieldArray insertObject:cellView atIndex:index];
    }
   

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if(focusField && [focusField isKindOfClass:[WS_GeneralTableFieldView class]]){
            WS_GeneralTableFieldView *field = (WS_GeneralTableFieldView*)focusField;
            [field resignFocus];
        }
        
        focusField = nil;
        
        
        GS_EditCtrller *vc;
        
        NSInteger index = [self caluateIndex:indexPath];//(indexPath.section == 0 ? indexPath.row : (Group1_Start + indexPath.row));
        
        if (index == CounponEdit_Detail || index == CounponEdit_Limited) {
            vc = [[GS_EditCtrller alloc] initWithStyle:EditStyle_TextView delegate:self];
            [vc setMaxChar:280];
        } else {
            vc = [[GS_EditCtrller alloc] initWithStyle:EditStyle_TextField delegate:self];
            [vc setMaxChar:30];
        }
        
        [self.navigationController pushViewController:vc animated:YES];
        [vc setNavTitle:[NSString stringWithUTF8String:fieldTitleStr[index]]];
        [vc setText:((WS_GeneralTableFieldView*)[self.fieldArray objectAtIndex:index]).fieldStr];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [self caluateIndex:indexPath];
    if (index == CounponEdit_AdvPic) {
        if ((self.coupon && IsSafeString(self.coupon.image_url) && !self.couponImgdeleted) || self.couponImg) {
            return 220.0f / 480.0f * 290.0f + 5;
        } else {
            return 65;
        }
    } else {
        return 44;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 30;
    } else {
        return 10;
    }
}

#pragma mark -
#pragma mark table field delegate & datsource -



-(NSInteger)pickerViewSeletedRow:(WS_GeneralTableFieldView*)fieldView component:(NSInteger)component
{
    switch (fieldView.tag - FieldViewStartTag) {
        case CounponEdit_StartTime:
        case CounponEdit_EndTime:
        {
            if (fieldView.tag - FieldViewStartTag == CounponEdit_StartTime) {
                [fieldView.pickView.locateDatePicker setMinimumDate:fieldView.pickView.locateDatePicker.date];
            } else {
                [fieldView.pickView.locateDatePicker setMinimumDate:self.startDate?self.startDate:fieldView.pickView.locateDatePicker.date];
            }
            
            NSString *dateStr = fieldView.fieldStr;
            NSDate *date = dateFromChinaDateString(dateStr);
            
            if ([date compare:[NSDate date]] >= NSOrderedSame) {
                [fieldView.pickView.locateDatePicker setDate:date];
            }
            
            return 0;
        }
            
        default:
            return 0;
    }
}

-(NSString*)fieldView:(WS_GeneralTableFieldView*)fieldView  pickerViewSelected:(TSLocateView*)pickView
{
    NSString *retStr = nil;
    
    switch (fieldView.tag - FieldViewStartTag) {
        case CounponEdit_StartTime:
        case CounponEdit_EndTime:
        {
            NSDate *date = fieldView.pickView.locateDatePicker.date;
            retStr = transDatetoChinaDateStr(date);
            
            if ((fieldView.tag - FieldViewStartTag) == CounponEdit_StartTime) {
                self.startDate = date;
                if(!self.endDate || [self.endDate compare:self.startDate] < NSOrderedSame){
                    [self.endDateField setFieldValue:transDatetoChinaDateStr(self.startDate)];
                }
            } else {
                self.endDate = date;
            }
            
            break;
        }
              default:
                break;
    }
    
    return retStr;
}

-(void)pickerViewWillDidload:(WS_GeneralTableFieldView*)fieldView
{
//    [self transFocus:fieldView];

    focusField = fieldView;

}

- (NSInteger)fieldView:(WS_GeneralTableFieldView*)fieldView numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    switch (fieldView.tag - FieldViewStartTag) {
        case CounponEdit_StartTime:
        case CounponEdit_EndTime:
            return 3;
        default:
            return 1;
    }
    
}


//- (NSInteger)fieldView:(WS_GeneralTableFieldView*)fieldView pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
//{
//    return 0;
//    
//}
//
//- (NSString *)fieldView:(WS_GeneralTableFieldView*)fieldView pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    NSString *retStr = nil;
//    
//    switch (fieldView.tag - FieldViewStartTag) {
//        case StoreDetailField_Type:
//        {
//            retStr = ((StoreSort*)[self.sortArray objectAtIndex:row]).name;
//            break;
//        }
//        case StoreDetailField_BaseReate:
//        {
//            if (component == 0) {
//                retStr = [NSString stringWithFormat:@"%d.",row];
//            } else {
//                retStr = [NSString stringWithFormat:@"%d",row];
//            }
//            break;
//        }
//        case StoreDetailField_WorkStartTime:
//        case StoreDetailField_WorkEndTime:
//        {
//            if (component == 0) {
//                retStr = [NSString stringWithFormat:@"%d",row];
//            } else {
//                retStr = [NSString stringWithFormat:@"%02d",row];
//            }
//            break;
//        }
//        default:
//            break;
//    }
//    
//    
//    return retStr;
//}
//
//-(void)accessPerformed
//{
//    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus]!= kCLAuthorizationStatusDenied) {
//        [GS_GlobalObject showCurentLocInsideMap:self title:@"定位商店地址" enabledSave:true];
//        self.addressField.accessBtn.enabled = FALSE;
//        [NSTimer scheduledTimerWithTimeInterval:2.26f block:^(NSTimeInterval time){
//            self.addressField.accessBtn.enabled = TRUE;
//        }repeats:NO];
//        
//    }
//    
//    //    CLLocation *storLocation = [[CLLocation alloc] initWithLatitude:self.storeDetailInfo.latitude longitude:self.storeDetailInfo.longitude];
//    //    [[GS_GlobalObject GS_GObject] pushOwnPositionInsideMap:storLocation in:self];
//}
#pragma mark -
#pragma mark action sheet delegate -

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger click = buttonIndex;
    
    if ((self.coupon && IsSafeString(self.coupon.image_url) && !self.couponImgdeleted) || self.couponImg) {
        click--;
    }
    
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    
    
        switch (click) {
            case ACTION_TakePicture:
                imgPicker.allowsEditing = NO;
                imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imgPicker animated:YES completion:nil];
                break;
            case ACTION_SelPicture:
            {
                imgPicker.allowsEditing = NO;
                imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                
                [self presentViewController:imgPicker animated:YES completion:nil];
            }
                break;
            case ACTION_Cancel:
                break;
            default: //删除
            {
                if (self.coupon && IsSafeString(self.coupon.image_url)) {
                    self.couponImgdeleted = TRUE;
                }
                self.couponImg = nil;
                
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
                break;
            }
        }
    
}
#pragma mark -
#pragma mark photo picker delegate -

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *img = [[info objectForKey:UIImagePickerControllerOriginalImage] fixOrientation];
    
    GKImgCroperViewController *vc = [[GKImgCroperViewController alloc] initWithImg:img style:CroperStyle_480X220];
    vc.delegate = self;
    [self dismissViewControllerAnimated:NO completion:^{
        showModalViewCtroller(self, vc, YES);
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)saveImage:(UIImage *)img
{
    NSLog(@"saveImage");
    self.couponImg = img;
  //  self.hadChangedAdvImg = TRUE;
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
}
@end
