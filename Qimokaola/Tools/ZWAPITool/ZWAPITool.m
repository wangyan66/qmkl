//
//  ZWAPITool.m
//  Qimokaola
//
//  Created by Administrator on 16/8/23.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZWAPITool.h"

@interface NSString (URLExtension)

// 几个接口路径
- (NSString *)api;
- (NSString *)user;
- (NSString *)school;
- (NSString *)sb;
- (NSString *)dbfs;
- (NSString *)sms;
- (NSString *)good;
- (NSString *)order;

// 详细接口
- (NSString *)sendCode;
- (NSString *)smsSendCode;
- (NSString *)verifyCode;
- (NSString *)smsVerifyCode;
- (NSString *)listSchool;
- (NSString *)listAcademy;
- (NSString *)register;
- (NSString *)uploadAvatar;
- (NSString *)login;
- (NSString *)userInfo;
- (NSString *)modifyUserInfo;
- (NSString *)logout;
- (NSString *)infobyname;
- (NSString *)resetPwd;
- (NSString *)oauthLogin;
- (NSString *)goodList;
- (NSString *)goodState;
- (NSString *)addOrder;
- (NSString *)payOrder;
- (NSString *)listOrder;


@end

@implementation NSString (URLExtension)

- (NSString *)api {
    return [self stringByAppendingString:@"/api"];
}

- (NSString *)user {
    return [self stringByAppendingString:@"/user"];
}

- (NSString *)school {
    return [self stringByAppendingString:@"/school"];
}

- (NSString *)sb {
    return [self stringByAppendingString:@"/sb"];
}

- (NSString *)sms {
    return [self stringByAppendingString:@"/sms"];
}

- (NSString *)good {
    return [self stringByAppendingString:@"/good"];
}

- (NSString *)order {
    return [self stringByAppendingString:@"/order"];
}

- (NSString *)sendCode {
    return [self stringByAppendingString:@"/sendCode"];
}

- (NSString *)smsSendCode {
    return [self stringByAppendingString:@"/send"];
}


- (NSString *)verifyCode {
    return [self stringByAppendingString:@"/verifyCode"];
}

- (NSString *)smsVerifyCode {
    return [self stringByAppendingString:@"/verify"];
}

- (NSString *)listSchool {
    return [self stringByAppendingString:@"/list"];
}

- (NSString *)listAcademy {
    return [self stringByAppendingString:@"/listAcademy"];
}

- (NSString *)register {
    return [self stringByAppendingString:@"/register"];
}

- (NSString *)uploadAvatar {
    return [self stringByAppendingString:@"/upload"];
}

- (NSString *)login {
    return [self stringByAppendingString:@"/login"];
}

- (NSString *)userInfo {
    return [self stringByAppendingString:@"/info"];
}

- (NSString *)dbfs {
    return [self stringByAppendingString:@"/dbfs"];
}

- (NSString *)modifyUserInfo {
    return [self stringByAppendingString:@"/modify"];
}

- (NSString *)logout {
    return [self stringByAppendingString:@"/logout"];
}

- (NSString *)infobyname {
    return [self stringByAppendingString:@"/infobyname"];
}

- (NSString *)resetPwd {
    return [self stringByAppendingString:@"/resetpw"];
}

- (NSString *)oauthLogin {
    return [self stringByAppendingString:@"/oauthLogin"];
}

- (NSString *)goodList {
    return [self stringByAppendingString:@"/list2"];
}

- (NSString *)addOrder {
    return [self stringByAppendingString:@"/add"];
}

- (NSString *)payOrder {
    return [self stringByAppendingString:@"/pay"];
}

- (NSString *)listOrder {
    return [self stringByAppendingString:@"/list"];
}

- (NSString *)goodState {
    return [self stringByAppendingString:@"state"];
}

@end

@implementation ZWAPITool

+ (NSString *)base {
    return @"https://finalexam.cn";
}

+ (NSString *)sendCodeAPI {
    return [[ZWAPITool user] sendCode];
}

+ (NSString *)smsSendCodeAPI {
    return [[ZWAPITool sms] smsSendCode];
}

+ (NSString *)verifyCodeAPI {
    return [[ZWAPITool user] verifyCode];
}

+ (NSString *)smsVerifyCodeAPI {
    return [[ZWAPITool sms] smsVerifyCode];
}

+ (NSString *)listSchoolAPI {
    return [[ZWAPITool school] listSchool];
}

+ (NSString *)listAcademyAPI {
    return [[ZWAPITool school] listAcademy];
}

+ (NSString *)registerAPI {
    return [[ZWAPITool user] register];
}

+ (NSString *)loginAPI {
    return [[ZWAPITool user] login];
}

+ (NSString *)uploadAvatarAPI {
    return [[ZWAPITool user] uploadAvatar];
}

+ (NSString *)userInfoAPI {
    return [[ZWAPITool user] userInfo];
}

+ (NSString *)listFileAndFolderAPI {
    return [[ZWAPITool dbfsInUnknowSchool] stringByAppendingString:@"/list"];
}

+ (NSString *)modifyUserInfoAPI {
    return [[ZWAPITool user] modifyUserInfo];
}

+ (NSString *)logoutAPI {
    return [[ZWAPITool user] logout];
}

+ (NSString *)downloadUrlAPI {
    return [[ZWAPITool dbfsInUnknowSchool] stringByAppendingString:@"/downloadurl"];;
}

+ (NSString *)uploadFileAPI {
    return [[ZWAPITool dbfsInUnknowSchool] stringByAppendingString:@"/upload"];
}

+ (NSString *)infoByNameAPI {
    return [[ZWAPITool user] infobyname];
}

+ (NSString *)resetPwdAPI {
    return [[ZWAPITool user] resetPwd];
}

+ (NSString *)oauthLoginAPI {
    return [[ZWAPITool user] oauthLogin];
}

+ (NSString *)shareFileAPI {
    return [[ZWAPITool dbfs] stringByAppendingString:@"/md5/%@/%@"];
}

+ (NSString *)sbAPI {
    return [[ZWAPITool api] stringByAppendingString:@"/sb/getSB"];
}

+ (NSString *)appInfoAPI {
    return @"http://itunes.apple.com/lookup?id=1054613325";
}

+ (NSString *)goodListAPI {
    return [[ZWAPITool good] goodList];
}

+ (NSString *)goodStateAPI {
    return [[ZWAPITool good] goodState];
}

+ (NSString *)addOrderAPI {
    return [[ZWAPITool order] addOrder];
}

+ (NSString *)payOrderAPI {
    return [[ZWAPITool order] payOrder];
}

+ (NSString *)listOrderAPI {
    return [[ZWAPITool order] listOrder];
}

+ (NSString *)api {
    return [[ZWAPITool base] api];
}

+ (NSString *)user {
    return [[ZWAPITool api] user];
}

+ (NSString *)school {
    return [[ZWAPITool api] school];
}

+ (NSString *)dbfs {
    return [[ZWAPITool api] dbfs];
}

+ (NSString *)sms {
    return [[ZWAPITool api] sms];
}

+ (NSString *)good {
    return [[ZWAPITool api] good];
}

+ (NSString *)order {
    return [[ZWAPITool api] order];
}

+ (NSString *)dbfsInUnknowSchool {
    return [[ZWAPITool dbfs] stringByAppendingString:@"/%d"];
}

@end
