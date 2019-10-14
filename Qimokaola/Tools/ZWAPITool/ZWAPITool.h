//
//  ZWAPITool.h
//  Qimokaola
//
//  Created by Administrator on 16/8/23.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZWAPITool : NSObject

+ (NSString *)base;

+ (NSString *)api;

+ (NSString *)user;

+ (NSString *)school;

+ (NSString *)dbfs;

+ (NSString *)dbfsInUnknowSchool;

+ (NSString *)sendCodeAPI;

+ (NSString *)smsSendCodeAPI;

+ (NSString *)verifyCodeAPI;

+ (NSString *)smsVerifyCodeAPI;

+ (NSString *)listSchoolAPI;

+ (NSString *)listAcademyAPI;

+ (NSString *)registerAPI;

+ (NSString *)loginAPI;

+ (NSString *)uploadAvatarAPI;

+ (NSString *)userInfoAPI;

+ (NSString *)listFileAndFolderAPI;

+ (NSString *)modifyUserInfoAPI;

+ (NSString *)logoutAPI;

+ (NSString *)downloadUrlAPI;

+ (NSString *)infoByNameAPI;

+ (NSString *)shareFileAPI;

+ (NSString *)sbAPI;

+ (NSString *)appInfoAPI;

+ (NSString *)uploadFileAPI;

+ (NSString *)resetPwdAPI;

+ (NSString *)oauthLoginAPI;

+ (NSString *)goodListAPI;

+ (NSString *)goodStateAPI;

+ (NSString *)addOrderAPI;

+ (NSString *)payOrderAPI;

+ (NSString *)listOrderAPI;

@end
