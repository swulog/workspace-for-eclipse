//
//  WSImageView.m
//  GK
//
//  Created by W.S. on 13-7-17.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "WSImageView.h"
#import "ReferemceList.h"
#import "Config.h"

static NSMutableDictionary *imgEngines;

@interface WSImageView()
@property (nonatomic,strong) UIImage *placeImg;
@end

@implementation WSImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.imgV = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imgV.contentMode = UIViewContentModeScaleToFill;
        self.imgV.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight );
        //self.frame = self.bounds;
        
        [self addSubview:self.imgV];
        self.autoresizesSubviews = YES;
    }
    return self;
}

-(id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        self.imgV = [[UIImageView alloc] init];
        self.imgV.contentMode = UIViewContentModeScaleToFill;
        self.imgV.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight );
        [self addSubview:self.imgV];
        self.autoresizesSubviews = YES;
    }
    return self;
}

-(void)awakeFromNib
{
    self.imgV = [[UIImageView alloc] initWithFrame:self.bounds];
    self.imgV.contentMode = UIViewContentModeScaleToFill;
    self.imgV.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight );
    //self.frame = self.bounds;
    
    [self addSubview:self.imgV];
    self.autoresizesSubviews = YES;
}

-(void)dealloc
{
    if (_isWaitting) {
        [self.imgV removeObserver:self forKeyPath:@"image"];
    }
}

-(void)setDefaultImg:(UIImage*)_image
{
    self.defaultImage = _image;
    self.imgV.image = _image;
}

-(void)showDefaultImg:(UIImage*)_image
{
    self.defaultImage = _image;
    self.imgV.image = _image;
    self.imgV.contentMode = UIViewContentModeCenter;
    self.imgUrl = nil;
    self.isWaitting = FALSE;
    
}

-(void)setIsWaitting:(BOOL)isWaitting
{
    if (isWaitting) {
        //if (self.waitView)    self.waitView.hidden = TRUE;
        _isWaitting = isWaitting;
        [self.imgV addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [self showActivity];
        //[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(showActivity) userInfo:nil repeats:NO];
    } else {
        if (self.waitView) {
            [self.waitView stopAnimating];
            self.waitView.hidden = TRUE;
        }
        if (_isWaitting)
            [self.imgV removeObserver:self forKeyPath:@"image"];
        _isWaitting = isWaitting;
    }
}

-(void)showUrl:(NSURL*)_url
{
    [self showUrl:_url activity:FALSE];
}

-(void)showUrl:(NSURL *)_url activity:(BOOL)activitenabled
{
    [self showUrl:_url activity:activitenabled palce:nil];
}

-(void)showUrl:(NSURL *)_url activity:(BOOL)activitenabled palce:(UIImage*)placeImg
{
    if (!IsSafeString(_url.absoluteString)) {
        return;
    }
    
    if (_url && [_url.absoluteString isEqualToString:self.imgUrl.absoluteString]) {
        if (self.isWaitting && self.waitView) { //fix tableview dequeueReusableCellWithIdentifier to the waitView hidden
            self.waitView.hidden = FALSE;
            [self.waitView startAnimating];
        }
        return;
    }
    
    self.isWaitting = FALSE;
    self.imgUrl = _url;
    self.imgV.image = nil;
    self.placeImg = placeImg;
    
    if (_url) {
        NSString *host =   _url.host;
        WSImageNetEngine *iEngine;
        
        @synchronized(imgEngines)
        {
            if (!imgEngines) {
                imgEngines = [NSMutableDictionary dictionaryWithCapacity:3];
            }
            
            if (!imgEngines[host]) {
                WSImageNetEngine *engine = [[WSImageNetEngine alloc] initWithHostName:host];
                [engine useCache];
                [imgEngines setObject:engine forKey:host];
            }
        }
        
        iEngine = imgEngines[host];
        [self.imgV setImageFromURL:_url placeHolderImage:nil usingEngine:iEngine animation:YES];
    }
    
    if (activitenabled && !self.imgV.image) self.isWaitting = TRUE;
}

-(void)replaceImgWithUrl:(NSURL *)_url autoSize:(BOOL)_atuoSize finished:(WSNillBlock_Image)succBack fail:(WSNillBlock_Error)failBack
{
    if (!_atuoSize) {
        [self showUrl:_url];
    } else{
        self.imgUrl = _url;
        
        NSString *host =   _url.host;
        WSImageNetEngine *iEngine;
        
        @synchronized(imgEngines)
        {
            if (!imgEngines) {
                imgEngines = [NSMutableDictionary dictionaryWithCapacity:3];
            }
            
            if (!imgEngines[host]) {
                WSImageNetEngine *engine = [[WSImageNetEngine alloc] initWithHostName:host];
                [engine useCache];
                [imgEngines setObject:engine forKey:host];
            }
        }
        
        iEngine = imgEngines[host];
        [self.imgV replaseImageFrom:self.imgUrl usingEngine:iEngine succ:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
            if(succBack) succBack(fetchedImage);
        } fail:^(MKNetworkOperation *completedOperation, NSError *error) {
            if (error && failBack) {
                failBack(error);
            }
        }];
    }
}

-(void)showActivity
{
    if (!self.imgV.image && self.isWaitting) {
        if (!self.waitView) {
            UIActivityIndicatorView *waitView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];//指定进度轮的大小
            [waitView setCenter:self.imgV.center];//指定进度轮中心点
            [waitView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];//设置进度轮显示类型
            [self addSubview:waitView];
            [waitView startAnimating];
            self.waitView = waitView;
        } else if(self.waitView.hidden){
            self.waitView.hidden = FALSE;
            [self.waitView startAnimating];
        }
        
    }
}

-(void)setImageContentMode:(UIViewContentMode)contentMode
{
    [super setContentMode:contentMode];
    self.imgV.contentMode = contentMode;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context

{
        self.isWaitting = FALSE;
        
        if (self.placeImg && self.imgV.image == nil) {
            self.imgV.contentMode = UIViewContentModeCenter;
            self.imgV.image = self.placeImg;
        } else {
            self.imgV.contentMode = self.contentMode;
        }
}
@end

@implementation  WSImageNetEngine

-(NSString*) cacheDirectoryName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSString *cacheDirectoryName = [documentsDirectory stringByAppendingPathComponent:@"WSImage"];
    return cacheDirectoryName;
}


@end
