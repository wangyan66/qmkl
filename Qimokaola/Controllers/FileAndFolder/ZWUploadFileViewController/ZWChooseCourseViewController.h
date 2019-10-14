//
//  ZWChooseCourseViewController.h
//  Qimokaola
//
//  Created by Administrator on 2016/10/17.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZWCourseViewController.h"

@interface ZWChooseCourseViewController : ZWCourseViewController

@property (nonatomic, copy) void(^chooseCourseCompletion)(NSString *course);

@end
