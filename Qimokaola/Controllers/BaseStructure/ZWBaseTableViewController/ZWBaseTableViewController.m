//
//  ZWBaseTableViewController.m
//  Qimokaola
//
//  Created by Administrator on 2016/10/6.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZWBaseTableViewController.h"

@interface ZWBaseTableViewController ()

@end

@implementation ZWBaseTableViewController

#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        //作为导航控制器中的顶层视图时是否显示底部工具栏
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
//    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 88, kScreenW, kScreenH)];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    
    //删除单元格分割线
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(freshHeaderStartFreshing)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.shouldEmptyViewShow = YES;
        [self.tableView.mj_header beginRefreshing];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//空白页的图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView   {
    return [UIImage imageNamed:@"pic_none_hint_gray"];
}

//是否显示空白页面
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return _shouldEmptyViewShow;
}
//空白页是否可以滚动
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    
    return YES;
}

- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView {
    scrollView.contentOffset = CGPointZero;
}

//- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
//    UIEdgeInsets insets = self.tableView.contentInset;
//    return (insets.top == 0.0f) ? -64.0f : 0.0f;
//}

#pragma mark - Common Methods

- (void)freshHeaderStartFreshing {
    
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
