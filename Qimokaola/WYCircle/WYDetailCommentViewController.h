//
//  WYDetailCommentViewController.h
//  Qimokaola
//
//  Created by 王焱 on 2018/8/20.
//  Copyright © 2018年 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYCommentModel.h"
@interface WYDetailCommentViewController : UIViewController
//帖子的model
@property (nonatomic,strong) WYCommentModel *model;
@property (nonatomic, assign) BOOL isNeedModel;
@end
