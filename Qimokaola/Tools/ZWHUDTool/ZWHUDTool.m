//
//  ZWHUDTool.m
//  Qimokaola
//
//  Created by Administrator on 16/8/23.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZWHUDTool.h"


#define window [UIApplication sharedApplication].keyWindow

static NSString *const kSuccessImageAssetName = @"";
static NSString *const kFailureImageAssetName = @"";
static NSString *const kWarningImageAssetName = @"";

@implementation ZWHUDTool



// v1
+ (void)showHUDWithTitle:(NSString *)title message:(NSString *)message duration:(NSTimeInterval)duration {
    [self showHUDInView:[UIApplication sharedApplication].keyWindow withTitle:title message:message duration:duration];
}

+ (MBProgressHUD *)successHUDInView:(UIView *)view withMessage:(NSString *)message {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
    hud.label.text = message;
    hud.square = YES;
    return hud;
}

+ (void)showSuccessHUDInView:(UIView *)view withMessage:(NSString *)message duration:(NSTimeInterval)duration {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
    hud.label.text = message;
    hud.square = YES;
    [hud hideAnimated:YES afterDelay:duration];
}

+ (void)showHUDInView:(UIView *)view withTitle:(NSString *)title message:(NSString *)message duration:(NSTimeInterval)duration {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = title;
    hud.detailsLabel.text = message;
    hud.userInteractionEnabled = NO;
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:duration];
}

+ (MBProgressHUD *)excutingHudInView:(UIView *)view title:(NSString *)title {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = title;
    return hud;
}
 
 
 

// v2

// 方法名中带有 InView 字样的方法显示的 HUD 显示在特定的 View，其他方法显示的 HUD 默认显示在 [UIApplication sharedApplication].keyWindow 中
// dimiss 方法可以 dismiss 所有默认显示的 HUD  dismissInView: 可以 dimiss 特定 View 中的 HUD

// Executing HUD
+ (MBProgressHUD *)show {
    return [self showInView:window];
}

+ (MBProgressHUD *)showInView:(UIView *)view {
    return [self showInView:view text:nil];
}

// 带有文字的 Executing HUD
+ (MBProgressHUD *)showWithText:(NSString *)text {
    return [self showInView:window text:text];
}

+ (MBProgressHUD *)showInView:(UIView *)view text:(NSString *)text {
    [MBProgressHUD hideHUDForView:view animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = text;
    return hud;
}

// 关闭 HUD
+ (void)dismiss {
    [self dismissInView:window];
}

+ (void)dismissInView:(UIView *)view {
    [MBProgressHUD hideHUDForView:view animated:YES];
}

// 只显示文字弹窗
+ (MBProgressHUD *)showPlainHUDWithText:(NSString *)text {
    return [self showPlainHUDInView:window text:text];
}

+ (MBProgressHUD *)showPlainHUDInView:(UIView *)view text:(NSString *)text {
    return [self showPlainHUDInView:view title:text message:nil];
}

// 显示头部与内容弹窗
+ (MBProgressHUD *)showPlainHUDWithTitle:(NSString *)title message:(NSString *)message {
    return [self showPlainHUDInView:window title:title message:message];
}

+ (MBProgressHUD *)showPlainHUDInView:(UIView *)view title:(NSString *)title message:(NSString *)message {
    [MBProgressHUD hideHUDForView:view animated:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = title;
    hud.detailsLabel.text = message;
    return hud;
}

// 显示 成功 警告 失败
+ (MBProgressHUD *)showSuccess {
    return [self showInView:window];
}

+ (MBProgressHUD *)showSuccessInView:(UIView *)view {
    return [self showSuccessInView:view text:nil];
}

+ (MBProgressHUD *)showSuccessWithText:(NSString *)text {
    return [self showSuccessInView:window text:text];
}

+ (MBProgressHUD *)showSuccessInView:(UIView *)view text:(NSString *)text {
    
    return [self showCustomView:[self imageViewWithImageAssetName:kSuccessImageAssetName] inView:view text:text];
}

+ (MBProgressHUD *)showFailure {
    return [self showFailureInView:window];
}

+ (MBProgressHUD *)showFailureInView:(UIView *)view {
    return [self showFailureInView:view text:nil];
}

+ (MBProgressHUD *)showFailureWithText:(NSString *)text {
    return [self showFailureInView:window text:text];
}

+ (MBProgressHUD *)showFailureInView:(UIView *)view text:(NSString *)text {
    return [self showCustomView:[self imageViewWithImageAssetName:kFailureImageAssetName] inView:view text:text];
}

+ (MBProgressHUD *)showWarning {
    return [self showWarningInView:window];
}

+ (MBProgressHUD *)showWarningInView:(UIView *)view {
    return [self showWarningInView:view text:nil];
}

+ (MBProgressHUD *)showWarningWithText:(NSString *)text {
    return [self showWarningInView:window text:text];
}

+ (MBProgressHUD *)showWarningInView:(UIView *)view text:(NSString *)text {
    return [self showCustomView:[self imageViewWithImageAssetName:kWarningImageAssetName] inView:view text:text];
}

+ (MBProgressHUD *)showCustomView:(UIView *)customview {
    return [self showCustomView:customview inView:window];
}

+ (MBProgressHUD *)showCustomView:(UIView *)customview text:(NSString *)text {
    return [self showCustomView:customview inView:window text:text];
}

+ (MBProgressHUD *)showCustomView:(UIView *)customview inView:(UIView *)view {
    return [self showCustomView:customview inView:view text:nil];
}

+ (MBProgressHUD *)showCustomView:(UIView *)customview inView:(UIView *)view text:(NSString *)text {
    [MBProgressHUD hideHUDForView:view animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = customview;
    hud.label.text = text;
    return hud;
}

+ (UIImageView *)imageViewWithImageAssetName:(NSString *)assetName {
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:assetName]];
}

@end
