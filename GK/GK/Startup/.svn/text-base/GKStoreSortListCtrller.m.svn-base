//
//  GKStoreListCtrller.m
//  GK
//
//  Created by W.S. on 13-12-9.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GKStoreSortListCtrller.h"
#import "WSScrollContentView.h"
#import "WSMultiColList.h"
#import "GlobalObject.h"




@interface GKStoreSortListCtrller ()<WSMultiColCellDelegate>
@property (nonatomic,strong) NSMutableArray *orgSelectedItemArrays,*updateSelectedItemArrays;
@end

@implementation GKStoreSortListCtrller

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil style:VIEW_WITH_NAVBAR];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"添加分类"];
    [self addBackItem];
    [self addNavRightItem:@"确定" action:@selector(save)];
    [self.rightBtn setEnabled:FALSE];
    [self.scrollContentV enableScrollFor:self];
    self.orgSelectedItemArrays = [NSMutableArray arrayWithCapacity:3];
    self.updateSelectedItemArrays = [NSMutableArray arrayWithCapacity:3];
    [self initGroup];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark initer -
-(void)initGroup
{
    [self initGroup:0];
    [self initGroup:1];
    [self initGroup:2];
}

-(void)initGroup:(int)index
{
    WSMultiColList *list[] = {self.groupV0,self.groupV1,self.groupV2};
    list[index].numOfColPerRow = 3;
    list[index].cellTitltColor = colorWithUtfStr(SearchButtonTitleColor);
    list[index].footerViewHide = YES;
    list[index].cellColor = colorWithUtfStr(StoreSortLC_NormalBGColor);
    list[index].selectedColor = colorWithUtfStr(SortListC_TopTabPopViewCellSelectedBg);
    list[index].allowMultiSelect = TRUE;
    list[index].multiColListDelegate = self;
    list[index].tag = index;
    
    NSMutableArray *total = [GlobalObject totalCustStoreSorts];
    NSMutableArray *group = total[index];
    NSMutableArray *orgSelectss = [GlobalObject locateStoreSorts];
    
    NSMutableArray *cellArray = [NSMutableArray array];
    NSMutableArray *selectedArray = [NSMutableArray array];
    
    for (int k = 0; k < group.count; k++) {
        WSMultiColCell *cell = [WSMultiColCell initWithTitle:((CustomStoreSort*)group[k]).Name imageView:nil];
        [cellArray addObject:cell];
        
        [orgSelectss enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            if ([obj isEqualToString:((CustomStoreSort*)group[k]).ID]) {
                [selectedArray addObject:[NSNumber numberWithInt:k]];
                *stop = TRUE;
            }
        }];
    }
    
    list[index].itemSource = cellArray;
    list[index].selectedItem = [NSMutableArray arrayWithArray:selectedArray];
    [self.orgSelectedItemArrays addObject:selectedArray];
    [self.updateSelectedItemArrays addObject:[NSMutableArray arrayWithArray:selectedArray]];
}
#pragma mark -
#pragma mark event handler -
-(void)save
{
    NSMutableArray *locate = [GlobalObject locateStoreSorts];
    NSMutableArray *total = [GlobalObject totalCustStoreSorts];
    NSMutableArray *del = [NSMutableArray array];
    
    [locate enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        __block BOOL find = FALSE;
        for (int k = 0; k < self.updateSelectedItemArrays.count && !find; k++) {
            NSMutableArray *group = total[k];
            [self.updateSelectedItemArrays[k] enumerateObjectsUsingBlock:^(NSNumber *obj1, NSUInteger index, BOOL *stop) {
                CustomStoreSort *sort = group[[obj1 intValue]];
                if ([sort.ID isEqualToString:obj]) {
                    find = TRUE;
                    *stop = TRUE;
                }
            }];
        }
        if(!find) [del addObject:obj];
    }];
    for (NSString *sortId in del)
        [locate removeObject:sortId];
    
    for (int k = 0; k < self.updateSelectedItemArrays.count; k++) {
        NSMutableArray *group = total[k];
        [self.updateSelectedItemArrays[k] enumerateObjectsUsingBlock:^(NSNumber *obj1, NSUInteger index, BOOL *stop) {
            __block BOOL find = FALSE;
            CustomStoreSort *sort = group[[obj1 intValue]];
            [locate enumerateObjectsUsingBlock:^(NSString *obj2, NSUInteger idx, BOOL *stop) {
                if ([sort.ID isEqualToString:obj2])
                    *stop = find =  TRUE;
            }];
            
            if (!find)  [locate addObject:sort.ID];
        }];
    }
    
    [GlobalObject setLocStoreSorts:locate];
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark -
#pragma mark delegate-
-(BOOL)isChanged
{
    __block BOOL isChanged = FALSE;
    
    if (self.updateSelectedItemArrays.count != self.orgSelectedItemArrays.count) {
        isChanged = TRUE;
    }
    
    for (int k = 0;  k < self.updateSelectedItemArrays.count && !isChanged; k++) {
        if (((NSArray*)self.updateSelectedItemArrays[k]).count != ((NSArray*)self.orgSelectedItemArrays[k]).count) {
            isChanged = TRUE;
            break;
        }
        
        [self.updateSelectedItemArrays[k] enumerateObjectsUsingBlock:^(NSNumber *obj1, NSUInteger idx, BOOL *stop1) {
            __block BOOL find = FALSE;
            [self.orgSelectedItemArrays[k] enumerateObjectsUsingBlock:^(NSNumber *obj2, NSUInteger idx, BOOL *stop2) {
                if ([obj1 intValue] == [obj2 intValue]) {
                    find = TRUE;
                    *stop2 = TRUE;
                }
            }];
            if (!find) {
                isChanged = TRUE;
                *stop1 = TRUE;
            }
        }];
    }
    
    return isChanged;
}

-(void)MultiColList:(WSMultiColList *)list cellSelected:(NSInteger)index
{
    [self.updateSelectedItemArrays[list.tag] addObject:[NSNumber numberWithInt:index]];

    [self.rightBtn setEnabled:[self isChanged]];
}

-(void)MultiColList:(WSMultiColList *)list cellDeSelected:(NSInteger)index
{
    [self.updateSelectedItemArrays[list.tag] enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL *stop) {
        if ([obj intValue] == index) {
            [self.updateSelectedItemArrays[list.tag] removeObject:obj];
            *stop = TRUE;
        }
    }];
    
    [self.rightBtn setEnabled:[self isChanged]];
}
@end
