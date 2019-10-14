//
//  ZWOrderListViewController.h
//  Qimokaola
//
//  Created by Administrator on 2017/6/1.
//  Copyright © 2017年 Administrator. All rights reserved.
//

#import "ZWBaseTableViewController.h"

@interface ZWOrderListViewController : ZWBaseTableViewController


/**
 用户付款成功后 在AppDelegate的回调里调用此方法来刷新视图
 */
- (void)reloadCellOfPrintOrderJustPaid;

@end
