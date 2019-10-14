//
//  ZWGoodListViewController.m
//  Qimokaola
//
//  Created by Administrator on 2017/5/6.
//  Copyright © 2017年 Administrator. All rights reserved.
//

#import "ZWGoodListViewController.h"
#import "ZWAPIRequestTool.h"
#import "ZWGood.h"
#import "ZWGoodCell.h"
#import "ZWCommitOrderViewController.h"

#import "ZWHUDTool.h"

#import "MarqueeLabel.h"
#import <LinqToObjectiveC/LinqToObjectiveC.h>
#import <YYModel/YYModel.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

static NSString *const kGoodCellIdentifier = @"kGoodCellIdentifier";
static NSString *const kContentWhenOpen = @"需上传和打印自己的资料, 请用电脑浏览器访问 finalexam.cn";
static NSString *const kContentWhenClosed = @"暂停营业";

@interface ZWGoodListViewController () <ZWGoodCellDelegate>

@property (nonatomic, strong) NSArray *goodList;

@property (nonatomic, strong) MarqueeLabel *marqueeLabel;


/**
 标记是否停止营业
 */
@property (nonatomic, assign) BOOL isClosed;

@end

@implementation ZWGoodListViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"在线打印";
    [self.tableView registerNib:[UINib nibWithNibName:@"ZWGoodCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kGoodCellIdentifier];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 140;
    
    self.marqueeLabel = [[MarqueeLabel alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
    self.marqueeLabel.textColor = [UIColor lightGrayColor];
    self.marqueeLabel.marqueeType = MLContinuous;
    self.marqueeLabel.animationCurve = UIViewAnimationCurveLinear;//动画方式
    self.marqueeLabel.fadeLength = 10.0f;//左右边缘模糊效果
    self.marqueeLabel.leadingBuffer = 20.0f;
    self.marqueeLabel.trailingBuffer = 20.0f;
    self.marqueeLabel.animationDelay = 0.f;
    self.marqueeLabel.textAlignment = NSTextAlignmentCenter;
    self.tableView.tableHeaderView = self.marqueeLabel;
    self.marqueeLabel.hidden = YES;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.marqueeLabel.frame) - 0.5, kScreenW, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.marqueeLabel addSubview:line];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Fetch Data

- (void)freshHeaderStartFreshing {
    
    __weak __typeof(self) weakSelf = self;
    [ZWAPIRequestTool requestGoodList:^(id response, BOOL success) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.tableView.mj_header endRefreshing];
            
            if (success) {
                if ([[response objectForKey:kHTTPResponseCodeKey] intValue] == 0) {
                    strongSelf.goodList = [response[kHTTPResponseResKey][@"list"] linq_select:^id(NSDictionary *item) {
                        return [ZWGood yy_modelWithDictionary:item];
                    }];
                    strongSelf.isClosed = [response[kHTTPResponseResKey][@"closed"] boolValue];
                    strongSelf.marqueeLabel.text = self.isClosed ? kContentWhenClosed : kContentWhenOpen;
                    strongSelf.marqueeLabel.hidden = NO;
                    [strongSelf.tableView reloadData];
                } else {
                    [[ZWHUDTool showFailureInView:strongSelf.navigationController.view text:[response objectForKey:kHTTPResponseInfoKey]] hideAnimated:YES afterDelay:kTimeIntervalShort];
                }
            } else {
                [[ZWHUDTool showFailureInView:strongSelf.navigationController.view text:@"获取数据失败"] hideAnimated:YES afterDelay:kTimeIntervalShort];
            }
        });
    }];
}

#pragma mark - ZWGoodCellDelegate

- (void)goodCell:(ZWGoodCell *)goodCell didClickBuyButtonWithGood:(ZWGood *)good {
    NSLog(@"点击购买 %@", good.title);
    ZWCommitOrderViewController *orderVC = [[ZWCommitOrderViewController alloc] init];
    orderVC.good = good;
    [self.navigationController pushViewController:orderVC animated:YES];
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.goodList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZWGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:kGoodCellIdentifier];
    ZWGood *good = self.goodList[indexPath.row];
    cell.good = good;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.canBuy = !self.isClosed;
    return cell;
}

#pragma mark - UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 140;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
