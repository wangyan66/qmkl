//
//  ZWLoginView.h
//  Qimokaola
//
//  Created by Administrator on 2017/3/12.
//  Copyright © 2017年 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWPasswordField.h"

@interface ZWLoginView : UIView

+ (instancetype)loadLoginViewFormXib;

@property (weak, nonatomic) IBOutlet UIButton *switchToRegisterBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet ZWPasswordField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordBtn;

@end
