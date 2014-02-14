//
//  WSImageView.h
//  GK
//
//  Created by W.S. on 13-7-17.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKNetworkKit.h"
#import "UIImageView+MKNetworkKitAdditions.h"

typedef void (^WSNillBlock_Image)(UIImage* image);
typedef void (^WSNillBlock_Error)(NSError* error);

@interface WSImageView : UIControl

@property (nonatomic,strong) UIImage *defaultImage;
@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) NSURL *imgUrl;

-(void)setDefaultImg:(UIImage*)_image;
-(void)showDefaultImg:(UIImage*)_image;
-(void)showUrl:(NSURL*)_url;
-(void)showUrl:(NSURL *)_url placeImg:(UIImage*)_image;
-(void)replaceImgWithUrl:(NSURL *)_url autoSize:(BOOL)_atuoSize finished:(WSNillBlock_Image)succBack fail:(WSNillBlock_Error)failBack;
@end


@interface WSImageNetEngine : MKNetworkEngine


@end