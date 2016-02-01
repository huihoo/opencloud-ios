//
//  APPManager.m
//  OpenCloud
//
//  Created by colin liao on 7/17/15.
//  Copyright (c) 2015 colin liao. All rights reserved.
//

#import "APPManager.h"
#include "FileDirectoryObj.h"
#include "UpYun.h"
#include "FileNameObj.h"

static APPManager* instanceAPPManager = nil;

@interface APPManager()

@property(nonatomic)UILabel* titleLable;
@property(nonatomic)BOOL isUpload;

@end

@implementation APPManager

+(id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedAppManager];
}

+(APPManager*)sharedAppManager
{
    if (!instanceAPPManager) {
        instanceAPPManager = [[super allocWithZone:nil] init];
        
        
        //初始化filename数组
        instanceAPPManager.fileNameArray = [NSMutableArray array];
        //初始化fileDirectory数组
        instanceAPPManager.fileDirectoryArray = [NSMutableArray array];
        
        //test一个数据(从服务器获得)
        /***/
        FileDirectoryObj* obj = [[FileDirectoryObj alloc] init];
        obj.fileDirectory = @"/";
        [instanceAPPManager.fileDirectoryArray addObject:obj];
        /***/
        
        //初始化uilabel
        instanceAPPManager.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        
        instanceAPPManager.titleLable.font = [UIFont boldSystemFontOfSize:18];
        
        instanceAPPManager.titleLable.textColor = [UIColor whiteColor];
        
        instanceAPPManager.titleLable.textAlignment = NSTextAlignmentCenter;
        
    }
    
    return instanceAPPManager;
}

-(UILabel*)getNaViLabel:(ControllerType)type
{
    
    switch (type) {
        case ControllerType_Home:
            self.titleLable.text = @"开放云";
            break;
        case ControllerType_Share:
            self.titleLable.text = @"分享";
            break;
        case ControllerType_Transfer:
            self.titleLable.text = @"传输列表";
            break;
        case ControllerType_More:
            self.titleLable.text = @"设置";
            break;
        case ControllerType_Add:
            self.titleLable.text = @"文件类型";
            break;
            
            
        default:
            break;
    }
    
    return self.titleLable;
}

-(void)addFileNameObj:(FileNameObj *)fileNameObj
{
    [self.fileNameArray addObject:fileNameObj];
}

-(NSInteger)getFileNameArrayCount
{
    return self.fileNameArray.count;
}

-(FileNameObj*)getFileObjectFromArray:(NSInteger)index
{
    return self.fileNameArray[index];
}


-(void)startUpload
{
    //如果正在上传则不操作
    if (self.isUpload) {
        return;
    }
    
    if (self.fileNameArray.count <= 0) {
        return;
    }
    
    UpYun *uy = [[UpYun alloc] init];
    self.isUpload = YES;
    uy.successBlocker = ^(id data)
    {
        
        
        //操作删除文件与userdefault以及数组数据
        FileNameObj* obj = self.fileNameArray[0];

        NSString* message = [NSString stringWithFormat:@"上传成功,删除本地%@文件",[obj getFileNameString]];
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        NSLog(@"%@",data);

        [self obatainHomeListData];
        
        [self deleteFileMessage:0 withIsNewUpload:YES];
        
    };
    uy.failBlocker = ^(NSError * error)
    {
        NSString *message = [error.userInfo objectForKey:@"message"];
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"error" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        NSLog(@"%@",error);
        
        [self deleteFileMessage:0 withIsNewUpload:YES];
        
    };
    uy.progressBlocker = ^(CGFloat percent, long long requestDidSendBytes)
    {
//
        NSLog(@"cur percent %f",percent);
        FileNameObj* obj = self.fileNameArray[0];
        obj.curSchedule = percent;
        //调用代理函数
        [self.delegate refresh:self.fileNameArray withIsNeedReload:NO];
    };
    
    
    /**
     *	@brief	根据 UIImage 上传
     */
    NSString* documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/upload"];
    FileNameObj* obj = self.fileNameArray[0];
    NSString* filePath = [documentsPath stringByAppendingPathComponent:[obj getFileNameString]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSLog(@"11111");
    }else
    {
        [self.fileNameArray removeObjectAtIndex:0];
    }
    UIImage * image = [UIImage imageNamed:filePath];
    [uy uploadFile:image saveKey:[self getSaveKey]];
    
}

-(void)deleteFileMessage:(NSInteger)index withIsNewUpload:(BOOL)isNew
{
    //删除已经上传的文件
    FileNameObj* obj = self.fileNameArray[index];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[obj getFileNameString]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString* filePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/upload/%@",[obj getFileNameString]]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    [self.fileNameArray removeObjectAtIndex:index];
    [self.delegate refresh:self.fileNameArray withIsNeedReload:YES];
    
    if (isNew) {
        self.isUpload = NO;
        //上传完成一个之后再开始上传
        [self startUpload];
    }
}

-(NSString*)getSaveKey
{
    FileNameObj* obj = self.fileNameArray[0];
    NSString* string = [[NSUserDefaults standardUserDefaults] objectForKey:[obj getFileNameString]];
    NSString* saveKey = [NSString stringWithFormat:@"%@%@",string,[obj getFileNameString]];
    return  saveKey;
}

-(void)obatainHomeListData
{
    [UpYunHttpRequest getRootFileSuccess:^(id info) {
        [self.obtainDataDelegate obtainData:info];
        
    } Failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}



@end
