//
//  WYZanTableViewCell.m
//  Qimokaola
//
//  Created by 王焱 on 2018/8/26.
//  Copyright © 2018年 Administrator. All rights reserved.
//

#import "WYZanTableViewCell.h"
#import <YYWebImage/YYWebImage.h>
@interface WYZanTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end

@implementation WYZanTableViewCell
+(instancetype)loadCommentCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"WYZanTableViewCell" owner:self options:nil] lastObject];
}
- (void)setModel:(WYCommentModel *)model{
    _model=model;
    NSString *url=@"http://120.77.32.233/qmkl1.0.0/user/download/avatar/id/";
    [self.avatar yy_setImageWithURL:[NSURL URLWithString:[url stringByAppendingString:model.ID]] placeholder:nil];
    if (model.nickname == nil || [model.nickname isKindOfClass:[NSNull class]] || model.nickname.length == 0) {
        self.nickName.text=@"???";
    }else{
        self.nickName.text=model.nickname;
    }
    self.time.text=model.time;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self layoutIfNeeded];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
