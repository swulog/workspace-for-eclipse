//
//  SpringBoardItem.h
//  BossE_V1
//
//  Created by 万松 on 12-10-12.
//
//

#import <UIKit/UIKit.h>


#define PBMenuItem_Width 105
#define PBMenuItem_Height 105
#define PBMenuItem_Img_Width 56
#define PBMenuItem_Img_Height 56
#define PBMenuItem_DelBtn_Width 30
#define PBMenuItem_DelBtn_Height 30

typedef enum{
    BTN_Normal,
    BTN_Delete,
    BTN_Delete_Hide
}BTN_STATE;

typedef enum{
    SpringBoardItemLargeRectBtn,
    SpringBoardItemIconBtn
}SpringBoardItemType;

@protocol SpringBoardItemDelegate;

@interface SpringBoardItem : UIButton
{
    UILongPressGestureRecognizer *deleteRecognizer;
    UIPanGestureRecognizer *dragRecognizer;
}

@property (nonatomic,readonly) BOOL movEnabled;

@property (nonatomic,assign) BTN_STATE btnState;
@property(nonatomic,assign) BOOL    deleteEnabled;
@property(nonatomic,assign) id<SpringBoardItemDelegate> delegate;
@property(nonatomic,strong) UIButton *springBtn;

@property(nonatomic,assign) NSString *badgeValue;
-(id)initWithStyle:(SpringBoardItemType)type;

//+(id)pbMenuItemWithPoint:(CGPoint)_point image:(UIImage*)_img title:(NSString*)_title;
//-(void)setPBButton:(CGPoint)_point withImg:(UIImage*)_img withTitle:(NSString*)_title;
//-(void)initPBButton:(UIImage*)_icon withTitle:(NSString*)_title;
//-(void)setPBFrame:(CGRect)frame;
-(void)setImage:(UIImage *)image title:(NSString*)title;
-(void)cancelDeleteAction;
-(BOOL)isInsideDelBtn:(CGPoint)point;
@end

@protocol SpringBoardItemDelegate <NSObject>

@optional
-(void)SpringItemDelete:(id)sender;
-(void)SpringItemWillShowDeleteBtn:(id)sender;
-(void)SpringItemDMove:(id)sender;
-(void)SpringItemStopMove:(id)sender;

@end
;