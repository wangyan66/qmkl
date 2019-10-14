//
//  ZWAvatarViewController.h
//  Qimokaola
//
//  Created by Administrator on 2016/9/19.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ZWAvatarViewControllerType) {
    ZWAvatarViewControllerTypeSelf = 0,  // app用户
    ZWAvatarViewControllerTypeOthers    // 其他用户
};

@interface ZWModifyAvatarViewController : UIViewController

@property (nonatomic, strong) void(^completion)(void);

@property (nonatomic, assign) ZWAvatarViewControllerType avatarViewType;

@property (nonatomic, strong) NSString *avatarUrl;

@end
