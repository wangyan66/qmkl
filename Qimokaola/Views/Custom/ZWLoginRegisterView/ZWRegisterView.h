//
//  ZWRegisterView.h
//  Qimokaola
//
//  Created by Administrator on 2017/3/12.
//  Copyright © 2017年 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWPasswordField.h"

@interface ZWRegisterView : UIView

+ (instancetype)loadRegisterViewFromXib;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeField;
@property (weak, nonatomic) IBOutlet UIButton *fetchVerifyCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *switchToLoginBtn;
@property (weak, nonatomic) IBOutlet ZWPasswordField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *filloutBtn;

@end
