//
//  ZWMineHeaderView.h
//  Qimokaola
//
//  Created by Administrator on 2017/3/2.
//  Copyright © 2017年 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZWUser.h"

@interface ZWMineHeaderView : UIView

+ (instancetype)mineHeaderViewInstance;

@property (nonatomic, strong) ZWUser *user;

@end
