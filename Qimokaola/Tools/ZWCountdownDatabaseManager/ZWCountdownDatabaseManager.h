//
//  ZWCountdownDatabaseManager.h
//  Qimokaola
//
//  Created by Administrator on 2017/2/23.
//  Copyright © 2017年 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZWCountdown.h"

@interface ZWCountdownDatabaseManager : NSObject

+ (instancetype)defaultManager;

- (NSMutableArray *)fetchCountdownList;

- (BOOL)addCountdown:(ZWCountdown *)countdown;

- (BOOL)deleteCountdown:(ZWCountdown *)countdown;

- (BOOL)isCountdownExist:(ZWCountdown *)countdown;

- (BOOL)updateCountdown:(ZWCountdown *)countdown;

@end
