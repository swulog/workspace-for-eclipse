//
//  GKCommentReleaseCtrller.m
//  GK
//
//  Created by W.S. on 13-12-13.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GKCommentReleaseCtrller.h"
#import "GKAppDelegate.h"
#import "GKCommentService.h"
#import "MMProgressHUD.h"
#import "GlobalObject.h"

#define RankBtnNum 2
#define GoodCommentTag 1
#define BadCommentTag 0
#define PresetCommentNum 3
#define SyncSNSNum 4
#define ShareContentMaxLength 100
#define ShareTxt @"我在 @贵客 对【%@】发表了评价：\"%@\"\n 下载贵客：" GK_WebSite

@interface GKCommentReleaseCtrller ()<UMSocialUIDelegate>
{
    dispatch_once_t onceToken;
    float offset;
    NSString *badSubject,*goodSubject;
    NSString *SyncSns[SyncSNSNum];
    NSString *SyncSnsChinaName[SyncSNSNum];

    NSInteger bakStatus;
    NSInteger lines;
    BOOL releasing;
    
    float textViewOrgHeight;
}
@property (nonatomic,assign) BOOL custScroll ;
@property (nonatomic,assign) BOOL isDraging ;


@property (nonatomic,assign) NSInteger rankTag;
@property (nonatomic,assign) NSUInteger relaseStatus;

@property (nonatomic,strong) NSString *subject;
@property (nonatomic,copy) NillBlock_BOOL syncHandler;

@end

@implementation GKCommentReleaseCtrller

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil style:VIEW_WITH_NAVBAR];
    if (self) {
        // Custom initialization
        [self initParams];
    }
    return self;
}

-(id)initWithStore:(StoreInfo*)store
{
    self =[self init];
    if (self) {
        self.store = store;
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"添加评论"];
    [self addBackItemWithCloseImg:@selector(goBack)];
//    [self addBackItem:nil img:nil action:@selector(goBack)];
    [self addNavRightItem:@"发表" action:@selector(releaseComment)];
    [self.rightBtn setEnabled:FALSE];
    
    [self.scrollContentView enableScrollFor:self];

    [self initUi];
    [self initGestureRecognizer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];

    [self.goodBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
}



-(void)viewWillLayoutSubviews
{
    dispatch_once(&onceToken, ^{
        if (isRetina_640X960) {
            CGRect rect = self.subjectTextView.frame;
            rect.size.height -= 27;
            self.subjectTextView.frame = rect;
        }
        textViewOrgHeight = self.subjectTextView.frame.size.height;
    });
}


- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark initer -

-(void)initUi
{
    self.goodBtn.backgroundColor = colorWithUtfStr(StoreSortLC_NormalBGColor);
    self.badBtn.backgroundColor = colorWithUtfStr(StoreSortLC_NormalBGColor);
    
    self.goodBtn.selectedColor = colorWithUtfStr(HomePageC_NavPopViewFootColor);
    self.badBtn.selectedColor = colorWithUtfStr(SortListC_ButtonBgColor);
    
    [self.goodBtn setTitleColor:colorWithUtfStr(SortListC_ButtonTextColor) forState:UIControlStateNormal];
    [self.badBtn setTitleColor:colorWithUtfStr(SortListC_ButtonTextColor) forState:UIControlStateNormal];
    
    [self.goodBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.badBtn setTitleColor:colorWithUtfStr(SortListC_ButtonHightedColor) forState:UIControlStateSelected];
    
    [self initPresetCommentBtn:self.commentBtn0];
    [self initPresetCommentBtn:self.commentBtn1];
    [self initPresetCommentBtn:self.commentBtn2];
    self.presetCommentView.clipsToBounds = YES;
    
    self.subjectTextView.layer.borderColor = [colorWithUtfStr(StoreSortLC_NormalBGColor) CGColor];
    self.subjectTextView.layer.borderWidth = 2;
    if (IOS_VERSION < 7.0) {
        self.subjectTextView.contentInset = UIEdgeInsetsMake(1, 5, 3, 3);
    } else {
        self.subjectTextView.textContainerInset =  UIEdgeInsetsMake(10, 5,10, 2);
    }
    
    self.label.textColor = colorWithUtfStr(SortListC_ButtonTextColor);

    [self initSyncSNSBtn];
}

-(void)initPresetCommentBtn:(UIButton*)btn
{
    btn.layer.borderColor = [colorWithUtfStr(StoreSortLC_NormalBGColor) CGColor];
    btn.layer.borderWidth = 2;
    [btn setTitleColor:colorWithUtfStr(SortListC_ButtonTextColor) forState:UIControlStateNormal];
}

-(void)initSyncSNSBtn
{
    WSLargeButton *btns[] = {self.sinaBtn,self.qqWBBtn,self.qqZoneBtn,self.qqFriendBtn};
    
    UIColor *disabledColor = colorWithUtfStr(ComemntReleaseC_SNSDisabledColor);
    UIColor *enabledColor = colorWithUtfStr(ComemntReleaseC_SNSEnabledColor);
    
    for (int k = 0; k < SyncSNSNum; k++) {
        btns[k].selectedColor = enabledColor;
        btns[k].normalBGColor = disabledColor;
        if (![GlobalObject SNSSyncClosed:SyncSns[k]]) {
            if ([UMSocialAccountManager isOauthWithPlatform:SyncSns[k]])
                btns[k].selected = TRUE;
        }
     }
}

-(void)initParams
{
    SyncSns[0] = UMShareToSina;
    SyncSns[1] = UMShareToTencent;
    SyncSns[2] = UMShareToQzone;
    SyncSns[3] = UMShareToWechatTimeline;
    
    SyncSnsChinaName[0] = @"新浪微博";
    SyncSnsChinaName[1] = @"腾讯微博";
    SyncSnsChinaName[2] = @"QQ空间";
    SyncSnsChinaName[3] = @"朋友圈";

}

-(void)initGestureRecognizer
{
    UITapGestureRecognizer *clickRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(closeKeyPad:)];
    [clickRecognizer setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:clickRecognizer];
}

#pragma mark -
#pragma mark setter -
-(void)setRankTag:(NSInteger)rankTag
{
    if (rankTag != _rankTag) {
        _rankTag = rankTag;
        NSInteger status = bakStatus;
        bakStatus = self.relaseStatus;
        self.relaseStatus = status;
        
        WSLargeButton *btns[RankBtnNum] = {self.badBtn,self.goodBtn};
        for (int k = 0; k < RankBtnNum; k++)
            [btns[k] setSelected:(k == rankTag)];
        
        if (offset == 0) {
            offset = self.presetCommentView.frame.size.height;
            return;
        }

        NSString *text ;
        float alpha = 0 ;
        CGRect rect1 = self.subjectTextView.frame;
        if (rankTag == BadCommentTag) {
            rect1.size.height += (offset + 10);
            rect1.origin.y -= (offset + 10);
            goodSubject = self.subjectTextView.text;
            text = badSubject;
        } else {
            rect1.size.height -= (offset + 10);
            rect1.origin.y += (offset + 10);
            alpha = 1;
            badSubject = self.subjectTextView.text;
            text = goodSubject;
        }
        
        [UIView animateWithDuration:CMM_AnimatePerior animations:^{
            self.subjectTextView.frame = rect1;
            self.presetCommentView.alpha = alpha;
        } completion:Nil];
        [UIView transitionWithView:self.subjectTextView duration:CMM_AnimatePerior options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            self.subjectTextView.text = text;
        } completion:Nil];

        [self.subjectTextView resignFirstResponder];
    }
}

-(void)setRelaseStatus:(NSUInteger)relaseStatus
{
    _relaseStatus = relaseStatus;
    [self.rightBtn setEnabled:(relaseStatus > 0)];
}
#pragma mark -
#pragma mark event handler -

-(void)goBack
{
    [self dismissFullViewControllerAnimated:YES completion:nil];
}

-(void)releaseComment
{
    if (releasing) {
        [self showTopPop:@"正在发布评论，请稍候"];
        return;
    }
    
    releasing = TRUE;
    [self.subjectTextView resignFirstResponder];
    
    [self showWaiting:@"正在上传评论" task:^{
        __block BOOL finished = FALSE;
        __block Comment *comment;
        while (!finished) {
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            {
                [self buildSubject];
                [GKCommentService releaseComment:self.store.id subject:self.subject rank:self.rankTag succ:^(NSObject *obj){
                    comment = (Comment*)obj;
                    dispatch_semaphore_signal(sema);
                } fail:^(NSError *err) {
                    finished = TRUE;
                    releasing = FALSE;
                    [self updateWaittingForError:@"上传失败,请稍候再试"];
                    dispatch_semaphore_signal(sema);
                }];
            }
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            
            if (!finished) {
                WSLargeButton *btns[] = {self.sinaBtn,self.qqWBBtn,self.qqZoneBtn,self.qqFriendBtn};
                for (int k = 0; k < SyncSNSNum; k++) {
                    if (btns[k].selected) {
                        [self updateWaitting:[NSString stringWithFormat:@"正在同步:%@",SyncSnsChinaName[k]]];
                        sema = dispatch_semaphore_create(0);
                        [self SNSShare:SyncSns[k] block:^(BOOL successed) {
                            if (!successed) {
                                [self updateWaitting:[NSString stringWithFormat:@"同步%@失败",SyncSnsChinaName[k]]];
                            }
                            dispatch_semaphore_signal(sema);
                        }];
                        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
                    }
                }
                [self updateWaittingForSuccess:@"发布评论成功"];
                releasing = FALSE;
                finished = TRUE;
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_CommentRelease object:comment];
                
                double delayInSeconds = 1.5f;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    NSLog(@"goback");
                    [self goBack];

                });
            }
        }
    }];
    
    
//    MBProgressHUD *hud =  [[MBProgressHUD alloc] initToView:self.maskView];
//    [hud setMode:MBProgressHUDModeIndeterminate];
//    [hud setLabelText:@"正在上传评论"];
//    [hud setLabelFont:FONT_NORMAL_13];
//    [hud showWhileExecuting:^{
//        __block BOOL finished = FALSE;
//        while (!finished) {
//            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
//            {
//                [GKCommentService releaseComment:self.store.id subject:self.subject rank:self.rankTag succ:^{
//                    dispatch_semaphore_signal(sema);
//                } fail:^(NSError *err) {
//                    finished = TRUE;
//                    dispatch_semaphore_signal(sema);
//                }];
//            }
//            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
//            
//            if (finished) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                UIImage *image = [MMVectorImage
//                                  vectorImageShapeOfType:MMVectorShapeTypeX
//                                  size:CGSizeMake(37, 37)
//                                  fillColor:[UIColor colorWithWhite:1.f alpha:1.f]];
//                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//                hud.customView = imageView;
//                [hud setMode:MBProgressHUDModeCustomView];
//                [hud setLabelText:@"上传失败,请稍候再试"];
//                [hud hide:YES afterDelay:1.f];
//                    [self.maskView removeFromSuperview];
//                releasing = FALSE;
//                
//                });
//                break;
//            }
//            
//            WSLargeButton *btns[] = {self.sinaBtn,self.qqWBBtn,self.qqZoneBtn,self.qqFriendBtn};
//            for (int k = 0; k < SyncSNSNum; k++) {
//                if (btns[k].selected) {
//                    [hud setLabelText:[NSString stringWithFormat:@"正在同步:%@",SyncSnsChinaName[k]]];
//
//                    sema = dispatch_semaphore_create(0);
//                    [self SNSShare:SyncSns[k] block:^(BOOL successed) {
//                        if (!successed) {
//                            [hud setLabelText:[NSString stringWithFormat:@"同步%@失败",SyncSnsChinaName[k]]];
//                            sleep(1);
//                        }
//                        dispatch_semaphore_signal(sema);
//                    }];
//                    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
//                }
//            }
//            
//            finished = TRUE;
//            
//            if (finished) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    UIImage *image = [MMVectorImage
//                                      vectorImageShapeOfType:MMVectorShapeTypeCheck
//                                      size:CGSizeMake(37, 37)
//                                      fillColor:[UIColor colorWithWhite:1.f alpha:1.f]];
//                    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//                    hud.customView = imageView;
//                    [hud setMode:MBProgressHUDModeCustomView];
//
//                    [hud setLabelText:@"发布评论成功"];
//                    [hud hide:YES afterDelay:1.f];
//                    [self performSelector:@selector(goBack) withObject:nil afterDelay:1.5f];
//                });
//                break;
//            }
//        }
//    } animated:YES];
}

- (IBAction)presetCommentClick:(id)sender {
    UIButton *btn = sender;
    btn.selected = !btn.selected;
    btn.layer.borderColor = [colorWithUtfStr(btn.selected ?HomePageC_NavPopViewFootColor : StoreSortLC_NormalBGColor) CGColor];
    
    if (btn.selected)
        self.relaseStatus |= 1<<btn.tag;
    else
        self.relaseStatus &= ~(1<<btn.tag);
}

- (IBAction)commentTagClick:(id)sender {
    WSLargeButton *btn = sender;
    self.rankTag = btn.tag;
}


-(void)closeKeyPad:(id)sender
{
    [self.subjectTextView resignFirstResponder];
}

- (IBAction)snsClick:(id)sender {
    WSLargeButton *btn = sender;
    if (btn.selected) {
        btn.selected = !btn.selected;
        [GlobalObject SNSSyncClose:SyncSns[btn.tag]];
    } else {
        if ([UMSocialAccountManager isOauthWithPlatform:SyncSns[btn.tag]]) {
            btn.selected = TRUE;
            [GlobalObject SNSSyncOpen:SyncSns[btn.tag]];
        } else {
            [self OauthWtihSNS:btn.tag];
        }
    }
}



#pragma mark -
#pragma mark Inside Fcuntion -
-(NSString*)buildSubject
{
    NSMutableString *subject = [NSMutableString string];
    if (self.rankTag == GoodCommentTag) {
        UIButton *btns[] = {self.commentBtn0,self.commentBtn1,self.commentBtn2};
        for (int k = 0; k < PresetCommentNum; k++)
        {
            if ((self.relaseStatus & (1<<k)) > 0)
                [subject appendString:btns[k].titleLabel.text];
        }
    }

    if (IsSafeString(self.subjectTextView.text))
        [subject appendString:self.subjectTextView.text];
    
    _subject = subject;
    return subject;
}

-(void)setReducationProperty:(NSString*)property value:(NSValue*)value delay:(float)second
{
    NSValue *oldValue = [self valueForKey:property];
    [self setValue:value forKey:property];
    double delayInSeconds = second;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self setValue:oldValue forKey:property];
    });
}

#pragma mark -
#pragma mark Network adapter -

#pragma mark -
#pragma mark Umshare handler -
-(void)OauthWtihSNS:(NSInteger)index
{
    NSString *platformName = (NSString*)GSNSS[index];
    
    [UMSocialControllerService defaultControllerService].socialUIDelegate = self;
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:platformName];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            WSLargeButton *btns[] = {self.sinaBtn,self.qqWBBtn,self.qqZoneBtn,self.qqFriendBtn};
            btns[index].selected = TRUE;
            [GlobalObject SNSSyncOpen:SyncSns[index]];
        } else {
            NSLog(@"授权失败");
        }
    });
    
}

-(void)SNSShare:(NSString*)plateName block:(NillBlock_BOOL)callBack
{
    self.syncHandler = callBack;
    [self SNSShare:plateName];
}

- (void)SNSShare:(NSString*)plateName {
    
    
    NSString *shareContent = [NSString stringWithFormat:ShareTxt,self.store.name,[self.subject substringToIndex:MIN(ShareContentMaxLength, self.subject.length)]];
 //   UIImage *shareImage =  nil;//[UIImage imageNamed:@"IOS114.png"] ;
    
    if ([plateName isEqualToString:UMShareToWechatTimeline]) {
        [UMSocialData defaultData].extConfig.title = shareContent;
    }
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[plateName] content:shareContent image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
        if (self.syncHandler) {
            self.syncHandler(shareResponse.responseCode == UMSResponseCodeSuccess);
            self.syncHandler = nil;
        }
    }];
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    if (self.syncHandler) {
        self.syncHandler(response.responseCode == UMSResponseCodeSuccess);
        self.syncHandler = nil;
    }
    
}
#pragma mark -
#pragma mark UiTextView Delegate -
- (void)textViewDidChange:(UITextView *)textView
{
    if (IsSafeString(textView.text))
        self.relaseStatus |= 1<<SyncSNSNum;
    else
        self.relaseStatus &= ~(1<<SyncSNSNum);
    

}


//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGSize size = [self.subjectTextView.text sizeWithFont:[self.subjectTextView font]];
//    //取出文字的高度
//    int length = size.height;
//    //计算行数
//    int colomNumber = self.subjectTextView.contentSize.height/length;
//  //   || (lines != colomNumber)
////    if (scrollView == self.subjectTextView&& !self.isDraging && (!self.custScroll)) {
////        //custScroll = TRUE;
////        
////        NSLog(@"%d %d",colomNumber,length);
////
////        
////            lines = colomNumber;
////            [self setReducationProperty:@"custScroll" value:[NSNumber numberWithBool:TRUE] delay:0.3];
////            
////            
////            CGPoint p = scrollView.contentOffset;
////            p.y += 10;
////            scrollView.contentOffset = p;
////
////        
//////        double delayInSeconds = 1.0;
//////        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//////        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//////            custScroll = FALSE;
//////        });
////    }
//}
//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    if (scrollView == self.subjectTextView) {
//        self.isDraging = TRUE;
//    }
//}
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    if (scrollView == self.subjectTextView) {
//        self.isDraging = FALSE;
//    }
//}



-(void)keyboardWillChangeFrame:(NSNotification *)notification
{

    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        
        
        
        NSValue *keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
        
        CGRect keyboardBounds;
        [keyboardBoundsValue getValue:&keyboardBounds];
        
        if (keyboardBounds.origin.y == APP_DELEGATE.window.frame.size.height) {
            CGRect rect =       self.subjectTextView.frame;
            rect.size.height = textViewOrgHeight;
        //    [self setReducationProperty:@"custScroll" value:[NSNumber numberWithBool:TRUE] delay:0.2];
            self.subjectTextView.frame = rect;
            if (self.subjectTextView.contentSize.height < rect.size.height) {
                [self.subjectTextView setContentOffset:CGPointZero animated:YES];
            }
        } else {
            CGPoint point =  self.subjectTextView.frame.origin;
            point = [self.subjectTextView.superview convertPoint:point toView:nil];
            float diff = point.y  - keyboardBounds.origin.y;
            CGRect rect =  self.subjectTextView.frame;
            rect.size.height =  - diff ;
            
            CGRect orgKeyboardBounds;
            keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey];
            [keyboardBoundsValue getValue:&orgKeyboardBounds];
            if (orgKeyboardBounds.origin.y == APP_DELEGATE.window.frame.size.height) {
                [self.subjectTextView setFrame:rect animation:YES completion:nil];
            } else {
                self.subjectTextView.frame = rect;
            }
        }
    }
}

@end
