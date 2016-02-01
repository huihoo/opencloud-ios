//
//  SizeModel.h
//  OpenCloud
//
//  Created by 王亮 on 15/7/18.
//  Copyright (c) 2015年 colin liao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SizeModel : NSObject

//根据str值转化为计算的大小
+ (NSString *)sizeBOfString:(NSString *)sizeStr;
@end
