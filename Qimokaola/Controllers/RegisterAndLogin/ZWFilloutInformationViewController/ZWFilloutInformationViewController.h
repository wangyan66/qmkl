//
//  ZWFilloutInformationViewController.h
//  Qimokaola
//
//  Created by Administrator on 16/7/14.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZWUser;
@interface ZWFilloutInformationViewController : UIViewController
//注册时的用户和密码
@property (nonatomic, strong) NSDictionary *registerParam;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) ZWUser *oauthLoginUser;

@end
