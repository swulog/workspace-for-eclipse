//
//  Constans.c
//  GK
//
//  Created by W.S. on 13-5-30.
//  Copyright (c) 2013年 JinSuanPan. All rights reserved.
//

#include <stdio.h>
#include "Config.h"

const char* ErrorDesc[] = {
    "网络获取失败，请检查网络或稍后再试",
    "Sorry，数据错误，请尝试重新操作",
    "数据类型不匹配或者数据为空", //此错误一般须要程序吸收掉，勿显示给用户
    "未知错误",
    "注册失败，请稍后再试",
    "获取位置信息失败",
    "用户名或者密码错误，请重新输入",
    "该手机号已注册！",
    "校验码错误",
    "您已经关注过了!",
    "网络异常，请尝试刷新数据"
};


//char *STORE_SORT_EN[] = {"CanYin","YuLe","YunDong","ShengHuo","GouWu","More"};
int StoreSortIndex[]    ={StoreSort_CANYIN,StoreSort_GOUWU,StoreSort_YULE,StoreSort_SHENGHUO,StoreSort_YUNDONG};
char *STORE_SORT[StoreTopSortNum]      = {"餐饮美食","时尚购物","娱乐休闲","生活服务","运动健身"};
char *StoreSortIcon[]   = {"HP_CanYinMenuIcon","HP_GouWuMenuIcon","HP_YuLeMenuIcon","HP_ShengHuoMenuIcon","HP_YunDongMenuIcon"};

char *StoreList_Option[] = {"默认排序","最新发布","使用最多","好评最多"};
char *NearStoreList_Option[] = {"离我最近","最新发布","使用最多"};

//char *NearStoreList_DistanceOption[] = {"范围500米","范围1千米","范围3千米","全部"};
int NearStoreList_DistanceScope[] = {500,1000,3000,10000};
//char *tabTitles[GKTabItemCount] = {"首页","附近","享优惠","享网购","我的"};

//char *tabImgNames[GKTabItemCount] = {"tab_home","tab_fujin","tab_youhui","tab_tb","tab_owner"};
char *tabImgNames[GKTabItemCount] = {"HP_HomeIcon","HP_NearIcon","HP_XWGIcon","HP_RecommondIcon","HP_OwnerIcon"};

int getSortIndex(StoreTopSort sort)
{
    int ret  = 0;
    int count = sizeof(StoreSortIndex)/sizeof(StoreSortIndex[0]);
    for (; ret < count; ret++) {
        if (StoreSortIndex[ret] == sort) {
            break;
        }
    }
    return ret;
}