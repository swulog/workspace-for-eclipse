//
//  GKCommentService.h
//  GK
//
//  Created by W.S. on 13-12-6.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "WSBaseNetWorkService.h"
#import "GKObject.h"
#import "Constants.h"

@interface GKCommentService : WSBaseNetWorkService
+(void)restCommentService;

+(void)GetCommentList:(NSString*)storeId
                index:(int)_pageNo
                  num:(int)_pageNum
                 rank:(NSInteger)rankTag
              refresh:(BOOL)refresh
                 succ:(NillBlock_OBBB)sucCallback
                 fail:(NillBlock_Error)failCallback;

+(void)GetOwnerCommentList:(NSInteger)rankTag
                     index:(int)_pageNo
                       num:(int)_pageNum
                   refresh:(BOOL)refresh
                      succ:(NillBlock_OBBB)sucCallback
                      fail:(NillBlock_Error)failCallback;

+(void)releaseComment:(NSString*)storeId
              subject:(NSString*)subject
                 rank:(NSInteger)rank
                 succ:(NillBlock_OBJ)succBack
                 fail:(NillBlock_Error)failBack;
@end


@interface Comment : GKObject
@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *sid; //评论商户ID
@property (nonatomic,strong) NSString *store_name;
@property (nonatomic,strong) NSString *uid; //评论者会员UID
@property (nonatomic,strong) NSString *owner_name; //评论者名称
@property (nonatomic,strong) NSString *rank; //好评1、差评0
@property (nonatomic,strong) NSString *subject; //评论内容
@property (nonatomic,strong) NSString *created; //格式(yyyy-MM-dd H:i:s)
@end