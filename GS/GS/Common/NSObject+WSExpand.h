//
//  NSObject+WSExpand.h
//  GK
//
//  Created by apple on 13-4-11.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (WSExpand)

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

@interface UIView (WSExpand)
-(void)setFrame:(CGRect)frame animation:(BOOL)animated;
-(void)move:(float)offset direct:(Direction)direction animation:(BOOL)animated;

-(void)move:(float)offset direct:(Direction)direction;
-(void)moevrTo:(CGPoint)nPoint;
-(void)strechTo:(CGSize)nSize;
@end


@interface NSArray(WSExpand)
+(id)arrayWithCArray:(char**)strs len:(NSInteger)length;
@end

@interface NSString (WSExpand)
-(NSString*)stringEncodeBase64;
@end


@interface UINavigationController(WSExpand)
-(void)pusInsidehViewController:(UIViewController *)viewController animated:(BOOL)animated;
-(UIViewController*)popInsideViewControllerAnimated:(BOOL)animated;

- (void)pushViewControllerAnimatedWithTransition: (UIViewController*)controller;
- (UIViewController*)popViewControllerAnimatedWithTransition ;

//-(void)pusViewController:(UIViewController *)viewController andTab:(BOOL)pushTab animated:(BOOL)animated;

@end


@interface UIImage (WSExpand)
+(UIImage*)getImgFromFile:(NSString*)imgName;
- (UIImage *)fixOrientation;
- (UIImage *)scaleToSize:(CGSize)reSize;
- (UIImage *)scale:(float)scaleSize;
@end


@interface UIImageView (WSExpand)
-(void)compressToRect:(CGRect)rect;
@end


@interface UINavigationBar (WSExpand)
- (void)drawRect:(CGRect)rect;
@end

@interface GKNavigationBar : UINavigationBar

@end

@interface NSError (Description)

+ (NSError *)errorWithMsg:(NSString *)msg;
+ (NSError *)errorWithMsg:(NSString *)msg code:(NSInteger)_code;
@end

@interface GKLabel_Style0:UILabel
@end

@interface GKLabel_Style1:UILabel
@end

@interface DownLineLabel : UILabel

@end
