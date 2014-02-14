//
//  AppConstans.c
//  GS
//
//  Created by W.S. on 13-6-4.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#import "AppConstans.h"
#import <UIKit/UIKit.h>


const char* WS_ErrorDesc[] = {
    "网络获取失败，请检查网络或稍后再试",
    "Sorry，数据错误，请尝试重新操作",
    "数据类型不匹配或者数据为空", //此错误一般须要程序吸收掉，勿显示给用户
    "未知错误",
    "该手机号已注册！",//"注册失败，请检查手机号或者稍候再试",
    "获取位置信息失败",
    "用户名或者密码错误，请重新输入",
    "坐标越界",
    "百度地图服务失败",
    "验证码错误"
};

int WSLineBreakModeWordWrap()
{
    if (IOS_VERSION > 6.0) {
        return NSLineBreakByWordWrapping;
    } else {
        return UILineBreakModeWordWrap;
    }
}

int WSTextAlignmentLeft()
{
    if (IOS_VERSION > 6.0) {
        return NSTextAlignmentLeft;
    } else {
        return UITextAlignmentLeft;
    }
}

void showModalViewCtroller(UIViewController* pvc, UIViewController* vc, BOOL animated)
{
    if (IOS_VERSION>=6.0) {
        [pvc presentViewController:vc animated:animated completion:nil];
    } else {
        [pvc presentModalViewController:vc animated:animated];
    }
}