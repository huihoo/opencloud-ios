//
//  TransferCollectionViewCell.m
//  OpenCloud
//
//  Created by colin liao on 7/18/15.
//  Copyright (c) 2015 colin liao. All rights reserved.
//

#import "TransferCollectionViewCell.h"
#include "FileNameObj.h"

@interface TransferCollectionViewCell ()

@property(weak,nonatomic)IBOutlet UIProgressView* loadProgressView;
@property(weak,nonatomic)IBOutlet UIImageView* fileImageView;
@property(weak,nonatomic)IBOutlet UILabel* loadLabel;

@property(weak,nonatomic)IBOutlet UIButton* closeButton;

@property(nonatomic)NSIndexPath* indexPath;


@end

@implementation TransferCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.layer.cornerRadius = 4;
    
    
}

-(void)changePercent:(CGFloat)percent
{
    NSLog(@"%f",self.loadProgressView.progress);
    [self.loadProgressView setProgress:percent animated:YES];
    
    self.loadLabel.text = [NSString stringWithFormat:@"%d％",(int)(percent*100)];
    
}

-(void)initWithIndex:(NSIndexPath *)indexPath
{
    NSString* uploadPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/upload"];
    FileNameObj* obj = [APPManager sharedAppManager].fileNameArray[indexPath.row];
    NSString* filePath = [uploadPath stringByAppendingPathComponent:[obj getFileNameString]];
    self.fileImageView.image = [UIImage imageNamed:filePath];
    self.indexPath = indexPath;
    if (indexPath.row == 0) {
        self.closeButton.hidden = YES;
    }
}

-(IBAction)buttonToClose:(id)sender
{
    [[APPManager sharedAppManager] deleteFileMessage:self.indexPath.row withIsNewUpload:NO];
}
@end
