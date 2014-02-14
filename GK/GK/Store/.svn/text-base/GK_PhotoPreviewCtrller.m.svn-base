//
//  GS_PhotoPreviewCtrllerViewController.m
//  GS
//
//  Created by W.S. on 13-9-6.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GK_PhotoPreviewCtrller.h"
#import "GKStoreSortListService.h"
#import "WSImageView.h"
#import "GKAppDelegate.h"

#define SCROLL_SUBVIEW_TAG_START 1000
@interface GK_PhotoPreviewCtrller ()
{
    BOOL isInited;
}
@property (nonatomic,strong) NSMutableArray *photList;
@property (nonatomic,assign) NSInteger      focusIndex;
@end

@implementation GK_PhotoPreviewCtrller

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil style:VIEW_NOBAR|VIEW_WITH_NOStatusBar];
    if (self) {
        // Custom initialization
        isInited = TRUE;
    }
    return self;
}

-(id)initWithTransPhotoList:(NSArray*)photoList offset:(NSInteger)focusIndex
{
    self = [self init];
    if (self) {
        self.photList = [NSMutableArray arrayWithArray:photoList];
        self.focusIndex = focusIndex;
    }
    return self;
}

-(id)initWtihPhotoList:(NSMutableArray*)photoList offset:(NSInteger)focusIndex
{
    self = [self initWithNibName:@"GK_PhotoPreviewCtrller" bundle:nil ];
    if (self) {
        self.focusIndex = focusIndex;
        
        self.photList = [NSMutableArray array];
        for (StorePhotos *sphoto in photoList) {
            PhotoTransporingObject *photo = [[PhotoTransporingObject alloc] init];
            photo.orgUrlString = sphoto.thumbnail_image;
            photo.transporingUrlString = sphoto.default_image;
            [self.photList addObject:photo];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    self.view.backgroundColor = [UIColor clearColor];
    [self.bgView setHidden:FALSE animation:YES];

    CGRect rect = self.scrollV.frame;
    rect.origin.y = 0;
    float offset = rect.size.width;
    for (int k = 0; k < self.photList.count; k++) {
        rect.origin.x = offset * k;
        PhotoTransporingObject *photo = self.photList[k];
        UIView *v = [[UIView alloc] initWithFrame:rect];
        [v setTag:SCROLL_SUBVIEW_TAG_START+k];
        [self.scrollV addSubview:v];
        WSImageView *imgV = [[WSImageView alloc] initWithFrame:CGRectMake(0, 0, 128, 128)];
        [imgV showUrl:[NSURL URLWithString:photo.orgUrlString]];
        [v addSubview:imgV];
        CGPoint p;// = v.center;
        p = [self.scrollV convertPoint:v.center toView:v ];
        [imgV setCenter:p];
    }
    
    self.scrollV.contentSize = CGSizeMake( self.photList.count * 320,rect.size.height);
    self.pageControl.numberOfPages = self.photList.count;
    [self initPhotoForIndex:self.focusIndex];
    
    UITapGestureRecognizer *clickRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [clickRecognizer setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:clickRecognizer];
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

-(void)viewWillDisappear:(BOOL)animated
{
    //[[UIApplication sharedApplication] setStatusBarHidden:FALSE];
}

-(void)viewWillAppear:(BOOL)animated
{
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];

}


-(void)initPhotoForIndex:(NSInteger)index
{
    if (index != 0) {
        [self.scrollV setContentOffset:CGPointMake(320 * self.focusIndex, 0) animated:YES];
    } else {
        [self showPhoto:index];
    }
}

-(void)showPhoto:(NSInteger) index
{
    PhotoTransporingObject *photo =((PhotoTransporingObject*)self.photList[index]);
    
    __block BOOL completion = FALSE;
    __block UIImage *img = nil;
    
    WSImageView *wsImgV = [(UIView*)([self.scrollV subviews][index]) subviews][0] ;
    CGRect rect = wsImgV.frame;
    if (isInited)
        if (!CGRectIsEmpty(self.startRect))
            [wsImgV setFrame:self.startRect];
    
    NillBlock_OBJ block = ^(NSObject *obj){
        UIImage *image = (UIImage*)obj;
        UIView *sV = wsImgV.superview;
        
        CGSize size = image.size;
        float horScale = sV.frame.size.width /  size.width  ;
        float verScale = sV.frame.size.height / size.height  ;
        UIImage *nImage = [image scale:MIN(horScale, verScale)];
        
        CGRect rect =wsImgV.frame;
        rect.size = nImage.size;
        rect.origin.x = (sV.frame.size.width - rect.size.width) / 2;
        rect.origin.y = (sV.frame.size.height - rect.size.height) / 2;
        
        double delayInSeconds = 0.1f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [UIView animateWithDuration:0.5f animations:^{
                [wsImgV setFrame:rect];
            }];
        });
    };

    [wsImgV replaceImgWithUrl:[NSURL URLWithString:photo.transporingUrlString] autoSize:YES finished:^(UIImage *image) {
        img = image;
        completion = TRUE;
        if (!isInited) block(img);
    } fail:nil];
    
    if (isInited) {
        if (!completion) {
            [wsImgV setFrame:rect animation:YES completion:^(BOOL finished) {
                isInited = FALSE;
                if (completion) block(img);
            }];
        } else {
            block(img);
            isInited = FALSE;
        }
    }

    self.pageControl.currentPage = index;
    [self setTitle:[NSString stringWithFormat:@"%d/%d",index+1,self.photList.count]];
}

-(void)dismiss
{
    WSImageView *wsImgV = [(UIView*)([self.scrollV subviews][self.pageControl.currentPage]) subviews][0];

    CGRect rect;
    if (self.delegate && [self.delegate respondsToSelector:@selector(rectForFocus:)]) {
        rect = [self.delegate rectForFocus:self.pageControl.currentPage];
        PhotoTransporingObject *photo = self.photList[self.pageControl.currentPage];
        
        [UIView animateWithDuration:CMM_AnimatePerior animations:^{
            [wsImgV showUrl:[NSURL URLWithString:photo.orgUrlString]];
            [wsImgV setFrame:rect];
            [self.bgView setHidden:YES animation:YES];
            [[UIApplication sharedApplication] setStatusBarHidden:FALSE withAnimation:YES];
        } completion:^(BOOL finished) {
            [self dismissTransparentViewController];
        }];
    } else {
        CGAffineTransform transform = CGAffineTransformMakeScale(0, 0);
        [UIView animateWithDuration:CMM_AnimatePerior animations:^{
            wsImgV.alpha = 0;
            wsImgV.transform = transform;
            [self.bgView setHidden:YES animation:YES];
            [[UIApplication sharedApplication] setStatusBarHidden:FALSE withAnimation:YES];
        } completion:^(BOOL finished) {
            [self dismissTransparentViewController];
        }];
    }
}

#pragma mark - scrollView delegate
#pragma mark -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.view.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (self.pageControl.currentPage != page) {
        [self showPhoto:page];
    }
}

@end

@implementation PhotoTransporingObject



@end
