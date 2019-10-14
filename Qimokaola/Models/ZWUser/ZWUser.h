//
//  ZWUser.h
//  Qimokaola
//
//  Created by Administrator on 16/9/4.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <YYModel/YYModel.h>

@interface ZWUser : NSObject <NSCoding, NSCopying>

// 用户唯一标识
@property (nonatomic, copy) NSString *uid;
// 用户用户名 手机号 或者 管理员身份
@property (nonatomic, copy) NSString *username;
// 用户昵称
@property (nonatomic, copy) NSString *nickname;
// 用户性别
@property (nonatomic, copy) NSString *gender;
// 学校ID
@property (nonatomic, strong) NSNumber *collegeId;
// 学校名
@property (nonatomic, copy) NSString *collegeName;
// 学院ID
@property (nonatomic, strong) NSNumber *academyId;
// 学院名
@property (nonatomic, copy) NSString *academyName;
// 头像url
@property (nonatomic, copy) NSString *avatar_url;
// 是否是管理员身份
@property (nonatomic, assign) BOOL isAdmin;
// 手机电话
@property (nonatomic, copy) NSString *phone;
// 入学年份
@property (nonatomic, copy) NSString *enterYear;
//第三方登录的平台ID
@property (nonatomic, copy) NSString *platformId;
//第三方登录的平台名字
@property (nonatomic, copy) NSString *platform;
// 以下两个变量首次登录无效 用已标记登录用户当前所选择的学校 若未登录置空
// 当前选择的学校id
@property (nonatomic, copy) NSNumber *currentCollegeId;
// 当前选择的学校名
@property (nonatomic, copy) NSString *currentCollegeName;
//登录token
@property (nonatomic,copy) NSString *token;
@end
