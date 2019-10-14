//
//  ZWBaseSearchViewController.m
//  Qimokaola
//
//  Created by Administrator on 16/9/8.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZWBaseSearchViewController.h"

@interface ZWBaseSearchViewController ()

@end

@implementation ZWBaseSearchViewController


#pragma mark - Life Cycle

- (void)viewWillDisappear:(BOOL)animated  {
    [super viewWillDisappear:animated];
    
    if (self.searchController.active) {
        self.searchController.active = NO;
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self.searchController.searchBar removeFromSuperview];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置下级页面的返回键
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButtonItem;
    
    //初始化方法,如果是在当前控制器展示结果,就传nil
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    //设置结果更新代理
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    //当前控制器展示结果，所以不需要这个透明视图
    self.searchController.dimsBackgroundDuringPresentation = NO;
    [self.searchController.searchBar sizeToFit];
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
//    self.tableView.frame=CGRectMake(0, 88, kScreenW, kScreenH);
//    if (@available(iOS 11.0, *)) {
//        self.navigationItem.searchController = _searchController;
//    } else {
//        self.tableView.tableHeaderView = _searchController.searchBar;
//    }
    self.definesPresentationContext = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITabelViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
// 这里通过searchController的active属性来区分展示数据源是哪个
    if (self.searchController.active) {
        return self.filteredArray.count;
    } else {
        return self.dataArray.count;
    }
}

#pragma mark - UISearchResultsUpdating 
//实现搜索逻辑
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
}

#pragma mark - UISearchControllerDelegate

- (void)willPresentSearchController:(UISearchController *)searchController {
    searchController.searchBar.searchBarStyle = UIBarStyleDefault;
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
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
