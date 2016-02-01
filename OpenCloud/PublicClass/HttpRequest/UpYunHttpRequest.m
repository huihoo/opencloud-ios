//
//  UpYunHttpRequest.m
//  YouPaiDemo
//
//  Created by 王亮 on 15/7/17.
//  Copyright (c) 2015年 王亮. All rights reserved.
//

#import "UpYunHttpRequest.h"

#import "MF_Base64Additions.h"
#import "NSData+MD5Digest.h"
#import "AFNetworking.h"
#import "NSData+Utils.h"

static NSString * UpYunAPI_SERVER = @"http://v0.api.upyun.com/";//基本url
//static NSString * UpYunAPI_bucket = @"colinimages";//又拍云的空间名
//static NSString * UpYunAPI_password = @"itez6hPAeoSOFfxR/c5NXILz18E=";//私密
//static NSString * UpYunAPI_operator = @"colin";//操作员
//static NSString * UpYunAPI_operatorPassword = @"colinliao";//操作员秘密

static NSString * UpYunAPI_bucket = @"lennytest2";//又拍云的空间名
static NSString * UpYunAPI_password = @"a/V3fe3x4lo0DviU1Xgu+N8h3+Y=";//私密
static NSString * UpYunAPI_operator = @"lenny";//操作员
static NSString * UpYunAPI_operatorPassword = @"12345678a";//操作员秘密

#define DATE_STRING(expiresIn) [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970] + expiresIn]

@implementation UpYunHttpRequest

//获取当前的GMT格式时间
+ (NSString *)getNowGMTTime {
    
    //Wed, 29 Oct 2014 02:26:58 GMT
    NSDate *  aDate=[NSDate date];
    NSDateFormatter *dateFormater=[[NSDateFormatter alloc] init];
    [dateFormater setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"EN_US"]];
    [dateFormater setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss ZZZZ"];//需转换的格式
    NSMutableString *dateStr = [[dateFormater stringFromDate:aDate] copy];
    return dateStr;
}

//获取授权信息
+ (NSString *)getAuthorization:(NSString* )timeStr withPath:(NSString *)path withState:(NSString *)state{
    
    NSMutableString *str = [NSMutableString string];
    [str appendString:[NSString stringWithFormat:@"%@&",state]];
    
    NSString *urlStr =[NSString stringWithFormat:@"/%@/",UpYunAPI_bucket];
    if (![path isEqual:@""] && path) {
        urlStr = [NSString stringWithFormat:@"%@%@/",urlStr,path];
    }
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [str appendString:[NSString stringWithFormat:@"%@&",urlStr]];
    [str appendString:timeStr];
    if ([state isEqual:@"GET"]) {
        
        [str appendString:@"&0&"];
    }else if ([state isEqual:@"PUT"] || [state isEqual:@"POST"]){
        
        [str appendString:@"&1&"];
    }else {
        
        [str appendString:@"&"];
    }
    NSString *password = UpYunAPI_operatorPassword;
    NSString *passwordMD5 = [[[password dataUsingEncoding:NSUTF8StringEncoding] MD5HexDigest] lowercaseString];
    [str appendString:passwordMD5];
    
    return [[[str dataUsingEncoding:NSUTF8StringEncoding] MD5HexDigest] lowercaseString];
}


//获取root所有文件
+ (void)getRootFileSuccess:(Success)success Failure:(Failure)failure {
    
    NSString *urlStr =[NSString stringWithFormat:@"%@%@",UpYunAPI_SERVER,UpYunAPI_bucket];
    NSURL *url = [NSURL URLWithString:urlStr];
    AFHTTPRequestOperationManager *httpManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    httpManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString* timeStr = [self getNowGMTTime];
    NSString* auth = [self getAuthorization:timeStr withPath:@"" withState:@"GET"];
    NSString * str = [NSString stringWithFormat:@" UpYun %@:%@",UpYunAPI_operator,auth];
    [httpManager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
    [httpManager.requestSerializer setValue:@"0" forHTTPHeaderField:@"Content-Length"];
    [httpManager.requestSerializer setValue:timeStr forHTTPHeaderField:@"Date"];
    AFHTTPRequestOperation *operation = [httpManager GET:@"" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSArray *array =[str componentsSeparatedByString:@"\n"];
        success(array);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
    }];
    [operation start];
}

//创建目录
+ (void)createFloderSuccess:(Success)success Failure:(Failure)failure {
    
    NSString *urlStr =[NSString stringWithFormat:@"%@%@/to/folder",UpYunAPI_SERVER,UpYunAPI_bucket];
    NSURL *url = [NSURL URLWithString:urlStr];
    AFHTTPRequestOperationManager *httpManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    httpManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString* timeStr = [self getNowGMTTime];
    NSString* auth = [self getAuthorization:timeStr withPath:@"to/folder" withState:@"POST"];
    NSString * str = [NSString stringWithFormat:@" UpYun %@:%@",UpYunAPI_operator,auth];
    [httpManager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
    [httpManager.requestSerializer setValue:@"100" forHTTPHeaderField:@"Content-Length"];
    [httpManager.requestSerializer setValue:timeStr forHTTPHeaderField:@"Date"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"folder"] = @"nameNew1";
    
    AFHTTPRequestOperation *operation = [httpManager POST:@"" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        NSLog(@"success");
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"falid");
        failure(error);
    }];
    [operation start];
}

+ (void)deleteFileWithDic:(NSDictionary *)dic Success:(Success)success Failure:(Failure)failure {
    
    NSString *urlStr =[NSString stringWithFormat:@"%@%@",UpYunAPI_SERVER,UpYunAPI_bucket];
    NSURL *url = [NSURL URLWithString:urlStr];
    AFHTTPRequestOperationManager *httpManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    httpManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString* timeStr = [self getNowGMTTime];
    NSString* auth = [self getAuthorization:timeStr withPath:dic[@"name"] withState:@"DELETE"];
    NSString * str = [NSString stringWithFormat:@" UpYun %@:%@",UpYunAPI_operator,auth];
    [httpManager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
//    [httpManager.requestSerializer setValue:@"1" forHTTPHeaderField:@"Content-Length"];
    [httpManager.requestSerializer setValue:timeStr forHTTPHeaderField:@"Date"];
    AFHTTPRequestOperation *operation = [httpManager DELETE:@"" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSArray *array =[str componentsSeparatedByString:@"\n"];
        success(array);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
    }];
    [operation start];
}


@end
