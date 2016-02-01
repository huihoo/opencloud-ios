//
//  TransferCollectionViewCell.h
//  OpenCloud
//
//  Created by colin liao on 7/18/15.
//  Copyright (c) 2015 colin liao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransferCollectionViewCell : UICollectionViewCell

-(void)initWithIndex:(NSIndexPath*)indexPath;
-(void)changePercent:(CGFloat)percent;

@end
