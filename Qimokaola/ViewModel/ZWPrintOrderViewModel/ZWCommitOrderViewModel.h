//
//  ZWCommitOrderViewModel.h
//  Qimokaola
//
//  Created by Administrator on 2017/5/31.
//  Copyright © 2017年 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACCommand;
@class ZWGood;
@interface ZWCommitOrderViewModel : NSObject

@property (nonatomic, strong) NSString *buyerName;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *phone;

@property (nonatomic, strong) NSString *payType;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) RACCommand *commitOrderCommand;

- (instancetype)initWithGood:(ZWGood *)good;

@end
