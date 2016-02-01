//
//  DateModel.h
//  OpenCloud
//
//  Created by 王亮 on 15/7/18.
//  Copyright (c) 2015年 colin liao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateModel : NSObject

//时间戳转化为时间字符串
+ (NSString *)dateInvertToDateStr:(NSString *)timeStr;

@end
