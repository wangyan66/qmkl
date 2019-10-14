//
//  ZWNetworkingManager.m
//  Qimokaola
//
//  Created by Administrator on 16/7/26.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZWNetworkingManager.h"

@interface ZWNetworkingManager ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

static ZWNetworkingManager *_manager = nil;

@implementation ZWNetworkingManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sessionManager = [AFHTTPSessionManager manager];
        self.sessionManager.requestSerializer.timeoutInterval = 10.0;
        self.sessionManager.requestSerializer=[AFJSONRequestSerializer serializer];
//        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode: AFSSLPinningModeCertificate];
//        NSString *certificatePath = [[NSBundle mainBundle] pathForResource:@"qimokaola" ofType:@"cer"];
//        NSData *certificateData = [NSData dataWithContentsOfFile:certificatePath];
//        
//        NSSet *certificateSet  = [[NSSet alloc] initWithObjects:certificateData, nil];
//        [securityPolicy setPinnedCertificates:certificateSet];
//        securityPolicy.allowInvalidCertificates = YES;
//        securityPolicy.validatesDomainName = NO;
//        self.sessionManager.securityPolicy = securityPolicy;
        
//        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//        securityPolicy.allowInvalidCertificates = YES;
//        self.sessionManager.securityPolicy = securityPolicy;
    }
    return self;
}


+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[ZWNetworkingManager alloc] init];
    });
    return _manager;
}


+ (NSURLSessionDataTask *)getWithURLString:(NSString *)url
                                    params:(id)params
                                  progress:(ProgressBlock)progress
                                   success:(SuccessBlock)success
                                   failure:(FailureBlock)failure {
    
    
    return [[ZWNetworkingManager sharedManager].sessionManager GET:url
                                                        parameters:params
                                                          progress:progress
                                                           success:success
                                                           failure:failure];
}

+ (NSURLSessionDataTask *)getWithURLString:(NSString *)url
                                   success:(SuccessBlock)success
                                   failure:(FailureBlock)failure {
    
    return [ZWNetworkingManager getWithURLString:url
                                          params:nil
                                        progress:nil success:success
                                         failure:failure];
    
}

+ (NSURLSessionDataTask *)getWithURLString:(NSString *)url
                                    params:(id)params
                                   success:(SuccessBlock)success
                                   failure:(FailureBlock)failure {
    
    return [ZWNetworkingManager getWithURLString:url
                                          params:params
                                        progress:nil
                                         success:success
                                         failure:failure];
}

+ (NSURLSessionDataTask *)postWithURLString:(NSString *)url
                                     params:(id)params
                                   progress:(ProgressBlock)preogress
                                    success:(SuccessBlock)success
                                    failure:(FailureBlock)failure {
//    NSDictionary *parameters=@{@"username":@"13157694909",@"password":@"f9e84102d063cf5887093255b7ad7bc64758975f"};
//    NSString *murl=@"http://120.77.32.233/qmkl0.0.7/user/login";
//    AFHTTPSessionManager *managers=[AFHTTPSessionManager manager];
//    managers.requestSerializer=[AFJSONRequestSerializer serializer];
    
//    [managers POST:murl parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"shit--%@",responseObject);
//
//        NSDictionary *dict=(NSDictionary *)responseObject;
//        NSString *msg=dict[@"msg"];
//        NSString *data=dict[@"data"];
//        NSLog(@"%@",msg);
//        NSLog(@"%@",data);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"请求失败");
//    }];
    
    //return [managers POST:murl parameters:parameters progress:nil success:success failure:failure];
   // return [[ZWNetworkingManager sharedManager].sessionManager POST:url parameters:params progress:preogress success:success failure:failure];
    return [[ZWNetworkingManager sharedManager].sessionManager POST:url
                                                         parameters:params
                                                           progress:preogress
                                                            success:success
                                                            failure:failure];
}

+ (NSURLSessionDataTask *)postWithURLString:(NSString *)url
                                     params:(id)params
                                    success:(SuccessBlock)success
                                    failure:(FailureBlock)failure {
    
    
    
    return [ZWNetworkingManager postWithURLString:url
                                           params:params
                                         progress:nil
                                          success:success
                                          failure:failure];
}

+ (NSURLSessionDataTask *)postWithURLString:(NSString *)url
                                     params:(id)params
                  constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block
                                   progress:(ProgressBlock)progress
                                    success:(SuccessBlock)success
                                    failure:(FailureBlock)failure {
    
    return [[ZWNetworkingManager sharedManager].sessionManager POST:url
                                                         parameters:params
                                          constructingBodyWithBlock:block
                                                           progress:progress
                                                            success:success
                                                            failure:false];
    
}

+ (BOOL)isNetWorkAvailable {
    return [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable;
}


@end
