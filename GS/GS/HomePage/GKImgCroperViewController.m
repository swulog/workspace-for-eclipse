//
//  GKImgCroperViewController.m
//  GK
//
//  Created by W.S. on 13-5-13.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GKImgCroperViewController.h"
#import "NSObject+WSExpand.h"
#import "AppConstans.h"

@interface GKImgCroperViewController ()
@property (nonatomic,assign) BOOL hadInit;
@end

@implementation GKImgCroperViewController

#define CROPT_SIZE_WIDTH 200.0f
#define CROPT_SIZE_HEIGHT CROPT_SIZE_WIDTH

#define CROPT_VALID_EDAGE_OFFSET 20
#define CROPT_MIN_WIDTH 50
#define CROPT_MIN_HEIGHT CROPT_MIN_WIDTH
-(id)initWithImg:(UIImage*)iMg
{
    self = [self initWithNibName:@"GKImgCroperViewController" bundle:nil];
    
    if (self) {
        self.srcImg =iMg;
        style = CroperStyle_Square;
    }
    return self;
}

-(id)initWithImg:(UIImage*)iMg style:(CroperStyle)sTyle
{
    self = [self initWithNibName:@"GKImgCroperViewController" bundle:nil];
    
    if (self) {
        self.srcImg =iMg;
        style = sTyle;
        

        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setHidesBottomBarWhenPushed:YES];
        
   //     [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor blackColor];

    self.imgV = [[UIImageView alloc] initWithImage:self.srcImg];
   // self.imgV.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.imgRegion addSubview:self.imgV];
    
    NSMutableString *btnBgStr = [NSMutableString stringWithString:@"photo_cropper_rect"];
    
    switch (style) {
        case CroperStyle_480X220:
            initWidth = self.view.frame.size.width;
            initHeight = self.view.frame.size.width/480*220;
            [btnBgStr appendString:@"_310X142"];
            break;
          
        case CroperStyle_Square:
            initWidth = CROPT_SIZE_WIDTH;
            initHeight = CROPT_SIZE_WIDTH;
            [btnBgStr appendString:@"_310X310"];
            break;
        default:
            break;
    }
    
    
    
    CGRect rect = CGRectMake(0, 0, initWidth, initHeight);
    [self.selectBtn setFrame:rect];
    
    self.selectBtn.center = self.imgRegion.center;
    
    
    [self.selectBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_on",btnBgStr ]] forState:UIControlStateNormal];
    [self.selectBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_strech",btnBgStr ]] forState:UIControlStateHighlighted];
    
    [self.selectBtn addTarget:self
                       action:@selector(imageTouch:withEvent:)
             forControlEvents:UIControlEventTouchDown];
    [self.selectBtn addTarget:self
                       action:@selector(imageMoved:withEvent:)
             forControlEvents:UIControlEventTouchDragInside];


}

-(void)viewWillAppear:(BOOL)animated
{
    if (!self.hadInit) {
        self.hadInit = TRUE;
        [self.imgV compressToRect:self.imgRegion.frame];
    }
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
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SELECT_PIC object:[self croppedPhoto]];
    [self.delegate performSelector:@selector(saveImage:) withObject:[self croppedPhoto]];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)backClick:(id)sender {
   // [self.navigationController popViewControllerAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];
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
        
#if 1
        diffX = point.x - prev.x;
        diffY = point.y - prev.y;
        
        
        float offsetX,offsetY;
        if (ABS(diffX) / ABS(diffY) >= initWidth/initHeight) {
            offsetY = diffY;
            offsetX = ABS(offsetY) *  initWidth / initHeight * diffX / ABS(diffX);
        } else {
            offsetX = diffX;
            offsetY = ABS(offsetX) * initHeight / initWidth * diffY / ABS(diffY);
        }

        switch (strechDirection) {
            case STRECH_LD:
                newFrame.origin.y +=  offsetY;
                offsetY = -offsetY;
                break;
            case STRECH_RU:
                newFrame.origin.x += offsetX;
                offsetX = -offsetX;
                break;
            case STRECH_RD:
                newFrame.origin.x += offsetX;
                newFrame.origin.y += offsetY;
                offsetX = -offsetX;
                offsetY = -offsetY;
                break;
            default:
                break;
        }
        newFrame.size.width += offsetX;
        newFrame.size.height += offsetY;
#else
        float offset = 0.0;

        
        diffX = point.x - prev.x;
        diffY = point.y - prev.y;

        

        
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
                offset = diffX > diffY ? diffY : diffX;
                newFrame.origin.x -= offset;
                newFrame.origin.y -= offset;
                break;
        }
        newFrame.size.width += offset;
        newFrame.size.height += offset;
#endif
    }
    
    
    
      if(CGRectIntersectsRect(newFrame,self.imgV.frame) && CGRectContainsRect(self.imgRegion.frame, newFrame) && (newFrame.size.width > CROPT_MIN_WIDTH && newFrame.size.height > CROPT_MIN_HEIGHT))
        button.frame = newFrame;
}



- (void) imageTouch:(id)sender withEvent:(UIEvent *)event{

    CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];
    lastPoint = point;
    

    if ([self isTouchAtEdage:point]) {
        isMoveCropRect = FALSE;
    } else{
        isMoveCropRect = TRUE;
    }
    
//        CGRect rect = CGRectInset(self.selectBtn.frame,CROPT_VALID_EDAGE_OFFSET , CROPT_VALID_EDAGE_OFFSET) ;
//    NSLog(@"touch --> (%f,%f)",point.x,point.y);
//    NSLog(@"selectBtn ----> (%f,%f,%f,%f)",self.selectBtn.frame.origin.x,self.selectBtn.frame.origin.y,self.selectBtn.frame.size.width,self.selectBtn.frame.size.height);
//    
//
//    NSLog(@"edigtRect ---> (%f,%f,%f,%f)",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);    NSLog(@"drag:%d",[self isTouchAtEdage:startPoint]);
}
@end
