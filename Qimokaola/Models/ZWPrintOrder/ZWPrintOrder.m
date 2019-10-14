//
//  ZWPrintOrder.m
//  Qimokaola
//
//  Created by Administrator on 2017/6/3.
//  Copyright © 2017年 Administrator. All rights reserved.
//

#import "ZWPrintOrder.h"

#import <YYModel/YYModel.h>

@implementation ZWPrintOrder
- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self yy_modelInitWithCoder:aDecoder]; }
- (id)copyWithZone:(NSZone *)zone { return [self yy_modelCopy]; }
- (NSUInteger)hash { return [self yy_modelHash]; }
- (BOOL)isEqual:(id)object { return [self yy_modelIsEqual:object]; }
- (NSString *)description { return [self yy_modelDescription]; }

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"address" : @"addr",
             @"goodList" : @"list"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"goodList" : [ZWGood class]
             };
}

@end
