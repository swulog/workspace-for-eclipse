//
//  WSMultiColList.h
//  GK
//
//  Created by W.S. on 13-10-18.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSImageView.h"

typedef enum {
    WSMultiCol_SampleStr,
    WSMultiCol_ImageStr
}WSMultiColType;

@class WSMultiColList;

@protocol WSMultiColCellDelegate <NSObject>
@optional
-(void)cellSelected:(NSInteger)index;
-(void)MultiColList:(WSMultiColList*)list cellSelected:(NSInteger)index;
-(void)MultiColList:(WSMultiColList*)list cellDeSelected:(NSInteger)index;

@end

@interface WSMultiColList : UITableView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign) id<WSMultiColCellDelegate> multiColListDelegate;
@property (nonatomic,assign) WSMultiColType type;

@property (nonatomic,strong) NSArray *itemSource; //WSMultiColCell
@property (nonatomic,strong) NSMutableArray *selectedItem;
@property (nonatomic,assign) NSInteger numOfColPerRow;
@property (nonatomic,strong) UIColor *cellTitltColor;
@property (nonatomic,strong) UIColor *cellColor;
@property(nonatomic,strong) UIColor *selectedColor;

@property (nonatomic,assign) UIEdgeInsets ownContentInset;
@property (nonatomic,assign) float cellGap;
@property (nonatomic,strong) UIColor *footColor;
@property (nonatomic,assign) BOOL footerViewHide;
@property (nonatomic,assign) BOOL allowMultiSelect;

-(void)delSelected;
-(BOOL)isSelected:(NSInteger)index;
//-(void)selectIndex:(NSInteger)index;
@end


@interface WSMultiColCell : NSObject
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) UIImageView *imageView;
+(WSMultiColCell*)initWithTitle:(NSString*)title imageView:(UIImageView*)imageV;
@end