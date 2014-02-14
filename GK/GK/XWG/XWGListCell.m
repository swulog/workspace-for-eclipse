//
//  XWGListCell.m
//  GK
//
//  Created by W.S. on 13-8-27.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "XWGListCell.h"
//#import "NSObject+GKExpand.h"
//#import "NSObject+BlockObservation.h"
#import "Appheader.h"

@implementation XWGListCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
       // self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)awakeFromNib
{
    self.downCView.backgroundColor = colorWithUtfStr(CouponInforC_PageControlNormalColor);
    self.priceLabel.textColor = colorWithUtfStr(CouponInforC_PageControlSeletedColor);
    self.loveLabel.textColor = colorWithUtfStr(CouponInforC_PageControlSeletedColor);

}

//-(void)setFrame:(CGRect)frame
//{
//    CGRect orgFrame = self.frame;
//    
//    [super setFrame:frame];
//        
//    float offset = frame.size.height - orgFrame.size.height;
//    
//    [self.priceLabel move:offset direct:Direct_Down];
//    [self.loveLabel move:offset direct:Direct_Down];
//    [self.loveV move:offset direct:Direct_Down];
//    
//}
-(void)removeCellObserverForKeyPath:(NSString *)keyPath
{
    if (!self.handlers || self.handlers.count == 0) {
        return;
    }
    
    if ([self.handlers objectForKey:keyPath]) {
        NSArray *array = [self.handlers objectForKey:keyPath];
        NSObject *obj =  [array objectAtIndex:0];
        [obj removeObserver:self forKeyPath:keyPath];
        [self.handlers removeObjectForKey:keyPath];
    }
}

-(void)addObserver:(NSObject*)obj forKeyPath:(NSString *)keyPath handler:(NillBlock_OBJ)handler
{
    if (!self.handlers) {
        self.handlers = [[NSMutableDictionary alloc] initWithCapacity:3];
    }
    NSArray *set = [[NSArray alloc] initWithObjects:obj,[handler copy], nil];
    
    self.handlers[keyPath] = set;
    
    
    [obj addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NillBlock_OBJ block =  [((NSArray*)self.handlers[keyPath]) objectAtIndex:1];
    block(object);
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.loveV reAliginWith:self.loveLabel idirect:Direct_Left gap:NOT_DEFINED];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
