//
//  OwnerParentViewController.m
//  GK
//
//  Created by W.S. on 13-5-8.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "OwnerParentViewController.h"

@interface OwnerParentViewController ()

@end

@implementation OwnerParentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
#ifdef TABBAR_WITH_CUSTOM
        [self showCustTabBar];
        
#else
        [self showCustTabBar:@"我的"];
#endif
        self.ownerRootViewController = [[OwnerViewController alloc] initWithNibName:@"OwnerViewController" bundle:nil];
//                 self.navigation = [[UINavigationController alloc] initWithRootViewController:self.ownerRootViewController];
//        self.ownerRootViewController.pController = self;
//        [self addChildViewController:self.navigation];
        [self.contentView addSubview:self.ownerRootViewController.view];


        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(test) name:@"ImgPickerDidShow" object:nil];
    
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
 //   [self test];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setContentView:nil];
    [super viewDidUnload];
}

-(void)test
{
    self.imgPicker       = [[UIImagePickerController alloc] init];
    self.imgPicker.delegate = self;
    self.imgPicker.allowsEditing = NO;
    self.imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // [self presentViewController:self.imgPicker animated:YES completion:nil];
    [self presentModalViewController:self.imgPicker animated:YES];
    [self.ownerRootViewController.view removeFromSuperview];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissModalViewControllerAnimated:YES];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
    
    [self.contentView addSubview:self.ownerRootViewController.view];
}

@end
