//
//  ZWCommitOrderViewController.m
//  Qimokaola
//
//  Created by Administrator on 2017/5/30.
//  Copyright © 2017年 Administrator. All rights reserved.
//

#import "ZWCommitOrderViewController.h"

#import "ZWGood.h"
#import "ZWUserManager.h"
#import "ZWHUDTool.h"

#import "ZWCommitOrderViewModel.h"

#import "ZWGoodTool.h"
#import "UIColor+Extension.h"

#import <AlipaySDK/AlipaySDK.h>

//#import <UMMobClick/MobClick.h>
#import <PPNumberButton/PPNumberButton.h>
#import <YYWebImage/YYWebImage.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

static NSString *const kPrintOrderPhoneKey = @"kPrintOrderPhoneKey";
static NSString *const kPrintOrderAddressKey = @"kPrintOrderAddressKey";
static NSString *const kPrintOrderNameKey = @"kPrintOrderNameKey";

@interface ZWCommitOrderViewController ()

@property (nonatomic, strong) ZWCommitOrderViewModel *printOrderViewModel;

@property (weak, nonatomic) IBOutlet UIImageView *goodImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet PPNumberButton *numberButton;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UIButton *commitOrderButton;

@end

@implementation ZWCommitOrderViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单信息";
    
    [self.commitOrderButton setBackgroundImage:[[UIColor lightGrayColor] parseToImage] forState:UIControlStateDisabled];
    [self.commitOrderButton setBackgroundImage:[RGB(80.f, 140.f, 238.f) parseToImage] forState:UIControlStateNormal];
    self.commitOrderButton.layer.masksToBounds = YES;
    
    [self.goodImageView yy_setImageWithURL:[NSURL URLWithString:self.good.imageUrl] options:YYWebImageOptionProgressive];
    [self.goodTitleLabel setText:self.good.title];
    [self.totalPriceLabel setText:[ZWGoodTool convertPriceFromPriceInCent:self.good.price]];
    
    [self bindViewModel];
    
    @weakify(self)
    self.numberButton.resultBlock = ^(NSInteger number, BOOL increaseStatus) {
        @strongify(self)
        [self.totalPriceLabel setText:[ZWGoodTool convertPriceFromPriceInCent:self.good.price * number]];
        self.printOrderViewModel.count = number;
    };
    
    [self configReciverData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 根据存储的信息自动填充收货人信息
 */
- (void)configReciverData {
    NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:kPrintOrderPhoneKey];
    NSString *address = [[NSUserDefaults standardUserDefaults] objectForKey:kPrintOrderAddressKey];
    
    self.phoneField.text = phone ? phone : [ZWUserManager sharedInstance].loginUser.phone;
    self.addressField.text = address ? address : @"";
}


/**
 保存收货人信息
 */
- (void)storeReciverData {
    [[NSUserDefaults standardUserDefaults] setObject:self.phoneField.text forKey:kPrintOrderPhoneKey];
    [[NSUserDefaults standardUserDefaults] setObject:self.addressField.text forKey:kPrintOrderAddressKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)bindViewModel {
    @weakify(self)
    _printOrderViewModel = [[ZWCommitOrderViewModel alloc] initWithGood:self.good];
    _printOrderViewModel.payType = @"alipay";
    RAC(_printOrderViewModel, address) = [RACSignal merge:@[self.addressField.rac_textSignal, RACObserve(self.addressField, text)]];
    RAC(_printOrderViewModel, phone) = [RACSignal merge:@[self.phoneField.rac_textSignal, RACObserve(self.phoneField, text)]];
    self.commitOrderButton.rac_command = _printOrderViewModel.commitOrderCommand;
    
    [[self.commitOrderButton.rac_command.executionSignals switchToLatest] subscribeNext:^(NSDictionary *result) {
        @strongify(self)
        [ZWHUDTool showSuccessInView:self.navigationController.view text:@"提交成功,即将跳转至付款页面"];
        
        // 若提交成功则认为用户下次仍将使用此信息
        [self storeReciverData];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kTimeIntervalShort * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [ZWHUDTool dismissInView:self.navigationController.view];
            
            NSLog(@"付款信息: %@ %@", [result objectForKey:@"type"], [result objectForKey:@"payinfo"]);
            
            if ([[result objectForKey:@"type"] isEqualToString:@"alipay"]) {
                [[AlipaySDK defaultService] payOrder:[result objectForKey:@"payinfo"] fromScheme:@"qmklappalipayscheme" callback:^(NSDictionary *resultDic) {
                    NSLog(@"reslut = %@",resultDic);
                    [self dealWithPayResult:resultDic];
                }];
            }
        });
    }];
    
    [self.commitOrderButton.rac_command.errors subscribeNext:^(NSError *error) {
        @strongify(self)
        [[ZWHUDTool showFailureInView:self.navigationController.view text:@"提交失败"] hideAnimated:YES afterDelay: kTimeIntervalShort];
    }];
    
    [self.commitOrderButton.rac_command.executing subscribeNext:^(NSNumber *x) {
        @strongify(self)
        if ([x boolValue]) {
 //           [MobClick event:kCommitOrderEventID];
            [ZWHUDTool showInView:self.navigationController.view text:@"提交订单中..."];
        }
    }];
}

- (void)dealWithPayResult:(NSDictionary *)result {
    if ([[result objectForKey:@"resultStatus"] integerValue] != APLIPAY_PAY_SUCCESS_STATUS) {
        NSString *errMsg = [result objectForKey:@"memo"];
        [[ZWHUDTool showFailureWithText:errMsg.length > 0 ? errMsg : @"付款失败 请重试"] hideAnimated:YES afterDelay:kTimeIntervalLong];
    } else {
        [ZWHUDTool showSuccessWithText:@"支付成功!"];
//        [MobClick event:kPayOrderEventID];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kTimeIntervalLong * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ZWHUDTool dismiss];
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
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
