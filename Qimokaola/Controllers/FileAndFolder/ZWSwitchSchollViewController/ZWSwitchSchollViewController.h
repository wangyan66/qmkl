//
//  ZWModifySchollViewController.h
//  Qimokaola
//
//  Created by Administrator on 2016/10/13.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZWBaseTableViewController.h"

@interface ZWSwitchSchollViewController : ZWBaseTableViewController

@property (nonatomic, copy) void (^switchSchoolCompletion)(NSString *collegeName, NSString *collegeID);

@end
