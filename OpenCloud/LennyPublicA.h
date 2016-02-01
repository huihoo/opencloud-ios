//
//  LennyPublicA.h
//  Mallike
//
//  Created by wangliang on 15/4/18.
//  Copyright (c) 2015年 wangliang. All rights reserved.
//

#ifndef Mallike_LennyPublicA_h
#define Mallike_LennyPublicA_h

#import "UpYunHttpRequest.h"

#define User_Info @"userInfo"
#define User_Email @"userEmail"
#define User_Pwd @"UserPwd"
#define NullToEmpty(key) ([key isKindOfClass:[NSNull class]] ?  @"" : key)
#define Home_Back_color WLColor(235,235,235)

#define DefualtImage ([UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"3" ofType:@"jpg"]])

#define K_LoginIn @"loginIn"

#endif
