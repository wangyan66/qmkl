//
//  ZWResetPasswordViewController.h
//  Qimokaola
//
//  Created by Administrator on 2016/11/25.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZWResetPasswordViewController : UIViewController

@property (nonatomic, strong) NSString *enterPhoneNumber;

@property (nonatomic, copy) void (^completion)(void);;

@end
