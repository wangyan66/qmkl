//
//  ZWFileAndFolderViewController.h
//  Qimokaola
//
//  Created by Administrator on 16/9/9.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWBaseTableViewController.h"
#import "ZWAPIRequestTool.h"
#import "ZWUserManager.h"
#import "ZWFile.h"
#import "ZWFolder.h"

/**
 *  @author Administrator, 16-09-10 21:09:03
 *
 *  显示文件以及文件夹
 */

@interface ZWFileAndFolderViewController : ZWBaseTableViewController

// 所有文件
@property (nonatomic, strong) NSMutableArray *files;
// 所有文件夹
@property (nonatomic, strong) NSMutableArray *folders;
// 据搜索字段筛选出的文件
@property (nonatomic, strong) NSMutableArray *filteredFiles;
// 筛选出的文件夹
@property (nonatomic, strong) NSMutableArray *filteredFolder;
// 当前路径
@property (nonatomic, strong) NSString *path;
// 当前课程
@property (nonatomic, strong) NSString *course;
// 检测row是否处于文件范围
- (BOOL)isIndexInFiles:(NSInteger)index;

@end
