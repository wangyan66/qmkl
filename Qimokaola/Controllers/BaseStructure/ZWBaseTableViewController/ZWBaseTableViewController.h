//
//  ZWBaseTableViewController.h
//  Qimokaola
//
//  Created by Administrator on 2016/10/6.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIScrollView+EmptyDataSet.h"
#import "MJRefresh.h"

@interface ZWBaseTableViewController : UITableViewController <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

// 对外暴露的下拉刷新时执行的方法
// 子类中具体实现
- (void)freshHeaderStartFreshing;

// 此变量控制初始时空数据占位图是否显示 默认不显示 可在子类中修改以实现具体功能
@property (nonatomic, assign) BOOL shouldEmptyViewShow;

@end
