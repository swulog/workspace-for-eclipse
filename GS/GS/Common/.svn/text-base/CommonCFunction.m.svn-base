//
//  CommonCFunction.cpp
//  GS
//
//  Created by W.S. on 13-6-7.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#include "CommonCFunction.h"
#import "AppHeader.h"


NSError* WSErrorWithCode(NSInteger errcode)
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithUTF8String:WS_ErrorDesc[errcode]], NSLocalizedDescriptionKey, nil];

    return [NSError errorWithDomain:WS_ErrorDomain code:errcode + WS_ErrorDomainStart userInfo:userInfo];
}


BOOL checkPWD(NSString* _pwd)
{
    BOOL ret = FALSE;
    NSString *regex =  @"(^[A-Za-z0-9]{6,12}$)";
    if (_pwd) {
        NSPredicate * pred  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        ret = [pred evaluateWithObject:_pwd];
    }
    return  ret;
}

BOOL checkPhoneNo(NSString* _id)
{
    BOOL ret = FALSE;
    NSString *regex =  @"^((\\+86)|(\\(\\+86\\)))?\\D?((((010|021|022|023|024|025|026|027|028|029|852)|(\\(010\\)|\\(021\\)|\\(022\\)|\\(023\\)|\\(024\\)|\\(025\\)|\\(026\\)|\\(027\\)|\\(028\\)|\\(029\\)|\\(852\\)))\\D?\\d{8}|((0[3-9][1-9]{2})|(\\(0[3-9][1-9]{2}\\)))\\D?\\d{7,8}))(\\D?\\d{1,4})?$";
    
    if (_id) {
        NSPredicate * pred  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        ret = [pred evaluateWithObject:_id];
    }
    return  ret;
    
}

BOOL check400PhoneNo(NSString* _id)
{
    BOOL ret = FALSE;
    NSString *regex =  @"^400[016789]\\d{6}$";
    
    if (_id) {
        NSPredicate * pred  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        ret = [pred evaluateWithObject:_id];
    }
    return  ret;
}
BOOL check800PhoneNo(NSString* _id)
{
    BOOL ret = FALSE;
    NSString *regex =  @"^800\\d{7}$";
    
    if (_id) {
        NSPredicate * pred  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        ret = [pred evaluateWithObject:_id];
    }
    return  ret;
}

BOOL checkMobileNo(NSString* _id)
{
    BOOL ret = FALSE;
    NSString *regex =  @"^(\\+86|(\\(\\+86\\)))?(((13[0-9]{1})|(15[0-9]{1})|(18[0-9]{1}))+[0-9]{8})$";
    
    
    if (_id) {
        NSPredicate * pred  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        ret = [pred evaluateWithObject:_id];
    }
    return  ret;
}
BOOL checkID(NSString* _id)
{
    BOOL ret = FALSE;
    NSString *regex =  @"(^[a-zA-Z0-9_\u4e00-\u9fa5]{2,16}$)";
    
    
    if (_id) {
        NSPredicate * pred  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        ret = [pred evaluateWithObject:_id];
    }
    return  ret;
}

BOOL checkDigit(NSString *str)
{
    const char* utf8Str = str.UTF8String;
    for (int k = 0; k < str.length ; k++) {
        if(!(utf8Str[k]>='0'&&utf8Str[k]<='9'))    return false;
    }
    
    return true;
    
}


#pragma mark - url function
NSString* getHost(NSString* url)
{
    assert([url hasPrefix:@"http://"]);
    
    NSString* str = [url substringFromIndex:7];
    NSRange range = [str rangeOfString:@"/"];
    str = [str substringToIndex:range.location];
    
    return str;
    
}

NSString* getPath(NSString* url)
{
    assert([url hasPrefix:@"http://"]);
    
    NSString* str = [url substringFromIndex:7];
    NSRange range = [str rangeOfString:@"/"];
    
    str = [str substringFromIndex:range.location+1];
    return str;
}

UIImage* resizeImage(UIImage* image ,CGSize newSize )
{
    UIGraphicsBeginImageContext( newSize );
	[image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}

NSString* upcaseHeadLetter(NSString* str)
{
    if (!str || str.length == 0) {
        return nil;
    }
    
    NSString *uStr =  str.uppercaseString;
    
    NSMutableString *retStr = [NSMutableString stringWithCapacity:str.length];
    [retStr appendString:[uStr substringToIndex:1]];
    [retStr appendString:[str substringFromIndex:1]];
    return retStr;
}

NSString* transDatetoChinaDateStr(NSDate* date)
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [formatter setLocale:locale];
    NSString *string = [formatter stringFromDate:date];
    
    if (IOS_VERSION >= 7.0) {
        return string;
    } else {
        return transtoChinaDateStr(string, @"-");
    }
}

NSString* transtoChinaDateStr(NSString* inputDateStr,NSString *seprator)
{
    NSMutableString *retStr =  [[NSMutableString alloc] initWithString:inputDateStr];
    [retStr replaceCharactersInRange: NSMakeRange(4, 1) withString:@"年"];
    NSRange range = [retStr rangeOfString:seprator];
    [retStr replaceCharactersInRange: range withString:@"月"];
    [retStr appendString:@"日"];
    
    return  retStr;

}

NSString* transfromChinaDateStr(NSString* inputDateStr,NSString *seprator)
{
    NSMutableString *retStr =  [[NSMutableString alloc] initWithString:inputDateStr];
    NSRange range = [retStr rangeOfString:@"年"];
    [retStr replaceCharactersInRange:range withString:seprator];
    range = [retStr rangeOfString:@"月"];
    [retStr replaceCharactersInRange: range withString:seprator];
    range =     [retStr rangeOfString:@"日"];
   return [retStr substringToIndex:range.location];

}

NSDate* dateFromString(NSString *dateString){
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
}

NSDate* dateFromChinaDateString(NSString *dateString){
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy年M月dd日"];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
}
