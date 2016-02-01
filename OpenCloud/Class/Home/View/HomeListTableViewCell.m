//
//  HomeListTableViewCell.m
//  OpenCloud
//
//  Created by 王亮 on 15/7/18.
//  Copyright (c) 2015年 colin liao. All rights reserved.
//

#import "HomeListTableViewCell.h"

@interface HomeListTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;

@end

@implementation HomeListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setInfoDic:(NSDictionary *)infoDic {
    
    _infoDic = infoDic;
    self.nameLabel.text = infoDic[@"name"];
    self.timeLabel.text = infoDic[@"time"];
    if ([infoDic[@"size"] integerValue] > 0) {
        
        self.sizeLabel.hidden = NO;
        self.sizeLabel.text = infoDic[@"size"];
    }else {
        self.sizeLabel.hidden = YES;
    }
    

}

@end
