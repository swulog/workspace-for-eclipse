//
//  NIDropDown.h
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NIDropDown;
@protocol NIDropDownDelegate
- (void) niDropDownDelegateMethod: (NIDropDown *) sender;
@end 

@interface NIDropDown : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) id <NIDropDownDelegate> delegate;

-(void)hideDropDown:(UIView *)b;
//- (id)initWith:(UIView *)b    height:(CGFloat *)height  items:(NSArray *)arr;
-(id)showDropDown:(UIView *)b height:(CGFloat)height items:(NSArray *)arr;
- (id)initWith:(CGRect)r    height:(CGFloat)height  items:(NSArray *)arr;
@end
