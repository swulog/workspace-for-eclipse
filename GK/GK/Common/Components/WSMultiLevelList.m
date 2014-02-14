//
//  WSMultiLevelList.m
//  GK
//
//  Created by W.S. on 13-10-23.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "WSMultiLevelList.h"
#import "Constants.h"
#import "NSObject+GKExpand.h"

#define SepatorLineStartTag 1000

@interface WSMultiLevelList()
{
    float cellHeight;
    BOOL  isInit;
}
@end

@implementation WSMultiLevelList

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initParams];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame parent:(WSMultiLevelList*)pList
{
    self = [self initWithFrame:frame];
    if (self) {
        _parentList = pList;
        if (pList) {
            _level = pList.level + 1;
        }
    }
    return self;
}

-(void)initParams
{
    cellHeight = 40;
    isInit = TRUE;
    
    self.selectedColor = [UIColor yellowColor];
    self.cellColor = [UIColor grayColor];
    self.titleColor = [UIColor whiteColor];
    self.selectRow = NOT_DEFINED;
    
    self.separatorStyle =  UITableViewCellSeparatorStyleNone;
    self.delegate = self;
    self.dataSource = self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview && self.level != 0) {
        if (self.nextList) {
            [self.nextList removeFromSuperview];
            _nextList = nil;
        }
        
        if (self.parentList) {
            UIView *v = [self.superview viewWithTag:(self.tag + self.level + SepatorLineStartTag)];
            [v removeFromSuperview];
        }
    }
}

-(WSMultiLevelList*)topList
{
    WSMultiLevelList *list = self;
    while (list.parentList) {
        list = list.parentList;
    }
    return list;
}



-(void)setMultiLevelDataSource:(NSArray *)multiLevelDataSource
{
    _multiLevelDataSource = multiLevelDataSource;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    //return self.multiLevelDataSource.count;
    return [self.multiTableDelegate numberOfRow:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *multiLevelCellIdetifier = @"WSMultiLevelListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:multiLevelCellIdetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:multiLevelCellIdetifier];
        cell.backgroundColor = self.cellColor;
        UIView *bgV =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        bgV.backgroundColor = self.selectedColor;
        cell.selectedBackgroundView = bgV;
        cell.textLabel.font = FONT_NORMAL_13;
        cell.textLabel.textColor = self.titleColor;
        
       // cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if ([self.multiTableDelegate multiLevelList:self nextLevelEnabled:indexPath.row]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [self.multiTableDelegate multiLevelList:self titleOfRow:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectRow = indexPath.row;
    
    if ([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
        if (self.multiTableDelegate && [self.multiTableDelegate respondsToSelector:@selector(multiLevelList:willPopNextLevel:)]) {
            [self.multiTableDelegate multiLevelList:self willPopNextLevel:indexPath.row];
        }
        [self showNextList];
    } else {
        if (_nextList) {

            [_nextList removeFromSuperview];
            _nextList = nil;
        }
        
        if (self.multiTableDelegate && [self.multiTableDelegate respondsToSelector:@selector(multiLevelList:cellSelected:)]) {
            [self.multiTableDelegate performSelector:@selector(multiLevelList:cellSelected:) withObject:self withObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
        }
    }
}

-(void)showNextList
{
    CGRect rect = self.frame;
    rect.origin.x += self.frame.size.width + 1;
    [_nextList removeFromSuperview];

    _nextList = [[WSMultiLevelList alloc] initWithFrame:rect parent:self];
    _nextList.tag = self.tag;
    _nextList.cellColor = self.selectedColor;
    _nextList.titleColor  = self.titleColor;
    _nextList.selectedColor = self.selectedColor;
    _nextList.maxHeight = self.maxHeight;
    self.nextList.multiTableDelegate = self.multiTableDelegate;
    [self.superview addSubview:self.nextList];
    
    rect.origin.x -= 1;
    rect.size.width = 1;
    UIView *v = [[UIView alloc] initWithFrame:rect];
    v.backgroundColor= [UIColor whiteColor];
    v.tag = SepatorLineStartTag + self.tag + _nextList.level;
    
    [self.superview addSubview:v];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)layoutSubviews
{
    [super layoutSubviews];

    if (isInit) {
        isInit = FALSE;
        self.backgroundColor = self.cellColor;
        CGRect rect = self.frame;
        
        if ((self.frame.origin.y +  self.contentSize.height) > self.superview.frame.size.height ) {
            rect.size.height = self.superview.frame.size.height - rect.origin.y;
        } else {
            rect.size = self.contentSize;
        }
        
        if (self.maxHeight > 0) {
            if (rect.size.height > self.maxHeight) {
                rect.size.height = self.maxHeight;
            }
        }         
        
        self.frame = rect;
    }

}
@end

@implementation WSMultiLevelCellData
@end
