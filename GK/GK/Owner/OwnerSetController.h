//
//  OwnerSetControllerViewController.h
//  GK
//
//  Created by W.S. on 13-5-28.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GKBaseViewController.h"

@interface OwnerSetController : GKBaseViewController<UIActionSheetDelegate,MBProgressHUDDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *contentTable;

@end
