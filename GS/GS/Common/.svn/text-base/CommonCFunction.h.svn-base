//
//  CommonCFunction.h
//  GS
//
//  Created by W.S. on 13-6-7.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#ifndef __GS__CommonCFunction__
#define __GS__CommonCFunction__

NSError* WSErrorWithCode(NSInteger errcode);

BOOL checkPWD(NSString* _pwd);
BOOL checkID(NSString* _id);
BOOL checkDigit(NSString *str);
BOOL checkMobileNo(NSString* _id);
BOOL checkPhoneNo(NSString* _id);
BOOL check400PhoneNo(NSString* _id);
BOOL check800PhoneNo(NSString* _id);


NSString* getHost(NSString* url);
NSString* getPath(NSString* url);

UIImage* resizeImage(UIImage* image ,CGSize newSize );

NSString* upcaseHeadLetter(NSString* str);
NSString* transtoChinaDateStr(NSString* inputDateStr,NSString *seprator);
NSString* transDatetoChinaDateStr(NSDate* date);
NSString* transfromChinaDateStr(NSString* inputDateStr,NSString *seprator);
NSDate* dateFromString(NSString *dateString);
NSDate* dateFromChinaDateString(NSString *dateString);
#endif /* defined(__GS__CommonCFunction__) */
