//
//  WSMultiColList.m
//  GK
//
//  Created by W.S. on 13-10-18.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "WSMultiColList.h"
#import "Constants.h"
#import "NSObject+GKExpand.h"
#import "ReferemceList.h"

#define WSMultiColListGap 1
//#define WSMultiColListItemOffset 20
#define WSMultiColListFooterHeight 5
#define WSMultiColSimpleStrCellHeight 40


#define WSMultiColImgToTitleGap 7
#define WSMultiColImgToTopGap 7
#define WSMultiColTitleHeight 15
#define WSMultiColTitleToBottomGap WSMultiColImgToTopGap

@interface WSMultiColList()
{
    float cellHeight,cellWidth,lines,imgCellXGap;
}
@property(nonatomic,assign) BOOL needResize;
@property (nonatomic,strong) UIColor *normalColor;
@property (nonatomic,assign) NSInteger selectedIndex;
@property (nonatomic,strong) UIButton *focusBtn;

@end

@implementation WSMultiColList

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initOwnParams];
        
    }
    return self;
}

-(void)awakeFromNib
{
    [self initOwnParams];
}

-(void)initOwnParams
{
    self.numOfColPerRow = 3;
    self.delegate = self;
    self.dataSource = self;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.needResize = TRUE;
    self.bounces = FALSE;
    self.cellTitltColor = [UIColor redColor];
    
    self.cellGap = WSMultiColListGap;
    self.ownContentInset = UIEdgeInsetsZero;
    self.footColor = [UIColor redColor];

    self.cellColor = colorWithUtfStr(CommonViewBGColor);
    self.selectedColor = [UIColor yellowColor];
}

-(void)setItemSource:(NSArray *)itemSource
{
    _itemSource = itemSource;
    self.needResize = TRUE;
    [self setNeedsLayout];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return lines;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float yOffset = indexPath.row == 0 ? self.ownContentInset.top : 0;
    return cellHeight + yOffset;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *picWallItemView = @"WSMultiColListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:picWallItemView];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:picWallItemView];
        cell.backgroundColor = tableView.backgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    int index = indexPath.row * self.numOfColPerRow ;

    for (int k = 0;  k < self.numOfColPerRow; k++) {
        WSMultiColCell *cellData = Nil;
        if(index < self.itemSource.count){
            id data = self.itemSource[index];
            if ([data isKindOfClass:[WSMultiColCell class]]) {
                cellData  = data;
            } else {
                NSLog(@"need realized");
            }
        }
        
        float xOffset =k * (cellWidth + self.cellGap);
        float yOffset = indexPath.row == 0 ? self.ownContentInset.top : 0;
        xOffset +=self.ownContentInset.left;

        UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(xOffset,yOffset, cellWidth, (indexPath.row == lines - 1) ?cellHeight : cellHeight - self.cellGap)];
        cellView.backgroundColor =  colorWithUtfStr(CommonViewBGColor);
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTag:index];
        [btn addTarget:self action:@selector(cellHighted:) forControlEvents:UIControlEventTouchDown];
        [btn addTarget:self action:@selector(cellUnHighted:) forControlEvents:UIControlEventTouchUpOutside];
        [btn addTarget:self action:@selector(cellSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        if (cellData) {
            btn.backgroundColor = self.cellColor;

            if (self.type == WSMultiCol_SampleStr) {
                CGRect rect = cellView.frame;
                rect.origin = CGPointZero;
                btn.frame = rect;
                btn.titleLabel.font = FONT_NORMAL_13;
                [btn setTitleColor:self.cellTitltColor forState:UIControlStateNormal];
                
                if (IsSafeString(cellData.title))
                    [btn setTitle:cellData.title forState:UIControlStateNormal];
                
                if (IsSafeArray(self.selectedItem)) {
                    if ([self isSelected:index] && self.selectedColor) {
                        btn.backgroundColor = self.selectedColor;
                        self.focusBtn = btn;
                    }
                }
                
                [cellView addSubview:btn];
            } else {
                if (cellData.imageView) {
                    CGSize size = cellData.imageView.frame.size;
                    CGRect rect = CGRectZero;
                    rect.size = size;
                    rect.origin.y = WSMultiColImgToTopGap;
                    rect.origin.x = (cellView.frame.size.width - size.width) /2;
                    
                    btn.frame = rect;
                    [btn setImage:cellData.imageView.image forState:UIControlStateNormal];
                    [cellView addSubview:btn];
                }
                if (IsSafeString(cellData.title)) {
                    UIButton *titlBtn;
                    if (!cellData.imageView)    titlBtn = btn;
                    else titlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [titlBtn setFrame:CGRectMake(0, cellView.frame.size.height - WSMultiColTitleHeight - WSMultiColTitleToBottomGap , cellView.frame.size.width, WSMultiColTitleHeight)];
                    titlBtn.titleLabel.font = FONT_NORMAL_13;
                    [titlBtn setTitleColor:self.cellTitltColor forState:UIControlStateNormal];
                    [titlBtn setTitle:cellData.title forState:UIControlStateNormal];
                    [cellView addSubview:titlBtn];
                }
            }
        }
        
        [cell addSubview:cellView];
        index++;
    }
    
    return cell;
}

-(void)cellSelected:(id)sender
{
    UIButton *btn = sender;

    if (!self.allowMultiSelect) {
        if (self.focusBtn) {
            self.focusBtn.backgroundColor  = self.cellColor;
        }
        [self.selectedItem removeAllObjects];
        self.focusBtn = btn;
    }
    
    [self selected:btn.tag];
    BOOL selected = [self isSelected:btn.tag];
    if(self.selectedColor)
        btn.backgroundColor = selected ? self.selectedColor : self.cellColor;
    
    if (self.multiColListDelegate) {
        if (selected) {
            if ([self.multiColListDelegate respondsToSelector:@selector(MultiColList:cellSelected:)]){
                [self.multiColListDelegate MultiColList:self cellSelected:btn.tag];
            } else {
                if ([self.multiColListDelegate respondsToSelector:@selector(cellSelected:)]) {
                    [self.multiColListDelegate cellSelected:btn.tag];
                }
            }
        } else {
            if ([self.multiColListDelegate respondsToSelector:@selector(MultiColList:cellDeSelected:)]){
                [self.multiColListDelegate MultiColList:self cellDeSelected:btn.tag];

            }
        }
    }
}

-(void)cellHighted:(id)sender
{
    UIButton *btn = sender;
    if (self.selectedColor) {
        btn.backgroundColor = self.selectedColor;
    }
}

-(void)cellUnHighted:(id)sender
{
    UIButton *btn = sender;
    if (self.selectedColor) {
        btn.backgroundColor = self.cellColor;
    }
}

-(void)delSelected
{
    self.focusBtn.backgroundColor = self.cellColor;
    self.focusBtn = Nil;
    
    if (IsSafeArray(self.selectedItem)) {
        
        [self.selectedItem removeAllObjects];
    }
}

-(void)layoutSubviews
{
    // Drawing code
    lines =  ceil((float)self.itemSource.count / (float)self.numOfColPerRow) ;
    
    if (self.needResize) {
        self.needResize = FALSE;
        CGRect rect = self.frame;
        
        float boundWidth = rect.size.width -  self.ownContentInset.left - self.ownContentInset.right;
        
        
        float height = 0;
        if (self.type == WSMultiCol_ImageStr) {
            float maxImgHeight = 0;
            float maxWidth = 0;
            BOOL hasTitle = FALSE;
            for (WSMultiColCell *cell in self.itemSource) {
                if (cell.imageView) {
                    maxImgHeight = maxImgHeight >= cell.imageView.frame.size.height ? :cell.imageView.frame.size.height;
                    maxWidth = maxWidth >= cell.imageView.frame.size.width ? :cell.imageView.frame.size.width;
                }
                if (IsSafeString(cell.title)) {
                    hasTitle = TRUE;
                }
            }
            if (maxImgHeight > 0) {
                height += WSMultiColImgToTopGap + maxImgHeight;
                if (hasTitle) {
                    height += (maxImgHeight == 0 ?:WSMultiColImgToTitleGap) + WSMultiColTitleHeight;
                }
                height += WSMultiColTitleToBottomGap;
                
                self.backgroundColor = colorWithUtfStr(CommonViewBGColor);
                //self.selectedColor = [UIColor lightGrayColor];

                float gap =  (boundWidth - maxWidth * self.numOfColPerRow - (self.numOfColPerRow - 1 ) * self.cellGap) / (self.numOfColPerRow * 2 + 2);
                imgCellXGap = gap;
                cellWidth = maxWidth + 2*gap;
                gap = (boundWidth - self.numOfColPerRow * cellWidth - (self.numOfColPerRow - 1 ) * self.cellGap) / 2;
                UIEdgeInsets insets = self.ownContentInset;
                insets.left += gap;
                insets.right += gap;
                self.ownContentInset = insets;
            } else {
                height += WSMultiColSimpleStrCellHeight;
                cellWidth = ( boundWidth - (self.numOfColPerRow - 1 ) * self.cellGap ) / self.numOfColPerRow;
            }
        } else {
            height += WSMultiColSimpleStrCellHeight;
            cellWidth = ( boundWidth - (self.numOfColPerRow - 1 ) * self.cellGap ) / self.numOfColPerRow;
        }
        cellHeight = height;
        
        height = self.ownContentInset.top;
        height += lines * cellHeight;
        height += self.ownContentInset.bottom;

        if (!self.tableFooterView && !self.footerViewHide) {
            UIView *footerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, WSMultiColListFooterHeight + self.ownContentInset.bottom)];
            footerV.backgroundColor = [UIColor clearColor];
            UIView *speatorView = [[UIView alloc] initWithFrame:CGRectMake(0,self.ownContentInset.bottom, rect.size.width, WSMultiColListFooterHeight)];
            speatorView.backgroundColor = self.footColor;
            [footerV addSubview:speatorView];
            self.tableFooterView = footerV;
            height += WSMultiColListFooterHeight;
        }
        
        rect.size.height = height;
        self.frame = rect;
    }
    
    return [super layoutSubviews] ;
    
}
-(NSMutableArray*)selectedItem
{
    if (!_selectedItem) {
        _selectedItem = [NSMutableArray array];
    }
    return _selectedItem;
}

-(BOOL)isSelected:(NSInteger)index
{
    if (IsSafeArray(self.selectedItem)) {
        for (NSNumber *indexObj in self.selectedItem) {
            if ([indexObj intValue] == index) {
                return TRUE;
            }
        }
    }
    
    return FALSE;
}

-(void)selected:(NSInteger)index
{
    if (IsSafeArray(self.selectedItem)) {
        for (NSNumber *indexObj in self.selectedItem) {
            if ([indexObj intValue] == index) {
                [self.selectedItem removeObject:indexObj];
                return;
            }
        }
    }
    [self.selectedItem addObject:[NSNumber numberWithInt:index]];
}

-(id)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    if ([hitView isKindOfClass:[UIButton class]]) {
        return hitView;
    } else {
        return nil;
    }
}

@end

@implementation WSMultiColCell
+(WSMultiColCell*)initWithTitle:(NSString*)title imageView:(UIImageView*)imageV
{
    WSMultiColCell *cell = [[self alloc] init];
    if (cell) {
        cell.imageView = imageV;
        cell.title = title;
    }
    return cell;
}
@end
