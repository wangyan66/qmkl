//
//  ZWFileTool.h
//  Qimokaola
//
//  Created by Administrator on 16/8/23.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSArray *array;

@interface ZWFileTool : NSObject

+ (NSString *)typeWithName:(NSString *)name;
+ (NSString *)sizeWithDouble:(double)size;

+ (NSString *)sizeWithString:(NSString *)sizeString;

+ (NSString *)parseTypeWithString:(NSString *)type;

+ (NSString *)fileTypeFromFileName:(NSString *)fileName;

@end
