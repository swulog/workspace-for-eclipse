//
//  CommonFunction.h
//  GK
//
//  Created by W.S. on 13-7-26.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config.h"
#ifdef CORE_TEXT
#import <CoreText/CoreText.h>
#endif
#pragma mark - normarl c function define

BOOL checkPWD(NSString* _pwd);
BOOL checkID(NSString* _id);
BOOL checkDigit(NSString *str);
BOOL checkMobileNo(NSString* _id);
BOOL checkPhoneNo(NSString* _id);
BOOL checkLocPhoneNo(NSString *_id);
BOOL check400PhoneNo(NSString* _id);

NSString* getHost(NSString* url);
NSString* getPath(NSString* url);

UIImage* resizeImage(UIImage* image ,CGSize newSize );

NSString* upcaseHeadLetter(NSString* str);
float distanceBetween(float lat1,float long1,float lat2,float long2);

NSDate* dateFromString(NSString *dateString);
NSString* transtoChinaDateStr(NSString* inputDateStr,NSString *seprator);
NSString* transDatetoChinaDateStr(NSDate* date);
NSString* transDateToFormatStr(NSDate *date,NSString *format);
NSDate* dateFromChinaDateString(NSString *dateString);
#ifdef CORE_TEXT
CTFontRef CTFontCreateFromUIFont(UIFont *font);
#endif