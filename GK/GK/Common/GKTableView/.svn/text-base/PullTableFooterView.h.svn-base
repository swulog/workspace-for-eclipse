//
// DemoTableFooterView.h
//
// @author Shiki
//

#import <UIKit/UIKit.h>
#import "NSObject+GKExpand.h"

@protocol FooterViewClickDelegate <NSObject>

-(void)footerViewCliecked;

@end
@interface PullTableFooterView : UIView {
    
  UIActivityIndicatorView *activityIndicator;
  DownLineLabel *infoLabel;
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) IBOutlet DownLineLabel *infoLabel;
@property(nonatomic,assign) id<FooterViewClickDelegate> delegate;

-(void)reset;
@end
