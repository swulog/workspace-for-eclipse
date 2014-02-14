//
//  GKSearchResultCtroller.h
//  GK
//
//  Created by apple on 13-4-16.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GKBaseViewController.h"
//#import "HJObjManager.h"
//#import "HJManagedImageV.h"
//#import "GKTableView.h"

@interface GKSearchResultCtroller : GKBaseViewController<WSMultiColCellDelegate>
{
  //  BOOL tableHasFoot;
    int pageIndex,pageNum,totalPage;
    BOOL hadClearMoreSperateLine;
    BOOL hasNext;

}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong,nonatomic) NSString *searchKey;
@property (strong,nonatomic) NSMutableArray *resultArray;
@property (strong,nonatomic) NSString *cityId;
//@property (strong,nonatomic) HJObjManager *storeIconManager;
@property (strong, nonatomic)  WSMultiColList *hotKeyTable;
@property (weak, nonatomic) IBOutlet UIView *keyWordsRegion;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil keyword:(NSString*)kEyWord;
@end


@interface UIButtonWithSearch : UIButton
@end
