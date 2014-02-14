//
//  GS_GlobalObject.m
//  GS
//
//  Created by W.S. on 13-6-8.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "GS_GlobalObject.h"
#import "DataBaseClient.h"
#import "MobClick.h"



NSCondition *iCondition;

@implementation GS_GlobalObject

+(GS_GlobalObject*)GS_GObject{
    static id shareSigleton = nil;
    
    @synchronized(self){
        if (shareSigleton == nil) {
            shareSigleton = [[self alloc] init];
        }
    }
    
    return shareSigleton;
}

-(void)initAPP
{
    if (isSimulator) {
        [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:REALTIME channelId: @"MACTEST"];
    } else {
#ifdef TEST_PHASE
        [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:REALTIME channelId: @"IPHONETEST"];
#else
        [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:REALTIME channelId: @"App Store"];
#endif
    }
    [self checkAppVersionForAppStore];
    [self checkCacheVersion];
    [self checkCachePeriod];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logonOK:) name:NOTIFICATION_LOGON_OK object:nil];

    NSString *gsId = [[NSUserDefaults standardUserDefaults] stringForKey:@"LastUser"];
        
    if (gsId) {
        self.ownIdInfo = [GSLogonService getUserInfo:gsId];
        
        if (self.ownIdInfo) {
            NSThread *timer = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
            [timer start];
            [NSThread detachNewThreadSelector:@selector(logon) toTarget:self withObject:nil];
            
            iCondition = [[NSCondition alloc] init];
            [iCondition lock];
            [iCondition wait];
            [iCondition unlock];
            iCondition = nil;
            
#if 0
            [GSLogonService logon:self.ownIdInfo.gsId pwd:self.ownIdInfo.gspwd  succ:^(NSObject* obj){
                NSLog(@"GLOBAL LOGON OK");
                
            } fail:^(NSError *err){
                self.ownIdInfo = nil;
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGON_FAIL object:nil];
            }];
#endif
        }
    }
    
    [self getSorts:nil];
}

-(void)wakeUp
{
    if (iCondition) {
        [iCondition lock];
        [iCondition signal];
        [iCondition unlock];
    }
}

-(void)run
{
    sleep(2);
    [self wakeUp];
}

-(void)logon{
    
    NSURL *url = [NSURL URLWithString:GS_LOGON_URL];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSString *base64EncodedString = [[[NSString stringWithFormat:@"%@:%@", self.ownIdInfo.gsId , self.ownIdInfo.gspwd] dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
    [request setValue:[NSString stringWithFormat:@"%@ %@", @"Basic", base64EncodedString]
        forHTTPHeaderField:@"Authorization"];
    
    NSError *err = nil;;
    NSURLResponse *response = nil;
    NSData *data  = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    BOOL logonOK = FALSE;
    if (!err && response) {
            int statusCode = [(NSHTTPURLResponse *)response statusCode];
            if ((statusCode > 199) && (statusCode < 299) && (data != nil)) logonOK = TRUE;
    }
        

    if (logonOK) {
        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        GSIDInfo *idinfo = [[GSIDInfo alloc] init];
        [idinfo Deserialize:(NSDictionary*)resDict coustom:nil];
        idinfo.gsId = self.ownIdInfo.gsId;
        idinfo.gspwd = self.ownIdInfo.gspwd;
        
        [GSLogonService saveUserInfo:idinfo];
        
        if (self.ownIdInfo.exist) {
            [[NSUserDefaults standardUserDefaults] setValue:idinfo.gsId forKeyPath:@"LastUser"];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGON_OK object:idinfo];
    }else {
        self.ownIdInfo = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGON_FAIL object:nil];
    }
    [self wakeUp];

}



-(void)logonOK:(NSNotification*)notification
{
    GSIDInfo *obj = (GSIDInfo*)notification.object;

    obj.hasLogoned = TRUE;
    self.ownIdInfo = obj;
    
    //if(!self.gToken)
    {
        [GSLogonService getToken:self.ownIdInfo.gsId pwd:self.ownIdInfo.gspwd succ:^(NSObject* obj){
            self.gToken =  (NSString*)obj;
        } fail:nil];
    }
}
////////////////////////////////////////////////
////////////////////////////////////////////////
+(BOOL)getGPSLocWithAddress:(NSString*)addrStr succ:(NillBlock_OBJ)succCallback fail:(NillBlock_Error)failCallback
{
    return  [[GS_GlobalObject GS_GObject] getLocationXYWithBaidu:addrStr succ:^(NSObject *obj){
        
#if 1
        SAFE_BLOCK_CALL(succCallback, obj);
#else
        
        [[GS_GlobalObject GS_GObject] tranformWithBM:loc toBM:FALSE success:^(NSObject *obj){
            CLLocation *gpsLoc = (CLLocation*)obj;
            SAFE_BLOCK_CALL(succCallback, gpsLoc);
        }fail:^(NSError *err){
            NSLog(@"TransBMCo Fail:%@",err.localizedDescription);
            SAFE_BLOCK_CALL(failCallback, err);
        }];
#endif
    }fail:^(NSError *err){
        SAFE_BLOCK_CALL(failCallback, err);
    }];
}

+(BOOL)getBaiduLocation:(NillBlock_OBJ)succCallback fail:(NillBlock_Error)failCallback
{
    BOOL ret = FALSE;
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus]!= kCLAuthorizationStatusDenied)
    {
        ret = TRUE;
        
        [[GS_GlobalObject GS_GObject] getCurrentLocation:^(NSObject *obj){
            CLLocation *loc = (CLLocation*)obj;
            [[GS_GlobalObject GS_GObject] getBaiduPosition:loc succ:^(NSObject *obj){
                CLLocation *baiduloc = (CLLocation*)obj;
                [[GS_GlobalObject GS_GObject] getLocationStrWithBaidu:baiduloc succ:^(NSObject *obj){
                    BMKAddrInfo *bmkAddr = (BMKAddrInfo*)obj;
                    SAFE_BLOCK_CALL(succCallback, bmkAddr);
//                    NSString *strAddr = (NSString*)obj;
//                    BMKAddrInfo *addr = [[BMKAddrInfo alloc] init];
//                    CLLocationCoordinate2D geopt = {baiduloc.coordinate.latitude,baiduloc.coordinate.longitude};
//                    addr.geoPt = geopt;
//                    addr.strAddr = strAddr;
//                    SAFE_BLOCK_CALL(succCallback, addr);
                }fail:failCallback];
            }fail:failCallback];
            
        }fail:failCallback];
    
    }
    
    return ret;
}

+(void)showCurentLocInsideMap:(UIViewController*)_pvc title:(NSString*)_title enabledSave:(Boolean)_showSave
{
    [[GS_GlobalObject GS_GObject] getCurrentLocation:^(NSObject *obj){
         CLLocation *loc = (CLLocation*)obj;
         [GS_GlobalObject GS_GObject].curLoc = loc;
        [[GS_GlobalObject GS_GObject] getBaiduPosition:loc succ:^(NSObject *obj){
            [[GS_GlobalObject GS_GObject] pushOwnPositionInsideMap:(CLLocation*)obj gpsLoc:loc in:_pvc title:_title enabledSave:_showSave];
        } fail:nil];
    }fail:^(NSError *err){
        
    }];
}

////////////////////////////////////////////////
////////////////////////////////////////////////
-(NSInteger)getSortIndex:(NSString*)sortid
{
    NSInteger ret = 0;
    if (self.sortArray) {
        int index =0;
        for (StoreSort *sort in self.sortArray) {
            if ([sort.id isEqualToString:sortid]) {
                return index;
            }
            index++;
        }
    }
    return ret;

}

-(NSInteger)getSortIndexWithName:(NSString *)sortName
{
    NSInteger ret = 0;
    if (self.sortArray) {
        int index =0;
        for (StoreSort *sort in self.sortArray) {
            if ([sort.name isEqualToString:sortName]) {
                return index;
            }
            index++;
        }
    }
    return ret;
}

-(NSString*)getSortID:(NSString*)sortName
{
    NSString *ret = nil;
    if (self.sortArray) {
        for (StoreSort *sort in self.sortArray) {
            if ([sort.name isEqualToString:sortName]) {
                return sort.id;
            }
        }
    }
    return ret;
}

-(NSString*)getSortName:(NSString*)sortid
{
    NSString *ret = nil;
    if (self.sortArray) {
        
        for (StoreSort *sort in self.sortArray) {
            if ([sort.id isEqualToString:sortid]) {
                ret =  sort.name;
            }
        }
    }
    return ret;
}

-(NSArray*)getSorts:(NillBlock_Array)updateBlock
{
    NSArray *retArray = self.sortArray;
    
    if (!self.sortArray && !self.isGetSort) {
        self.isGetSort = TRUE;
        self.sortArray = [GSStoreService getStoreSort:FALSE succ:^(NSObject *obj){
            self.isGetSort = FALSE;

            self.sortArray = (NSArray*)obj;
            SAFE_BLOCK_CALL(updateBlock, self.sortArray);
        }fail:^(NSError *err){
            self.isGetSort = FALSE;

            [GS_GlobalObject showPopup:err.localizedDescription];
        }];
    }
    return  retArray;
}

-(void)checkAppVersionForAppStore
{

    [GSLogonService GetAppInfo:^(NSObject *obj) {
        AppInfo *appinfo = (AppInfo*)obj;
        NSString *curVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        
        if ([curVersion compare:appinfo.storeVersion] < NSOrderedSame) {
        
      //  if (![curVersion isEqualToString:appinfo.storeVersion]) {
            NSString *updateContent =[NSString stringWithFormat:@"检测到新版本%@，为了您更好的使用体验，请尽快升级到新版本",appinfo.storeVersion];
            UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle:@"有新版本了!"
                                                          message:updateContent
                                                         delegate:self       //委托给Self，才会执行上面的调用
                                                cancelButtonTitle:@"以后再说"
                                                otherButtonTitles:@"马上更新",nil];
            [updateAlert show];
        }
    } fail:nil];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

-(void)checkCacheVersion
{
    NSString *old = [[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentDBVersion"];
    NSString *lowestVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Supported Lowest Version"];
    NSString *new = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    BOOL needClearDb = FALSE;
    if (old && lowestVersion) {
        if([old compare:lowestVersion] < 0){
            needClearDb = TRUE;
        }
    } else if(!old){
        needClearDb = TRUE;
    }
    
    if (needClearDb) {
        [DataBaseClient clearDB];
        [[NSUserDefaults standardUserDefaults] setValue:new forKey:@"CurrentDBVersion"];
    }
    
}

-(void)checkCachePeriod
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *string = [formatter stringFromDate:date];
    //cache time tag
    NSDate *curDate = date;
    NSString *lastCacheDate = [[NSUserDefaults standardUserDefaults] stringForKey:@"LastCacheDate"];
    if (lastCacheDate) {
        NSDate *lastDate = dateFromString(lastCacheDate);
        NSTimeInterval period =   GSCACHE_EXPIRD_PERIOD * 60 * 60;
        NSDate *delDate = [lastDate dateByAddingTimeInterval:period];
        if ([curDate compare:delDate] >= NSOrderedSame) {
            [[NSUserDefaults standardUserDefaults] setValue:string  forKey:@"LastCacheDate"];
            [DataBaseClient clearDB];
        }
    } else {
        [[NSUserDefaults standardUserDefaults] setValue:string  forKey:@"LastCacheDate"];
    }
}

#pragma mark -
#pragma mark alert delegate -
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:  //确定
        {
            NSURL *url = [NSURL URLWithString:APP_DOWNLOAD_URL];
            [[UIApplication sharedApplication] openURL:url];
            
            break;
        }
        default:
            break;
    }
}
@end
