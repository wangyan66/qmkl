//
//  ZWFolder.m
//  Qimokaola
//
//  Created by Administrator on 16/9/9.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZWFolder.h"

@implementation ZWFolder

- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self yy_modelInitWithCoder:aDecoder]; }
- (id)copyWithZone:(NSZone *)zone { return [self yy_modelCopy]; }
- (NSUInteger)hash { return [self yy_modelHash]; }
- (BOOL)isEqual:(id)object { return [self yy_modelIsEqual:object]; }
- (NSString *)description { return [self yy_modelDescription]; }

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"extra" : @"ext"};
}

@end
