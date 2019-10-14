//
//  ZWFile.h
//  Qimokaola
//
//  Created by Administrator on 16/9/9.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZWFileBaseType.h"

/**
 *  @author Administrator, 16-09-09 23:09:31
 *
 *  描述文件的类 继承自 ZWFileBaseType
 */

@interface ZWFile : ZWFileBaseType

// 文件大小
@property (nonatomic, strong) NSString *size;

@property (nonatomic, strong) NSString *md5;

@property (nonatomic, assign) BOOL hasDownloaded;

@end
