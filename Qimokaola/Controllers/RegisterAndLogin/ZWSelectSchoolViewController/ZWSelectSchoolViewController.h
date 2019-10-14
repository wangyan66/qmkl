//
//  ZWSelectSchoolViewController.h
//  Qimokaola
//
//  Created by Administrator on 16/7/14.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZWSelectSchoolViewController : UITableViewController

@property (nonatomic, copy, readwrite) void(^completionBlock)(NSDictionary *result);
@property (nonatomic,strong) NSString *token;
@end
