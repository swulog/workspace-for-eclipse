//
//  GKImgCroperViewController.m
//  GK
//
//  Created by W.S. on 13-5-13.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GKImgCroperViewController.h"


@interface GKImgCroperViewController ()

@end

@implementation GKImgCroperViewController

#define CROPT_SIZE_WIDTH 200
#define CROPT_SIZE_HEIGHT CROPT_SIZE_WIDTH

#define CROPT_VALID_EDAGE_OFFSET 20
#define CROPT_MIN_WIDTH 50
#define CROPT_MIN_HEIGHT CROPT_MIN_WIDTH
-(id)initWithImg:(UIImage*)iMg
{
    self = [self initWithNibName:@"GKImgCroperViewController" bundle:nil];
    
    if (self) {
        self.srcImg =iMg;
        
    

        
        }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setHidesBottomBarWhenPushed:YES];
        
       
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (isRetina_640X1136) {
        self.view.frame = CGRectMake(0, 0, 320, 568);
    } else {
        self.view.frame = CGRectMake(0, 0, 320, 480);
    }
    
    self.view.backgroundColor = [UIColor blackColor];
    self.imgV = [[UIImageView alloc] initWithImage:self.srcImg];
       [self.imgRegion addSubview:self.imgV];
    
    CGRect rect = CGRectMake(0, 0, CROPT_SIZE_WIDTH, CROPT_SIZE_HEIGHT);
    [self.selectBtn setFrame:rect];
    self.selectBtn.center = self.imgRegion.center;

    [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"photo_cropper_rect_on"] forState:UIControlStateNormal];
    [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"photo_cropper_rect_strech"] forState:UIControlStateHighlighted];
    
    [self.selectBtn addTarget:self
                       action:@selector(imageTouch:withEvent:)
             forControlEvents:UIControlEventTouchDown];
    [self.selectBtn addTarget:self
                       action:@selector(imageMoved:withEvent:)
             forControlEvents:UIControlEventTouchDragInside];

}


-(void)viewWillLayoutSubviews
{
    [self.imgV compressToRect:self.imgRegion.frame];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setToolbar:nil];
    [self setBackBarItem:nil];
    [self setImgRegion:nil];
    [self setSelectBtn:nil];
    [super viewDidUnload];
}

- (IBAction)saveClick:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SELECT_PIC object:[self croppedPhoto]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(BOOL)isTouchAtEdage:(CGPoint)point 
{
    CGRect rect = CGRectInset(self.selectBtn.frame,CROPT_VALID_EDAGE_OFFSET , CROPT_VALID_EDAGE_OFFSET) ;
    
    
    
    if (CGRectContainsPoint(rect, point)) {
        return FALSE;
    }
    
    //判断是否四角区域
    if ((point.x > (rect.origin.x + CROPT_VALID_EDAGE_OFFSET) && point.x < (rect.origin.x + rect.size.width - CROPT_VALID_EDAGE_OFFSET)) ||
        (point.y > (rect.origin.y + CROPT_VALID_EDAGE_OFFSET) && point.y < (rect.origin.y + rect.size.height - CROPT_VALID_EDAGE_OFFSET))
        ) {
        return FALSE;
    }
    
    if (point.x <= (rect.origin.x + CROPT_VALID_EDAGE_OFFSET) && (point.y <= (rect.origin.y + CROPT_VALID_EDAGE_OFFSET)) ) {
        strechDirection = STRECH_RD;
    } else if(point.x <= (rect.origin.x + CROPT_VALID_EDAGE_OFFSET) && (point.y > (rect.origin.y + CROPT_VALID_EDAGE_OFFSET)) ){
        strechDirection = STRECH_RU;
    } else if(point.x > (rect.origin.x + CROPT_VALID_EDAGE_OFFSET) && (point.y <= (rect.origin.y + CROPT_VALID_EDAGE_OFFSET)) ){
        strechDirection = STRECH_LD;
    } else {
        strechDirection = STRECH_LU;
    }
    
    return TRUE;
}


- (UIImage *) croppedPhoto
{
     CGRect cropRect = CGRectMake(self.selectBtn.frame.origin.x + 15, self.selectBtn.frame.origin.y + 15  , self.selectBtn.frame.size.width - 30, self.selectBtn.frame.size.height - 30);
    
    CGRect transRect =[self.view convertRect:cropRect toView:self.imgV];
    CGImageRef imageRef = CGImageCreateWithImageInRect([self.imgV.image CGImage], transRect);
    UIImage *result = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return result;
}

- (void) imageMoved:(id)sender withEvent:(UIEvent *)event{
  //  NSLog(@"imageMoved");
    
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];
    CGPoint prev = lastPoint;
    lastPoint = point;
    
    UIControl *button = sender;
    CGRect newFrame = button.frame;
    float diffX = 0.0,diffY = 0.0;

    if (isMoveCropRect) {
        diffX = point.x - prev.x;
        diffY = point.y - prev.y;

        newFrame.origin.x += diffX;
        newFrame.origin.y += diffY;
    } else {
        
        float offset = 0.0;
        switch (strechDirection) {
            case STRECH_LU:
                diffX = point.x - prev.x;
                diffY = point.y - prev.y;
                offset = diffX>diffY?diffY:diffX;

                break;
            case STRECH_LD:
                diffX = point.x - prev.x;
                diffY = prev.y - point.y;
                offset = diffX>diffY?diffY:diffX;
                newFrame.origin.y -= offset;
                
                break;
            case STRECH_RU:
                diffX = prev.x - point.x;
                diffY = point.y - prev.y;
                offset = diffX>diffY?diffY:diffX;
                newFrame.origin.x -= offset;
                break;
            case STRECH_RD:
                diffX = prev.x - point.x;
                diffY = prev.y - point.y;
                offset = diffX>diffY?diffY:diffX;
                newFrame.origin.x -= offset;
                newFrame.origin.y -= offset;
                break;
        }
        newFrame.size.width += offset;
        newFrame.size.height += offset;
    }
    
    
    
      if(CGRectIntersectsRect(newFrame,self.imgV.frame) && CGRectContainsRect(self.imgRegion.frame, newFrame) && (newFrame.size.width > CROPT_MIN_WIDTH && newFrame.size.height > CROPT_MIN_HEIGHT))
        button.frame = newFrame;
}



- (void) imageTouch:(id)sender withEvent:(UIEvent *)event{
    NSLog(@"imageTouch");

    CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];
    lastPoint = point;
    

    if ([self isTouchAtEdage:point]) {
        isMoveCropRect = FALSE;
    } else{
        isMoveCropRect = TRUE;
    }
    NSLog(@"touch --> (%f,%f)",point.x,point.y);
//        CGRect rect = CGRectInset(self.selectBtn.frame,CROPT_VALID_EDAGE_OFFSET , CROPT_VALID_EDAGE_OFFSET) ;
//    NSLog(@"touch --> (%f,%f)",point.x,point.y);
//    NSLog(@"selectBtn ----> (%f,%f,%f,%f)",self.selectBtn.frame.origin.x,self.selectBtn.frame.origin.y,self.selectBtn.frame.size.width,self.selectBtn.frame.size.height);
//    
//
//    NSLog(@"edigtRect ---> (%f,%f,%f,%f)",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);    NSLog(@"drag:%d",[self isTouchAtEdage:startPoint]);
}
@end
