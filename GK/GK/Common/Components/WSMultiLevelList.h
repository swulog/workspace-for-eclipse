//
//  WSMultiLevelList.h
//  GK
//
//  Created by W.S. on 13-10-23.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WSMultiLevelListDelegate ;

@interface WSMultiLevelList : UITableView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) id<WSMultiLevelListDelegate> multiTableDelegate;

@property (nonatomic,strong) NSArray *multiLevelDataSource; //lowLevelDataSource
@property (nonatomic,readonly) NSInteger level;
@property (nonatomic,readonly) NSInteger pLevel;

@property (nonatomic,strong) UIColor *cellColor;
@property (nonatomic,strong) UIColor *selectedColor;
@property (nonatomic,strong) UIColor *titleColor;

@property (nonatomic,assign) float maxHeight;

@property (nonatomic,readonly) WSMultiLevelList *nextList;

@property (nonatomic,readonly) WSMultiLevelList *parentList;
@property (nonatomic,assign) NSInteger selectRow;

-(id)initWithFrame:(CGRect)frame parent:(WSMultiLevelList*)pList;
-(WSMultiLevelList*)topList;
@end


@protocol WSMultiLevelListDelegate <NSObject>
@optional
-(void)multiLevelList:(WSMultiLevelList*)table cellSelected:(NSIndexPath*)indexPath;
-(void)multiLevelList:(WSMultiLevelList*)table willPopNextLevel:(NSInteger)row;

-(NSInteger)numberOfRow:(WSMultiLevelList*)table;
-(NSString*)multiLevelList:(WSMultiLevelList*)table titleOfRow:(NSInteger)row;
-(BOOL)multiLevelList:(WSMultiLevelList*)table nextLevelEnabled:(NSInteger)row;

@end

@interface WSMultiLevelCellData : NSObject
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSArray *lowLevelDataSource;
@property (nonatomic,assign) NSInteger tag;
@property (nonatomic,assign) NSInteger pLevel;
@end