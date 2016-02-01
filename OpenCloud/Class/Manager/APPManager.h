//
//  APPManager.h
//  OpenCloud
//
//  Created by colin liao on 7/17/15.
//  Copyright (c) 2015 colin liao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol LoadMessageChangedDelegate <NSObject>

@required
-(void)refresh:(NSArray*)uploadFileArray withIsNeedReload:(BOOL)isNeedRload;

@end


@protocol ObtainDataDelegate <NSObject>

@required
-(void)obtainData:(id)info;

@end


@class  FileNameObj;
typedef enum
{
    ControllerType_Home,
    ControllerType_Share,
    ControllerType_Transfer,
    ControllerType_More,
    ControllerType_Add,
}ControllerType;

@interface APPManager : NSObject
@property(nonatomic,assign)id<LoadMessageChangedDelegate>delegate;
@property(nonatomic,assign)id<ObtainDataDelegate>obtainDataDelegate;

@property(nonatomic,strong)NSMutableArray* fileDirectoryArray;
@property(nonatomic,strong)NSMutableArray* fileNameArray;

+(APPManager*)sharedAppManager;

//获取导航title
-(UILabel*)getNaViLabel:(ControllerType)type;

//filenameArray数组的操作
-(void)addFileNameObj:(FileNameObj*)fileNameObj;
-(NSInteger)getFileNameArrayCount;
-(FileNameObj*)getFileObjectFromArray:(NSInteger)index;

/***********
在appmanager中上传文件，
 //上传的处理,当appmanager中的filename数组为空时删除upload文件
 //显示文件的上传进度条，展示一个正在上传的文件，当这个文件上传完成的时候上传下一个文件，同事删除appmanager的filenamearray数组中的数据，
 //每个文件上传完成的时候检测一次appmanager中filename数组是否为空，空的时候清除upload文件夹
*/
//开始上传
-(void)startUpload;
-(void)deleteFileMessage:(NSInteger)index withIsNewUpload:(BOOL)isNew;


//请求首页文件信息
-(void)obatainHomeListData;

@end
