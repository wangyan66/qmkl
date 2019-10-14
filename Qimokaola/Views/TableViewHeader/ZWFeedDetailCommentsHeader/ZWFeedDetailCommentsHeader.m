//
//  ZWFeedDetailCommentsHeader.m
//  Qimokaola
//
//  Created by Administrator on 2016/10/14.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZWFeedDetailCommentsHeader.h"

@interface ZWFeedDetailCommentsHeader ()

@property (weak, nonatomic) IBOutlet UILabel *commentsCountLabel;

@end

@implementation ZWFeedDetailCommentsHeader

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setCommentsCount:(int)commentsCount {
    _commentsCount = commentsCount;
    _commentsCountLabel.text = [NSString stringWithFormat:@"%d 条评论", _commentsCount];
}

@end
