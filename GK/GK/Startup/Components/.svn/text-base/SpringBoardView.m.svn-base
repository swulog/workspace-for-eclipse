//
//  SpringBoardView.m
//  GK
//
//  Created by W.S. on 13-10-16.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "SpringBoardView.h"
static BOOL hadLayout = FALSE;

@interface SpringBoardView()<SpringBoardItemDelegate>
{
    float yOffset,verGap;
    float xOffset,horGap;
    float lines;
    BOOL itemArrangeChanged;
}
@property (nonatomic,strong) SpringBoardItem *delItem;
@end

@implementation SpringBoardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self awakeFromNib];
    }
    return self;
}

-(void)awakeFromNib
{
    self.numOfItemPerLine = 3;
    self.numOfItems = 0;
    self.itemSize = CGSizeMake(55, 88);
    self.itemOffset = UIOffsetMake(20, 20);
    self.itemGap = UIOffsetMake(20, 20);
    self.items = [NSMutableArray array];
    self.itemType = SpringBoardItemIconBtn;
}

-(void)addItem:(SpringBoardItem*)item
{
    [self.items addObject:item];
    self.numOfItems++;
    hadLayout = FALSE;
    [self addSubview:item];
    item.delegate = self;
}

-(void)addItem:(UIImage*)image title:(NSString*)title
{
    [self addItem:image title:title handler:nil with:nil];
}

-(SpringBoardItem*)addItem:(UIImage*)image title:(NSString*)title handler:(SEL)handler with:(id)obj
{
    SpringBoardItem *addItem =  [[SpringBoardItem alloc] initWithStyle:self.itemType];//  [SpringBoardItem item];
    [addItem setDeleteEnabled:TRUE];
    [addItem setImage:image title:title];
    [self addItem:addItem];
    
    if (handler) {
        [addItem.springBtn addTarget:obj action:handler forControlEvents:UIControlEventTouchUpInside];
    }
    return addItem;
}


-(void)deleteItem:(SpringBoardItem*)item animation:(BOOL)animated
{
    [self.items enumerateObjectsUsingBlock:^(SpringBoardItem *obj, NSUInteger idx, BOOL *stop) {
        if (obj == item) {
            self.delItem = item;
            if (animated)   [self deleteAnimation:item];
            *stop = TRUE;
        }
    }];
}

-(void)deleteAnimation:(SpringBoardItem*)item
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.toValue = [NSNumber numberWithFloat:0.0];
    animation.duration = .2f;
    animation.delegate = self;
    [item.layer addAnimation:animation forKey:@"animation"];
    
    [UIView animateWithDuration:0.2f animations:^{
        item.alpha = 0;
    }];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    __block NSInteger index = -1;
    [self.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (obj == self.delItem) {
            *stop = TRUE;
            index = idx;
        }
    }];
    [self.items removeObject:self.delItem];
    self.numOfItems--;
    [self.delItem removeFromSuperview];
    self.delItem = nil;
    
    NSMutableArray *oarray = [NSMutableArray array];
    NSMutableArray *dArray = [NSMutableArray array];
    
    for (int k = index  ; k < self.items.count; k++)
        [oarray addObject:[NSValue valueWithCGRect:((SpringBoardItem*)self.items[k]).frame]];
    [self layOut];
    
    for (int k = index ; k < self.items.count; k++) {
        [dArray addObject:[NSValue valueWithCGRect:((SpringBoardItem*)self.items[k]).frame]];
        ((SpringBoardItem*)self.items[k]).frame = [oarray[k-index] CGRectValue];
        
        [UIView animateWithDuration:0.1f * (k - index + 1) delay:0 options:UIViewAnimationOptionLayoutSubviews|UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             ((SpringBoardItem*)self.items[k]).frame = [dArray[k-index] CGRectValue];
                         }completion:nil];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(SpringBoardDeleteOver)]) {
        [self.delegate performSelector:@selector(SpringBoardDeleteOver)];
    }
}

-(void)removeAllItem
{
    [self.items makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.items removeAllObjects];
    self.numOfItems = 0;
}

-(void)cancelDeleteAction
{
    for (SpringBoardItem *item in self.items) {
        if (item.deleteEnabled) {
            [item cancelDeleteAction];
        }
    }
}

-(BOOL)isInsideDelView:(CGPoint)point
{
    for (SpringBoardItem *item in self.items) {
        CGPoint ipoint = [self convertPoint:point toView:item];

        if ([item isInsideDelBtn:ipoint]) {
            return TRUE;
        }
    }
//    UIView *hitV = [self hitTest:point withEvent:nil];
//    if ([hitV isKindOfClass:[SpringBoardItem class]]) {
//        NSLog(@"springitem");
//    } else if([hitV isKindOfClass:[UIButton class]]) {
//        NSLog(@"del %@",hitV);
//        ret = TRUE;
//    }
    return  FALSE;
}

-(void)drag:(id)sender
{
    NSLog(@"drag");
}

-(void)SpringItemWillShowDeleteBtn:(id)sender
{
    for (SpringBoardItem *item in self.items) {
        if (item.deleteEnabled && item != sender) {
            item.btnState = BTN_Delete;
        }
    }
}

-(void)SpringItemDelete:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(SpringItemDelete:)]) {
        [self.delegate performSelector:@selector(SpringItemDelete:) withObject:sender];
    }
}

-(void)SpringItemDMove:(id)sender
{
    SpringBoardItem *draggingItem = sender;
    CGFloat dragItemX = draggingItem.center.x;
    CGFloat dragItemY = draggingItem.center.y;
    CGFloat distanceWidth = self.itemSize.width + horGap;
    CGFloat distanceHeight = self.itemSize.height + verGap;
    
    NSInteger dragItemColumn = MAX(floor((dragItemX - self.itemOffset.horizontal )/distanceWidth),0); // item width
    dragItemColumn = MIN(self.numOfItemPerLine - 1, dragItemColumn);
    NSInteger dragItemRow = MAX(floor((dragItemY - self.itemOffset.vertical)/distanceHeight),0); // item height
    dragItemRow = MIN(dragItemRow, lines - 1);
    NSInteger dragIndex = (dragItemRow * self.numOfItemPerLine) + dragItemColumn;
    dragIndex = MIN(dragIndex, self.items.count-1);
    __block NSInteger oIndex;
    [self.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (obj == draggingItem) {
            oIndex = idx;
            *stop = TRUE;
        }
    }];

    if (oIndex != dragIndex && ((SpringBoardItem*)self.items[dragIndex]).btnState == BTN_Delete) {
        itemArrangeChanged = TRUE;
        if (dragIndex == self.items.count) {
            [self.items addObject:draggingItem];
        } else {
            [self.items insertObject:draggingItem atIndex:dragIndex>oIndex?dragIndex+1:dragIndex];
        }
        
        [self.items removeObjectAtIndex:dragIndex>oIndex?oIndex:oIndex+1];
    
        NSMutableArray *oarray = [NSMutableArray array];
        for (int k = 0 ; k < self.items.count; k++)
            [oarray addObject:[NSValue valueWithCGRect:((SpringBoardItem*)self.items[k]).frame]];
        
        [self layOut];
        for (int k = MIN(dragIndex, oIndex) ; k < MAX(oIndex, dragIndex); k++) {
            if (k != dragIndex) {
                CGRect rect = ((SpringBoardItem*)self.items[k]).frame;
                ((SpringBoardItem*)self.items[k]).frame = [oarray[k] CGRectValue];
                [UIView animateWithDuration:0.1f * (k - MIN(oIndex, dragIndex) + 1)  delay:0 options:UIViewAnimationOptionLayoutSubviews|UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
                                     ((SpringBoardItem*)self.items[k]).frame = rect;
                                 }completion:nil];
            }
        }
    }
}

-(void)SpringItemStopMove:(id)sender
{
    if (itemArrangeChanged) {
        itemArrangeChanged = FALSE;
        if(self.delegate && [self.delegate respondsToSelector:@selector(SpringBoardReAlign)])
           [self.delegate performSelector:@selector(SpringBoardReAlign)];
    }
    
    SpringBoardItem *item = sender;
    CGRect rect = item.frame;
    [self layOut];
    CGRect dRect = item.frame;
    item.frame = rect;
    [UIView animateWithDuration:0.30f animations:^{
        item.frame = dRect;
    }];
}

-(void)layOut
{
    //计算行数
    lines = ceil((float)self.numOfItems / (float)self.numOfItemPerLine);
    
    //计算上边距
    yOffset = self.itemOffset.vertical;
    verGap  = 0;
    
    if (yOffset == -1) {
        yOffset = (self.frame.size.height - lines * self.itemSize.height) / (lines + 1);
        verGap = yOffset;
    } else if(lines > 1){
        if (self.verAutoAlignment) {
            verGap = (self.frame.size.height - lines * self.itemSize.height - 2 * yOffset) / (lines - 1);
        } else {
            verGap = yOffset;
        }
    }
    
    //计算左边距
    xOffset = self.itemOffset.horizontal;
    horGap = 0 ;
    if (xOffset == -1) {
        xOffset = (self.frame.size.width - self.numOfItemPerLine * self.itemSize.width) / (self.numOfItemPerLine + 1);
        horGap = xOffset;
    } else if(self.numOfItems > 1){
        if (self.horAutoAlignment) {
            horGap = (self.frame.size.width - self.numOfItemPerLine * self.itemSize.width - 2 * xOffset) / (self.numOfItemPerLine - 1);
        } else {
            horGap = xOffset;
        }
    }
    
    //计算item坐标
    NSInteger index = 0;
    SpringBoardItem *item;
    for (int line = 0 ; line < lines ; line++) {
        for (int col = 0 ; col < self.numOfItemPerLine && index < self.numOfItems; col++) {
            item = self.items[index];
            CGRect rect;
            rect.origin.x = xOffset + (horGap + self.itemSize.width) * col ;
            rect.origin.y = yOffset + (verGap + self.itemSize.height) * line ;
            rect.size = self.itemSize;
            if (!item.movEnabled) {
                item.frame = rect;
            }
            //      item.itemType = self.itemType;
            index++;
        }
    }
    
    if (self.autoHeight || self.autoWidth) {
        float width = self.frame.size.width;
        float height = self.frame.size.height;
        
        if (self.autoWidth) {
            width = xOffset * 2 + horGap * (self.numOfItemPerLine - 1) + self.numOfItemPerLine * self.itemSize.width;
        }
        if (self.autoHeight) {
            height = yOffset * 2 + verGap * (lines - 1) + lines * self.itemSize.height;
        }
        
        CGRect rect = self.frame;
        rect.size = CGSizeMake(width, height);
        [self setFrame:rect];
    }
}

- (void)layoutSubviews
{
    if (!hadLayout) {
        hadLayout = TRUE;
        [self layOut];
    }

}






@end
