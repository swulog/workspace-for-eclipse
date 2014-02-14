//
//  GKSearchResultCtroller.m
//  GK
//
//  Created by apple on 13-4-16.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GKSearchResultCtroller.h"
//#import "Constants.h"
#import "GKStoreSortListService.h"
#import "GlobalObject.h"
#import "GKStoreTableCell.h"
#import "GKStoreInfomationController.h"

static dispatch_once_t onceToken;


@interface GKSearchResultCtroller ()
@property (nonatomic,strong) NSArray *keyWords;
@end

@implementation GKSearchResultCtroller

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil style:VIEW_WITH_NAVBAR];
    if (self) {
        // Custom initialization
        pageNum = LIST_PAGE_MAX_MUM;
        pageIndex = 0;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil keyword:(NSString*)kEyWord
{
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.searchKey = kEyWord;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[UIButtonWithSearch appearance] setBackgroundColor:colorWithUtfStr(SearchButtonBg)];
    [[UIButtonWithSearch appearance] setTitleColor:colorWithUtfStr(SearchButtonTitleColor) forState:UIControlStateNormal];
    [UIButtonWithSearch appearance].titleLabel.font = FONT_NORMAL_13;
    
    [self setTitle:@"搜索"];
    [self addBackItem];

    if (IOS_VERSION < 7.0) {
        [[self.searchBar.subviews objectAtIndex:0]removeFromSuperview];
//        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:SearchC_SearchBG]];
//        [img setFrame:self.searchBar.frame];
//       // [self.view addSubview:img];
//        [self.view bringSubviewToFront:self.searchBar];
    }
    
    UITapGestureRecognizer *clickRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(closeKeyPad:)];
    [clickRecognizer setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:clickRecognizer];
    
    
    NillBlock_OBJ hotkeyBlock = ^(NSObject *obj){
        if (!obj)            return ;
        
        self.keyWords = (NSArray*)obj;
        if (IsSafeArray(self.keyWords)) {
            self.hotKeyTable = [[WSMultiColList alloc] initWithFrame:self.keyWordsRegion.frame];
            self.hotKeyTable.numOfColPerRow = 3;
            self.hotKeyTable.cellTitltColor = colorWithUtfStr(SearchButtonTitleColor);
            self.hotKeyTable.footerViewHide = YES;
            self.hotKeyTable.cellColor = colorWithUtfStr(SearchButtonBg);
            
            NSMutableArray *array = [NSMutableArray array];
            for (int k = 0 ; k < self.keyWords.count; k++) {
                WSMultiColCell *cell = [WSMultiColCell initWithTitle:((SearchHotKey*)self.keyWords[k]).key imageView:nil];
                [array addObject:cell];
            }
            
            self.hotKeyTable.itemSource = array;
            self.hotKeyTable.multiColListDelegate = self;
            [self.view addSubview:self.hotKeyTable];
        }
        
        [self.keyWordsRegion removeFromSuperview];
    };
    
    NillBlock_OBJ cityBlock = ^(NSObject *obj){
        if (!obj)            return ;
        
        self.cityId = (NSString*)obj;
        NSArray *array =  [GKStoreSortListService getSearchHotKyes:self.cityId succ:hotkeyBlock fail:nil];
        hotkeyBlock(array);
    };
    
    cityBlock([GlobalObject getCityIdForExtraUser:cityBlock fail:nil]);
}

-(void)viewDidAppear:(BOOL)animated
{
    dispatch_once(&onceToken, ^{
        [self.searchBar becomeFirstResponder];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setSearchBar:nil];
    [super viewDidUnload];
}

-(void)viewWillLayoutSubviews
{
    if (onceToken) {
        [self.searchBar becomeFirstResponder];
    }
}

#pragma mark -
#pragma mark search bar delegate -

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.searchKey = self.searchBar.text;
    
    GKStoreListCtrller *vc = [[GKStoreListCtrller alloc] initWithSearchKey:self.searchKey];
    [self.navigationController pushViewController:vc animated:YES];
    
    [NSTimer scheduledTimerWithTimeInterval:CMM_AnimatePerior block:^(NSTimeInterval time) {
        [self.hotKeyTable delSelected];
    } repeats:NO];
}

-(void)closeKeyPad:(id)sender
{
    [self.searchBar resignFirstResponder];
}
#pragma mark -
#pragma mark tableview delegate && datasource -
-(void)cellSelected:(NSInteger)index
{
    NSString *searchKey = ((SearchHotKey*)self.keyWords[index]).key;
    
    GKStoreListCtrller *vc = [[GKStoreListCtrller alloc] initWithSearchKey:searchKey];
    [self.navigationController pushViewController:vc animated:YES];
    
    [NSTimer scheduledTimerWithTimeInterval:CMM_AnimatePerior block:^(NSTimeInterval time) {
        [self.hotKeyTable delSelected];
    } repeats:NO];
}

@end


@implementation UIButtonWithSearch
@end

