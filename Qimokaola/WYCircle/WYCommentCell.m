//
//  WYCommentCell.m
//  Qimokaola
//
//  Created by 王焱 on 2018/8/19.
//  Copyright © 2018年 Administrator. All rights reserved.
//

#import "WYCommentCell.h"

#import <YYWebImage/YYWebImage.h>
@interface WYCommentCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak,      nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *time;
- (IBAction)commentButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *comment;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
@property (weak, nonatomic) IBOutlet UILabel *zanLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIButton *collectionButton;
@property (weak, nonatomic) IBOutlet UILabel *seperatorView;



@end

@implementation WYCommentCell
+(instancetype)loadCommentCell{
     return [[[NSBundle mainBundle] loadNibNamed:@"WYCommentCell" owner:self options:nil] lastObject];
}
//- (void)layoutSubviews {
//    [super layoutSubviews];
////    [self layoutIfNeeded];
//    self.content.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 100;
//
//}
- (void)setModel:(WYCommentModel *)model{
    _model=model;
    NSString *url=@"http://120.77.32.233/qmkl1.0.0/user/download/avatar/id/";
    [self.avatar yy_setImageWithURL:[NSURL URLWithString:[url stringByAppendingString:model.ID]] placeholder:nil];
    //设置点赞
//    [self.zanBtn setImage:[UIImage imageNamed:@"unzan"] forState:UIControlStateNormal];
//    [self.zanBtn setImage:[UIImage imageNamed:@"unzan"] forState:UIControlStateSelected];
    
    [self.zanBtn addTarget:self action:@selector(zanButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.collectionButton addTarget:self action:@selector(collectionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if (model.nickname == nil || [model.nickname isKindOfClass:[NSNull class]] || model.nickname.length == 0) {
        self.nickName.text=@"???";
    }else{
        self.nickName.text=model.nickname;
    }
    
         self.content.text=[self getTextStringByUTFString:model.content];
   
    
    self.time.text=model.time;
    self.zanLabel.text=[NSString stringWithFormat:@"%@个人觉得赞",model.likeNum];
    self.commentLabel.text=[NSString stringWithFormat:@"%@个评论",model.commentNum];
    self.zanBtn.selected=model.isZan;
    self.collectionButton.selected=model.isCollection;
//    if (self.isCommentButtonHidden) {
//
//        self.comment.hidden=YES;
//    }
//    self.seperatorView.hidden=self.isSeperatorViewHidden;
//    self.zanBtn.hidden=self.isZanButtonHidden;
}
- (void)hideViews{
    self.comment.hidden=YES;
    self.seperatorView.hidden=YES;
    self.zanBtn.hidden=YES;
    self.collectionButton.hidden=YES;
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
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)zanButtonClicked:(UIButton *)button{
    button.selected=!button.isSelected;
    int temp;
    if (button.selected) {
        temp=_model.likeNum.intValue+1;
    }else{
        temp=_model.likeNum.intValue-1;
    }
    
_model.likeNum=[NSNumber numberWithInt:temp];
    self.zanLabel.text=[NSString stringWithFormat:@"%@个人觉得赞",_model.likeNum];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didZanButton:)]) {
        
        [self.delegate didZanButton:self.model.postID];
    }
}
- (void)collectionButtonClicked:(UIButton *)button{
    button.selected=!button.isSelected;
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didCollectionButtonWithPostId:)]) {
        [self.delegate didCollectionButtonWithPostId:self.model.postID];
    }
}
- (IBAction)commentButton:(id)sender {
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didCommentButton)]) {
        
        [self.delegate didCommentButton];
    }
}

@end
