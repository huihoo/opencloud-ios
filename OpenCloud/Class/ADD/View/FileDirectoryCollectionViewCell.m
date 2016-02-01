//
//  FileDirectoryCollectionViewCell.m
//  OpenCloud
//
//  Created by colin liao on 7/17/15.
//  Copyright (c) 2015 colin liao. All rights reserved.
//

#import "FileDirectoryCollectionViewCell.h"

@interface FileDirectoryCollectionViewCell()

@property(weak,nonatomic)IBOutlet UIView* bgView;//背景view
@property(weak,nonatomic)IBOutlet UILabel* nameLabel;

@end

@implementation FileDirectoryCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.bgView.layer.cornerRadius = self.bgView.frame.size.width/2;
    self.bgView.clipsToBounds = YES;
}

-(void)initWithFileDirectoryObject:(FileDirectoryObj *)obj
{
    self.nameLabel.text = obj.fileDirectory;
    self.fileDirectoryObj = obj;
}

@end
