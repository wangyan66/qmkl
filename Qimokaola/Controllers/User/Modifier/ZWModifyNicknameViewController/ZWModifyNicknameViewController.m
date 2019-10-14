//
//  ZWModifyNicknameViewController.m
//  Qimokaola
//
//  Created by Administrator on 2016/9/17.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZWModifyNicknameViewController.h"
#import "ZWHUDTool.h"
#import "ZWUserManager.h"

//#import <UMCommunitySDK/UMComDataRequestManager.h>

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <IQKeyboardManager/IQKeyboardManager.h>

@interface ZWModifyNicknameViewController ()

@property (nonatomic, strong) UITextField *nicknameField;

@end

@implementation ZWModifyNicknameViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"昵称";
    self.view.backgroundColor = defaultBackgroundColor;
        [self zw_addSubViews];
    
    UIBarButtonItem *leftCancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancleModification)];
    self.navigationItem.leftBarButtonItem = leftCancelItem;
    
    UIBarButtonItem *rightSavaItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveModification)];
    RAC(rightSavaItem, enabled) = [_nicknameField.rac_textSignal map:^id(NSString *value) {
        return @(value.length > 0 && ![value isEqualToString:[ZWUserManager sharedInstance].loginUser.nickname]);
    }];
    self.navigationItem.rightBarButtonItem = rightSavaItem;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    [_nicknameField endEditing:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_nicknameField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Commom Methods

- (void)zw_addSubViews {
    CGFloat nicknameFieldHeight = 40.f;
    _nicknameField = [[UITextField alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight + 30, kScreenW, nicknameFieldHeight)];
    _nicknameField.borderStyle = UITextBorderStyleNone;
    _nicknameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nicknameField.text = [ZWUserManager sharedInstance].loginUser.nickname;
    _nicknameField.backgroundColor = [UIColor whiteColor];
    _nicknameField.font = ZWFont(16);
    _nicknameField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, nicknameFieldHeight)];
    _nicknameField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_nicknameField];
}

- (void)cancleModification {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveModification {
    [_nicknameField endEditing:YES];
    @weakify(self)
    [ZWHUDTool showInView:self.navigationController.view text:@"正在修改"];
    [[ZWUserManager sharedInstance] modifyUserNickname:_nicknameField.text result:^(id response, BOOL success) {
        @strongify(self)
        
        if (success) {
            if ([[response objectForKey:kHTTPResponseCodeKey] intValue] == 200) {
                [ZWHUDTool dismissInView:self.navigationController.view];
                // 重新设置用户昵称
                [[ZWUserManager sharedInstance] updateNickname:self.nicknameField.text];
                ZWUser *user = [ZWUserManager sharedInstance].loginUser;
//                [[UMComDataRequestManager defaultManager] updateProfileWithName:user.nickname
//                                                                            age:0
//                                                                         gender:[user.gender isEqualToString:@"男"] ? @1 : @0
//                                                                         custom:user.collegeName
//                                                                   userNameType:userNameNoRestrict
//                                                                 userNameLength:userNameLengthNoRestrict
//                                                                     completion:^(NSDictionary *responseObject, NSError *error) {
//                                                                         
//                                                                     }];
                if (_completion) {
                    _completion();
                }
                [self.navigationController popViewControllerAnimated:YES];
            } else if([response[kHTTPResponseCodeKey] intValue]==202){
                [[ZWHUDTool showPlainHUDInView:self.navigationController.view text:response[kHTTPResponseMsgKey]] hideAnimated:YES afterDelay:kTimeIntervalShort];
            }else{
                [[ZWHUDTool showPlainHUDInView:self.navigationController.view text:@"修改用户信息失败"] hideAnimated:YES afterDelay:kTimeIntervalShort];
            }
        } else {
            [[ZWHUDTool showPlainHUDInView:self.navigationController.view title:@"修改失败" message:@"请稍后再试"] hideAnimated:YES afterDelay:kTimeIntervalShort];
        }
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
