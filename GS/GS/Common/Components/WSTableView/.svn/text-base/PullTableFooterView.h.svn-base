//
// DemoTableFooterView.h
//
// @author Shiki
//

#import <UIKit/UIKit.h>
#import "NSObject+WSExpand.h"

@protocol FooterViewClickDelegate <NSObject>

-(void)footerViewCliecked;

@end
@interface PullTableFooterView : UIView {
    
  UIActivityIndicatorView *activityIndicator;
  DownLineLabel *infoLabel;
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) IBOutlet UILabel *infoLabel;
@property(nonatomic,assign) id<FooterViewClickDelegate> delegate;

-(void)reset;
@end
