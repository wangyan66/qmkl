//
//  ZWUMUserFeedCell.m
//  Qimokaola
//
//  Created by Administrator on 2016/10/11.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZWUMUserFeedCell.h"

@implementation ZWUMUserFeedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
   // _contentLabel.numberOfLines = 0;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
