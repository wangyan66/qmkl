//
//  WYDetailCommentCell.m
//  Qimokaola
//
//  Created by 王焱 on 2018/8/20.
//  Copyright © 2018年 Administrator. All rights reserved.
//

#import "WYDetailCommentCell.h"
#import <YYWebImage/YYWebImage.h>
@interface WYDetailCommentCell()
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *content;

@end

@implementation WYDetailCommentCell

+(instancetype)loadCommentCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"WYDetailCommentCell" owner:self options:nil] lastObject];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.content.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 100;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self layoutIfNeeded];
    // Initialization code
}
- (NSString *)getTextStringByUTFString:(NSString *)UTFString{
    NSString *version= [UIDevice currentDevice].systemVersion;
    if(version.doubleValue >=9.0) {
        //iOS 9以后
        return [UTFString stringByRemovingPercentEncoding];
    }else{
        //iOS 9以前
        return [UTFString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
}
- (void)setModel:(WYCommentModel *)model{
    if (model.nickname == nil || [model.nickname isKindOfClass:[NSNull class]] || model.nickname.length == 0) {

        self.nickName.text=@"???";
    }else{
        self.nickName.text=model.nickname;
    }
    
    NSString *url=@"http://120.77.32.233/qmkl1.0.0/user/download/avatar/id/";
    [self.avatar yy_setImageWithURL:[NSURL URLWithString:[url stringByAppendingString:model.ID]] placeholder:nil];
    if (model.tonickname!=nil) {
        NSString *str = [NSString stringWithFormat:@"@%@:",model.tonickname];
        //        sendText = [str stringByAppendingString:text];
        self.content.text=[self getTextStringByUTFString:[str stringByAppendingString:model.content]];
    }else{
        self.content.text=[self getTextStringByUTFString:model.content];
    }
    self.time.text=model.time;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
