//
//  ConvertFuncForIOSVer.c
//  GK
//
//  Created by W.S. on 13-10-14.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#include <stdio.h>
#import <UIKit/UIKit.h>
#import "Constants.h"
#import "ReferemceList.h"

UIImage* NavBg()
{
//    if (IOS_VERSION >= 7.0) return [UIImage imageNamed:NavBarBg_IOS7];
//    return [UIImage imageNamed:NavBarBg_CIOS];
    
    return [UIImage imageNamed:NavBarBg_IOS7];
}