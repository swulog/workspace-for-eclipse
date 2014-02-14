//
//  GS_PhotoPreviewCtrllerViewController.m
//  GS
//
//  Created by W.S. on 13-9-6.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GS_PhotoPreviewCtrller.h"
#import "GSStoreService.h"

#define SCROLL_SUBVIEW_TAG_START 1000
@interface GS_PhotoPreviewCtrller ()
@property (nonatomic,strong) NSMutableArray *photList;
@property (nonatomic,assign) NSInteger      focusIndex;
@property (nonatomic,assign) BOOL           isInitScroolView;
@end

@implementation GS_PhotoPreviewCtrller

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWtihPhotoList:(NSMutableArray*)photoList offset:(NSInteger)focusIndex
{
    self = [super initNibWithStyle:WS_ViewStyleWithNavBar];
    if (self) {
        self.photList = photoList;
        self.focusIndex = focusIndex;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setBackgroundWithUIColor:[UIColor blackColor]];
    [self addBackItem:@"返回" action:@selector(goback)];
    [self addNavRightItem:@"删除" action:@selector(deleteClick)];
    
    float offset = 0;
    CGRect rect = self.scrollV.frame;
    if (iStyle == WS_ViewStyleWithNavBar) {
        rect.size.height -= 44;
        [self.scrollV setFrame:rect];
    }
    
    if (![UIApplication sharedApplication].statusBarHidden) {
        rect.size.height -= 20;
    }
    

    rect.origin.y = 0;
    int k = 0;

    for (; k < self.photList.count; k++) {
        rect.origin.x += offset;
        StorePhotos *photo = self.photList[k];
        UIView *v = [[UIView alloc] initWithFrame:rect];
        [v setTag:SCROLL_SUBVIEW_TAG_START+k];
        [self.scrollV addSubview:v];
        WSImageView *imgV = [[WSImageView alloc] initWithFrame:CGRectMake(0, 0, 128, 128)];
        [imgV showUrl:[NSURL URLWithString:photo.thumbnail_image]];
        [v addSubview:imgV];
        CGPoint p = v.center;
        p = [self.scrollV convertPoint:v.center toView:v ];
        [imgV setCenter:p];

        offset=320;
    }
    self.scrollV.contentSize = CGSizeMake( k * 320,rect.size.height);
    self.pageControl.numberOfPages = k;
    
//    [self performSelector:@selector(initPhotoForFocus) withObject:nil afterDelay:1];
    [self initPhotoForFocus];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setScrollV:nil];
    [self setPageControl:nil];
    [super viewDidUnload];
}

-(void)initPhotoForFocus
{
    if (self.focusIndex != 0) {
        [self.scrollV setContentOffset:CGPointMake(320 * self.focusIndex, 0) animated:NO];
    } else {
        self.isInitScroolView =  TRUE;
        [self scrollViewDidScroll:self.scrollV];
    }
}

-(void)showPhoto:(NSInteger) index
{
    StorePhotos *photo =((StorePhotos*)self.photList[index]);
    
    WSImageView *wsImgV = [(UIView*)([self.scrollV subviews][index]) subviews][0] ;
    [wsImgV replaceImgWithUrl:[NSURL URLWithString:photo.default_image] autoSize:YES finished:^(UIImage *image) {
        CGPoint p = wsImgV.center;
        UIView *sV = wsImgV.superview;
        
        CGSize size = image.size;
        float horScale =sV.frame.size.width /  size.width  ;
        float verScale = sV.frame.size.height / size.height  ;
        
        UIImage *nImage = nil;
        if (horScale > verScale) {
            nImage = [   image scale:verScale];
        } else {
            nImage = [   image scale:horScale];
        }
        
        CGRect rect =wsImgV.frame;
        rect.size = nImage.size;
        wsImgV.imgV.image = nImage;
        
        rect.origin.x = p.x - rect.size.width / 2;
        rect.origin.y = p.y - rect.size.height / 2;
        
        [UIView animateWithDuration:0.26f animations:^{
            [wsImgV setFrame:rect];
        }];
    } fail:^(NSError *error) {
        
    }];
    self.pageControl.currentPage = index;
    [self setNavTitle:[NSString stringWithFormat:@"%d/%d",index+1,self.photList.count]];
}
-(void)deleteClick
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"确定要删除此图？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定",nil];
    [sheet showInView:APP_DELEGATE.window];}

-(void)deletePhoto
{
    CGFloat pageWidth = self.view.frame.size.width;
    int index = floor((self.scrollV.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:STORE_PHOTO_MAX_NUM];

    for (int k = 0 ; k < STORE_PHOTO_MAX_NUM; k++) {
        int loop = k;
        
        StoreUploadPhoto *uPhoto = [[StoreUploadPhoto alloc] init];
        uPhoto.name = [NSString stringWithFormat:@"p%d",k+1];
        
        if (loop >= index) {
            loop++;
        }        
        
        if (self.photList && self.photList.count > loop) {
            uPhoto.id =((StorePhotos*) self.photList[loop]).id;
            uPhoto.image_data = nil;
        } else {
            uPhoto.id = @"0";
            uPhoto.image_data = nil;
        }
        [array addObject:uPhoto];
    }
    
    iStatus = WS_ViewStatus_Getting;
    [NSTimer scheduledTimerWithTimeInterval:0.26f target:self selector:@selector(showWatting) userInfo:nil repeats:NO];
    [GSStoreService updateStorePhotoes:((StorePhotos*)self.photList[0]).storeId photes:array succ:^(NSArray *array) {
        iStatus = WS_ViewStatus_Normal;
        [self hideWaitting];
        for (int k = index + 1; k < self.photList.count; k++) {
            ((StorePhotos*)self.photList[k]).name = [NSString stringWithFormat:@"p%d",k];
        }
        [self.photList removeObjectAtIndex:index];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFCATION_PHOTOED_UPDATE object:array];
        
        if (self.photList.count == 0) {
            [self dismissModalViewControllerAnimated:YES];
            return ;
        }
        
        UIView *curV = self.scrollV.subviews[index];
        UIView *moveV = nil;
        if (self.scrollV.subviews.count > (index+1)) {
            moveV = self.scrollV.subviews[index+1];
        }

        if (moveV) {
            [UIView animateWithDuration:0.26f animations:^{
                [moveV move:320 direct:Direct_Left];
                curV.alpha = 0.0f;

            } completion:^(BOOL finished) {
                [curV removeFromSuperview];
                [self showPhoto:index];
                self.scrollV.contentSize = CGSizeMake( (self.photList.count > 0 ? self.photList.count : 1 )* 320,self.scrollV.frame.size.height);
            }];
        } else if(index != 0){
            [self.scrollV setContentOffset:CGPointMake(0, 0) animated:NO];
            self.scrollV.contentSize = CGSizeMake( (self.photList.count > 0 ? self.photList.count : 1 )* 320,self.scrollV.frame.size.height);
            [curV removeFromSuperview];
        } else {
            [self setNavTitle:[NSString stringWithFormat:@"%d/%d",index,self.photList.count]];

            [curV removeFromSuperview];
        }
        self.pageControl.numberOfPages--;

    } fail:^(NSError *err) {
        iStatus = WS_ViewStatus_GetFail;
        [self hideWaitting];
        
    }];

}

#pragma mark - scrollView delegate
#pragma mark -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.view.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (self.isInitScroolView || self.pageControl.currentPage != page)
    {
        [self performBlock:^(id sender) {
            [self showPhoto:page];
        } afterDelay:self.isInitScroolView?1.0:0];

        self.isInitScroolView = FALSE;
    }
}
#pragma mark -
#pragma mark action sheet delegate -
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self deletePhoto];
    }
}
@end
