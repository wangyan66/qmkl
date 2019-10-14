//
//  ZWOrderListViewController.m
//  Qimokaola
//
//  Created by Administrator on 2017/6/1.
//  Copyright © 2017年 Administrator. All rights reserved.
//

#import "ZWOrderListViewController.h"

#import "ZWHUDTool.h"
#import "ZWPrintOrder.h"
#import "ZWPrintOrderCell.h"
#import "ZWAPIRequestTool.h"

#import <AlipaySDK/AlipaySDK.h>
#import <YYModel/YYModel.h>

@interface ZWOrderListViewController () <ZWPrintOrderCellDelegate>

@property (nonatomic, strong) NSMutableArray *printOrders;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger totoalSize;


/**
 标记正在支付的订单
 */
@property (nonatomic, weak) ZWPrintOrder *printOrderToPay;

@end

@implementation ZWOrderListViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.printOrders = [NSMutableArray array];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 140;
    
    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [ZWAPIRequestTool requestListOrderWithPageNumber:strongSelf.page result:^(id response, BOOL success) {
            if (success && [response[kHTTPResponseCodeKey] intValue] == 0) {
                
                NSArray *dicts = response[kHTTPResponseResKey][@"items"];
                // 如果没有更多数据 提示用户
                if (dicts.count == 0) {
                    [strongSelf.tableView.mj_footer endRefreshing];
                    [[ZWHUDTool showWarningInView:strongSelf.navigationController.view text:@"没有更多了"] hideAnimated:YES afterDelay:kTimeIntervalShort];
                } else {
                    [self.tableView.mj_footer endRefreshing];
                    for (NSDictionary *dict in dicts) {
                        ZWPrintOrder *printOrder = [ZWPrintOrder yy_modelWithDictionary:dict];
                        if ([strongSelf isValidOrder:printOrder]) {
                            [strongSelf.printOrders addObject:printOrder];
                        }
                    }
                    [strongSelf.tableView reloadData];
                    strongSelf.page ++;
                }
                
            } else {
                [strongSelf.tableView.mj_footer endRefreshing];
                [[ZWHUDTool showFailureInView:strongSelf.navigationController.view text:@"获取数据失败"] hideAnimated:YES afterDelay:kTimeIntervalShort];
            }
        }];
    }];
}

- (BOOL)isValidOrder:(ZWPrintOrder *)printOrder {
    return printOrder.uuid != nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)freshHeaderStartFreshing {
    self.page = 1;
    [self.printOrders removeAllObjects];
    [ZWAPIRequestTool requestListOrderWithPageNumber:_page result:^(id response, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        if (success && [response[kHTTPResponseCodeKey] intValue] == 0) {
            for (NSDictionary *item in response[kHTTPResponseResKey][@"items"]) {
                @autoreleasepool {
                    ZWPrintOrder *printOrder = [ZWPrintOrder yy_modelWithDictionary:item];
                    if ([self isValidOrder:printOrder]) {
                        [self.printOrders addObject:printOrder];
                        NSLog(@"%@", printOrder.uuid);
                    }
                }
            }
            [self.tableView reloadData];
            self.page ++;
        } else {
            [[ZWHUDTool showFailureInView:self.navigationController.view text:@"获取数据失败"] hideAnimated:YES afterDelay:kTimeIntervalShort];
        }
    }];
}


#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.printOrders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZWPrintOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PrintOrderCell"];
    cell.printOrder = self.printOrders[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - ZWPrintOrderCellDelegate

- (void)cell:(ZWPrintOrderCell *)cell didClickToPayWithPrintOrder:(ZWPrintOrder *)printOrder {
    [ZWHUDTool showInView:self.navigationController.view text:@"提交请求..."];
    self.printOrderToPay = printOrder;
    [ZWAPIRequestTool requestPayOrderWithUUID:printOrder.uuid payType:@"alipay" result:^(id response, BOOL success) {
        if (success) {
            if ([response[kHTTPResponseCodeKey] intValue] == 0) {
                [ZWHUDTool showPlainHUDInView:self.navigationController.view text:@"请求成功，即将跳转至支付页面"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kTimeIntervalShort * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [ZWHUDTool dismissInView:self.navigationController.view];
                    
                    if ([response[kHTTPResponseResKey][@"type"] isEqualToString:@"alipay"]) {
                        [[AlipaySDK defaultService] payOrder:response[kHTTPResponseResKey][@"payinfo"] fromScheme:@"qmklappalipayscheme" callback:^(NSDictionary *resultDic) {
                            NSLog(@"block result");
                            NSLog(@"reslut = %@",resultDic);
                            [self dealWithPayResult:resultDic];
                        }];
                    }
                    
                });
            } else {
                [[ZWHUDTool showFailureInView:self.navigationController.view text:response[kHTTPResponseInfoKey]] hideAnimated:YES afterDelay:kTimeIntervalShort];
            }
        } else {
            [[ZWHUDTool showFailureInView:self.navigationController.view text:@"请求失败，请重试"] hideAnimated:YES afterDelay:kTimeIntervalShort];
        }
    }];
}

- (void)dealWithPayResult:(NSDictionary *)result{
    if ([[result objectForKey:@"resultStatus"] integerValue] != APLIPAY_PAY_SUCCESS_STATUS) {
        NSString *errMsg = [result objectForKey:@"memo"];
        [[ZWHUDTool showFailureWithText:errMsg.length > 0 ? errMsg : @"付款失败 请重试"] hideAnimated:YES afterDelay:kTimeIntervalLong];
    } else {
        [ZWHUDTool showSuccessWithText:@"支付成功!"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kTimeIntervalLong * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ZWHUDTool dismiss];
            [self reloadCellOfPrintOrderJustPaid];
        });
    }
}

- (void)reloadCellOfPrintOrderJustPaid {
    if (self.printOrderToPay) {
        self.printOrderToPay.state = kPrintOderStateShipping;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.printOrders indexOfObject:self.printOrderToPay] inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
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
