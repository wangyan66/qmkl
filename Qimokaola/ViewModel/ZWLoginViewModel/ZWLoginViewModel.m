//
//  ZWLoginViewModel.m
//  Qimokaola
//
//  Created by Administrator on 16/9/3.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZWLoginViewModel.h"
#import "ZWAPIRequestTool.h"
#import "AFNetworking.h"
#import "ZWUserManager.h"
@implementation ZWLoginViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    
//    RACSignal *accountValidSignal = [RACObserve(self, account) map:^id(NSString *value) {
//        return @([self isAccountValid:value]);
//    }];
//    
//    RACSignal *passwordValidSignal = [RACObserve(self, password) map:^id(NSString *value) {
//        return @([self isPasswordValid:value]);
//    }];
//    
//    RACSignal *commandEnableSignal = [RACSignal combineLatest:@[accountValidSignal, passwordValidSignal] reduce:^id(NSNumber *accountValid, NSNumber *passwordValid){
//        return @([accountValid boolValue] && [passwordValid boolValue]);
//    }];
//    
//    @weakify(self)
//    self.loginCommand = [[RACCommand alloc] initWithEnabled:commandEnableSignal signalBlock:^RACSignal *(id input) {
//        @strongify(self)
//        return [self loginSignal];
//    }];
    
    @weakify(self)
    self.loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [self loginSignal];
    }];
    
}

- (RACSignal *)loginSignal {
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"登录时发送的account: %@ pwd: %@", self.account, self.password);
        //原来是pw和un
        NSString *shaPassword=[ZWAPIRequestTool sha1:self.password];
        [ZWAPIRequestTool requestLoginWithParameters:@{@"username":self.account,@"password":shaPassword}result:^(id response, BOOL success) {
            if (success) {//成功访问服务器
                
               
                NSLog(@"调用了登录接口");
                NSDictionary *result=(NSDictionary *)response;
                int resultCode = [result[kHTTPResponseCodeKey] intValue];
                if (resultCode==200){
                    [ZWUserManager sharedInstance].UserToken=result[kHTTPResponseDataKey];
                    [ZWAPIRequestTool requestLoginInfoWithParameters:@{@"token":result[kHTTPResponseDataKey]} result:^(id responseInfo, BOOL successInfo){
                        if (successInfo) {
                            NSLog(@"调用了请求信息接口");
                            [subscriber sendNext:responseInfo];
                            NSLog(@"%@",responseInfo);
                            //[subscriber sendNext:response];
                            [subscriber sendCompleted];
                        } else {
                            NSLog(@"m1");
                            [subscriber sendError:responseInfo];
                            NSLog(@"获取信息失败");
                            
                        }
                    }];
                }else{
                    NSLog(@"m2");
                    [subscriber sendNext:response];
                    [subscriber sendCompleted];
                }
                //NSLog(@"a big shit");
                //[subscriber sendCompleted];
                
            } else {
                NSLog(@"登录失败");
                [subscriber sendError:response];
            }
        }];
        
        return nil;
    }] delay:kRequestWaitingTime] timeout:5.0 onScheduler:[RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground]];
}

- (BOOL)isAccountValid:(NSString *)value {
    return value.length == kPhoneNumberLength;
}

- (BOOL)isPasswordValid:(NSString *)value {
    return value.length >= 6;
}

@end
