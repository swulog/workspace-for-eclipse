//
//  GS_PhotoPreviewCtrllerViewController.h
//  GS
//
//  Created by W.S. on 13-9-6.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GKBaseViewController.h"

@protocol PhotoPreviewDelegate <NSObject>
@optional
-(CGRect)rectForFocus:(NSInteger)index;
@end

@interface GK_PhotoPreviewCtrller : GKBaseViewController
@property (nonatomic,assign) id<PhotoPreviewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollV;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic,assign) CGRect startRect;

-(id)initWtihPhotoList:(NSMutableArray*)photoList offset:(NSInteger)focusIndex;
-(id)initWithTransPhotoList:(NSArray*)photoList offset:(NSInteger)focusIndex;

@end

@interface PhotoTransporingObject : NSObject
@property (nonatomic,strong) NSString *orgUrlString;
@property (nonatomic,strong) NSString *transporingUrlString;
@end


