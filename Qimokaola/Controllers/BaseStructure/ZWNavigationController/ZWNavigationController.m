//
//  ZWNavigationController.m
//  Qimokaola
//
//  Created by Administrator on 16/8/11.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZWNavigationController.h"

@interface ZWNavigationController ()

@end

@implementation ZWNavigationController


- (instancetype)initWithRootViewController:(UIViewController *)rootViewController tabBarItemComponents:(NSArray *)components {
    if (self = [super initWithRootViewController:rootViewController]) {
        self.tabBarItem.title = components[0];
        self.tabBarItem.image = [UIImage imageNamed:components[1]];
        self.tabBarItem.selectedImage = [[UIImage imageNamed:components[2]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
