//
//  FileNameObj.m
//  OpenCloud
//
//  Created by colin liao on 7/17/15.
//  Copyright (c) 2015 colin liao. All rights reserved.
//

#import "FileNameObj.h"


@interface FileNameObj ()


@property(nonatomic)NSString* fileNameStr;


@end

@implementation FileNameObj

-(instancetype)initWithString:(NSString *)fileNameStr
{
    self = [super init];
    self.fileNameStr = fileNameStr;
    self.curSchedule = 0;

    return self;
}

-(NSString*)getFileNameString
{
    return self.fileNameStr;
}

@end
