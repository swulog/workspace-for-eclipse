//
//  GKCommentReleaseCtrller.h
//  GK
//
//  Created by W.S. on 13-12-13.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GKBaseViewController.h"
#import "GKStoreSortListService.h"
#import "WSScrollContentView.h"

@interface GKCommentReleaseCtrller : GKBaseViewController
@property (weak, nonatomic) IBOutlet WSLargeButton *goodBtn;
@property (weak, nonatomic) IBOutlet WSLargeButton *badBtn;
@property (weak, nonatomic) IBOutlet WSLargeButton *commentBtn0;
@property (weak, nonatomic) IBOutlet WSLargeButton *commentBtn1;
@property (weak, nonatomic) IBOutlet WSLargeButton *commentBtn2;
@property (weak, nonatomic) IBOutlet UITextView *subjectTextView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIView *presetCommentView;

@property (weak, nonatomic) IBOutlet WSLargeButton *sinaBtn;
@property (weak, nonatomic) IBOutlet WSLargeButton *qqWBBtn;
@property (weak, nonatomic) IBOutlet WSLargeButton *qqZoneBtn;
@property (weak, nonatomic) IBOutlet WSLargeButton *qqFriendBtn;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet WSScrollContentView *scrollContentView;
@property (strong,nonatomic) StoreInfo *store;


-(id)initWithStore:(StoreInfo*)store;
@end
