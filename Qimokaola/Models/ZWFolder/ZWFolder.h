//
//  ZWFolder.h
//  Qimokaola
//
//  Created by Administrator on 16/9/9.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZWFileBaseType.h"

/**
 *  @author Administrator, 16-09-09 23:09:28
 *
 *  文件夹类 继承自 ZWFileBaseType
 */

@interface ZWFolder : ZWFileBaseType

// 特殊属性 记录例如读写权限
@property (nonatomic, strong) NSDictionary *extra;

@end
