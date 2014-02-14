//
//  GKCanYinController.h
//  GK
//
//  Created by apple on 13-4-11.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//


#import "GKBaseViewController.h"
#import "GKStoreSortListService.h"
#import "WSMultiLevelList.h"
#import "WSScrollContentView.h"

@class UIButtonWithStoreList;

@interface GKStoreListCtrller : GKBaseViewController<UIActionSheetDelegate,GKTableDelegate,WSMultiColCellDelegate,WSPopupDelete,WSMultiLevelListDelegate>
{
    BOOL hadClearMoreSperateLine;
    BOOL maybeNextPage;
    int  pageIndex,pageNum;
}


@property (weak, nonatomic) IBOutlet UIView *upsideHidenabledView;
@property (weak, nonatomic) IBOutlet UIButtonWithStoreList *topBtn0;
@property (weak, nonatomic) IBOutlet UIButtonWithStoreList *topBtn1;
@property (weak, nonatomic) IBOutlet UIButtonWithStoreList *topBtn2;

@property (weak, nonatomic) IBOutlet WSScrollContentView *scrollContentV;
@property (weak, nonatomic) IBOutlet UITableView *contentView;



@property (assign,nonatomic) BOOL isInitDataWithGetDistance;





-(id)initForNeighbour;
-(id)initWithSearchKey:(NSString*)key;
-(id)initForOwnerFocus;
-(id)initForSort:(StoreSort*)sort;

@end

@interface UIButtonWithStoreList : UIButton
@property (nonatomic,assign) BOOL tabSsSelected;
@end
