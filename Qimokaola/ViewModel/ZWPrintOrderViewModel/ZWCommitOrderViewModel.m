//
//  ZWCommitOrderViewModel.m
//  Qimokaola
//
//  Created by Administrator on 2017/5/31.
//  Copyright © 2017年 Administrator. All rights reserved.
//

#import "ZWCommitOrderViewModel.h"

#import "ZWAPIRequestTool.h"

#include "ZWGood.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ZWCommitOrderViewModel ()

@property (nonatomic, weak) ZWGood *good;

@end

@implementation ZWCommitOrderViewModel

- (instancetype)initWithGood:(ZWGood *)good {
    self = [super init];
    if (self) {
        _good = good;
        _count = 1;
        [self initialize];
        _buyerName = [@"" copy];
    }
    return self;
}

- (void)initialize {
    @weakify(self)
    RACSignal *buyerNameValidSignal = [RACObserve(self, buyerName) map:^id(NSString *value) {
        @strongify(self)
        return @([self isBuyerNameValid:value]);
    }];
    RACSignal *addressValidSignal = [RACObserve(self, address) map:^id(NSString *value) {
        @strongify(self)
        return @([self isAddressValid:value]);
    }];
    RACSignal *phoneValidSignal = [RACObserve(self, phone) map:^id(NSString *value) {
        @strongify(self)
        return @([self isPhoneValid:value]);
    }];
    RACSignal *commitOrderButtonEnableSignal = [RACSignal combineLatest:@[buyerNameValidSignal, addressValidSignal, phoneValidSignal] reduce:^(NSNumber *buyerNameValid, NSNumber *addressValid, NSNumber *phoneValid){
        return @([buyerNameValid boolValue] && [addressValid boolValue] && [phoneValid boolValue]);
    }];
    self.commitOrderCommand = [[RACCommand alloc] initWithEnabled:commitOrderButtonEnableSignal signalBlock:^RACSignal *(id input) {
        @strongify(self)
        
        NSLog(@"%@", @(self.count).stringValue);
        
        return [[self addOrderSignal]
                flattenMap:^RACStream *(NSDictionary *value) {
                    return [self payOrderSignalWithLastResult:value];
                }];
    }];
}

- (RACSignal *)addOrderSignal {
    @weakify(self)
   return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       @strongify(self)
       
       NSString *goodList = [NSString stringWithFormat:@"[[%lu, %ld]]", (unsigned long)self.good.gid, (long)self.count];
       NSLog(@"%@", self.buyerName);
       [ZWAPIRequestTool requestAddOrderWithBuyer:self.buyerName address:self.address phone:self.phone goodList:goodList result:^(id response, BOOL success) {
           if (success) {
               NSLog(@"%@", response);
               if ([[response objectForKey:kHTTPResponseCodeKey] intValue] == 0) {
                   [subscriber sendNext:[response objectForKey:kHTTPResponseResKey]];
                   [subscriber sendCompleted];
               } else {
                   [subscriber sendError:[NSError errorWithDomain:@"" code:1 userInfo:@{@"info" : [response objectForKey:kHTTPResponseInfoKey]}]];
               }
           } else {
               [subscriber sendError:response];
           }
       }];
       
       return nil;
    }];
}

- (RACSignal *)payOrderSignalWithLastResult:(NSDictionary *)lastResult {
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        
        NSLog(@"%@", lastResult);
        
        [ZWAPIRequestTool requestPayOrderWithUUID:[lastResult objectForKey:@"uuid"] payType:self.payType result:^(id response, BOOL success) {
           
            if (success) {
                NSLog(@"%@", response);
                if ([[response objectForKey:kHTTPResponseCodeKey] intValue] == 0) {
                    [subscriber sendNext:[response objectForKey:kHTTPResponseResKey]];
                    [subscriber sendCompleted];
                } else {
                    [subscriber sendError:[NSError errorWithDomain:@"" code:1 userInfo:@{@"info" : [response objectForKey:kHTTPResponseInfoKey]}]];
                }
            } else {
                [subscriber sendError:response];
            }
            
        }];
        
        return nil;
    }];
}

- (BOOL)isBuyerNameValid:(NSString *)buyerName {
    return buyerName.length >= 0;
}

- (BOOL)isAddressValid:(NSString *)address {
    return address.length > 0;
}

- (BOOL)isPhoneValid:(NSString *)phone {
    return phone.length == 11;
}

@end
