//
//  ZWPrintOrder.h
//  Qimokaola
//
//  Created by Administrator on 2017/6/3.
//  Copyright © 2017年 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "ZWGood.h"

@interface ZWPrintOrder : NSObject <NSCopying, NSCoding>

@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *payTime;
@property (nonatomic, copy) NSString *successTime;
@property (nonatomic, assign) CGFloat totalPrice;
@property (nonatomic, strong) NSArray<ZWGood *> *goodList;

@end
