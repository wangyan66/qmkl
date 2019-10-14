//
//  ZWBaseSearchViewController.h
//  Qimokaola
//
//  Created by Administrator on 16/9/8.
//  Copyright © 2016年 Administrator. All rights reserved.
//

/**
 *  @author Administrator, 16-09-08 16:09:18
 *
 *  封装了搜索视图 适用于单一数据类型的展现 多种数据类型即多cell类型需要重写必要方法
 */

#import <UIKit/UIKit.h>
#import "ZWBaseTableViewController.h"
#import "ZWSearchTool.h"

#import "MJRefresh.h"

@interface ZWBaseSearchViewController : ZWBaseTableViewController <UISearchResultsUpdating, UISearchControllerDelegate>

// 搜索控件
@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *filteredArray;

@end
