//
//  GS_GlobalObject.h
//  GS
//
//  Created by W.S. on 13-6-8.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "WS_GlobalObjectWithServices.h"
#import "GSLogonService.h"
#import "GSStoreService.h"

@interface GS_GlobalObject : WS_GlobalObjectWithServices<UIAlertViewDelegate>

@property(nonatomic,strong) GSIDInfo *ownIdInfo;
@property(nonatomic,strong) NSString *gToken;
+(GS_GlobalObject*)GS_GObject;

@property (strong,nonatomic) StoreInfo *iStore;
@property(strong,nonatomic) NSArray *sortArray;
@property(assign,nonatomic) BOOL isGetSort;

-(void)initAPP;
-(NSArray*)getSorts:(NillBlock_Array)updateBlock;
-(NSString*)getSortName:(NSString*)sortid;
-(NSInteger)getSortIndex:(NSString*)sortid;
-(NSString*)getSortID:(NSString*)sortName;
-(NSInteger)getSortIndexWithName:(NSString *)sortName;

+(BOOL)getBaiduLocation:(NillBlock_OBJ)succCallback fail:(NillBlock_Error)failCallback;
+(void)showCurentLocInsideMap:(UIViewController*)_pvc title:(NSString*)_title enabledSave:(Boolean)_showSave;
+(BOOL)getGPSLocWithAddress:(NSString*)addrStr succ:(NillBlock_OBJ)succCallback fail:(NillBlock_Error)failCallback;

@property(nonatomic,strong) CLLocation *curLoc;
@end
