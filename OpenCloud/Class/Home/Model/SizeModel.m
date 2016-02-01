//
//  SizeModel.m
//  OpenCloud
//
//  Created by 王亮 on 15/7/18.
//  Copyright (c) 2015年 colin liao. All rights reserved.
//

#import "SizeModel.h"

@implementation SizeModel

//根据str值转化为计算的大小
+ (NSString *)sizeBOfString:(NSString *)sizeStr {
    
    double size = sizeStr.doubleValue;
    NSString *uint = @"B";
    //B
    size = size;
    //KB
    if (size >= 1024) {
        
        size /= 1024;
        uint = @"KB";
    }
    
    //MB
    if (size >= 1024) {
        
        size /= 1024;
        uint = @"MB";
    }
    
    //GB
    if (size >= 1024) {
        
        size /= 1024;
        uint = @"GB";
    }
    
    //TB
    if (size >= 1024) {
        
        size /= 1024;
        uint = @"TB";
    }
    
    NSString *newSizeStr = nil;
    if ([uint isEqual:@"B"] || [uint isEqual:@"KB"]) {
        
        newSizeStr = [NSString stringWithFormat:@"%0.0f%@",size,uint];
    }else {
        
        newSizeStr = [NSString stringWithFormat:@"%0.2f%@",size,uint];
    }
    return newSizeStr;
}

@end
