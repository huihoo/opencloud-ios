//
//  UpYunHttpRequest.h
//  YouPaiDemo
//
//  Created by 王亮 on 15/7/17.
//  Copyright (c) 2015年 王亮. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Success)(id info);
typedef void(^Failure)(NSError *error);

@interface UpYunHttpRequest : NSObject

//获取root所有文件
+ (void)getRootFileSuccess:(Success)success Failure:(Failure)failure;

//创建目录
+ (void)createFloderSuccess:(Success)success Failure:(Failure)failure;

//删除指定文件
+ (void)deleteFileWithDic:(NSDictionary *)dic Success:(Success)success Failure:(Failure)failure;

@end
