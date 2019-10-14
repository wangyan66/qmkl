//
//  ZWAPIRequestTool.m
//  Qimokaola
//
//  Created by Administrator on 16/8/28.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZWAPIRequestTool.h"
#import "ZWUserManager.h"

@implementation ZWAPIRequestTool
+ (void)requestTest{
    [ZWAPIRequestTool requestWithAPI:@"http://119.23.36.199:9999/springboot-web/getValicode" parameters:@{@"phone":@"13235910535"} result:^(id response, BOOL success) {
        NSLog(@"response:%@",response)
    }];
}
+ (NSString *)sha1:(NSString *)inputStr{
    const char *cstr = [inputStr cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSData *data = [NSData dataWithBytes:cstr length:inputStr.length];
    
    
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    
    
    NSMutableString *outputStr = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        
        [outputStr appendFormat:@"%02x", digest[i]];
        
    }
    
    return outputStr;
}
+ (NSString *)getUTFStringByTextString:(NSString *)textString{
    NSString *version= [UIDevice currentDevice].systemVersion;
    if(version.doubleValue >=9.0) {
        //iOS 9以后
        return [textString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }else{
        //iOS 9以前
        return [textString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
}
//赞
+ (void)requestIfZanWithToken:(NSString *)token postId:(NSString *)postId result:(APIRequestResult)result{
    [ZWAPIRequestTool requestWithAPI:@"http://120.77.32.233/qmkl1.0.0/post/like/islike" parameters:@{@"token":token,@"postId":postId} result:result];
}

+ (void)requestZanWithToken:(NSString *)token postId:(NSString *)postId result:(APIRequestResult)result{
    [ZWAPIRequestTool requestWithAPI:@"http://120.77.32.233/qmkl1.0.0/post/like/add" parameters:@{@"token":token,@"postId":postId} result:result];
}
+ (void)requestReceivedZanWithToken:(NSString *)token page:(NSString *)page number:(NSString *)num result:(APIRequestResult)result{
    [ZWAPIRequestTool requestWithAPI:@"http://120.77.32.233/qmkl1.0.0/post/like/me" parameters:@{@"token":token,@"page":page,@"num":num} result:result];
}
#pragma mark 评论
//添加私密评论
+ (void)requestAddPrivateCommentWithToken:(NSString *)token postId:(NSString *)postId userId:(NSString *)userId content:(NSString *)content result:(APIRequestResult)result{
    NSString *UTFStr=[self getUTFStringByTextString:content];
    [ZWAPIRequestTool requestWithAPI:@"http://120.77.32.233/qmkl1.0.0/pri/comment/add" parameters:@{@"token":token,@"postId":postId,@"userId":userId,@"content":UTFStr} result:result];
}
//添加评论
+ (void)requestAddCommentWithToken:(NSString *)token postId:(NSString *)postId comment:(NSString *)comment userId:(NSString *)userId result:(APIRequestResult)result{
    NSString *UTFStr=[self getUTFStringByTextString:comment];
    [ZWAPIRequestTool requestWithAPI:@"http://120.77.32.233/qmkl1.0.0/comment/add" parameters:@{
                                                                                                @"token" :token,
                                                                                                @"postId": postId,
                                                                                                @"content" : UTFStr,
                                                                                                @"userId" :userId
                                                                                            } result:result];
}
//
+ (void)requestDetailCommentWithToken:(NSString *)token posetId:(NSString *)postId page:(NSString *)page number:(NSString *)num result:(APIRequestResult)result{
    [ZWAPIRequestTool requestWithAPI:@"http://120.77.32.233/qmkl1.0.0/comment/list" parameters:@{
                                                                                              @"token" :token,
                                                                                              @"page": page,
                                                                                              @"num" : num,
                                                                                              @"postId":postId                                 } result:result];
}

//我发出的评论
+ (void)requestMyCommentWithToken:(NSString *)token page:(NSString *)page number:(NSString *)num result:(APIRequestResult)result{
    [ZWAPIRequestTool requestWithAPI:@"http://120.77.32.233/qmkl1.0.0/comment/user/list" parameters:@{@"token":token,@"page":page,@"num":num} result:result];
}
//帖子
+ (void)requestAddPostWithToken:(NSString *)token content:(NSString *)content result:(APIRequestResult)result{
    NSString *UTFStr=[self getUTFStringByTextString:content];
    [ZWAPIRequestTool requestWithAPI:@"http://120.77.32.233/qmkl1.0.0/post/add" parameters:@{@"token":token,@"content":UTFStr} result:result];
}
+ (void)requestMyPostWithToken:(NSString *)token page:(NSString *)page number:(NSString *)num result:(APIRequestResult)result{
    [ZWAPIRequestTool requestWithAPI:@"http://120.77.32.233/qmkl1.0.0/post/user/list"  parameters:@{@"token":token,@"page":page,@"number":num} result:result];
}
//帖子列表
+(void)requestCommentListWithToken:(NSString *)token number:(NSString *)num page:(NSString *)page result:(APIRequestResult)result{
    [ZWAPIRequestTool requestWithAPI:@"http://120.77.32.233/qmkl1.0.0/post/list" parameters:@{
                                                                                              @"token" :token,
                                                                                              @"page": page,
                                                                                              @"num" : num
                                                                                              } result:result];
}
+ (void)requestPostInfoWithPostId:(NSString *)postId token:(NSString *)token  result:(APIRequestResult)result{
    
    NSString *url=@"http://120.77.32.233/qmkl1.0.0/post/get/";
    NSString *shit=[url stringByAppendingString:postId];
    [ZWAPIRequestTool requestWithAPI:shit parameters:@{@"token":token} result:result];
}
//收藏
+ (void)requestMyCollectionWithToken:(NSString *)token page:(NSString *)page number:(NSString *)num result:(APIRequestResult)result{
    [ZWAPIRequestTool requestWithAPI:@"http://120.77.32.233/qmkl1.0.0/collect/list" parameters:@{
                                                                                              @"token" :token,
                                                                                              @"page": page,
                                                                                              @"num" : num
                                                                                              } result:result];
}
+ (void)requestAddCollectionWithToken:(NSString *)token postId:(NSString *)postId result:(APIRequestResult)result{
    [ZWAPIRequestTool requestWithAPI:@"http://120.77.32.233/qmkl1.0.0/collect/aoc" parameters:@{
                                                                                                 @"token" :token,
                                                                                                 @"postId": postId
                                                                                                 } result:result];
}
+ (void)requestCancelCollectionWithToken:(NSString *)token postId:(NSString *)postId result:(APIRequestResult)result{
    [ZWAPIRequestTool requestWithAPI:@"http://120.77.32.233/qmkl1.0.0/collect/add" parameters:@{
                                                                                                @"token" :token,
                                                                                                @"postId": postId
                                                                                                } result:result];
}
+ (void)requestIfCollectedWithToken:(NSString *)token postId:(NSString *)postId result:(APIRequestResult)result{
    [ZWAPIRequestTool requestWithAPI:@"http://120.77.32.233/qmkl1.0.0/collect/iscollect" parameters:@{@"token":token,@"postId":postId} result:result];
}
+ (void)requestSendCodeWithParameter:(id)param result:(APIRequestResult)result {
   
    
    //para中含有msg
    [ZWAPIRequestTool requestWithAPI:@"http://120.77.32.233/qmkl1.0.0/sms/send"
                          parameters:param
                              result:result];
    
}

+ (void)requestSmsSendCodeWithPhoneNumber:(NSString *)phoneNumber result:(APIRequestResult)result {
    
    [ZWAPIRequestTool requestWithAPI:@"http://120.77.32.233/qmkl1.0.0/sms/send"
                          parameters:@{@"phone" : phoneNumber,@"msg":@"修改密码"}
                              result:result];
}

+ (void)requestVerifyCodeWithParameter:(id)param result:(APIRequestResult)result {
    //NSString *url=[ZWAPITool verifyCodeAPI];
    [ZWAPIRequestTool requestWithAPI:@"http://120.77.32.233/qmkl1.0.0/user/vercode"
                          parameters:param
                              result:result];
    
}
+ (void)requestRegisterWithParameter:(id)params result:(APIRequestResult)result{
    [ZWAPIRequestTool requestWithAPI:@"http://120.77.32.233/qmkl1.0.0/user/all/info" parameters:params result:result];
}

+ (void)requestSmsVerifyCodeWithCode:(NSString *)code result:(APIRequestResult)result {
    
    [ZWAPIRequestTool requestWithAPI:[ZWAPITool smsVerifyCodeAPI]
                          parameters:@{@"code": code}
                              result:result];
    
}

+ (void)requestListSchool:(APIRequestResult)result {
    //[ZWAPITool listSchoolAPI]
    [ZWAPIRequestTool requestWithAPI:@"http://120.77.32.233/qmkl1.0.0/college/list"
                          parameters:nil
                              result:result];
}

+ (void)requestListAcademyWithParameter:(id)param result:(APIRequestResult)result {
    //[ZWAPITool listAcademyAPI]
    
    [ZWAPIRequestTool requestWithAPI:@"http://120.77.32.233/qmkl1.0.0/academy/list/college"
                          parameters:param
                              result:result];
}


+ (void)requestLoginWithParameters:(id)params result:(APIRequestResult)result {
    //NSLog(@"%@",[ZWAPITool loginAPI]);
    //https://finalexam.cn/api/user/login
    NSLog(@"触发了用户登录,token改变");
    [ZWAPIRequestTool requestWithAPI:@"http://120.77.32.233/qmkl1.0.0/user/login"
                          parameters:params
                              result:result];
}

+ (void)requestLoginInfoWithParameters:(id)params result:(APIRequestResult)result {
    //NSLog(@"%@",[ZWAPITool loginAPI]);
    //https://finalexam.cn/api/user/login
    
    [ZWAPIRequestTool requestWithAPI:@"http://120.77.32.233/qmkl1.0.0/user/info"
                          parameters:params
                              result:result];
}
+ (void)requestUploadAvatarWithParamsters:(id)params
                constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block
                                   result:(APIRequestResult)result {
    NSLog(@"params:%@",params);
    //[ZWAPIRequestTool buildParameters:params ? params : @{}]
    [ZWNetworkingManager postWithURLString:@"http://120.77.32.233/qmkl1.0.0/user/update/avatar"
                                    params:params
                 constructingBodyWithBlock:block
                                  progress:nil
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       NSLog(@"response%@",responseObject);
                                       if (result) {
                                           result(responseObject, YES);
                                       }
                                       
                                   }
                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       
                                       if (result) {
                                           result(error, NO);
                                       }
                                   }];
}

+ (NSURLSessionDataTask *)requestUploadFileWithParamsters:(id)params constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block result:(APIRequestResult)result{
    return [ZWNetworkingManager postWithURLString:@"http://120.77.32.233/finalexam/app/upfile"
                                    params:params
                 constructingBodyWithBlock:block
                                  progress:nil
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       NSLog(@"response%@",responseObject);
                                       if (result) {
                                           result(responseObject, YES);
                                       }
                                       
                                   }
                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       
                                       if (result) {
                                           result(error, NO);
                                       }
                                   }];
}
+ (void)requestUserInfo:(APIRequestResult)result {
    [ZWAPIRequestTool requestWithAPI:[ZWAPITool userInfoAPI]
                          parameters:nil
                              result:result];
}

+ (void)requstFileAndFolderListInSchool:(NSNumber *)collegeId
                             path:(NSString *)path
                       needDetail:(BOOL)needDetail
                           result:(APIRequestResult)result {
    NSDictionary *params = @{@"path": path, @"detail": @(needDetail)};
    
    NSString *listAPI = [NSString stringWithFormat:[ZWAPITool listFileAndFolderAPI], [collegeId intValue]];
    [ZWAPIRequestTool requestWithAPI:listAPI
                          parameters:params
                              result:result];
}
+ (void)requestFileListInSchool:(NSString *)collegeName path:(NSString *)path token:(NSString *)token result:(APIRequestResult)result{
    if (!token) {
        NSLog(@"bug!!!token为空");
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserNeedLoginNotification object:nil];
    }else{
        [ZWAPIRequestTool requestWithAPI:@"http://120.77.32.233/qmkl1.0.0/file/list/" parameters:@{@"path":path,@"collegeName":collegeName,@"token":token} result:result];
    }
    
    
}
+ (void)requestDetailInfoOfFileInPath:(NSString *)path college:(NSString *)collegeName token:(NSString *)token result:(APIRequestResult)result{
    [ZWAPIRequestTool requestWithAPI:@"http://120.77.32.233/qmkl1.0.0/file/list/detail" parameters:@{@"path":path,@"collegeName":collegeName,@"token":token} result:result];
}
+ (void)requestModifyUserInfoWithParameters:(id)params result:(APIRequestResult)result {
//  params中需要带有token
    //[ZWAPITool modifyUserInfoAPI]
    [ZWAPIRequestTool requestWithAPI:@"http://120.77.32.233/qmkl1.0.0/user/update/info"
                          parameters:params
                              result:result];
}

+ (void)requestLogout:(NSString *)phoneNumber :(APIRequestResult)result {
    [ZWAPIRequestTool requestWithAPI:@"http://120.77.32.233/qmkl1.0.0/user/out"
                          parameters:@{@"username":phoneNumber?phoneNumber:[ZWUserManager sharedInstance].loginUser.username}
                              result:result];
}

+ (void)requestDownloadUrlInSchool:(NSNumber *)collegeId path:(NSString *)path result:(APIRequestResult)result {
    [ZWAPIRequestTool requestWithAPI:[NSString stringWithFormat:[ZWAPITool downloadUrlAPI], collegeId.intValue]
                          parameters:@{@"path" : path}
                              result:result];
}

+ (void)requestDownloadUrlWithCollegeName:(NSString *)collegeName path:(NSString *)path token:(NSString *)token result:(APIRequestResult)result{
    
    [ZWAPIRequestTool requestWithAPI:@"http://120.77.32.233/qmkl1.0.0/file/download/url" parameters:@{@"collegeName":collegeName,@"token":token,@"path":path} result:result];
}


+ (void)reuqestInfoByName:(NSString *)username result:(APIRequestResult)result {
    [ZWAPIRequestTool requestWithAPI:[ZWAPITool infoByNameAPI]
                          parameters:@{@"nickname" : username}
                              result:result];
}

+ (void)requestResetPasswordWithUserName:(NSString *)userName newPassword:(NSString *)newPassword result:(APIRequestResult)result {
    //[ZWAPITool resetPwdAPI]
    
    [ZWAPIRequestTool requestWithAPI:@""
                          parameters:@{@"username" : userName, @"password" : newPassword}
                              result:result];
}
+ (void)requestResetPasswordWithUserName:(NSString *)userName newPassword:(NSString *)newPassword token:(NSString *)token vercode:(NSString *)vercode result:(APIRequestResult)result{
    NSLog(@"request!!!!parameters:token:%@,username:%@,password%@",token,userName,newPassword);
    [ZWAPIRequestTool requestWithAPI:@"http://120.77.32.233/qmkl1.0.0/user/update/password" parameters:@{@"token" : token,@"vercode": vercode,@"phone":userName,@"password":newPassword} result:result];
}
+ (void)requestSBInfo:(APIRequestResult)result {
    NSLog(@"sbAPi%@",[ZWAPITool sbAPI]);
    [ZWAPIRequestTool requestWithAPI:@"http://120.77.32.233/qmkl1.0.0/ad/detail/adpage"
                          parameters:nil
                              result:result];
}

+ (void)requestAppInfo:(APIRequestResult)result {
    [ZWNetworkingManager getWithURLString:[ZWAPITool appInfoAPI]
                                  success:^(NSURLSessionDataTask *task, id responseObject) {
                                      if (result) {
                                          result(responseObject, YES);
                                      }
                                  }
                                  failure:^(NSURLSessionDataTask *task, NSError *error) {
                                      if (result) {
                                          result(error, NO);
                                      }
                                  }];
}

//第三方登录


+ (void)requestOauthLoginWithPlatformId:(NSString *)platformId platform:(NSString *)platform result:(APIRequestResult)result{
    [ZWAPIRequestTool requestWithAPI:@"http://120.77.32.233/qmkl1.0.0/userauth/login" parameters:@{@"platformId":platformId,@"platform":platform} result:result];
}

+ (void)requestOauthUserInfoWithParams:(id)params result:(APIRequestResult)result{
    [ZWAPIRequestTool requestWithAPI:@"http://120.77.32.233/qmkl1.0.0/userauth/update/info" parameters:params result:result];
}

+ (void)requestOauthLoginWithPlatform:(NSString *)platform openId:(NSString *)openId accessToken:(NSString *)accessToken result:(APIRequestResult)result {
    [ZWAPIRequestTool requestWithAPI:[ZWAPITool oauthLoginAPI]
                          parameters:@{@"platform" : platform,
                                       @"openId" : openId,
                                       @"accessToken": accessToken}
                              result:result];
}

+ (void)requestGoodList:(APIRequestResult)result {
    [ZWAPIRequestTool requestWithAPI:[ZWAPITool goodListAPI]
                          parameters:nil
                              result:result];
}

+ (void)requestGoodStateWithResult:(APIRequestResult)result {
    [ZWAPIRequestTool requestWithAPI:[ZWAPITool goodStateAPI] parameters:nil result:result];
}

+ (void)requestAddOrderWithBuyer:(NSString *)buyer address:(NSString *)address phone:(NSString *)phone goodList:(NSString *)goodList result:(APIRequestResult)result {
    [ZWAPIRequestTool requestWithAPI:[ZWAPITool addOrderAPI]
                          parameters:@{
                                       @"addr" : address,
                                       @"name" : buyer,
                                       @"phone" : phone,
                                       @"list" : goodList
                                       }
                              result:result];
}

+ (void)requestPayOrderWithUUID:(NSString *)uuid payType:(NSString *)payType result:(APIRequestResult)result {
    [ZWAPIRequestTool requestWithAPI:[ZWAPITool payOrderAPI]
                          parameters:@{
                                       @"uuid" : uuid,
                                       @"type" : payType
                                       }
                              result:result];
}

+ (void)requestListOrderWithPageNumber:(NSUInteger)pageNumber result:(APIRequestResult)result {
    [ZWAPIRequestTool requestWithAPI:[ZWAPITool listOrderAPI]
                          parameters:@{
                                       @"page" : @(pageNumber).stringValue
                                       }
                              result:result];
}
+ (void)requestZanWithFileId:(NSString *)fileId result:(APIRequestResult)result{
    [ZWAPIRequestTool requestWithAPI:@"http://120.77.32.233/qmkl1.0.0/like/addordesc" parameters:@{@"fileId":fileId,@"token":[ZWUserManager sharedInstance].loginUser.token} result:result];
}
+ (void)requestCaiWithFileId:(NSString *)fileId result:(APIRequestResult)result{
    [ZWAPIRequestTool requestWithAPI:@"http://120.77.32.233/qmkl1.0.0/dislike/addordesc" parameters:@{@"fileId":fileId,@"token":[ZWUserManager sharedInstance].loginUser.token} result:result];
}
+(void)requestIfZanWithFileId:(NSString *)fileId result:(APIRequestResult)result{
    [ZWAPIRequestTool requestWithAPI:@"http://120.77.32.233/qmkl1.0.0/like/is/like" parameters:@{@"fileId":fileId,@"token":[ZWUserManager sharedInstance].loginUser.token} result:result];
}
+(void)requestIfCaiWithFileId:(NSString *)fileId result:(APIRequestResult)result{
    [ZWAPIRequestTool requestWithAPI:@"http://120.77.32.233/qmkl1.0.0/dislike/is/dislike" parameters:@{@"fileId":fileId,@"token":[ZWUserManager sharedInstance].loginUser.token} result:result];
}
// 通用请求接口，针对接收字典参数的接口
+ (void)requestWithAPI:(NSString *)API parameters:(id)params result:(APIRequestResult)result {
    NSLog(@"通用请求借口传出的参数:%@",params);
    
    //[ZWAPIRequestTool buildParameters:params ? params : @{}]
    [ZWNetworkingManager postWithURLString:API
                                    params:params
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       
                                       if ([[responseObject objectForKey:kHTTPResponseMsgKey] isEqualToString:kUserNotLoginInfo]) {
                                           NSLog(@"返回数据!!!%@",[responseObject objectForKey:kHTTPResponseMsgKey]);
                                           [[NSNotificationCenter defaultCenter] postNotificationName:kUserNeedLoginNotification object:nil];
                                           
                                       }
                                       if (result) {
                                           NSLog(@"访问到服务器");
                                           result(responseObject, YES);
                                       }
                                   }
                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       if (result) {
                                           result(error, NO);
                                       }
                                   }];
    
}


+ (id)buildParameters:(id)param {
    
    if ([param isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *dict = [@{@"version": @1} mutableCopy];
        [dict addEntriesFromDictionary:param];
        return dict;
    } else if ([param isKindOfClass:[NSString class]]) {
        NSMutableString *validParams = [(NSString *)param mutableCopy];
        [validParams insertString:@"\n  \"version\":1" atIndex:1];
        return validParams;
    }
    return nil;
}



@end
