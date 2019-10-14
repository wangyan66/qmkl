//
//  ZWAddCountDownViewController.h
//  Qimokaola
//
//  Created by Administrator on 2017/2/20.
//  Copyright © 2017年 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWCountdown.h"

@interface ZWAddCountDownViewController : UITableViewController

+ (instancetype)addCountdownViewControllerInstance;

@property (nonatomic, strong) ZWCountdown *countdown;

@property (nonatomic, copy) void(^completion)(ZWCountdown *countdown);

@end
