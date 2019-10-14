//
//  ZWCountdown.m
//  Qimokaola
//
//  Created by Administrator on 2017/2/23.
//  Copyright © 2017年 Administrator. All rights reserved.
//

#import "ZWCountdown.h"

#import <YYModel/YYModel.h>

@implementation ZWCountdown

- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self yy_modelInitWithCoder:aDecoder]; }
- (id)copyWithZone:(NSZone *)zone { return [self yy_modelCopy]; }
- (NSUInteger)hash { return [self yy_modelHash]; }
- (BOOL)isEqual:(id)object { return [self yy_modelIsEqual:object]; }
- (NSString *)description { return [self yy_modelDescription]; }

@end
