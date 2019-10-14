//
//  ZWAPIRequestTool.h
//  Qimokaola
//
//  Created by Administrator on 16/8/28.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZWAPITool.h"
#import "ZWNetworkingManager.h"
#import <CommonCrypto/CommonDigest.h>

typedef void(^APIRequestResult)(id response, BOOL success);

@interface ZWAPIRequestTool : NSObject
+ (void)requestTest;
+ (NSString *)getUTFStringByTextString:(NSString *)textString;

//添加私密评论
+ (void)requestAddPrivateCommentWithToken:(NSString *)token postId:(NSString *)postId userId:(NSString *)userId content:(NSString *)content result:(APIRequestResult)result;

//在线预览
//+(void)requestOnlineWatchWithMD5:(NSString *)MD5 ID:(NSString *)ID View:(NSString *)view;
//获取帖子列表
+(void)requestCommentListWithToken:(NSString *)token number:(NSString *)num page:(NSString *)page result:(APIRequestResult)result;
//发帖
+ (void)requestAddPostWithToken:(NSString *)token content:(NSString *)content result:(APIRequestResult)result;
//查询我的帖子
+ (void)requestMyPostWithToken:(NSString *)token page:(NSString *)page number:(NSString *)num result:(APIRequestResult)result;
//查询某个帖子
+ (void)requestPostInfoWithPostId:(NSString *)postId token:(NSString *)token result:(APIRequestResult)result;

//添加评论
+ (void)requestAddCommentWithToken:(NSString *)token postId:(NSString *)postId comment:(NSString *)comment userId:(NSString *)userId result:(APIRequestResult)result;
//返回对应帖子的评论
+(void)requestDetailCommentWithToken:(NSString *)token posetId:(NSString *)postId page:(NSString *)page number:(NSString*)num result:(APIRequestResult)result;
//查询我的评论
+(void)requestMyCommentWithToken:(NSString *)token page:(NSString *)page number:(NSString *)num result:(APIRequestResult)result;

//判断帖子是否点赞
+ (void)requestIfZanWithToken:(NSString *)token postId:(NSString *)postId result:(APIRequestResult)result;
//帖子点赞
+ (void)requestZanWithToken:(NSString *)token postId:(NSString *)postId result:(APIRequestResult)result;
//赞我的
+ (void)requestReceivedZanWithToken:(NSString *)token page:(NSString *)page number:(NSString *)num result:(APIRequestResult)result;
//我的收藏
+ (void)requestMyCollectionWithToken:(NSString *)token page:(NSString *)page number:(NSString *)num result:(APIRequestResult)result;
//添加收藏
+ (void)requestAddCollectionWithToken:(NSString *)token postId:(NSString *)postId result:(APIRequestResult)result;
//取消收藏
//+ (void)requestCancelCollectionWithToken:(NSString *)token postId:(NSString *)postId result:(APIRequestResult)result;
//是否收藏
+ (void)requestIfCollectedWithToken:(NSString *)token postId:(NSString *)postId result:(APIRequestResult)result;
// 请求验证码
+ (void)requestSendCodeWithParameter:(id)param result:(APIRequestResult)result;
+ (void)requestSmsSendCodeWithPhoneNumber:(NSString *)phoneNumber result:(APIRequestResult)result;
// 验证验证码
+ (void)requestVerifyCodeWithParameter:(id)param result:(APIRequestResult)result;
+ (void)requestSmsVerifyCodeWithCode:(NSString *)code result:(APIRequestResult)result;
// 获得学校列表
+ (void)requestListSchool:(APIRequestResult)result;
// 获得学院列表
+ (void)requestListAcademyWithParameter:(id)param result:(APIRequestResult)result;
// 放到具体控制器实现
//// 注册
//+ (void)requestRegisterWithParameter:(id)params result:(APIRequestResult)result;
//新注册
+ (void)requestRegisterWithParameter:(id)params result: (APIRequestResult)result;

// 登录
+ (void)requestLoginWithParameters:(id)params result:(APIRequestResult)result;
//获取登录信息
+ (void)requestLoginInfoWithParameters:(id)params result:(APIRequestResult)result;
//第三方登录给服务器信息
+ (void)requestOauthLoginWithPlatformId:(NSString *)platformId platform:(NSString *)platform result:(APIRequestResult)result;
//第三方登录完善用户信息
+ (void)requestOauthUserInfoWithParams:(id)params result:(APIRequestResult)result;
// 上传头像
+ (void)requestUploadAvatarWithParamsters:(id)params constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block result:(APIRequestResult)result;
//上传文件
+ (NSURLSessionDataTask *)requestUploadFileWithParamsters:(id)params constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block result:(APIRequestResult)result;
// 用户信息
+ (void)requestUserInfo:(APIRequestResult)result;
// 请求文件夹与文件
+ (void)requstFileAndFolderListInSchool:(NSNumber *)collegeId path:(NSString *)path needDetail:(BOOL)needDetail result:(APIRequestResult)result;
+ (void)requestFileListInSchool:(NSString *)collegeName path:(NSString *)path token:(NSString *)token result: (APIRequestResult)result;
//请求文件夹的具体信息
+ (void)requestDetailInfoOfFileInPath:(NSString *)path college:(NSString *)collegeName token:(NSString *)token result:(APIRequestResult)result;
// 修改用户信息
+ (void)requestModifyUserInfoWithParameters:(id)params result:(APIRequestResult)result;

+ (void)requestResetPasswordWithUserName:(NSString *)userName newPassword:(NSString *)newPassword token:(NSString *)token vercode:(NSString *)vercode result:(APIRequestResult)result;

+ (void)requestResetPasswordWithUserName:(NSString *)userName newPassword:(NSString *)newPassword result:(APIRequestResult)result;

+ (void)requestLogout:(NSString *)phoneNumber :(APIRequestResult)result;

+ (void)requestDownloadUrlInSchool:(NSNumber *)collegeId path:(NSString *)path result:(APIRequestResult)result;

+ (void)requestDownloadUrlWithCollegeName:(NSString *)collegeName path:(NSString *)path token:(NSString *)token result:(APIRequestResult)result;

+ (void)reuqestInfoByName:(NSString *)username result:(APIRequestResult)result;

+ (void)requestSBInfo:(APIRequestResult)result;

+ (void)requestAppInfo:(APIRequestResult)result;

+ (void)requestOauthLoginWithPlatform:(NSString *)platform openId:(NSString *)openId accessToken:(NSString *)accessToken result:(APIRequestResult)result;

+ (void)requestGoodList:(APIRequestResult)result;

+ (void)requestAddOrderWithBuyer:(NSString *)buyer address:(NSString *)address phone:(NSString *)phone goodList:(NSString *)goodList result:(APIRequestResult)result;

+ (void)requestPayOrderWithUUID:(NSString *)uuid payType:(NSString *)payType result:(APIRequestResult)result;

+ (void)requestListOrderWithPageNumber:(NSUInteger)pageNumber result:(APIRequestResult)result;

+ (void)requestGoodStateWithResult:(APIRequestResult)result;
//点赞和踩
+ (void)requestZanWithFileId:(NSString *)fileId result:(APIRequestResult)result;
+ (void)requestCaiWithFileId:(NSString *)fileId result:(APIRequestResult)result;
+ (void)requestIfZanWithFileId:(NSString *)fileId result:(APIRequestResult)result;
+ (void)requestIfCaiWithFileId:(NSString *)fileId result:(APIRequestResult)result;
//加密
+ (NSString *) sha1:(NSString *)inputStr;
@end
