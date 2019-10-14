//
//  WYDetailCommentCell.h
//  Qimokaola
//
//  Created by 王焱 on 2018/8/20.
//  Copyright © 2018年 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYCommentModel.h"
@interface WYDetailCommentCell : UITableViewCell
@property (nonatomic,strong) WYCommentModel *model;
+ (instancetype)loadCommentCell;

@end
