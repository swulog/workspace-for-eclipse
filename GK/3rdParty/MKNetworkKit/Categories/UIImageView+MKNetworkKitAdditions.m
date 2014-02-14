//
//  UIImageView+MKNetworkKitAdditions.m
//  MKNetworkKitDemo
//
//  Created by Mugunth Kumar (@mugunthkumar) on 18/01/13.
//  Copyright (C) 2011-2020 by Steinlogic Consulting and Training Pte Ltd

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "UIImageView+MKNetworkKitAdditions.h"

#import "MKNetworkEngine.h"

#import <objc/runtime.h>

static MKNetworkEngine *DefaultEngine;
static char imageFetchOperationKey;

const float kFromCacheAnimationDuration = 0.1f;
const float kFreshLoadAnimationDuration =  0.35f;

@interface UIImageView (/*Private Methods*/)
@property (strong, nonatomic) MKNetworkOperation *imageFetchOperation;
@end

@implementation UIImageView (MKNetworkKitAdditions)

-(MKNetworkOperation*) imageFetchOperation {
  
  return (MKNetworkOperation*) objc_getAssociatedObject(self, &imageFetchOperationKey);
}

-(void) setImageFetchOperation:(MKNetworkOperation *)imageFetchOperation {
  
  objc_setAssociatedObject(self, &imageFetchOperationKey, imageFetchOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+(void) setDefaultEngine:(MKNetworkEngine*) engine {
  
  DefaultEngine = engine;
}

-(MKNetworkOperation*) setImageFromURL:(NSURL*) url {
  
  return [self setImageFromURL:url placeHolderImage:nil];
}

-(MKNetworkOperation*) setImageFromURL:(NSURL*) url placeHolderImage:(UIImage*) image {
  
  return [self setImageFromURL:url placeHolderImage:image usingEngine:DefaultEngine animation:YES];
}

-(MKNetworkOperation*) setImageFromURL:(NSURL*) url placeHolderImage:(UIImage*) image animation:(BOOL) yesOrNo {
  
  return [self setImageFromURL:url placeHolderImage:image usingEngine:DefaultEngine animation:yesOrNo];
}

-(MKNetworkOperation*) setImageFromURL:(NSURL*) url placeHolderImage:(UIImage*) image usingEngine:(MKNetworkEngine*) imageCacheEngine animation:(BOOL) animation {
  
  if(image) self.image = image;
  [self.imageFetchOperation cancel];
  if(!imageCacheEngine) imageCacheEngine = DefaultEngine;
  
  if(imageCacheEngine) {
      __weak UIImageView *weakSelf = self;
      self.imageFetchOperation = [imageCacheEngine imageAtURL:url
                                  //             size:self.frame.size
                                                         sync:YES
                                            completionHandler:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
                                                //                                              && !isInCache
                                                if(animation ) {
                                                    [UIView transitionWithView:weakSelf.superview
                                                                      duration:isInCache?0:kFreshLoadAnimationDuration
                                                                       options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowUserInteraction
                                                                    animations:^{
                                                                        //        weakSelf.contentMode = UIViewContentModeScaleToFill;
                                                                        weakSelf.image = fetchedImage;
                                                                    } completion:nil];
                                                } else {
                                                    weakSelf.image = fetchedImage;
                                                }
                                            }
                                                 errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
                                                     weakSelf.image = nil;
                                                     DLog(@"%@", error);
                                                 }];
  } else {
    DLog(@"No default engine found and imageCacheEngine parameter is null")
  }
  
  return self.imageFetchOperation;
}

-(MKNetworkOperation*) replaseImageFrom:(NSURL*) url usingEngine:(MKNetworkEngine*)imageCacheEngine succ:(MKNKImageBlock)succBack fail:(MKNKResponseErrorBlock)failBack {
    
    [self.imageFetchOperation cancel];
    if(!imageCacheEngine) imageCacheEngine = DefaultEngine;
    
    if(imageCacheEngine) {
        __weak UIImageView *weakSelf = self;
        self.imageFetchOperation = [imageCacheEngine imageAtURL:url sync:YES completionHandler:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
//            if (!isInCache) {
//                [UIView transitionWithView:weakSelf.superview
//                                                                                         duration:isInCache?kFreshLoadAnimationDuration:kFreshLoadAnimationDuration
//                                                                                          options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowUserInteraction
//                                                                                       animations:^{
//                                                                                           weakSelf.contentMode = UIViewContentModeScaleToFill;
//                                                                                           weakSelf.image = fetchedImage;
//                                                                                       } completion:nil];
//            }
            double delayInSeconds = 0.11f;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [UIView transitionWithView:weakSelf.superview
                                  duration:isInCache?kFreshLoadAnimationDuration:kFreshLoadAnimationDuration
                                   options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowUserInteraction
                                animations:^{
                                    weakSelf.contentMode = UIViewContentModeScaleToFill;
                                    weakSelf.image = fetchedImage;
                                } completion:nil];

            });
                                     succBack(fetchedImage,url,isInCache);
        } errorHandler:failBack];
    }
    
    
    
//        [imageCacheEngine imageAtURL:url
//                                                           size:self.frame.size
//                                              completionHandler:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
//                                                      [UIView transitionWithView:weakSelf.superview
//                                                                        duration:isInCache?kFreshLoadAnimationDuration:kFreshLoadAnimationDuration
//                                                                         options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowUserInteraction
//                                                                      animations:^{
//                                                                          weakSelf.contentMode = UIViewContentModeScaleToFill;
//                                                                          weakSelf.image = fetchedImage;
//                                                                      } completion:nil];
//                                                  if (succBack) succBack(fetchedImage,url,isInCache);
//                                                                                                } errorHandler:failBack];
//    } else {
//        DLog(@"No default engine found and imageCacheEngine parameter is null")
//    }
    
    return self.imageFetchOperation;
}
@end
