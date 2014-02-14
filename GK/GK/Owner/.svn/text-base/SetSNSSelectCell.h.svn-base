//
//  SetSNSSelectCell.h
//  GK
//
//  Created by W.S. on 13-11-7.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "NSObject+GKExpand.h"
#import "WSLargeButton.h"
#import "Appheader.h"

@interface SetSNSSelectCell : XIBView<UMSocialUIDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet WSLargeButton *sinaBtn;
@property (weak, nonatomic) IBOutlet WSLargeButton *qqWbBtn;
@property (weak, nonatomic) IBOutlet WSLargeButton *qqBtn;
@property (weak, nonatomic) IBOutlet WSLargeButton *rrBtn;

@property (nonatomic,strong) UIViewController *parentVC;

- (IBAction)sinaClick:(id)sender;
- (IBAction)qqwbClick:(id)sender;
- (IBAction)qqClick:(id)sender;
- (IBAction)rrClick:(id)sender;

-(void)updateSnsStatus:(NSInteger)index;
@end
