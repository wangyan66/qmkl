//
//  ZWUserCommentsViewController.m
//  Qimokaola
//
//  Created by Administrator on 2016/9/29.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZWUserCommentsViewController.h"
//#import "ZWRSCommentsViewController.h"

#import "DLTabedSlideView.h"

@interface ZWUserCommentsViewController () <DLTabedSlideViewDelegate>

@property (nonatomic, strong) DLTabedSlideView *tabedSlideView;
@property (nonatomic, strong) NSArray *items;

@end

@implementation ZWUserCommentsViewController

#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = defaultBackgroundColor;
    self.title = @"评论";
    
    [self zw_addSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Lazy Loading

#pragma mark - Common Methods

- (void)zw_addSubViews {
    UIColor *lightColor = RGB(76., 143., 215.);
    self.tabedSlideView = [[DLTabedSlideView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenW, kScreenH)];
    [self.view addSubview:self.tabedSlideView];
    self.tabedSlideView.baseViewController = self;
    self.tabedSlideView.tabItemNormalColor = [UIColor lightGrayColor];
    self.tabedSlideView.tabItemSelectedColor = lightColor;
    self.tabedSlideView.tabbarTrackColor = lightColor;
    self.tabedSlideView.tabbarBackgroundImage = [UIImage imageNamed:@"tabbarBk"];
    DLTabedbarItem *receivedItem = [DLTabedbarItem itemWithTitle:@"收到的评论" image:nil selectedImage:nil];
    DLTabedbarItem *sendedItem = [DLTabedbarItem itemWithTitle:@"发出的评论" image:nil selectedImage:nil];
    self.tabedSlideView.tabbarItems = @[receivedItem, sendedItem];
    [self.tabedSlideView buildTabbar];
    self.tabedSlideView.delegate = self;
    self.tabedSlideView.selectedIndex = 0;
}

#pragma mark - DLSlideViewDelegate

- (NSInteger)numberOfTabsInDLTabedSlideView:(DLTabedSlideView *)sender {
    return 2;
}

//- (UIViewController *)DLTabedSlideView:(DLTabedSlideView *)sender controllerAt:(NSInteger)index {
//    // 类型值可直接转换
//    return [[ZWUserCommentsViewController alloc] initWithUserCommentsType:index];
//}

- (void)DLTabedSlideView:(DLTabedSlideView *)sender didSelectedAt:(NSInteger)index {
    
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
