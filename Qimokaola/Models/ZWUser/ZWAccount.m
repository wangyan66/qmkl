//
//  ZWAccount.m
//  Qimokaola
//
//  Created by Administrator on 2016/11/30.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZWAccount.h"

#import <YYModel/YYModel.h>
#import <YYCategories/YYCategories.h>

#import "ZWPathTool.h"

static NSString *const kAESKey = @"7gy2r78t2bh9p8uI";
static NSString *const kAccoutStorageFileName = @"Account.dat";

@implementation ZWAccount

- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self yy_modelInitWithCoder:aDecoder]; }
- (id)copyWithZone:(NSZone *)zone { return [self yy_modelCopy]; }
- (NSUInteger)hash { return [self yy_modelHash]; }
- (BOOL)isEqual:(id)object { return [self yy_modelIsEqual:object]; }
- (NSString *)description { return [self yy_modelDescription]; }

- (BOOL)writeData {
    NSData *rawData = [NSKeyedArchiver archivedDataWithRootObject:self];
    NSData *encodedData = [rawData aes256EncryptWithKey:[kAESKey dataUsingEncoding:NSUTF8StringEncoding] iv:nil];
    return [encodedData writeToFile:[[ZWPathTool accountDirectory] stringByAppendingPathComponent:kAccoutStorageFileName] atomically:YES];
}

- (BOOL)readData {
    NSData *rawData = [NSData dataWithContentsOfFile:[[ZWPathTool accountDirectory] stringByAppendingPathComponent:kAccoutStorageFileName]];
    NSData *decodedData = [rawData aes256DecryptWithkey:[kAESKey dataUsingEncoding:NSUTF8StringEncoding] iv:nil];
    ZWAccount *account = (ZWAccount *)[NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
    NSLog(@"读入的缓存token%@",account.token);
    self.account = account.account;
    self.pwd = account.pwd;
    self.token=account.token;
    NSLog(@"readtoken%@",account.token);
    return account != nil;  

}

@end
