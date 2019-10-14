//
//  AppDelegate.m
//  Qimokaola
//
//  Created by Administrator on 15/10/8.
//  Copyright © 2015年 Administrator. All rights reserved.
//

#import "AppDelegate.h"
#import "ZWAdvertisementView.h"
#import "ZWTabBarController.h"
#import "ZWHUDTool.h"
#import "ZWUserManager.h"
#import "UIColor+Extension.h"
#import "ZWUploadFileViewController.h"
#import "ZWLoginRegisterViewController.h"
#import "ZWBrowserTool.h"

#import "ZWOrderListViewController.h"
#import "ZWCommitOrderViewController.h"

#import "ZWNetworkingManager.h"

#import <AlipaySDK/AlipaySDK.h>
//#import <UMSocialCore/UMSocialCore.h>
#import <UMShare/UMShare.h>
#import <UMAnalytics/MobClick.h>
//#import "UMMobClick/MobClick.h"
//#import <UMCommunitySDK/UMCommunitySDK.h>
//#import "UMessage.h"

#import <UMCommon/UMCommon.h>
#import <UMCommonLog/UMCommonLogHeaders.h>


#import <ReactiveCocoa/ReactiveCocoa.h>
#import <IQKeyboardManager/IQKeyboardManager.h>

#import <YYModel/YYModel.h>

#define IS_IOS_10 [[UIDevice currentDevice].systemVersion floatValue] >= 10.0

#define IS_IOS_9 [[UIDevice currentDevice].systemVersion floatValue] >= 9.0

#define IS_IOS_8 [[UIDevice currentDevice].systemVersion floatValue] >= 8.0

@interface AppDelegate () //<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    
    
    application.applicationIconBadgeNumber = 0;
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    // 初始化友盟推送
    //设置 AppKey 及 LaunchOptions
//    [UMessage startWithAppkey:@"57b447c6e0f55af52e000e0b" launchOptions:launchOptions httpsenable:YES];
    
    //1.3.0版本开始简化初始化过程。如不需要交互式的通知，下面用下面一句话注册通知即可。
//[UMessage registerForRemoteNotifications];
    
    //iOS10必须加下面这段代码。
    
//    if (IS_IOS_10) {
//        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//        //设置代理
//        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
//        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
//            if (granted) {
//                [[UIApplication sharedApplication] registerForRemoteNotifications];
//            } else {
//
//            }
//        }];
//    }   else if (IS_IOS_8){
//        //ios8注册通知
//        UIUserNotificationType type = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
//        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:type categories:nil];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//    }
    
//    [UMessage setLogEnabled:YES];

    // 初始化友盟微社区SDK
//    [UMCommunitySDK setAppkey:@"57b447c6e0f55af52e000e0b" withAppSecret:@"6133327b2d31ba894071c89b186284ac"];
    
//    //初始化友盟应用分析SDK
//    UMConfigInstance.appKey = @"561e48d167e58e12fd001243";
//    UMConfigInstance.channelId = @"App Store";
//    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
//
//    //打开调试日志
//    [[UMSocialManager defaultManager] openLog:YES];
//    //设置友盟appkey
    
//    [[UMSocialManager defaultManager] setUmSocialAppkey:@"57b447c6e0f55af52e000e0b"];
//    //设置微信的appkey等
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx056beaf1d57f120a" appSecret:@"0cb53204f1780e3b68821e0089985447" redirectURL:@"http://mobile.umeng.com/social"];
//
//    //设置QQ互联的appKey和appSecret
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"101369980" appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    /*
                    新版友盟SDK
     
    */
    //57b447c6e0f55af52e000e0b
    //通用初始化接口
    [UMConfigure initWithAppkey:@"561e48d167e58e12fd001243" channel:@"App Store"];
    [MobClick setScenarioType:E_UM_NORMAL];
    [MobClick event:kAppLaunchEventID];
    //设置日志
    [UMConfigure setLogEnabled:YES];
    [UMCommonLogManager setUpUMCommonLogManager];
    // U-Share 平台设置
    [self configUSharePlatforms];
    [self confitUShareSettings];

    //0.5秒后开始监听网络变化
    [self performSelector:@selector(monitorNetworkStatus) withObject:nil afterDelay:0.5f];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];

    @weakify(self)
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kUserNeedLoginNotification object:nil] deliverOnMainThread] subscribeNext:^(id x) {
        [[ZWUserManager sharedInstance] logoutStudentCircle];
        @strongify(self)
        
        [self presentLoginViewControllerAndHint];
    }];
    
    // 在确认存在本地用户与用户登录成功之后执行登录学生圈
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kLocalUserLoginStateGuranteedNotification object:nil]subscribeNext:^(id x) {
        // 本地用户存在，执行学生圈登录流程"
        @strongify(self)
        [self loginTheStudentCircle];
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kUserLoginSuccessNotification object:nil] subscribeNext:^(id x) {
        // 用户登录成功，执行学生圈登录流程
        @strongify(self)
        [self loginTheStudentCircle];
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kUserLogoutSuccessNotification object:nil] subscribeNext:^(id x) {
        @strongify(self)
        [[ZWUserManager sharedInstance] logoutStudentCircle];
        [self presentLoginViewController:YES];
        
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kShowAdNotification object:nil] subscribeNext:^(NSNotification *notification) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ZWBrowserTool openWebAddress:notification.userInfo[@"url"]];
        });
    }];
    
    [[UINavigationBar appearance] setBarTintColor:defaultBlueColor];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                           NSFontAttributeName : [UIFont systemFontOfSize:17 weight:UIFontWeightBold],
                                                           }];
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundImage:[[UIColor whiteColor] parseToImage]];
    
    //检测是否已经登录
    NSLog(@"%@",[ZWUserManager sharedInstance].loginUser);
    
    if ([ZWUserManager sharedInstance].loginUser&&[ZWUserManager sharedInstance].loginUser.token) {
       
        [self gotoLoginedView];

    } else {
    
        BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"LoginState"];
        if (isLogin) {
            NSLog(@"old login");
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LoginState"];
            [self gotoLoginedView];
        } else {
            NSLog(@"not login");
            //显示登录，注册视图
            //[self setWindowRootControllerWithClass:[ZWLoginAndRegisterViewController class]];
            //[self setWindowRootControllerWithClass:[ZWLoginRegisterViewController class]];
            
            self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            [self.window makeKeyAndVisible];
            self.window.rootViewController = [ZWLoginRegisterViewController loadLoginRegisterViewControllerInNavigatorFromStoryboard];
        }
        
        
    }
    return YES;
}

- (void)gotoLoginedView  {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [[ZWTabBarController alloc] init];
    @weakify(self)
    [[[[self fetchADSignal] timeout:5.0 onScheduler:[RACScheduler mainThreadScheduler]] deliverOnMainThread] subscribeNext:^(ZWAdvertisement *ad) {
        @strongify(self)
        if (ad.enabled) {
            
            ZWAdvertisementView *adView = [[ZWAdvertisementView alloc] initWithWindow:self.window];
            [adView showAdvertisement:ad];
        }
    } error:^(NSError *error) {
    }];
}

/*
- (void)setWindowRootControllerWithClass:(Class)clazz {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [[clazz alloc] init];
}
 */

/**
 执行登录学生圈流程
 */
- (void)loginTheStudentCircle {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       [[ZWUserManager sharedInstance] loginStudentCircle];  
    });
}

- (void)presentLoginViewController:(BOOL)goToLoginDirectly {
    [UIApplication sharedApplication].keyWindow.rootViewController = [ZWLoginRegisterViewController loadLoginRegisterViewControllerInNavigatorFromStoryboard];;

}

- (void)presentLoginViewControllerAndHint {
    NSLog(@"????");
    [ZWHUDTool showPlainHUDWithText:@"登录状态失效啦请重新登录"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kTimeIntervalMid * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [ZWHUDTool dismiss];
         [self presentLoginViewController:YES];
    });
}

- (RACSignal *)fetchADSignal {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [ZWAPIRequestTool requestSBInfo:^(id response, BOOL success) {
            if (success && [[response objectForKey:kHTTPResponseCodeKey] intValue] == 200) {
                
                ZWAdvertisement *ad = [ZWAdvertisement yy_modelWithJSON:[response objectForKey:kHTTPResponseDataKey]];
                [subscriber sendNext:ad];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:response];
            }
        }];
        return nil;
    }];
}

#pragma mark 检测网络变化,无网络时应用内全局提示
- (void)monitorNetworkStatus {

    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            [[ZWHUDTool showPlainHUDWithText:@"网络连接已断开"] hideAnimated:YES afterDelay:kTimeIntervalShort];
            
        } else {
            
            //网络改变之后且有网的情况下重新登录学生圈
            
            [self loginTheStudentCircle];
        }
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // 1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
    //[UMessage registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    //关闭友盟自带的弹出框
//    [UMessage setAutoAlert:NO];
//    [UMessage didReceiveRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNoData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //关闭友盟自带的弹出框
//    [UMessage setAutoAlert:NO];
//    [UMessage didReceiveRemoteNotification:userInfo];
}

//iOS10新增：处理前台收到通知的代理方法
//-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
//    NSDictionary * userInfo = notification.request.content.userInfo;
//    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        //应用处于前台时的远程推送接受
//        //关闭友盟自带的弹出框
//        [UMessage setAutoAlert:NO];
//        //必须加这句代码
//        [UMessage didReceiveRemoteNotification:userInfo];
//
//    }else{
//        //应用处于前台时的本地推送接受
//    }
//    //当应用处于前台时提示设置，需要哪个可以设置哪一个
//    completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionAlert);
//}

//iOS10新增：处理后台点击通知的代理方法
//-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
//    NSDictionary * userInfo = response.notification.request.content.userInfo;
//    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        //应用处于后台时的远程推送接受
//        //必须加这句代码
//        [UMessage didReceiveRemoteNotification:userInfo];
//
//    }else{
//        //应用处于后台时的本地推送接受
//    }
//
//}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError");
}

// 支持所有iOS系统
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation
//{
//    if ([url.host isEqualToString:@"safepay"]) {
//        //跳转支付宝钱包进行支付，处理支付结果
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
//            [self dealWithPayResult:resultDic];
//        }];
//        return YES;
//    }
//
////    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
////    if (!result) {
////        // 其他如支付等SDK的回调
////        NSLog(@"openURL:%@ sourceApplication:%@ annotation:%@", url, sourceApplication, annotation);
////        return [self checkURL:url];
////    }
//    return true;
//}
// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
        return [self checkURL:url];
    }
    return result;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options
{
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [self dealWithPayResult:resultDic];
        }];
        return YES;
    }
    
    
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
         return [self checkURL:url];
    }
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [self dealWithPayResult:resultDic];
        }];
        return YES;
    }
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (void)dealWithPayResult:(NSDictionary *)result {
    if ([[result objectForKey:@"resultStatus"] integerValue] != APLIPAY_PAY_SUCCESS_STATUS) {
        NSString *errMsg = [result objectForKey:@"memo"];
        [[ZWHUDTool showFailureWithText:errMsg.length > 0 ? errMsg : @"付款失败 请重试"] hideAnimated:YES afterDelay:kTimeIntervalLong];
    } else {
//        [MobClick event:kPayOrderEventID];
        [ZWHUDTool showSuccessWithText:@"支付成功!"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kTimeIntervalLong * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ZWHUDTool dismiss];
            UITabBarController *tabBarController = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            UINavigationController *navc = tabBarController.childViewControllers[tabBarController.selectedIndex];
            UIViewController *topVC = navc.topViewController;
            
            // 判断当前处于什么页面
            if ([topVC isKindOfClass:ZWOrderListViewController.class]) {
                // 如果处于订单列表页面，则调用相应的方法刷新列表
                [(ZWOrderListViewController *)topVC reloadCellOfPrintOrderJustPaid];
            } else if ([topVC isKindOfClass:ZWCommitOrderViewController.class]) {
                // 若处于提交订单页面 则直接退出此页面
                [navc popViewControllerAnimated:YES];
            }
        });
    }
}

#pragma mark UMCShare
- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
}
- (void)configUSharePlatforms
{
    
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx056beaf1d57f120a" appSecret:@"0cb53204f1780e3b68821e0089985447" redirectURL:@"http://mobile.umeng.com/social"];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    //101369980
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"101369980"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
}




/**
 分析传入的url是否为文件 判断应用是否由分享文件调用

 @param url url
 @return 友盟判断结果
 */
- (BOOL)checkURL:(NSURL *)url {
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:url.path]) {                                                                                                                                                 
        if (![ZWUserManager sharedInstance].isLogin) {
            
            [[NSFileManager defaultManager] removeItemAtURL:url error:NULL];
            [[ZWHUDTool showPlainHUDWithText:@"只有在登录状态下才能上传文件哦"] hideAnimated:YES afterDelay:kTimeIntervalMid];
        } else {
            
            [self presentUploadViewWithFileName:url];
        }
    }
    return YES;
}

- (void)presentUploadViewWithFileName:(NSURL *)url {

    ZWUploadFileViewController *uploader = [[ZWUploadFileViewController alloc] init];
    uploader.fileUrl = url;
    [(UINavigationController *)[(UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController selectedViewController] pushViewController:uploader animated:YES];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
