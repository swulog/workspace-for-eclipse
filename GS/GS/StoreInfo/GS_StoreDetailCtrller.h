//
//  GS_StoreDetailCtrller.h
//  GS
//
//  Created by W.S. on 13-6-5.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "WS_BaseViewController.h"
#import "AppHeader.h"
#import "GSStoreService.h"

//#import "WS_GeneralTableFieldView.h"

@protocol StoreDetailDelegate;

@interface GS_StoreDetailCtrller : WS_BaseViewController<WS_GeneralTableFieldDelegate>
{
UIView *focusField;
    BOOL isAdd;
}
@property (nonatomic,copy) StoreInfo *storeInfo;
@property (nonatomic,strong)  NSString *addStoreID;
@property (nonatomic,strong) NSArray *sortArray;
@property (assign,nonatomic) id<StoreDetailDelegate> delegate;

-(id)initWithStoreInfo:(StoreInfo*)info;
-(id)initWithStoreID:(NSString*)_storeID;


//@property(nonatomic,assign) BOOL

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) WS_GeneralTableFieldView*  addressField;
@property (strong,nonatomic) NSMutableArray*  fieldArray;

@property (strong,nonatomic) BMKAddrInfo* iLocation;
@property (assign,nonatomic) BOOL hadLocated;
@property (assign,nonatomic) BOOL hadEditedAddress;
- (void)saveClick;



@end

@protocol StoreDetailDelegate <NSObject>

@optional
-(void)saveOK;

@end
