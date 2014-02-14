//
//  GKCommentService.m
//  GK
//
//  Created by W.S. on 13-12-6.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GKCommentService.h"
#import "NetWorkClient.h"
#import "Config.h"
#import "CommonFunction.h"
#import "NSError+Description.h"
#import "GlobalObject.h"

#define StartPageNo 1

@implementation GKCommentService

+(void)restCommentService
{
    NSMutableDictionary *dict =  [self CommentsDict];
    dict = nil;
    dict = [self CursorDict];
    dict = nil;
    dict = [self PageDict];
    dict = nil;
}

+(void)GetCommentList:(NSString*)storeId
                index:(int)_pageNo
                  num:(int)_pageNum
                 rank:(NSInteger)rankTag
              refresh:(BOOL)refresh
                 succ:(NillBlock_OBBB)sucCallback
                 fail:(NillBlock_Error)failCallback
{
#if 1
    BOOL isOnLine = [NetWorkClient NetworkIsReachable];
    BOOL isCache = TRUE;
    __block BOOL next = TRUE;

    if (!isOnLine) {
        NSArray *array = ((NSArray*)([self PageDict][storeId]));
        if (IsSafeArray(array)){
            if (array[rankTag]) {
                if ([array[rankTag] intValue] < (_pageNo - 1) && _pageNo != StartPageNo) {
                    NSError *err = [NSError errorWithCode:WSError_NetWorkException];
                    if (failCallback) failCallback(err);
                }
            }
        } else {
            BOOL next = FALSE;
            NSMutableArray *retArray = [self CommentsFromCache:storeId index:_pageNo num:_pageNum rank:rankTag next:&next];
            if (sucCallback) sucCallback(retArray,next,!isOnLine,isCache);
        }
    } else {
        NSArray *array = ((NSArray*)([self CursorDict][storeId]));
        if (IsSafeArray(array)){
            if (array[rankTag]) {
                if ([array[rankTag] intValue] != 0) {
                    _pageNum += [array[rankTag] intValue];
                    _pageNo = 1;
                    [self restCommentService];
                }
            }
        }
        
        NSMutableString *url = [NSMutableString stringWithFormat:GK_Comment_URL,storeId];
        BOOL extraParams = FALSE;
        if (_pageNum != NOT_DEFINED) {
            [url appendString:[NSString stringWithFormat:@"?per_page=%d",_pageNum]];
            extraParams = TRUE;
        }
        
        if (_pageNo != NOT_DEFINED) {
            [url appendString:[NSString stringWithFormat:@"%@page=%d",extraParams?@"&":@"?",_pageNo]];
            extraParams = TRUE;
        }
        
        if (rankTag != NOT_DEFINED) {
            [url appendString:[NSString stringWithFormat:@"%@rank=%d",extraParams?@"&":@"?",rankTag]];
            extraParams = TRUE;
        }
        
        isCache = FALSE;
        [NetWorkClient requestURL:url withBody:nil method:HTTP_GET receiveHeader:[NSArray arrayWithObject:@"Link"] parser:^(NSObject *dataDict, NSDictionary *headers) {
            NSMutableArray *commenList = nil;
            if ([dataDict isKindOfClass:[NSArray class]]) {
                NSArray *array = (NSArray*)dataDict;
                if (IsSafeArray(array)) {
                    commenList = [NSMutableArray arrayWithCapacity:array.count];
                    for (id obj in array) {
                        Comment *comment = [[Comment alloc] init];
                        [comment Deserialize:obj];
                        [comment save:@"id"];
                        [commenList addObject:comment];
                    }
                }
            }
            next = [self checkNetPage:headers];
            if (sucCallback) sucCallback(commenList,next,!isOnLine,isCache);
        } fail:^(NSError *err) {
            SAFE_BLOCK_CALL(failCallback, err);
        }];
    }
#else
    __block BOOL next = TRUE;
    __block BOOL isCache = TRUE;
    BOOL isOnLine = [NetWorkClient NetworkIsReachable];
    BOOL needRefresh = refresh;
    
    if (_pageNo == 1) needRefresh = TRUE;
    if (needRefresh) {
        [self CursorDict][storeId] = [NSNumber numberWithInt:0];
        [self PageDict][storeId] = [NSNumber numberWithInt:0];
    }
    
    if (!isOnLine) {
        if (refresh) {
            if (sucCallback) sucCallback(nil,FALSE,!isOnLine,FALSE);
        } else {
            NSMutableArray *retArray = [self CommentsFromCache:storeId index:_pageNo num:_pageNum];
            next = [[self CursorDict][storeId] intValue] < ((NSArray*)[self CommentsDict][storeId]).count;
            if (sucCallback) sucCallback(retArray,next,!isOnLine,isCache);
        }
    } else {
        BOOL inserToHeader = TRUE;
        NSDate *endDate  = nil;
        NSMutableArray *retArray;
        if (!needRefresh) {
            retArray = [self CommentsFromCache:storeId index:_pageNo num:_pageNum];
            if (IsSafeArray(retArray)) {
                next = [[self CursorDict][storeId] intValue] < ((NSArray*)[self CommentsDict][storeId]).count;
                if (!next) {
                    NSInteger total = ((NSArray*)[self CommentsDict][storeId]).count;
                    if (total < storeCommentCount || storeCommentCount == 0) {
                        NSString *dateStr = ((Comment*)(((NSArray*)[self CommentsDict][storeId])[total - 1])).created;
                        endDate = dateFromString(dateStr);
                    }
                } else {
                    if (sucCallback) sucCallback(retArray,next,!isOnLine,isCache);
                    return;
                }
            }
        }
        
        NSMutableString *url = [NSMutableString stringWithFormat:GK_Comment_URL,storeId];
        BOOL extraParams = FALSE;
        if (_pageNum != NOT_DEFINED) {
            [url appendString:[NSString stringWithFormat:@"?per_page=%d",_pageNum]];
            extraParams = TRUE;
        }
        
        if (_pageNo != NOT_DEFINED) {
            [url appendString:[NSString stringWithFormat:@"%@page=%d",extraParams?@"&":@"?",_pageNo]];
            extraParams = TRUE;
        }
        
        [NetWorkClient requestURL:url withBody:nil method:HTTP_GET receiveHeader:[NSArray arrayWithObject:@"Link"] parser:^(NSObject *dataDict, NSDictionary *headers) {
            NSMutableArray *commenList = nil;
            if ([dataDict isKindOfClass:[NSArray class]]) {
                NSArray *array = (NSArray*)dataDict;
                if (IsSafeArray(array)) {
                    commenList = [NSMutableArray arrayWithCapacity:array.count];
                    for (id obj in array) {
                        Comment *comment = [[Comment alloc] init];
                        [comment Deserialize:obj];
                        [comment save:@"id"];
                        [commenList addObject:comment];
                    }
                    [self insertComments:commenList to:inserToHeader with:storeId];
                }
            }
            NSMutableArray *retArray = [self CommentsFromCache:storeId index:_pageNo num:_pageNum];
            next = [[self CursorDict][storeId] intValue] < ((NSArray*)[self CommentsDict][storeId]).count
                || ((NSArray*)[self CommentsDict][storeId]).count <  storeCommentCount;
            if (!next && storeCommentCount == 0) {
                next = [self checkNetPage:headers];
            }
            isCache = FALSE;
            if (sucCallback) sucCallback(retArray,next,!isOnLine,isCache);
        } fail:^(NSError *err) {
            SAFE_BLOCK_CALL(failCallback, err);
        }];
    }
#endif
}

+(void)GetOwnerCommentList:(NSInteger)rankTag
                index:(int)_pageNo
                  num:(int)_pageNum
              refresh:(BOOL)refresh
                 succ:(NillBlock_OBBB)sucCallback
                 fail:(NillBlock_Error)failCallback
{
    BOOL isOnLine = [NetWorkClient NetworkIsReachable];
    BOOL isCache = TRUE;
    __block BOOL next = TRUE;
    
    NSString *userId = [GlobalDataService userGKId];
    NSString *storeId = [NSString stringWithFormat:@"u%@",userId];
    
    if (!isOnLine) {
        NSArray *array = ((NSArray*)([self PageDict][storeId]));
        if (IsSafeArray(array)){
            if (array[rankTag]) {
                if ([array[rankTag] intValue] < (_pageNo - 1) && _pageNo != StartPageNo) {
                    NSError *err = [NSError errorWithCode:WSError_NetWorkException];
                    if (failCallback) failCallback(err);
                }
            }
        } else {
            BOOL next = FALSE;
            NSMutableArray *retArray = [self CommentsFromCache:storeId index:_pageNo num:_pageNum rank:rankTag next:&next];
            if (sucCallback) sucCallback(retArray,next,!isOnLine,isCache);
        }
    } else {
        NSArray *array = ((NSArray*)([self CursorDict][storeId]));
        if (IsSafeArray(array)){
            if (array[rankTag]) {
                if ([array[rankTag] intValue] != 0) {
                    _pageNum += [array[rankTag] intValue];
                    _pageNo = 1;
                    [self restCommentService];
                }
            }
        }
        
        NSMutableString *url = [NSMutableString stringWithFormat:GK_OwnerComment_URL];
        BOOL extraParams = FALSE;
        if (_pageNum != NOT_DEFINED) {
            [url appendString:[NSString stringWithFormat:@"?per_page=%d",_pageNum]];
            extraParams = TRUE;
        }
        
        if (_pageNo != NOT_DEFINED) {
            [url appendString:[NSString stringWithFormat:@"%@page=%d",extraParams?@"&":@"?",_pageNo]];
            extraParams = TRUE;
        }
        
        if (rankTag != NOT_DEFINED) {
            [url appendString:[NSString stringWithFormat:@"%@rank=%d",extraParams?@"&":@"?",rankTag]];
            extraParams = TRUE;
        }
        
        isCache = FALSE;
        [NetWorkClient requestURL:url withBody:Nil method:HTTP_GET user:[GlobalDataService userGKId] pwd:[GlobalDataService userPwd] token:[GlobalDataService token] needAuthorization:YES receiveHeader:[NSArray arrayWithObject:@"Link"] parser:^(NSObject *dataDict, NSDictionary *headers) {
            NSMutableArray *commenList = nil;
            if ([dataDict isKindOfClass:[NSArray class]]) {
                NSArray *array = (NSArray*)dataDict;
                if (IsSafeArray(array)) {
                    commenList = [NSMutableArray arrayWithCapacity:array.count];
                    for (id obj in array) {
                        Comment *comment = [[Comment alloc] init];
                        [comment Deserialize:obj];
                        [comment save:@"id"];
                        [commenList addObject:comment];
                    }
                }
            }
            next = [self checkNetPage:headers];
            if (sucCallback) sucCallback(commenList,next,!isOnLine,isCache);
        } fail:^(NSError *err) {
            SAFE_BLOCK_CALL(failCallback, err);
        }];
    }
}


+(void)releaseComment:(NSString*)storeId
              subject:(NSString*)subject
                 rank:(NSInteger)rank
                 succ:(NillBlock_OBJ)succBack
                 fail:(NillBlock_Error)failBack
{
    NSMutableDictionary *body = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:subject,[NSNumber numberWithInt:rank], nil] forKeys:[NSArray arrayWithObjects:@"subject",@"rank", nil]];
    NSMutableString *url = [NSMutableString stringWithFormat:GK_Comment_URL,storeId];
    
    [NetWorkClient requestURL:url withBody:body method:HTTP_POST user:[GlobalDataService userGKId] pwd:[GlobalDataService userPwd] token:[GlobalDataService token] needAuthorization:YES parser:^(NSObject *dataDict) {
        Comment *comment = nil;
        if ([dataDict isKindOfClass:[NSDictionary class]]) {
            comment = [[Comment alloc] init];
            [comment Deserialize:(NSDictionary*)dataDict];
            [comment save:@"id"];
        }
        SAFE_BLOCK_CALL(succBack,comment);
    } fail:^(NSError *err) {
        SAFE_BLOCK_CALL(failBack, err);
    }];
}

+(NSMutableDictionary*)CommentsDict
{
    static NSMutableDictionary *CommentsDict = nil;
    if (!CommentsDict) CommentsDict = [NSMutableDictionary dictionary];
    return CommentsDict;
}

+(NSMutableDictionary*)CursorDict
{
    static NSMutableDictionary *CursorDict = nil;
    if (!CursorDict) {
        CursorDict = [NSMutableDictionary dictionary];
        
    }
    return CursorDict;
}

+(NSMutableDictionary*)PageDict
{
    static NSMutableDictionary *PageDict = nil;
    if (!PageDict) PageDict = [NSMutableDictionary dictionary];
    return PageDict;
}

+(NSMutableArray*)CommentsFromCache:(NSString*)storeId
                              index:(int)_pageNo
                                num:(int)_pageNum
                               rank:(int)_rank
                               next:(BOOL*)rnext
{
    NSArray *commentArray = [self CommentsDict][storeId];
    if (!IsSafeArray(commentArray)) {
        if ([storeId hasPrefix:@"u"]) {
            NSString *userId = [storeId substringFromIndex:1];
            commentArray = [Comment getList:@"uid" value:userId];
        } else {
            commentArray = [Comment getList:@"sid" value:storeId];
        }
        commentArray = [commentArray sortedArrayUsingComparator:^NSComparisonResult(Comment *obj1, Comment *obj2) {
            NSDate *date1 = dateFromString(obj1.created);
            NSDate *date2 = dateFromString(obj2.created);
            return (NSComparisonResult)[date1 compare:date2];
        }];
    }

    
    if (IsSafeArray(commentArray)) {
        [self CommentsDict][storeId] = commentArray;
        NSInteger oldPage = 0,oldIndex = 0;
        if (IsSafeArray(((NSArray*)[self CursorDict][storeId])))
            if ([self CursorDict][storeId][_rank])
                oldIndex = [[self CursorDict][storeId][_rank] intValue];
        if (IsSafeArray(((NSArray*)[self PageDict][storeId])))
            if ([self PageDict][storeId][_rank])
                oldPage = [[self PageDict][storeId][_rank] intValue];
        
        __block NSInteger owed = (_pageNo - oldPage - 1) * _pageNum;
        __block NSInteger cur = 0;
        __block NSMutableArray *retArray = [NSMutableArray arrayWithCapacity:_pageNum];
        __block BOOL next = FALSE;
        [commentArray enumerateObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(oldIndex,commentArray.count - oldIndex )]  options:NSEnumerationConcurrent usingBlock:^(Comment *obj, NSUInteger idx, BOOL *stop) {
            if ([obj.rank intValue] == _rank) {
                if (owed)
                    owed--;
                else if(cur < _pageNum)
                {
                    [retArray addObject:obj];
                    cur++;
                } else {
                    cur = idx;
                    next = TRUE;
                    *stop = TRUE;
                }
            }
        }];
        
        NSMutableArray *array = [self CursorDict][storeId];
        if (!array) {
            array = [NSMutableArray arrayWithCapacity:2];
            [self CursorDict][storeId] = array;
        }
        array[_rank] = [NSNumber numberWithInt:cur];
        
        array = [self PageDict][storeId];
        if (!array) {
            array = [NSMutableArray arrayWithCapacity:2];
            [self PageDict][storeId] = array;
        }
        array[_rank] = [NSNumber numberWithInt:_pageNo];
        *rnext = next;
        return retArray;
    } else {
        return nil;
    }
}


+(void)insertComments:(NSArray*)nComments to:(BOOL)insertToHeader with:(NSString*)identifier rank:(NSInteger)rank
{
    NSMutableArray *commentArray = [self CommentsDict][identifier];
    if (!IsSafeArray(commentArray)) {
        commentArray = [NSMutableArray arrayWithArray:nComments];
        [self CommentsDict][identifier] = commentArray;
    } else {
        NSMutableArray *insertArray = [NSMutableArray array];
        [nComments enumerateObjectsUsingBlock:^(Comment *comment1, NSUInteger idx1, BOOL *stop1) {
            __block BOOL find = FALSE;
            [commentArray enumerateObjectsUsingBlock:^(Comment *comment2, NSUInteger idx2, BOOL *stop2) {
                if ([comment1.id isEqualToString:comment2.id])  *stop2 = find = TRUE;
            }];
            if (!find)    [insertArray addObject:comment1];
        }];
        
        if (IsSafeArray(insertArray)) {
            if (insertToHeader) {
                [commentArray insertObjects:insertArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, insertArray.count)]];
                
                NSMutableArray *array = [self CursorDict][identifier];
                if (!array) {
                    array = [NSMutableArray arrayWithCapacity:2];
                    [self CursorDict][identifier] = array;
                }
                NSInteger index = [array[rank] intValue];
                if (index > 0)  index += insertArray.count;
                array[rank] = [NSNumber numberWithInt:index];
            } else {
                [commentArray addObjectsFromArray:insertArray];
            }
        }
    }
}

@end

@implementation Comment
-(NSTimeInterval)validatePeroid
{
    return CommentCacheClearTimeInterval;
}
@end


