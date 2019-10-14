//
//  ZWCourseViewController.h
//  Qimokaola
//
//  Created by Administrator on 16/9/10.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWBaseSearchViewController.h"

#import "NSString+Extension.h"
#import "ZWFolder.h"
#import "ZWAPIRequestTool.h"
#import "ZWUserManager.h"
#import "ZWFileAndFolderViewController.h"
#import "ZWCourseCell.h"
#import "ZWPathTool.h"
#import "ZWUploadMethodViewController.h"
#import "ZWSwitchSchollViewController.h"

#import "ZWHUDTool.h"


#import "ZWCourseHeader.h"
#import <LinqToObjectiveC/LinqToObjectiveC.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>

#import <YYCache/YYCache.h>

/**
 *  @author Administrator, 16-09-10 21:09:47
 *
 *  显示每个学校所有课程文件夹 继承自ZWFileAndFolderViewController
 */

@interface ZWCourseViewController : ZWBaseSearchViewController

- (void)loadRemoteData:(NSDictionary *)data;


/**
 标记是否是处于上传文件页面的选择上传科目页
 */
@property (nonatomic, assign) BOOL isChooseCourseViewController;

@end
