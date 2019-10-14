//
//  ZWResetPwdViewModel.m
//  Qimokaola
//
//  Created by Administrator on 2016/11/30.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZWResetPwdViewModel.h"
#import "ZWAPIRequestTool.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation ZWResetPwdViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    @weakify(self)
    RACSignal *phoneNumberValidSignal = [RACObserve(self, phoneNumer) map:^id(NSString *value) {
        @strongify(self)
        return @([self isPhoneNumberValid:value]);
    }];
    RACSignal *verifyCodeValidSignal = [RACObserve(self, verifyCode) map:^id(NSString *value) {
        @strongify(self)
        return @([self isVeifyCodeValid:value]);
    }];
    RACSignal *passwordValidSignal = [RACObserve(self, password) map:^id(NSString *value) {
        @strongify(self)
        return @([self isPasswordValid:value]);
    }];
    
    RACSignal *nextButtonEnableSignal = [RACSignal combineLatest:@[phoneNumberValidSignal, verifyCodeValidSignal, passwordValidSignal] reduce:^(NSNumber *phoneNumberValid, NSNumber *verifyCodeValid, NSNumber *passwordValid){
        return @(phoneNumberValid.boolValue && verifyCodeValid.boolValue && passwordValid.boolValue);
    }];
    
    self.verifyCommand = [[RACCommand alloc] initWithEnabled:RACObserve(self, verifyButtonEnable) signalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [self getVerifyCodeSignal];
    }];
    
    self.resetCommand = [[RACCommand alloc] initWithEnabled:nextButtonEnableSignal signalBlock:^RACSignal *(id input) {
        @strongify(self)
//        return [[self verifyCodeSignal] flattenMap:^RACStream *(id value) {
//            return [self resetPwdSignal:value];
//        }];
        return [self resetPwdSignal];
    }];
}
//先将验证码发送 若正确则进行下一步请求(舍去)
- (RACSignal *)verifyCodeSignal {
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        [ZWAPIRequestTool requestSmsVerifyCodeWithCode:self.verifyCode result:^(id response, BOOL success) {
            [subscriber sendNext:response];
            [subscriber sendCompleted];
        }];
        return nil;
    }] ;
    
}
//重设密码按钮
- (RACSignal *)resetPwdSignal{
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
//            [ZWAPIRequestTool requestResetPasswordWithUserName:self.phoneNumer
//                                                   newPassword:self.password result:^(id response, BOOL success) {
//                                                       if (success) {
//                                                           [subscriber sendNext:response];
//                                                           [subscriber sendCompleted];
//                                                       } else {
//                                                           [subscriber sendError:response];
//                                                       }
//                                                   }];
        NSLog(@"即将发送的token为:%@,verifycode为:%@,",self.token,self.verifyCode);
        NSLog(@"%@",(NSString *)self.token);
        NSString *sha=[ZWAPIRequestTool sha1:self.password];
        if (self.token) {
            [ZWAPIRequestTool requestResetPasswordWithUserName:self.phoneNumer newPassword:sha token:self.token vercode:self.verifyCode result:^(id response, BOOL success) {
                NSLog(@"修改密码请求:%@",response);
                if (success) {
                    [subscriber sendNext:response];
                    [subscriber sendCompleted];
                } else {
                    [subscriber sendError:response];
                }
            }];
        }
        
        return nil;
    }];
}
//- (RACSignal *)resetPwdSignal:(id)lastRequestResult {
//    @weakify(self)
//    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        @strongify(self)
//        if ([lastRequestResult isKindOfClass:[NSError class]]) {
//            [subscriber sendError:lastRequestResult];
//        } else if ([[lastRequestResult objectForKey:kHTTPResponseCodeKey] intValue] != 0) {
//            [subscriber sendNext:lastRequestResult];
//            [subscriber sendCompleted];
//        } else {
//            [ZWAPIRequestTool requestResetPasswordWithUserName:self.phoneNumer
//                                                   newPassword:self.password result:^(id response, BOOL success) {
//                                                       if (success) {
//                                                           [subscriber sendNext:response];
//                                                           [subscriber sendCompleted];
//                                                       } else {
//                                                           [subscriber sendError:response];
//                                                       }
//                                                   }];
//        }
//        return nil;
//    }];
//}

//获取验证码
- (RACSignal *)getVerifyCodeSignal {
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        NSLog(@"我自己的手机号:%@",self.phoneNumer);
        [ZWAPIRequestTool requestSmsSendCodeWithPhoneNumber:self.phoneNumer result:^(id response, BOOL success) {
            if (success) {
                [subscriber sendNext:response];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:response];
            }
        }];
        return nil;
    }];
}

- (BOOL)isPhoneNumberValid:(NSString *)phoneNumber {
    return phoneNumber.length == kPhoneNumberLength;
}

- (BOOL)isPasswordValid:(NSString *)password {
    return password.length >= 6;
}

- (BOOL)isVeifyCodeValid:(NSString *)verifyCode {
    
    /// 只要求所填长度大于四
    
    return verifyCode.length >= 4;
    
    
    
    //    if (verifyCode.length < 4) {
    //        return NO;
    //    }
    //    NSScanner *scanner = [NSScanner scannerWithString:verifyCode];
    //    int var;
    //    return [scanner scanInt:&var] && [scanner isAtEnd];
}

@end
