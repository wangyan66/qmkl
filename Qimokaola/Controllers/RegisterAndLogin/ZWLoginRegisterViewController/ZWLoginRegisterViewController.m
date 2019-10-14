//
//  ZWLoginRegisterViewController.m
//  Qimokaola
//
//  Created by Administrator on 2017/3/7.
//  Copyright © 2017年 Administrator. All rights reserved.
//

#import "ZWLoginRegisterViewController.h"
#import "ZWTabBarController.h"
#import "ZWResetPasswordViewController.h"

#import "ZWLoginView.h"
#import "ZWLoginViewModel.h"
#import "ZWRegisterView.h"
#import "ZWRegisterViewModel.h"
#import "ZWZWOauthLoginViewModel.h"

#import "ZWUserManager.h"
#import "ZWAccount.h"
#import "ZWHUDTool.h"

#import "ZWFilloutInformationViewController.h"

//#import <UMSocialCore/UMSocialCore.h>
#import <UMShare/UMShare.h>
#import <YYModel/YYModel.h>

static NSString *const kStoryboardName = @"LoginRegister";
static NSString *const kStoryboardID = @"ZWLoginRegisterNavigator";

@interface ZWLoginRegisterViewController ()

@property (weak, nonatomic) IBOutlet UIView *loginRegisterContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginRegisterContainerLeading;
@property (weak, nonatomic) IBOutlet UIButton *qqOauthBtn;
//@property (weak, nonatomic) IBOutlet UIButton *wechatOauthBtn;

@property (nonatomic, strong) ZWLoginView *loginView;
@property (nonatomic, strong) ZWLoginViewModel *loginViewModel;
@property (nonatomic, strong) ZWRegisterView *registerView;
@property (nonatomic, strong) ZWRegisterViewModel *registerViewModel;

@property (nonatomic, strong) ZWZWOauthLoginViewModel *oauthLoginViewModel;

@end

@implementation ZWLoginRegisterViewController

+ (UIViewController *)loadLoginRegisterViewControllerInNavigatorFromStoryboard {
    UIStoryboard *loginRegisterBoard = [UIStoryboard storyboardWithName:kStoryboardName bundle:nil];
    return [loginRegisterBoard instantiateViewControllerWithIdentifier:kStoryboardID];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // 添加登录注册视图
    self.loginView = [ZWLoginView loadLoginViewFormXib];
    [self.loginRegisterContainer addSubview:self.loginView];
    self.registerView = [ZWRegisterView loadRegisterViewFromXib];
    [self.loginRegisterContainer addSubview:self.registerView];

    // 绑定信号
    [self bindViewModel];
    
    //若有缓存账户密码
    ZWAccount *account = [[ZWAccount alloc] init];
    if ([account readData] && account.account.length == 11) {
        self.loginView.phoneNumberField.text = account.account;
        self.loginView.passwordField.text = account.pwd;
        [self.loginView.phoneNumberField becomeFirstResponder];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar subviews][0].alpha = 0;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar subviews][0].alpha = 1.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.loginView.frame = CGRectMake(0, 0, self.view.width, self.loginRegisterContainer.height);
    self.registerView.frame = CGRectMake(self.view.width, 0, self.view.width, self.loginRegisterContainer.height);
}

- (void)bindViewModel {
    // 绑定登录视图的VM
    self.loginViewModel = [[ZWLoginViewModel alloc] init];

    RAC(self.loginViewModel, account) = [RACSignal merge:@[self.loginView.phoneNumberField.rac_textSignal, RACObserve(self.loginView.phoneNumberField, text)]];
//    RAC(self.loginViewModel,account)=self.loginView.phoneNumberField.rac_textSignal;
    RAC(self.loginViewModel, password) = [RACSignal merge:@[self.loginView.passwordField.rac_textSignal, RACObserve(self.loginView.passwordField, text)]];
    self.loginView.loginBtn.rac_command = self.loginViewModel.loginCommand;
    [self.loginView.switchToRegisterBtn addTarget:self action:@selector(switchLoginRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.loginView.forgotPasswordBtn addTarget:self action:@selector(findPassword) forControlEvents:UIControlEventTouchUpInside];
    [self listeningLogin];
    
    // 绑定注册视图的VM
    self.registerViewModel = [[ZWRegisterViewModel alloc] init];
    RAC(self.registerViewModel, phoneNumer) = [RACSignal merge:@[self.registerView.phoneNumberField.rac_textSignal, RACObserve(self.registerView.phoneNumberField, text)]];
    RAC(self.registerViewModel, verifyCode) = [RACSignal merge:@[self.registerView.verifyCodeField.rac_textSignal, RACObserve(self.registerView.verifyCodeField, text)]];
    RAC(self.registerViewModel, password) = [RACSignal merge:@[self.registerView.passwordField.rac_textSignal, RACObserve(self.registerView.passwordField, text)]];
    self.registerView.fetchVerifyCodeBtn.rac_command = self.registerViewModel.verifyCommand;
    self.registerView.filloutBtn.rac_command = self.registerViewModel.registerCommand;
    [self.registerView.switchToLoginBtn addTarget:self action:@selector(switchLoginRegister) forControlEvents:UIControlEventTouchUpInside];
    [self listeningRegister];
    
    //绑定第三方登录的VM
    self.oauthLoginViewModel = [[ZWZWOauthLoginViewModel alloc] init];
    self.qqOauthBtn.rac_command = self.oauthLoginViewModel.oauthLoginCommand;
//    self.wechatOauthBtn.rac_command = self.oauthLoginViewModel.oauthLoginCommand;
    [self listenOauthLogin];
}

- (void)listeningLogin {
    @weakify(self)
    [[[self.loginView.loginBtn.rac_command.executionSignals doNext:^(id x) {
        @strongify(self)
        [self.view endEditing:YES];
    }] switchToLatest] subscribeNext:^(NSDictionary *result) {
        @strongify(self)
        int resultCode = [result[kHTTPResponseCodeKey] intValue];
        NSLog(@"登录返回的msg%@",result[kHTTPResponseMsgKey]);
        
        if (resultCode == 200) {
 
            //在该处获得用户信息
            ZWUser *user = [ZWUser yy_modelWithDictionary:result[@"data"]];
            
                NSLog(@"YYModelUser:%@",user);
                user.token=[ZWUserManager sharedInstance].UserToken;
            
                // 解析出用户信息后跳转
                [ZWHUDTool showPlainHUDInView:self.navigationController.view text:@"登录成功"];
                [self loginSuccessWithUserInfo:user isOauthLogin:NO];
            
        } else if(resultCode == 202){
            [[ZWHUDTool showPlainHUDInView:self.navigationController.view text:result[kHTTPResponseMsgKey]] hideAnimated:YES afterDelay:kTimeIntervalShort];
        }else{
            [[ZWHUDTool showPlainHUDInView:self.navigationController.view text:@"登录失败"] hideAnimated:YES afterDelay:kTimeIntervalShort];
        }
        
    }];
    
    [self.loginView.loginBtn.rac_command.errors subscribeNext:^(id x) {
        @strongify(self)
        NSString *errDesc;
        int errCode=(int)[(NSError *)x code];
        if (errCode==-1001) {
            errDesc=@"连接不上服务器";
        }else if (errCode==-1009){
            errDesc=@"已断开与互联网的连接";
        }else{
            errDesc=@"登录失败";
        }
        
        
        [[ZWHUDTool showPlainHUDInView:self.navigationController.view title:@"出现错误" message:errDesc] hideAnimated:YES afterDelay:kTimeIntervalShort];
    }];
    
    [self.loginView.loginBtn.rac_command.executing subscribeNext:^(id x) {
            @strongify(self)
            if ([x boolValue]) {
                [ZWHUDTool showInView:self.navigationController.view text:@"正在登陆"];
            }
        }];
}

- (void)listeningRegister {
    @weakify(self)
    [[[self.registerView.filloutBtn.rac_command.executionSignals doNext:^(id x) {
        @strongify(self)
        [self.view endEditing:YES];
    }] switchToLatest] subscribeNext:^(NSDictionary *result) {
        @strongify(self)
        //原来的验证模块
        //现在返回的是注册的信息 200成功
        
        //NSLog(@"注册验证时候返回的token%@",result[kHTTPResponseDataKey]);
        if ([result[kHTTPResponseCodeKey] intValue] == 200) {
            [ZWHUDTool showPlainHUDInView:self.navigationController.view text:@"验证成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kTimeIntervalShort * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //跳转至完善信息页面
                [ZWHUDTool dismissInView:self.navigationController.view];
                
                ZWFilloutInformationViewController *fillout = [[ZWFilloutInformationViewController alloc] init];
            
                fillout.token=self.registerViewModel.token ;
                fillout.registerParam = @{@"phone": self.registerView.phoneNumberField.text, @"password": self.registerView.passwordField.text};
                [self.navigationController pushViewController:fillout animated:YES];
                
            });
    }else if([result[kHTTPResponseCodeKey] intValue] == 202){
            [[ZWHUDTool showPlainHUDInView:self.navigationController.view text:result[kHTTPResponseMsgKey]] hideAnimated:YES afterDelay:kTimeIntervalShort];
        
    }else{
        [[ZWHUDTool showPlainHUDInView:self.navigationController.view text:@"出现错误"] hideAnimated:YES afterDelay:kTimeIntervalShort];
    }
        
    }];
    
    [self.registerView.filloutBtn.rac_command.errors subscribeNext:^(NSError *error) {
        @strongify(self)
        NSString *errDesc;
        int errCode=(int)[(NSError *)error code];
        if (errCode==-1001) {
            errDesc=@"连接不上服务器";
        }else if (errCode==-1009){
            errDesc=@"已断开与互联网的连接";
        }else{
            errDesc=@"登录失败";
        }
        [[ZWHUDTool showPlainHUDInView:self.navigationController.view title:@"请求错误" message:errDesc] hideAnimated:YES afterDelay:kTimeIntervalShort];
    }];
    //发送验证码返回的信息
    [[[self.registerView.fetchVerifyCodeBtn.rac_command.executionSignals doNext:^(id x) {
        @strongify(self)
        [self.view endEditing:YES];
    }] switchToLatest] subscribeNext:^(NSDictionary *response) {
        @strongify(self)
//        NSString *msg = [response[kHTTPResponseCodeKey] intValue] == 113 ? @"该手机号已被注册" : response[kHTTPResponseMsgKey];
        NSLog(@"%@",response);
        NSString *msg=response[kHTTPResponseMsgKey];
        NSLog(@"msg:%@",msg);
        [ZWUserManager sharedInstance].messageToken=response[kHTTPResponseDataKey];
        self.registerViewModel.token=response[kHTTPResponseDataKey];
        [[ZWHUDTool showPlainHUDInView:self.navigationController.view text:msg] hideAnimated:YES afterDelay:kTimeIntervalShort];
    }];
    
    [self.registerView.fetchVerifyCodeBtn.rac_command.errors subscribeNext:^(id x) {
        @strongify(self)
        [[ZWHUDTool showPlainHUDInView:self.navigationController.view text:@"获取验证码失败"] hideAnimated:YES afterDelay:kTimeIntervalShort];
    }];
}

- (void)listenOauthLogin {
    @weakify(self)
    [[self.oauthLoginViewModel.oauthLoginCommand.executionSignals switchToLatest] subscribeNext:^(id result) {
        @strongify(self)
        NSLog(@"第三方登录服务器返回的数据%@", result);
        if ([result[kHTTPResponseCodeKey] intValue] != 404) {
            //ZWUser *user = [ZWUser yy_modelWithDictionary:result[kHTTPResponseResKey]];
            if ([result[kHTTPResponseCodeKey] intValue]==200) {
                //用户信息完整,直接获取用户信息登录
                
                //保存token
                [ZWUserManager sharedInstance].UserToken=result[kHTTPResponseDataKey];
                [ZWAPIRequestTool requestLoginInfoWithParameters:@{@"token":result[kHTTPResponseDataKey]} result:^(id response, BOOL success) {
                    if (success&&[response[kHTTPResponseCodeKey] intValue]==200) {
                      
                        ZWUser *user = [ZWUser yy_modelWithDictionary:response[@"data"]];
                        user.token=[ZWUserManager sharedInstance].UserToken;
                        NSLog(@"第三方登录用户的信息为%@",user);
                        // 解析出用户信息后跳转
                        [ZWHUDTool showPlainHUDInView:self.navigationController.view text:@"登录成功"];
                        
                        [self loginSuccessWithUserInfo:user isOauthLogin:YES];
                    } else {
                         [[ZWHUDTool showPlainHUDInView:self.navigationController.view text:result[kHTTPResponseMsgKey]] hideAnimated:YES afterDelay:kTimeIntervalShort];
                    }
                }];
            } else {//code==202 需要完善用户信息
                [ZWHUDTool showPlainHUDInView:self.navigationController.view text:@"获取权限成功 请完善信息"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kTimeIntervalShort * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [ZWHUDTool dismissInView:self.navigationController.view];
                    ZWFilloutInformationViewController *fillout = [[ZWFilloutInformationViewController alloc] init];
                    fillout.oauthLoginUser =[ZWUserManager sharedInstance].oauthUser;
                    NSLog(@"fillout.oauthLoginUser%@",fillout.oauthLoginUser);
                    fillout.token=result[kHTTPResponseDataKey];
                    [self.navigationController pushViewController:fillout animated:YES];
                });
            }
            
        } else {
            [[ZWHUDTool showPlainHUDInView:self.navigationController.view text:@"出现错误,请重试"] hideAnimated:YES afterDelay:kTimeIntervalShort];
        }
    }];
    
    [self.oauthLoginViewModel.oauthLoginCommand.errors subscribeNext:^(id x) {
        @strongify(self)
        NSString *errDesc;
        int errCode=(int)[(NSError *)x code];
        if (errCode==-1001) {
            errDesc=@"连接不上服务器";
        }else if (errCode==-1009){
            errDesc=@"已断开与互联网的连接";
        }else{
            errDesc=@"快捷登录失败";
        }
        
        [[ZWHUDTool showPlainHUDInView:self.navigationController.view text:errDesc] hideAnimated:YES afterDelay:kTimeIntervalShort];
        [[ZWHUDTool showPlainHUDInView:self.navigationController.view title:@"出现错误" message:errDesc] hideAnimated:YES afterDelay:kTimeIntervalShort];
    }];
    
    [self.oauthLoginViewModel.oauthLoginCommand.executing subscribeNext:^(NSNumber *x) {
        @strongify(self)
        if ([x boolValue]) {
            [ZWHUDTool showInView:self.navigationController.view];
        }
    }];
}

- (void)loginSuccessWithUserInfo:(ZWUser *)user isOauthLogin:(BOOL)isOauthLogin {
    [ZWUserManager sharedInstance].loginUser = user;
    //如果不是第三方登录
    if (!isOauthLogin) {
        ZWAccount *account = [[ZWAccount alloc] init];
        account.account = self.loginView.phoneNumberField.text;
        account.pwd = self.loginView.passwordField.text;
        account.token=user.token;
        [account writeData];
        NSLog(@"writedata");
    }
        
    
    // 发送用户登录成功通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginSuccessNotification object:nil];
    
    [ZWHUDTool showSuccessInView:self.navigationController.view text:@"登录成功"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kTimeIntervalShort * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [ZWHUDTool dismissInView:self.navigationController.view];
        // 根据根视图类型决定跳转类型
        ZWTabBarController *tabbarController = [[ZWTabBarController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = tabbarController;
    });
}
//MF
- (void)findPassword {
    ZWResetPasswordViewController *resetPwdController = [[ZWResetPasswordViewController alloc] init];
    resetPwdController.title = @"找回密码";
    [self.navigationController pushViewController:resetPwdController animated:YES];
}

- (void)switchLoginRegister {
    self.loginRegisterContainerLeading.constant = self.loginRegisterContainerLeading.constant == 0 ? -self.view.width : 0;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
