//
//  DateModel.m
//  OpenCloud
//
//  Created by 王亮 on 15/7/18.
//  Copyright (c) 2015年 colin liao. All rights reserved.
//

#import "DateModel.h"

@implementation DateModel

//时间戳转化为时间字符串
+ (NSString *)dateInvertToDateStr:(NSString *)timeStr {
    
    double lastactivityInterval = [timeStr doubleValue];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH：mm"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:lastactivityInterval];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

@end
