//
//  WSLargeButton.h
//
//
//  Created by 万松 on 12-10-12.
//
//

#import <UIKit/UIKit.h>


@protocol WSLargeButtonDelegate;

@interface WSLargeButton : UIButton
@property (nonatomic,assign) id<WSLargeButtonDelegate> delegate;

@property (nonatomic,strong) UIColor *hightedBGColor;
@property (nonatomic,strong) UIColor *normalBGColor;
@property (nonatomic,strong) UIColor *selectedColor;

@property (nonatomic,strong) NSString *badgeValue;
@property (nonatomic,strong) UIColor *badgeFillColor;

@property (nonatomic,assign) BOOL canDeleteAction;

//-(void)cancelDeleteAction;

@end

@protocol WSLargeButtonDelegate <NSObject>

@optional
-(void)willDeletePBButton:(id)sender;

@end
