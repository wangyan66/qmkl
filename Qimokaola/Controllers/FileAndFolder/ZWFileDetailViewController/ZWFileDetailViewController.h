//
//  ZWFileDetailViewController.h
//  Qimokaola
//
//  Created by Administrator on 16/9/11.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWFile.h"

/**
 *  @author Administrator, 16-09-11 19:09:29
 *
 *  显示文件详情
 */

@interface ZWFileDetailViewController : UIViewController

// 文件路径
@property (nonatomic, strong) NSString *path;
// 记录文件属于哪个课程
@property (nonatomic, strong) NSString *course;

@property (nonatomic, strong) ZWFile *file;

@property (nonatomic, strong) NSString *fileId;
@property (nonatomic, strong) NSString *zanNum;
@property (nonatomic, strong) NSString *caiNum;
// 文件存储于磁盘的文件名 防止重名   在下载页跳转至此时直接赋值可节省时空
@property (nonatomic, strong) NSString *storage_name;

@property (nonatomic, assign) BOOL hasDownloaded;

@property (nonatomic, copy) void (^downloadCompletion)();

@end
