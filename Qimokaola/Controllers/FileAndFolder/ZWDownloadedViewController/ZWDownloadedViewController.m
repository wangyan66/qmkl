//
//  ZWDownloadedViewController.m
//  Qimokaola
//
//  Created by Administrator on 2016/10/7.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZWDownloadedViewController.h"
#import "ZWPathTool.h"
#import "ZWDataBaseTool.h"
#import "ZWDownloadedInfoCell.h"
#import "ZWFileDetailViewController.h"

#import <YYCategories/YYCategories.h>

#define kDownloadedCellIdentifier @"kDownloadedCellIdentifier"

@interface ZWDownloadedViewController () <UISearchResultsUpdating, UISearchControllerDelegate>

@end

@implementation ZWDownloadedViewController

#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = NO;
        NSLog(@"init %@ success", NSStringFromClass([self class]));
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.shouldEmptyViewShow = YES;
    self.title = @"已下载";
    self.view.backgroundColor = [UIColor whiteColor];
    self.hidesBottomBarWhenPushed = NO;
    
    
    
    //编辑按钮
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(edit:)];
    self.navigationItem.rightBarButtonItem = editButton;
    
    self.tableView.mj_header = nil;
    self.tableView.rowHeight = 55;
    [self.tableView registerClass:[ZWDownloadedInfoCell class] forCellReuseIdentifier:kDownloadedCellIdentifier];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
 
    self.dataArray = [[ZWDataBaseTool sharedInstance] fetchDonwloadedInfos];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated  {
    
    [super viewWillDisappear:animated];
    
    self.tableView.editing = NO;
    self.navigationItem.rightBarButtonItem.title = @"编辑";
    
    self.dataArray = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)edit:(UIBarButtonItem *)sender  {
    self.tableView.editing = !self.tableView.editing;
    if (self.tableView.isEditing) {
        sender.title = @"完成";
    }  else  {
        sender.title = @"编辑";
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZWDownloadedInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kDownloadedCellIdentifier];
    cell.downloadInfo = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:UITableViewRowAnimationNone];
    });
    
    ZWDownloadedInfo *downloadInfo = [self.dataArray objectAtIndex:indexPath.row];
    ZWFileDetailViewController *fileDetail = [[ZWFileDetailViewController alloc] init];
    fileDetail.file = downloadInfo.file;
    fileDetail.storage_name = downloadInfo.storage_name;
    fileDetail.course = downloadInfo.course;
    fileDetail.hasDownloaded = YES;
    
    [self.navigationController pushViewController:fileDetail animated:YES];
    
    NSLog(@"shit");
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ZWDownloadedInfo *downloadInfo = [self.dataArray objectAtIndex:indexPath.row];
        // 1.删除文件
        [[NSFileManager defaultManager] removeItemAtPath:[[ZWPathTool downloadDirectory] stringByAppendingPathComponent:downloadInfo.storage_name] error:NULL];
        // 2.删除数据库记录
        [[ZWDataBaseTool sharedInstance] deleteFileDownloadInfo:downloadInfo.file.md5];
        // 3.删除model数据
        // [self.dataArray removeObject:downloadInfo];
        [self.dataArray removeObject:downloadInfo];
        // 4.更新视图
        [tableView deleteRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationAutomatic];
        if (self.dataArray.count == 0) {
            [self.tableView reloadData];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.searchController.active ? NO : YES;
}

#pragma mark - UISearchResultUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self.filteredArray removeAllObjects];
    self.filteredArray = [ZWSearchTool searchFromArray:self.dataArray withSearchText:searchController.searchBar.text withSearhPredicateString:@"file.name CONTAINS[c] %@"];
    [self.tableView reloadData];
}


#pragma mark - UISearchControllerDelegate

- (void)willPresentSearchController:(UISearchController *)searchController {
    searchController.searchBar.searchBarStyle = UIBarStyleDefault;
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.tabBarController.tabBar.hidden = YES;
    self.tableView.emptyDataSetSource = nil;
    self.tableView.emptyDataSetDelegate = nil;
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
   // [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.tabBarController.tabBar.hidden = NO;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
}


@end
