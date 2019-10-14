//
//  ZWFileBaseType.h
//  Qimokaola
//
//  Created by Administrator on 16/9/10.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <YYModel/YYModel.h>

/**
 *  @author Administrator, 16-09-10 22:09:29
 *
 *  文件基类 抽象出文件与文件夹的共同属性
 */

@interface ZWFileBaseType : NSObject <NSCopying, NSCoding>

// 文件(夹)名
@property (nonatomic, strong) NSString *name;
// 创建时间
@property (nonatomic, strong) NSString *ctime;
// 上传或者创建用户
@property (nonatomic, strong) NSString *creator;
// 相关用户id
@property (nonatomic, strong) NSString *uid;

@end
