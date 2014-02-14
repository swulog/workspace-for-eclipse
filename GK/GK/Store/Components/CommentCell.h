//
//  CommentCell.h
//  GK
//
//  Created by W.S. on 13-12-6.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "NSObject+GKExpand.h"

@class myUILabel;

@interface CommentCell : XIBView
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet myUILabel *commentLabel;
@property (nonatomic,assign) int rankTag;
@property (nonatomic,strong) NSString *comment;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) BOOL dropEnabeld;
@property (nonatomic,readonly) BOOL expandValidate;
@property (nonatomic,strong)    NSAttributedString  *attributedName;

@end


typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;
@interface myUILabel : UILabel
{
@private
    VerticalAlignment _verticalAlignment;
}

@property (nonatomic) VerticalAlignment verticalAlignment;

@end