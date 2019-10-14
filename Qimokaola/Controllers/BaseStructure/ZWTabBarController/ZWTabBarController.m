//
//  ZWMainViewController.m
//  Qimokaola
//
//  Created by Administrator on 16/8/11.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZWTabBarController.h"
#import "ZWCourseViewController.h"
#import "ZWDownloadedViewController.h"
//#import "ZWStudentCircleViewController.h"
#import "WYCommentViewController.h"
#import "ZWNavigationController.h"
#import "ZWMineViewController.h"
#import "ZWGoodListViewController.h"
#import "WYEmptyViewController.h"
@interface ZWTabBarController ()

@property (strong, nonatomic) NSArray *viewControllersInfo;

@end

@implementation ZWTabBarController

- (NSArray *)viewControllersInfo {
    if (_viewControllersInfo == nil) {
        _viewControllersInfo = @[
//                                 @{@"class" : [ZWGoodListViewController class],
//                                   @"title" : @"云打印",
//                                   @"image" : @"icon_tab_print",
//                                   @"selected_image" : @"icon_tab_print_selected"},
                                 
                                 @{
                                     @"class" : [ZWCourseViewController class],
                                     @"title" : @"资源",
                                     @"image" : @"icon_tab_resource",
                                     @"selected_image" : @"icon_tab_resource_selected"
                                     },
                                 
                                 @{@"class" : [ZWDownloadedViewController class],
                                   @"title" : @"已下载",
                                   @"image" : @"icon_tab_downloaded",
                                   @"selected_image" : @"icon_tab_downloaded_selected"
                                  },
//wyempty
                                 @{@"class" : [WYCommentViewController class],
                                   @"title" : @"趣聊",
                                   @"image" : @"icon_tab_circle",
                                   @"selected_image" : @"icon_tab_circle_selected"
                                   }
//
//                                 @{@"class" : [ZWMineViewController class],
//                                   @"title" : @"发现",
//                                   @"image" : @"icon_tab_discovery",
//                                   @"selected_image" : @"icon_tab_discovery_selected"
//                                   },
                                 ];
    }
    return _viewControllersInfo;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor whiteColor];
    
    NSMutableArray<UIViewController *> *viewControllers = [NSMutableArray array];
    for (NSDictionary *dict in self.viewControllersInfo) {
        Class clazz = dict[@"class"];
        
        ZWNavigationController *nav = [[ZWNavigationController alloc] initWithRootViewController:[[clazz alloc] init] tabBarItemComponents:@[dict[@"title"], dict[@"image"], dict[@"selected_image"]]];
        [viewControllers addObject:nav];
    }
    self.viewControllers = viewControllers;
    
    self.tabBar.layer.shadowOpacity = 0.05;
    self.tabBar.layer.shadowOffset = CGSizeMake(0, -1.5);
    self.tabBar.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.tabBar.bounds].CGPath;
    
    // 此处观察用户管理器中未读消息数量 已设置相应视图
//    RAC(self.viewControllers[2].tabBarItem, badgeValue) = [RACSignal combineLatest:@[RACObserve([ZWUserManager sharedInstance], unreadCommentCount), RACObserve([ZWUserManager sharedInstance], unreadLikeCount)]
//                                         reduce:^id(NSNumber *unreadCommentNumber, NSNumber *unreadLikeNumber){
//                                             int unreadCount = unreadCommentNumber.intValue + unreadLikeNumber.intValue;
//                                             if (unreadCount > 0) {
//                                                 return @(unreadCount).stringValue;
//                                             } else {
//                                                 return nil;
//                                             }
//                                         }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
