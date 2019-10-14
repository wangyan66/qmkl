//
//  ZWRegisterViewModel.m
//  Qimokaola
//
//  Created by Administrator on 2016/11/26.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZWRegisterViewModel.h"
#import "ZWAPIRequestTool.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "ZWUserManager.h"
@implementation ZWRegisterViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
//    RACSignal *phoneNumberValidSignal = [RACObserve(self, phoneNumer) map:^id(NSString *value) {
//        return @([self isPhoneNumberValid:value]);
//    }];
//    RACSignal *verifyCodeValidSignal = [RACObserve(self, verifyCode) map:^id(NSString *value) {
//        return @([self isVeifyCodeValid:value]);
//    }];
//    RACSignal *passwordValidSignal = [RACObserve(self, password) map:^id(NSString *value) {
//        return @([self isPasswordValid:value]);
//    }];
//    
//    RACSignal *nextButtonEnableSignal = [RACSignal combineLatest:@[phoneNumberValidSignal, verifyCodeValidSignal, passwordValidSignal] reduce:^(NSNumber *phoneNumberValid, NSNumber *verifyCodeValid, NSNumber *passwordValid){
//        return @(phoneNumberValid.boolValue && verifyCodeValid.boolValue && passwordValid.boolValue);
//    }];
    
//    self.verifyCommand = [[RACCommand alloc] initWithEnabled:RACObserve(self, verifyButtonEnable) signalBlock:^RACSignal *(id input) {
//        return [self getVerifyCodeSignal];
//    }];
//    
//    self.registerCommand = [[RACCommand alloc] initWithEnabled:nextButtonEnableSignal signalBlock:^RACSignal *(id input) {
//        return [self verifyCodeSignal];
//    }];
    
    @weakify(self)
    self.verifyCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [self getVerifyCodeSignal];
    }];
    //与下一步，完善资料按钮绑定
    self.registerCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [self verifyCodeSignal];
        
    }];
    
}
//原来的验证信号,先发送给服务器验证码,然后再注册信息
//现在直接发送账号密码和验证码给服务器注册，然后再完善资料
//好的 现在变成原来了- -
- (RACSignal *)verifyCodeSignal {
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        if ([ZWUserManager sharedInstance].messageToken) {
            [ZWAPIRequestTool requestVerifyCodeWithParameter:@{@"vercode": self.verifyCode,@"phone":self.phoneNumer,@"token":[ZWUserManager sharedInstance].messageToken} result:^(id response, BOOL success) {
                NSLog(@"注册验证时返回的result%@",response);
                if (success) {
                    NSLog(@"注册验证成功连接服务器时返回的response%@",response);
                    [subscriber sendNext:response];
                    [subscriber sendCompleted];
                } else {
                    [subscriber sendError:response];
                }
            }];
        }else{
            [subscriber sendError:nil];
        }
//        NSDictionary *shit=@{@"shit":@"shit"};
//        [subscriber sendNext: shit];
//        [subscriber sendCompleted];
        return nil;
    }] ;
    
}
//发送短信验证码注册新号
- (RACSignal *)getVerifyCodeSignal {
    @weakify(self)
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        [ZWAPIRequestTool requestSendCodeWithParameter:@{@"phone": self.phoneNumer,@"msg":@"注册"} result:^(id response, BOOL success) {
            if (success) {
                [subscriber sendNext:response];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:response];
            }
        }];
        return nil;
    }] timeout:5 onScheduler:[RACScheduler scheduler]];
}

- (BOOL)isPhoneNumberValid:(NSString *)phoneNumber {
    return phoneNumber.length == kPhoneNumberLength;
}

- (BOOL)isPasswordValid:(NSString *)password {
    return password.length >= 6;
}

- (BOOL)isVeifyCodeValid:(NSString *)verifyCode {
    return verifyCode.length >= 4;
//    if (verifyCode.length < 4) {
//        return NO;
//    }
//    NSScanner *scanner = [NSScanner scannerWithString:verifyCode];
//    int var;
//    return [scanner scanInt:&var] && [scanner isAtEnd];
}

@end
