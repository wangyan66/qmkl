//
//  ZWAccount.h
//  Qimokaola
//
//  Created by Administrator on 2016/11/30.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZWAccount : NSObject <NSCoding, NSCopying>

- (BOOL)readData;
- (BOOL)writeData;

@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *pwd;
@property (nonatomic, strong) NSString *token;


@end
