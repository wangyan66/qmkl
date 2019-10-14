//
//  ZWUserManager.h
//  Qimokaola
//
//  Created by Administrator on 16/9/4.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZWUser.h"
#import "ZWAPIRequestTool.h"

@interface ZWUserManager : NSObject

// 当前登录的用户
@property (nonatomic, strong) ZWUser *loginUser;
//第三方登录用户的信息
@property (nonatomic, strong) ZWUser *oauthUser;
// 登录状态
@property (nonatomic, assign) BOOL isLogin;
//@property (nonatomic, assign) BOOL isOauth;
@property (nonatomic, copy) NSString *UserToken;
@property (nonatomic, assign) NSInteger unreadCommentCount;
@property (nonatomic, assign) NSInteger unreadLikeCount;
@property (nonatomic, copy) NSString *messageToken;
@property (nonatomic, assign) BOOL HasNetWorking;
+ (instancetype)sharedInstance;

- (void)loginStudentCircle;
- (void)logoutStudentCircle;

// 修改昵称
- (void)modifyUserNickname:(NSString *)nickname result:(APIRequestResult)result;
- (void)updateNickname:(NSString *)nickname;

// 修改性别
- (void)modifyUserGender:(NSString *)gender result:(APIRequestResult)result;
- (void)updateGender:(NSString *)gender;



// 修改学院
//旧
- (void)modifyUserAcademyId:(NSNumber *)academyId result:(APIRequestResult)result;

- (void)updateAcademyId:(NSNumber *)academyId academyName:(NSString *)academyName;
- (void)updateCurrentCollegeId:(NSNumber *)collegeId collegeName:(NSString *)collegeName;
//新
- (void)modifyUserAcademyName:(NSString *)academyName result:(APIRequestResult)result;
- (void)modifyUserSchoolName:(NSString *)schoolName result:(APIRequestResult)result;

// 修改入学年份
- (void)modifyUserEnterYear:(NSString *)enterYear result:(APIRequestResult)result;
- (void)updateEnterYear:(NSString *)enterYear;

//第三方登录完善信息
- (void)modifyOauthUserCollegeName:(NSString *)collegeName academyName:(NSString *)academyName enterYear:(NSString *)enterYear  gender:(NSString *)gender  nickname:(NSString *)nickname result:(APIRequestResult)result;
- (void)updateOauthUserCollegeName:(NSString *)collegeName academyName:(NSString *)academyName enterYear:(NSString *)enterYear  gender:(NSString *)gender  nickname:(NSString *)nickname;
- (void)modifyOauthUserCollegeId:(NSNumber *)collegeId academyId:(NSNumber *)academyId enterYear:(NSString *)enterYear result:(APIRequestResult)result;
- (void)updateOauthUserCollegeId:(NSNumber *)collegeId collegeName:(NSString *)collegeName academyId:(NSNumber *)academyId academyName:(NSString *)academyName enterYear:(NSString *)enterYear;

- (void)updateAvatarUrl:(NSString *)avatarUrl;

- (void)userLogout:(APIRequestResult)result;

@end
