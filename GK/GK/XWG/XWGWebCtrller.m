//
//  XWGWebCtrller.m
//  GK
//
//  Created by W.S. on 13-8-29.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "XWGWebCtrller.h"

@interface XWGWebCtrller ()
@property (nonatomic,strong) NSString *urlStr;

@property (nonatomic,strong) NSString *titleStr;
@property (nonatomic,assign) BOOL toolBarHided;
@end

@implementation XWGWebCtrller

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



-(id)initWithUrl:(NSString*)url title:(NSString*)titleStr
{
    self = [self initWithNibName:@"XWGWebCtrller" bundle:nil style:VIEW_NOBAR];
    
    if (self) {
        self.urlStr = url;
        self.titleStr = titleStr;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.toolBar.backgroundColor = colorWithUtfStr(XWGWebC_ToolBarBGColor);

    [self.webV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    [ self.webV   setUserInteractionEnabled: YES ];	 //是否支持交互
//    self.webV.paginationMode =     UIWebPaginationModeUnpaginated;
    
    activityIndicatorView = [[UIActivityIndicatorView alloc]
                             initWithFrame : CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)] ;
    [activityIndicatorView setCenter: self.view.center] ;
    [activityIndicatorView setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleWhite] ;
    [self.view addSubview : activityIndicatorView] ;

    [self refreshToolBar];

    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    singleRecognizer.delegate = self;
    [self.webV addGestureRecognizer:singleRecognizer];
//    singleRecognizer.cancelsTouchesInView = NO;
//    UIPanGestureRecognizer* singlePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
//    [self.view addGestureRecognizer:singlePan];
//    singlePan.delegate = self;
//    singlePan.cancelsTouchesInView = NO;
}
-(void)SingleTap:(UITapGestureRecognizer*)recognizer
{
    
//    CGPoint p = [recognizer locationInView:self.view];
//    CGRect rect = self.webV.frame;
//    rect.size.height = self.toolBarHided?rect.size.height:rect.size.height-44;
//    if (CGRectContainsPoint(rect, p)) {
//        [self.toolBar move:44 direct:self.toolBarHided?Direct_Up:Direct_Down animation:YES];
//        self.toolBarHided  = !self.toolBarHided;
//        CGSize size = self.webV.frame.size;
//
//        if (self.toolBarHided) {
//            size.height += 44;
//        } else {
//            size.height -= 44;
//        }
//        [self.webV strechTo:size];
//    }
    
    [self refreshToolBar];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    //当事件是传递给此View内部的子View时，让子View自己捕获事件，如果是传递给此View自己时，放弃事件捕获
    UIView* __tmpView = [self.view hitTest:point withEvent:event];
    
    return __tmpView;
}

-(void)refreshToolBar
{
    self.toolBarBackBtn.enabled = [self.webV canGoBack] ?  TRUE :FALSE;
    self.toolBarForwardBtn.enabled = [self.webV canGoForward] ?  TRUE :FALSE;
}

- (void)viewDidUnload {
    [self setWebV:nil];
    [self setToolBar:nil];

    [super viewDidUnload];
}

- (IBAction)backClick:(id)sender {
    [self.webV goBack];
    [self refreshToolBar];
}

- (IBAction)forwardClick:(id)sender {
    [self.webV goForward];
    [self refreshToolBar];
}

- (IBAction)refreshClick:(id)sender {
    [self.webV reload];
    [self refreshToolBar];
}

- (IBAction)closeClick:(id)sender {
    [super goback];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    //    NSLog(@"handle touch");
    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{

    return YES;
    
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    //    NSLog(@"2");
    return YES;
}

- (BOOL)webView:(UIWebView *)webview shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [self refreshToolBar];
    return YES;
}
@end
