//
//  ZWAcademyCell.h
//  Qimokaola
//
//  Created by Administrator on 16/9/10.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @author Administrator, 16-09-10 20:09:47
 *
 *  显示课程的cell(只显示课程文件夹 因课程文件夹cell需要特殊效果) 只显示根目录的文件夹
 */

@interface ZWCourseCell : UITableViewCell

@property (nonatomic, strong) UIButton *collectButton;

@property (nonatomic, strong) NSString *folderName;

@property (nonatomic, copy) void(^collectBlock)(BOOL newCollectStatus);

@end
