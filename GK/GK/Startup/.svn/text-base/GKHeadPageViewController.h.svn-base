//
//  GKHeadPageViewController.h
//  GK
//
//  Created by apple on 13-4-11.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "GKBaseViewController.h"
#import "GKSearchResultCtroller.h"
///#import "HJManagedImageV.h"
#import "GKLogonService.h"
#import "SpringBoardView.h"
#import "WSMultiColList.h"



@interface GKHeadPageViewController : GKBaseViewController<WSMultiColCellDelegate>

- (IBAction)canyinClick:(id)sender;
- (IBAction)yuleClick:(id)sender;
- (IBAction)yundongClick:(id)sender;
- (IBAction)gouwuClick:(id)sender;
- (IBAction)shenghuoClick:(id)sender;
- (IBAction)beautyClick:(id)sender;


@property (weak, nonatomic) IBOutlet SpringBoardView *springBoradView;

@property (weak, nonatomic) IBOutlet UIScrollView *fullScrollView;

@property (weak, nonatomic) IBOutlet UIScrollView *advScrollView;

@property (weak, nonatomic) IBOutlet StyledPageControl *custPageControl;

@property (strong,nonatomic) NSString *cityId;
@property (strong,nonatomic) NSString *cityName;

@property(strong,nonatomic) NSArray *advArray;



@end
