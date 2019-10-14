//
//  ZWZWOauthLoginViewModel.m
//  Qimokaola
//
//  Created by Administrator on 2017/3/20.
//  Copyright © 2017年 Administrator. All rights reserved.
//

#import "ZWZWOauthLoginViewModel.h"

#import "ZWAPIRequestTool.h"

#import "ZWUserManager.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
//#import <UMSocialCore/UMSocialCore.h>
#import <UMShare/UMShare.h>
@interface ZWZWOauthLoginViewModel ()

@property (nonatomic, strong) NSArray *platforms;

@property (nonatomic, strong) NSArray *platformType;
@property (nonatomic, strong) NSArray *platformName;

@end

@implementation ZWZWOauthLoginViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    
    _platformName = @[@"qq", @"wx"];
    _platformType = @[@(UMSocialPlatformType_QQ), @(UMSocialPlatformType_WechatSession)];
    
    @weakify(self)
    _oauthLoginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *input) {
        @strongify(self)
        UMSocialPlatformType platformType = (UMSocialPlatformType)[self.platformType[input.tag] integerValue];
        return [[self userInfoSignalWithPlatformType:platformType]
                flattenMap:^RACStream *(id value) {
                    return [self oauthLoginWithGetUserInfoResult:value triggerBtnTag:input.tag];
        }];
    }];
}

- (RACSignal *)userInfoSignalWithPlatformType:(UMSocialPlatformType)platformType {
    NSLog(@"调用userInfoSignalWithPlatformType")
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

        [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType
                                            currentViewController:nil
                                                       completion:^(id result, NSError *error) {
                                                           NSLog(@"友盟第三方登录获取的result:%@", result);
                                                           [subscriber sendNext:result ? result : error];
                                                           [subscriber sendCompleted];
                                                       }];

        return nil;
    }];
}

- (RACSignal *)oauthLoginWithGetUserInfoResult:(id)lastRequestResult triggerBtnTag:(NSInteger)tag {
    @weakify(self)
    NSLog(@"调用oauthLoginWithGetuserInfoResult");
   
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       
        if ([lastRequestResult isKindOfClass:[NSError class]]) {
            NSLog(@"获取快捷登录权限失败");
            [subscriber sendError:(NSError *)lastRequestResult];
        } else if (![lastRequestResult isKindOfClass:[UMSocialUserInfoResponse class]]) {
            [subscriber sendError:nil];
        } else {
            @strongify(self)
            NSLog(@"获取第三方快捷登录权限成功，准备验证权限");
            UMSocialUserInfoResponse *resp = lastRequestResult;
            NSLog(@"权限信息: %@", resp);
            NSDictionary *info=@{@"avatar":resp.iconurl,
                                 @"gender":resp.gender,
                                 @"platform":self.platformName[tag],
                                 @"platformId":resp.openid,
                                 @"nickname":resp.name
                                 };
            ZWUser *user=[ZWUser yy_modelWithDictionary:info];

            
            [ZWUserManager sharedInstance].oauthUser=user;
            NSLog(@"头像的url%@",[ZWUserManager sharedInstance].oauthUser.avatar_url);
//            [ZWUserManager sharedInstance].oauthUser.avatar_url=resp.iconurl;
//            [ZWUserManager sharedInstance].oauthUser.nickname=resp.name;
//            [ZWUserManager sharedInstance].oauthUser.gender=resp.gender;
//            [ZWUserManager sharedInstance].oauthUser.platform=self.platformName[tag];
//            [ZWUserManager sharedInstance].oauthUser.platformId=resp.openid;
            [ZWAPIRequestTool requestOauthLoginWithPlatformId:resp.openid platform:self.platformName[tag] result:^(id response, BOOL success) {
                if (success) {
                    NSLog(@"快捷登录请求成功，等待解析后端数据");
                    [subscriber sendNext:response];
                    [subscriber sendCompleted];
                } else {
                    NSLog(@"快捷登录请求失败,没有访问到服务器");
                    [subscriber sendError:response];
                }
            }];
        }
        
        return nil;
    }];
}


@end
