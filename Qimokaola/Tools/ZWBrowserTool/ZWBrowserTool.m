//
//  ZWBrowserTool.m
//  Qimokaola
//
//  Created by Administrator on 2016/10/16.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZWBrowserTool.h"

@implementation ZWBrowserTool

+ (void)openWebAddress:(NSString *)url fixedTitle:(NSString *)fixedTitle {
    AXWebViewController *webVC = [[AXWebViewController alloc] initWithAddress:url];
    webVC.showsToolBar = NO;
    webVC.hidesBottomBarWhenPushed = YES;
    if (fixedTitle) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightBold];
        titleLabel.text = fixedTitle;
        webVC.navigationItem.titleView = titleLabel;
    }
    UITabBarController *tabbarController = (ZWTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [(UINavigationController *)tabbarController.selectedViewController pushViewController:webVC animated:YES];
}

+ (void)openWebAddress:(NSString *)url {
    [self openWebAddress:url fixedTitle:nil];
}

@end
