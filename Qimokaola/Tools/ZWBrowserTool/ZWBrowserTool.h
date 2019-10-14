//
//  ZWBrowserTool.h
//  Qimokaola
//
//  Created by Administrator on 2016/10/16.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZWTabBarController.h"
#import <AXWebViewController/AXWebViewController.h>

@interface ZWBrowserTool : NSObject

+ (void)openWebAddress:(NSString *)url fixedTitle:(NSString *)fixedTitle;

+ (void)openWebAddress:(NSString *)url;

@end
