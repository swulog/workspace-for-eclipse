//
//  NSObject+GKExpand.h
//  GK
//
//  Created by apple on 13-4-11.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface NSObject (GKExpand)

@end


typedef enum{
    Direct_Up,
    Direct_Down,
    Direct_Left,
    Direct_Right
}Direction;


CGPoint CGRectCenter(CGRect rect);
//float redColor(char* colStr);
UIColor* colorWithUtfStr(char *colStr);

@interface UIView (GKExpand)
-(void)setFrame:(CGRect)frame animation:(BOOL)animated completion:(NillBlock_BOOL)completion;
-(void)move:(float)offset direct:(Direction)direction animation:(BOOL)animated;
-(void)move:(float)offset direct:(Direction)direction;
-(void)moveUp:(NSNumber*)offset;
-(void)moveDown:(NSNumber*)offset;
-(void)moevrTo:(CGPoint)nPoint;
-(void)strechTo:(CGSize)nSize;
-(void)strech:(float)offset direct:(Direction)direction animation:(BOOL)animated;

-(float)reAliginWith:(UILabel*)label idirect:(Direction)direction gap:(float)gap;
-(id)viewForClassName:(NSString*)className;

-(void)setHidden:(BOOL)hidden animation:(BOOL)animation;
-(void)resetrAutoresizingMask;
@end


@interface NSArray(GKExpand)
+(id)arrayWithCArray:(char**)strs len:(NSInteger)length;
@end

@interface NSString (GKExpand)
-(NSString*)stringEncodeBase64;
@end

@interface UIViewController (GKExpand)
-(void)presentFullViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion;
-(void)dismissFullViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion;
-(void)presentTransparentViewController:(UIViewController*)vc;
-(void)dismissTransparentViewController;
@end
#if 0
@interface UINavigationController(GKExpand)
@property (nonatomic,copy) void (^finishBlock)() ;

typedef enum{
    NavigationAnimation_AlphaAnimation
}NavigationAnimation;

- (void)pushViewController: (UIViewController*)controller
    animatedWithTransition: (UIViewAnimationTransition)_transition;
- (UIViewController*)popViewControllerAnimatedWithTransition:(UIViewAnimationTransition)_transition;
-(void)pusInsidehViewController:(UIViewController *)viewController animated:(BOOL)animated;
-(UIViewController*)popInsideViewControllerAnimated:(BOOL)animated;

- (void)pushViewControllerAnimatedWithTransition: (UIViewController*)controller;
- (UIViewController*)popViewControllerAnimatedWithTransition ;


-(UIViewController*)popViewControllerWithAnimation:(NavigationAnimation)animationType finished:(void (^)()) finishBlock
;
@end
#endif

@interface UIImage (GKExpand)
+(UIImage*)getImgFromFile:(NSString*)imgName;
- (UIImage *)fixOrientation;
- (UIImage *)scaleToSize:(CGSize)reSize;
-(UIImage *)scale:(float)scaleSize;
+(id) imageWithUIView:(UIView*) view;
@end


@interface UIImageView (GKExpand)
-(void)compressToRect:(CGRect)rect;
@end


@interface UINavigationBar (GKExpand)
- (void)drawRect:(CGRect)rect;
@end

//@interface GKNavigationBar : UINavigationBar
//
//@end


@interface GKLabel_Style0:UILabel
@end

@interface GKLabel_Style1:UILabel
@end

@interface DownLineLabel : UILabel
@property (nonatomic,strong) UIColor *downLineColor;
@end

@interface XIBView : UIView
+(id)XIBView;
@end
