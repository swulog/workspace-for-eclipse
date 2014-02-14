//
//  CommonFunction.m
//  GK
//
//  Created by W.S. on 13-7-26.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "CommonFunction.h"

#import "Constants.h"


#pragma mark -
#pragma mark check format function

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

BOOL checkLocPhoneNo(NSString *_id)
{
    BOOL ret = FALSE;
    NSString *regex =  @"^(([0-9]{7})|(([0-9]{8})))$";
    
    
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
#include "math.h"
float distanceBetween(float lat1,float long1,float lat2,float long2)
{
    int MAXITERS = 20;
    // Convert lat/long to radians
    
    lat1 *= M_PI / 180.0;
    lat2 *= M_PI / 180.0;
    long1 *= M_PI / 180.0;
    long2 *= M_PI / 180.0;
    
    double a = 6378137.0; // WGS84 major axis
    double b = 6356752.3142; // WGS84 semi-major axis
    double f = (a - b) / a;
    double aSqMinusBSqOverBSq = (a * a - b * b) / (b * b);
    
    double L = long2 - long1;
    double A = 0.0;
    double U1 = atan((1.0 - f) * tan(lat1));
    double U2 =atan((1.0 - f) * tan(lat2));
    
    double cosU1 = cos(U1);
    double cosU2 = cos(U2);
    double sinU1 = sin(U1);
    double sinU2 = sin(U2);
    double cosU1cosU2 = cosU1 * cosU2;
    double sinU1sinU2 = sinU1 * sinU2;
    
    double sigma = 0.0;
    double deltaSigma = 0.0;
    double cosSqAlpha = 0.0;
    double cos2SM = 0.0;
    double cosSigma = 0.0;
    double sinSigma = 0.0;
    double cosLambda = 0.0;
    double sinLambda = 0.0;
    
    double lambda = L; // initial guess
    for (int iter = 0; iter < MAXITERS; iter++) {
        double lambdaOrig = lambda;
        cosLambda = cos(lambda);
        sinLambda = sin(lambda);
        double t1 = cosU2 * sinLambda;
        double t2 = cosU1 * sinU2 - sinU1 * cosU2 * cosLambda;
        double sinSqSigma = t1 * t1 + t2 * t2; // (14)
        sinSigma = sqrt(sinSqSigma);
        cosSigma = sinU1sinU2 + cosU1cosU2 * cosLambda; // (15)
        sigma = atan2(sinSigma, cosSigma); // (16)
        double sinAlpha = (sinSigma == 0) ? 0.0 :
        cosU1cosU2 * sinLambda / sinSigma; // (17)
        cosSqAlpha = 1.0 - sinAlpha * sinAlpha;
        cos2SM = (cosSqAlpha == 0) ? 0.0 :
        cosSigma - 2.0 * sinU1sinU2 / cosSqAlpha; // (18)
        
        double uSquared = cosSqAlpha * aSqMinusBSqOverBSq; // defn
        A = 1 + (uSquared / 16384.0) * // (3)
        (4096.0 + uSquared *
         (-768 + uSquared * (320.0 - 175.0 * uSquared)));
        double B = (uSquared / 1024.0) * // (4)
        (256.0 + uSquared *
         (-128.0 + uSquared * (74.0 - 47.0 * uSquared)));
        double C = (f / 16.0) *
        cosSqAlpha *
        (4.0 + f * (4.0 - 3.0 * cosSqAlpha)); // (10)
        double cos2SMSq = cos2SM * cos2SM;
        deltaSigma = B * sinSigma * // (6)
        (cos2SM + (B / 4.0) *
         (cosSigma * (-1.0 + 2.0 * cos2SMSq) -
          (B / 6.0) * cos2SM *
          (-3.0 + 4.0 * sinSigma * sinSigma) *
          (-3.0 + 4.0 * cos2SMSq)));
        
        lambda = L +
        (1.0 - C) * f * sinAlpha *
        (sigma + C * sinSigma *
         (cos2SM + C * cosSigma *
          (-1.0 + 2.0 * cos2SM * cos2SM))); // (11)
        
        double delta = (lambda - lambdaOrig) / lambda;
        if (abs(delta) < 1.0e-12) {
            break;
        }
    }
    
    float distance = (float) (b * A * (sigma - deltaSigma));
    return distance;
}


#pragma mark -date  trans fujnction
#pragma mark -

NSDate* dateFromString(NSString *dateString){
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
 //   NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
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

NSString* transDateToFormatStr(NSDate *date,NSString *format){
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [formatter setLocale:locale];
    NSString *string = [formatter stringFromDate:date];
    
    int length = string.length;
    int dateValue[3];
    
    NSString *sepatorStr[3];
    if (IOS_VERSION >= 7.0) {
        sepatorStr[0] = @"年";
        sepatorStr[1] = @"月";
        sepatorStr[2] = @"日";
    } else {
        sepatorStr[0] = sepatorStr[1] = sepatorStr[2] = @"-";
    }
    
    NSRange range = {0,length};
    for (int k = 0; k < 3; k++) {
        string = [string substringWithRange:range];
        NSRange destrange = [string rangeOfString:sepatorStr[k]];
        if (destrange.length>0) {
            destrange.length = destrange.location;
            destrange.location = 0;
            dateValue[k] = [[string substringWithRange:destrange] intValue];
            range.location = destrange.location+destrange.length+[sepatorStr[k] length];
            range.length = [string length] - range.location;
        } else {
            dateValue[k] = [string intValue];
        }
    }
    
    if ([[format lowercaseString] isEqualToString:@"yyyymmdd"]) {
        return [NSString stringWithFormat:@"%04d%02d%02d",dateValue[0],dateValue[1],dateValue[2]];
    } else if([[format lowercaseString] isEqualToString:@"yyyy-mm-dd"]){
        return [NSString stringWithFormat:@"%04d-%02d-%02d",dateValue[0],dateValue[1],dateValue[2]];
    } else {
        return nil;
    }
    
}
NSDate* dateFromChinaDateString(NSString *dateString){
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy年M月dd日"];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
}
#ifdef CORE_TEXT
CTFontRef CTFontCreateFromUIFont(UIFont *font)
{
    CTFontRef ctFont =CTFontCreateWithName((__bridge CFStringRef)font.fontName,
                                           font.pointSize,
                                           NULL);
    return ctFont;
}
#endif

