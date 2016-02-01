//
//  FileDirectoryCollectionViewCell.h
//  OpenCloud
//
//  Created by colin liao on 7/17/15.
//  Copyright (c) 2015 colin liao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileDirectoryObj.h"

@interface FileDirectoryCollectionViewCell : UICollectionViewCell
-(void)initWithFileDirectoryObject:(FileDirectoryObj*)obj;
@property(nonatomic)FileDirectoryObj* fileDirectoryObj;
@end
