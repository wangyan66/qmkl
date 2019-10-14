//
//  ZWUserManager.m
//  Qimokaola
//
//  Created by Administrator on 16/9/4.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZWUserManager.h"
#import "ZWPathTool.h"

//#import "UMessage.h"
//#import <UMCommunitySDK/UMComDataRequestManager.h>
//#import <UMCommunitySDK/UMComSession.h>

#import <YYCache/YYCache.h>
#import <YYCategories/YYCategories.h>

static NSString *const kUserInfoFileName = @"UserInfo.dat";

@interface ZWUserManager ()

@property (nonatomic, strong) YYCache *cache;
@property (nonatomic) dispatch_semaphore_t semaphore;

@end

NSString *const kLoginedUserKey = @"kLoginedUserKey";

@implementation ZWUserManager

+ (instancetype)sharedInstance {
    static ZWUserManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZWUserManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cache = [[YYCache alloc] initWithName:@"UserInfo"];
        self.semaphore = dispatch_semaphore_create(1);
        // 首先检查是否有持久化对象
        self.loginUser = (ZWUser *)[NSKeyedUnarchiver unarchiveObjectWithFile:[[ZWPathTool accountDirectory] stringByAppendingPathComponent:kUserInfoFileName]];
        if(!self.loginUser){
             NSLog(@"meiyou");
        }else{
            NSLog(@"shitfuck%@",self.loginUser);
        }
        
        // 为兼容旧版本 读取缓存中的数据
        if (!self.loginUser) {
            NSLog(@"读取旧版本内容");
            self.loginUser = (ZWUser *)[_cache objectForKey:kLoginedUserKey];
            if (self.loginUser) {
                NSLog(@"读取旧版本内容成功");
                // 移除旧版本对登录控制变量的依赖
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LoginState"];
                [_cache removeObjectForKey:kLoginedUserKey];
                [self writeLoginUserData];
            }
        }
        if (self.loginUser) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kLocalUserLoginStateGuranteedNotification object:nil];
        }
    }
    return self;
}

- (void)loginStudentCircle {
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
//    if (!self.loginUser || [UMComSession sharedInstance].loginUser) {
//        dispatch_semaphore_signal(self.semaphore);
//        return;
//    }
    
    @weakify(self)
/*    [[UMComDataRequestManager defaultManager] userCustomAccountLoginWithName:_loginUser.nickname
                                                                    sourceId:_loginUser.uid
                                                                    icon_url:[[[ZWAPITool base] stringByAppendingString:@"/"] stringByAppendingString:self.loginUser.avatar_url]
                                                                      gender:[_loginUser.gender isEqualToString:@"男"] ? 1 : 0
                                                                         age:0
                                                                      custom:_loginUser.collegeName
                                                                       score:0
                                                                  levelTitle:nil
                                                                       level:0
                                                           contextDictionary:nil
                                                                userNameType:userNameNoRestrict
                                                              userNameLength:userNameLengthNoRestrict
                                                                  completion:^(NSDictionary *responseObject, NSError *error) {
                                                                      @strongify(self)
                                                                      if (error) {
                                                                          NSLog(@"登录发生错误 ;%@", error);
                                                                      } else {
                                                                          if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                                                              UMComUser *user = responseObject[UMComModelDataKey];
                                                                              if (user) {
                                                                                  NSLog(@"登录学生圈成功，登录用户: %@, 自定义字段: %@", user.name, user.custom);
                                                                                  [UMComSession sharedInstance].loginUser = user;
                                                                                  [[UMComDataBaseManager shareManager] saveRelatedIDTableWithType:UMComRelatedRegisterUserID withUsers:@[user]];
                                                                                  [self startFetchCommunityUnreadDataTimer];
                                                                                  // 若自定义字段为null，则更新用户信息确保自定义字段存在
                                                                                  if (!user.custom) {
                                                                                      [[UMComDataRequestManager defaultManager]
                                                                                       updateProfileWithName:user.name
                                                                                       age:user.age
                                                                                       gender:user.gender
                                                                                       custom:self.loginUser.collegeName
                                                                                       userNameType:userNameNoRestrict
                                                                                       userNameLength:userNameLengthNoRestrict
                                                                                       completion:^(NSDictionary *responseObject, NSError *error) {
                                                                                           // 由于友盟SDK bug原因 此处修改信息必定错误 但修改生效 故不考虑结果
                                                                                       }];
                                                                                  }
                                                                                  //[UMComSession sharedInstance].token = responseObject[UMComTokenKey];
                                                                                  
                                                                                  //                                                                                  [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginSucceedNotification object:nil];
                                                                              }
                                                                          }
                                                                      }
                                                                      dispatch_semaphore_signal(self.semaphore);
                                                                  }];
 */
}

- (void)startFetchCommunityUnreadDataTimer {
    // 进入时先获取一遍未读数据
    [self fetchCommunityUnreadData];
    @weakify(self)
    [NSTimer scheduledTimerWithTimeInterval:kFetchUnreadInfoInterval block:^(NSTimer * _Nonnull timer) {
        @strongify(self)
        [self fetchCommunityUnreadData];
    } repeats:YES];
}  

- (void)fetchCommunityUnreadData {
//    @weakify(self)
//    [[UMComDataRequestManager defaultManager] fetchConfigDataWithCompletion:^(NSDictionary *responseObject, NSError *error) {
//        if (responseObject) {
//            @strongify(self)
//            NSDictionary *msgBox = [responseObject objectForKey:@"msg_box"];
//            self.unreadCommentCount = [[msgBox objectForKey:@"comment"] integerValue];
//            self.unreadLikeCount = [[msgBox objectForKey:@"like"] integerValue];
//        }
//    }];
}

- (void)logoutStudentCircle {
    // 如果学生圈已经登录 则登出
//    if ([UMComSession sharedInstance].isLogin) {
//        [[UMComSession sharedInstance] userLogout];
//    }
}
- (void)setUserToken:(NSString *)UserToken{
    NSLog(@"usermanage的token即将从%@变为%@",_UserToken,UserToken);
    _UserToken=UserToken;
}
- (void)setLoginUser:(ZWUser *)loginUser {
    NSLog(@"set user to %@", loginUser);
    if (_loginUser) {
        //NSString *token=_loginUser.token;
        //NSLog(@"setToken:%@",self.UserToken);
        NSNumber *currentCollegeId = _loginUser.currentCollegeId;
        NSString *currentCollegeName = _loginUser.currentCollegeName;
        _loginUser = loginUser;
//        _loginUser.token=_UserToken;
        _loginUser.currentCollegeId = currentCollegeId;
        _loginUser.currentCollegeName = currentCollegeName;
    } else {
        NSLog(@"此时没有loginUser，即将设置新的");
        _loginUser = loginUser;
        
        if (_loginUser) {
            if (!_loginUser.currentCollegeId) {
                _loginUser.currentCollegeId = _loginUser.collegeId;
            }
            if (!_loginUser.currentCollegeName) {
                _loginUser.currentCollegeName = _loginUser.collegeName;
            }
        }
    }
//    if (_loginUser) {
//        [UMessage addTag:_loginUser.collegeName response:nil];
//        [UMessage addTag:_loginUser.gender response:nil];
//    }
    _isLogin = loginUser != nil;
    [self writeLoginUserData];
}

- (void)writeLoginUserData {
    [NSKeyedArchiver archiveRootObject:self.loginUser toFile:[[ZWPathTool accountDirectory] stringByAppendingPathComponent:kUserInfoFileName]];
    if (!self.loginUser) {
        [[NSFileManager defaultManager] removeItemAtPath:[[ZWPathTool accountDirectory] stringByAppendingPathComponent:kUserInfoFileName] error:NULL];
    }
}

- (void)modifyUserNickname:(NSString *)nickname result:(APIRequestResult)result {
    
    [self modifyUserInfo:@{@"nickname" : nickname} result:result];
}

- (void)updateNickname:(NSString *)nickname {
    _loginUser.nickname = [nickname copy];
    [self writeLoginUserData];
}

- (void)modifyUserGender:(NSString *)gender result:(APIRequestResult)result {
    NSLog(@"gender:%@",gender);
    [self modifyUserInfo:@{@"gender" : gender} result:result];
}

- (void)updateGender:(NSString *)gender {
    _loginUser.gender = [gender copy];
    [self writeLoginUserData];
}

- (void)modifyUserAcademyId:(NSNumber *)academyId result:(APIRequestResult)result {
    [self modifyUserInfo:@{@"AcademyId" : academyId} result:result];
}

- (void)modifyUserAcademyName:(NSString *)academyName result:(APIRequestResult)result{
    
    [self modifyUserInfo:@{@"academy": academyName,@"college":self.loginUser.collegeName} result:result];
}
- (void)modifyUserSchoolName:(NSString *)schoolName result:(APIRequestResult)result{
    [self modifyUserInfo:@{@"college": schoolName} result:result];
}

-(void)modifyOauthUserCollegeName:(NSString *)collegeName academyName:(NSString *)academyName enterYear:(NSString *)enterYear gender:(NSString *)gender nickname:(NSString *)nickname result:(APIRequestResult)result{
    NSDictionary *params=@{
        @"platformId":_oauthUser.platformId,
        @"nickname":nickname,
        @"platform":_oauthUser.platform,
        @"gender":gender,
        @"enterYear":enterYear,
        @"avatar":_oauthUser.avatar_url,
        @"college":collegeName,
        @"academy" :academyName
    };
    [ZWAPIRequestTool requestOauthUserInfoWithParams:params result:result];
}

- (void)updateOauthUserCollegeName:(NSString *)collegeName academyName:(NSString *)academyName enterYear:(NSString *)enterYear gender:(NSString *)gender nickname:(NSString *)nickname{
    _loginUser.collegeName=[collegeName copy];
_loginUser.currentCollegeName=[collegeName copy];
    _loginUser.academyName=[academyName copy];
    _loginUser.enterYear=[enterYear copy];
    
}
- (void)modifyOauthUserCollegeId:(NSNumber *)collegeId academyId:(NSNumber *)academyId enterYear:(NSString *)enterYear result:(APIRequestResult)result {
    [self modifyUserInfo:@{
                           @"CollegeId" : collegeId,
                           @"AcademyId": academyId,
                           @"enterYear" : enterYear
                           } result:result];
}


- (void)updateOauthUserCollegeId:(NSNumber *)collegeId collegeName:(NSString *)collegeName academyId:(NSNumber *)academyId academyName:(NSString *)academyName enterYear:(NSString *)enterYear {
    _loginUser.collegeId = collegeId;
    _loginUser.currentCollegeId = collegeId;
    _loginUser.collegeName = [collegeName copy];
    _loginUser.currentCollegeName = [collegeName copy];
    _loginUser.academyId = academyId;
    _loginUser.academyName = [academyName copy];
    _loginUser.enterYear = [enterYear copy];
    
    [self writeLoginUserData];
}

- (void)updateAcademyId:(NSNumber *)academyId academyName:(NSString *)academyName {
    _loginUser.academyId = academyId;
    _loginUser.academyName = [academyName  copy];
    [self writeLoginUserData];
}


- (void)updateCurrentCollegeId:(NSNumber *)collegeId collegeName:(NSString *)collegeName {
    _loginUser.currentCollegeId = collegeId;
    _loginUser.collegeName = [collegeName copy];
    [self writeLoginUserData];
}

- (void)modifyUserEnterYear:(NSString *)enterYear result:(APIRequestResult)result {
    [self modifyUserInfo:@{@"enterYear" : enterYear} result:result];
}

- (void)updateEnterYear:(NSString *)enterYear {
    _loginUser.enterYear = [enterYear copy];
    [self writeLoginUserData];
}

- (void)updateAvatarUrl:(NSString *)avatarUrl {
    _loginUser.avatar_url = [avatarUrl copy];
   [self writeLoginUserData];
}

- (void)modifyUserInfo:(id)params result:(APIRequestResult)result {
    NSDictionary *modifyParams=@{@"token":self.loginUser.token,@"user":params};
    [ZWAPIRequestTool requestModifyUserInfoWithParameters:modifyParams result:result];
}

- (void)userLogout:(APIRequestResult)result {
    [ZWAPIRequestTool requestLogout:_loginUser.phone :result];
}

@end
