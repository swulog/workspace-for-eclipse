//
//  SpringBoardView.h
//  GK
//
//  Created by W.S. on 13-10-16.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpringBoardItem.h"
@protocol SprinBoardDelete  <SpringBoardItemDelegate>
@optional
-(void)SpringBoardDeleteOver;
-(void)SpringBoardReAlign;
@end

@interface SpringBoardView : UIView
@property (nonatomic,assign) NSInteger numOfItemPerLine;
@property (nonatomic,assign) NSInteger numOfItems;

@property (nonatomic,assign) SpringBoardItemType itemType;
@property (nonatomic,strong) NSMutableArray *items;
@property (nonatomic,assign) CGSize itemSize;
@property (nonatomic,assign) UIOffset itemOffset;
@property (nonatomic,assign) UIOffset itemGap;
@property (nonatomic,assign) NSInteger selectedItem;

@property (nonatomic,assign) BOOL verAutoAlignment; //忽略itemGap.vertical
@property (nonatomic,assign) BOOL horAutoAlignment; //忽略itemGap.hortical
@property (nonatomic,assign) BOOL autoWidth,autoHeight;

@property (nonatomic,assign) id<SprinBoardDelete> delegate;
-(void)cancelDeleteAction;
-(void)removeAllItem;
-(void)addItem:(SpringBoardItem*)item;
-(void)addItem:(UIImage*)image title:(NSString*)title;
-(SpringBoardItem*)addItem:(UIImage*)image title:(NSString*)title handler:(SEL)handler with:(id)obj;
-(void)deleteItem:(SpringBoardItem*)item animation:(BOOL)animated;
-(BOOL)isInsideDelView:(CGPoint)point;
@end

