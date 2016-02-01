//
//  LennyPublic.h
//  cakeShop
//
//  Created by wangliang on 15/1/13.
//  Copyright (c) 2015年 John. All rights reserved.
//

#ifndef cakeShop_LennyPublic_h
#define cakeShop_LennyPublic_h


//设备屏尺寸
#define IOS_IPHONE_WINDOW_FRAME ([[UIScreen mainScreen] bounds])
//设备宽度
#define IOS_IPHONE_WINDOW_WIDE (IOS_IPHONE_WINDOW_FRAME.size.width)
//设备高度
#define IOS_IPHONE_WINDOW_HIGH (IOS_IPHONE_WINDOW_FRAME.size.height)


#define WL_XIB(string) ([[[NSBundle mainBundle] loadNibNamed:string owner:nil options:nil] lastObject])
#define WL_NIB(key) ([UINib nibWithNibName:key bundle:nil])

#define LOAD_IMAGE(string) [UIImage imageWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForAuxiliaryExecutable:string]]]

#define WLColor(r,g,b) ([UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1])
#define All_BackGroundColor WLColor(39,38,54)
#define All_LogInBackGroundColor WLColor(192,192,192);
#define All_CarBackGroundColor WLColor(235,235,235);

//首页标题栏
#define Side_Wide (250)

//常量
#define KSessionID  @"sessionId"
#define kSuccess @"SUCCESS"
#define kMethod @"method"
#define KMessage @"message"
#define KError @"error"


#ifdef DEBUG
#define WLLog(...) NSLog(__VA_ARGS__)
#else
#define WLLOG(...)
#endif

typedef enum
{
    ViewControllerCutType_Default = 0,
    ViewControllerCutType_DisMiss = 1,
    ViewControllerCutType_Push = 2,
    ViewControllerCutType_PopRoot = 3,
    ViewControllerCutType_Pop = 4,
    
} ViewControllerCutType;

#define kRateWide (IOS_IPHONE_WINDOW_WIDE-20)
#define kRate ((IOS_IPHONE_WINDOW_WIDE-20)/300)

#endif
