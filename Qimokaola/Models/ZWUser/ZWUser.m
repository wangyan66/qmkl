//
//  ZWUser.m
//  Qimokaola
//
//  Created by Administrator on 16/9/4.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZWUser.h"

@implementation ZWUser

- (void)encodeWithCoder:(NSCoder *)aCoder {[self yy_modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self yy_modelInitWithCoder:aDecoder]; }
- (id)copyWithZone:(NSZone *)zone { return [self yy_modelCopy]; }
- (NSUInteger)hash { return [self yy_modelHash]; }
- (BOOL)isEqual:(id)object { return [self yy_modelIsEqual:object]; }
- (NSString *)description { return [self yy_modelDescription]; }

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"uid" : @"id",
             @"academyId" : @"AcademyId",
             @"collegeId" : @"CollegeId",
             @"avatar_url" : @"avatar",
             @"academyName":@"academy",
             @"collegeName":@"college"
             };
}
- (void)setToken:(NSString *)token{
    NSLog(@"token由%@变为%@",self.token,token);
    _token=token;
}
@end
