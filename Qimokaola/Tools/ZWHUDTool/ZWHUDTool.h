//
//  ZWHUDTool.h
//  Qimokaola
//
//  Created by Administrator on 16/8/23.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface ZWHUDTool : NSObject


/*
// v1
+ (void)showHUDWithTitle:(NSString *)title message:(NSString *)message duration:(NSTimeInterval)duration;

+ (void)showHUDInView:(UIView *)view withTitle:(NSString *)title message:(NSString *)message duration:(NSTimeInterval)duration;

+ (MBProgressHUD *)successHUDInView:(UIView *)view withMessage:(NSString *)message;

+ (void)showSuccessHUDInView:(UIView *)view withMessage:(NSString *)message duration:(NSTimeInterval)duration;

+ (MBProgressHUD *)excutingHudInView:(UIView *)view title:(NSString *)title;
 
*/


 
// v2

// 方法名中带有 InView 字样的方法显示的 HUD 显示在特定的 View，其他方法显示的 HUD 默认显示在 [UIApplication sharedApplication].keyWindow 中
// dimiss 方法可以 dismiss 所有默认显示的 HUD  dismissInView: 可以 dimiss 特定 View 中的 HUD

// 带有 InView 的显示方法必须与 dismissInView 合用 

// Executing HUD
+ (MBProgressHUD *)show;
+ (MBProgressHUD *)showInView:(UIView *)view;
// 带有文字的 Executing HUD
+ (MBProgressHUD *)showWithText:(NSString *)text;
+ (MBProgressHUD *)showInView:(UIView *)view text:(NSString *)text;

// 关闭 HUD
+ (void)dismiss;
+ (void)dismissInView:(UIView *)view;

// 只显示文字弹窗
+ (MBProgressHUD *)showPlainHUDWithText:(NSString *)text;
+ (MBProgressHUD *)showPlainHUDInView:(UIView *)view text:(NSString *)text;
// 显示头部与内容弹窗
+ (MBProgressHUD *)showPlainHUDWithTitle:(NSString *)title message:(NSString *)message;
+ (MBProgressHUD *)showPlainHUDInView:(UIView *)view title:(NSString *)title message:(NSString *)message;

// 显示 成功 警告 失败
+ (MBProgressHUD *)showSuccess;
+ (MBProgressHUD *)showSuccessInView:(UIView *)view;
+ (MBProgressHUD *)showSuccessWithText:(NSString *)text;
+ (MBProgressHUD *)showSuccessInView:(UIView *)view text:(NSString *)text;

+ (MBProgressHUD *)showFailure;
+ (MBProgressHUD *)showFailureInView:(UIView *)view;
+ (MBProgressHUD *)showFailureWithText:(NSString *)text;
+ (MBProgressHUD *)showFailureInView:(UIView *)view text:(NSString *)text;

+ (MBProgressHUD *)showWarning;
+ (MBProgressHUD *)showWarningInView:(UIView *)view;
+ (MBProgressHUD *)showWarningWithText:(NSString *)text;
+ (MBProgressHUD *)showWarningInView:(UIView *)view text:(NSString *)text;

+ (MBProgressHUD *)showCustomView:(UIView *)customview;
+ (MBProgressHUD *)showCustomView:(UIView *)customview text:(NSString *)text;
+ (MBProgressHUD *)showCustomView:(UIView *)customview inView:(UIView *)view;
+ (MBProgressHUD *)showCustomView:(UIView *)customview inView:(UIView *)view text:(NSString *)text;

@end
