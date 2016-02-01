//
//  FileNameObj.h
//  OpenCloud
//
//  Created by colin liao on 7/17/15.
//  Copyright (c) 2015 colin liao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileNameObj : NSObject


@property(nonatomic)CGFloat curSchedule;

-(instancetype)initWithString:(NSString*)fileNameStr;
-(NSString*)getFileNameString;



@end
