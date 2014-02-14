//
//  WSImageView.m
//  GK
//
//  Created by W.S. on 13-7-17.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "WSImageView.h"

static NSMutableDictionary *imgEngines;

@implementation WSImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.imgV.contentMode = UIViewContentModeScaleToFill;
        self.imgV.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight );
        //self.frame = self.bounds;
        self.imgV = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.imgV];
    }
    return self;
}

-(void)awakeFromNib
{
    self.imgV.contentMode = UIViewContentModeScaleToFill;
    self.imgV.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight );
    //self.frame = self.bounds;
    self.imgV = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:self.imgV];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGRect rect = self.imgV.frame;
    rect.size = frame.size;
    [self.imgV setFrame:rect];
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
    self.imgUrl = nil;
}

+ (BOOL)automaticallyNotifiesObserversForKey: (NSString *)theKey
{
    BOOL automatic;
    
    if ([theKey isEqualToString:@"imgV"]) {
        automatic = NO;
    } else {
        automatic = [super automaticallyNotifiesObserversForKey:theKey];
    }
    
    return automatic;
}
-(void)showUrl:(NSURL*)_url
{
//    NSLog(@"%@",_url.absoluteString);
//    
    if ([_url.absoluteString isEqualToString:self.imgUrl.absoluteString]) {
        return;
    }
    
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
    [self.imgV setImageFromURL:_url placeHolderImage:nil usingEngine:iEngine animation:YES];
}

-(void)showUrl:(NSURL *)_url placeImg:(UIImage*)_image
{
    self.defaultImage = _image;
    
    if ([_url.absoluteString isEqualToString:self.imgUrl.absoluteString]) {
        return;
    }
    
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
        self.imgV.image = self.defaultImage;
    [self.imgV setImageFromURL:_url placeHolderImage:nil usingEngine:iEngine animation:YES];
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

@end

@implementation  WSImageNetEngine

-(NSString*) cacheDirectoryName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSString *cacheDirectoryName = [documentsDirectory stringByAppendingPathComponent:@"WSImage"];
    return cacheDirectoryName;
}


@end
