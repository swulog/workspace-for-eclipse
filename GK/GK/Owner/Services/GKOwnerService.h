//
//  GKLogonService.h
//  GK
//
//  Created by apple on 13-4-16.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "Appheader.h"

@interface GKOwnerService : Singleton

+(BOOL)getFocusStoreList:(int)_pageNo num:(int)_pageNum success:(NillBlock_OBJ_BOOL)sucCallback fail:(NillBlock_Error)failCallback;
+(NSArray*)getCouponLoveList:(int)_pageNo num:(int)_pageNum refresh:(BOOL)refresh success:(NillBlock_OBJ_BOOL)sucCallback fail:(NillBlock_Error)failCallback;
+(NSArray*)getXWGGoodsLoveList:(int)_pageNo num:(int)_pageNum refresh:(BOOL)refresh success:(NillBlock_OBJ_BOOL)sucCallback fail:(NillBlock_Error)failCallback;

+(BOOL)updateName:(NSString*)_newName success:(NillBlock_Nill)sucCallback fail:(NillBlock_Error)failCallback;
+(BOOL)updateHeadIcon:(UIImage*)_image success:(NillBlock_Nill)sucCallback fail:(NillBlock_Error)failCallback progress:(NillBlock_Double)progressHandler;
@end


@interface XWGLove : GKObject
@property(nonatomic,strong) NSString *id;
@property(nonatomic,strong) NSString *xwgGoodId;
@end