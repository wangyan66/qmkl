//
//  WYZanTableViewCell.h
//  Qimokaola
//
//  Created by 王焱 on 2018/8/26.
//  Copyright © 2018年 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYCommentModel.h"
@interface WYZanTableViewCell : UITableViewCell
+ (instancetype)loadCommentCell;
@property (nonatomic,strong) WYCommentModel *model;
@end
