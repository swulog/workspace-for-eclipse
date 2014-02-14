//
//  GKXWGService.h
//  GK
//
//  Created by W.S. on 13-8-26.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "Singleton.h"
#import "GKObject.h"
#import "Appheader.h"
#import "WSBaseNetWorkService.h"

@interface GKXWGService : WSBaseNetWorkService
@property (nonatomic,copy) NillBlock_Error  tbkFailBack;
@property (nonatomic,copy) NillBlock_OBJ    tbkSuccBack;
@property (nonatomic,strong) NSString *itemId;

+(WSNetServicesReault*)getXWGList:(NSInteger)_cid order:(NSString*)_orderKey  page:(int)_pageNo num:(int)_pageNum succ:(NillBlock_OBJ_BOOL)sucCallback fail:(NillBlock_Error)failCallback;
+(id)getUserInfo:(NSString*)iD success:(NillBlock_OBJ)sucCallback fail:(NillBlock_Error)failCallback;
+(void)loveGood:(NSString*)_goodId hadFocused:(BOOL)hadFocused  success:(NillBlock_Nill)sucCallback fail:(NillBlock_Error)failCallback;
+(void)getLoveStatus:(NSString*)_goodId success:(NillBlock_BOOL)sucCallback fail:(NillBlock_Error)failCallback;

+(NSString*)convertUrl2TBKUrl:(NSString*)itemId  succ:(NillBlock_OBJ)succBack fail:(NillBlock_Error)failBack;
+(NSArray*)getXWGGoodSorts:(NillBlock_Array)sucCallback fail:(NillBlock_Error)failCallback;
@end


#define GoodIDForEditor NOT_DEFINED
#define GoodIDForTopSort 0

@interface GoodsInfo : GKObject
@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *owner_id;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSString *smal_image_url;
@property (nonatomic,strong) NSString *large_image_url;

@property (nonatomic,strong) NSString *url;
@property (nonatomic,assign) NSInteger user_favorites;
@property (nonatomic,assign) NSInteger sold_count;
@property (nonatomic,strong) NSString *description;

@property (nonatomic,strong) NSString *item_id;

//@property (nonatomic,assign) NSInteger sid;
@end

@interface XWGGoodUrls : GKObject
@property (nonatomic,strong) NSString *item_id;
@property (nonatomic,strong) NSString *click_url;
@property (nonatomic,strong) NSString *platform;

@end

@interface XWGGoodSort : GKObject
@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *parent_cid;

@property (nonatomic,strong) NSString *weight;

@end

//@interface GoodsDetail : GKObject
//@property (nonatomic,strong) NSString *id;
//@property (nonatomic,strong) NSString *owner_id;
//@property (nonatomic,strong) NSString *title;
//@property (nonatomic,strong) NSString *price;
//@property (nonatomic,strong) NSString *image_url;
//@property (nonatomic,strong) NSString *url;
//@property (nonatomic,assign) NSInteger user_favorites;
//@property (nonatomic,assign) NSInteger sold_count;
//@property (nonatomic,strong) NSString *description;
//@end

@interface UserInfo  : GKObject
@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *avatar_url;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *type;
@end


