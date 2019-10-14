//
//  WYPrivateCommentCell.h
//  Qimokaola
//
//  Created by 王焱 on 2019/4/8.
//  Copyright © 2019年 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYCommentModel.h"


@interface WYPrivateCommentCell : UITableViewCell
@property (nonatomic,strong) WYCommentModel *model;
+ (instancetype)loadCommentCell;
@end


