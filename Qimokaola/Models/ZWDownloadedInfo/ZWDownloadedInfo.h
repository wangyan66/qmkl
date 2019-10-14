//
//  ZWDownloadedInfo.h
//  Qimokaola
//
//  Created by Administrator on 2016/10/8.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZWFile.h"

@interface ZWDownloadedInfo : NSObject

@property (nonatomic, strong) ZWFile *file;

@property (nonatomic, strong) NSString *storage_name;

@property (nonatomic, strong) NSString *school;

@property (nonatomic, strong) NSString *course;

@property (nonatomic, strong) NSString *lastAccessTime;

// 暂时不需要
//@property (nonatomic, strong) NSString *extra;

@end
